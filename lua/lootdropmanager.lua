-- Offshore casino rework
function LootDropManager:droppable_items(item_pc, infamous_success)
	local plvl = managers.experience:current_level()
	local pc_items = self._global.pc_items[item_pc]
	local droppable_items = {}
	local maxed_inventory_items = {}

	for type, items in pairs(pc_items) do
		local type_tweak = tweak_data.blackmarket[type]
		droppable_items[type] = {}
		maxed_inventory_items[type] = {}

		for i, item in ipairs(items) do
			local item_tweak = type_tweak[item]
			local is_infamous = item_tweak.infamous or item_tweak.global_value == "infamous" or false
			local is_dlc = item_tweak.dlcs or item_tweak.dlc or false
			local got_qlvl = item_tweak.qlvl or false
			local fixed_global_value = item_tweak.global_value or false
			local pass_infamous = not is_infamous or infamous_success
			local pass_dlc = true
			local pass_qlvl = not got_qlvl or got_qlvl <= plvl
			local global_value = fixed_global_value or "normal"

			if is_infamous then
				global_value = "infamous"
			elseif is_dlc then
				local dlcs = {}

				if item_tweak.dlcs then
					for _, dlc in ipairs(item_tweak.dlcs) do
						table.insert(dlcs, dlc)
					end
				end

				if item_tweak.dlc then
					table.insert(dlcs, item_tweak.dlc)
				end

				local dlc_global_values = {}

				for _, dlc in ipairs(dlcs) do
					if tostring(managers.dlc.is_dlc_unlocked) ~= "nil" and managers.dlc:is_dlc_unlocked(dlc) or managers.dlc:has_dlc(dlc) then
						table.insert(dlc_global_values, dlc)
					end
				end

				if #dlc_global_values > 0 then
					global_value = fixed_global_value or dlc_global_values[math.random(#dlc_global_values)]
				else
					pass_dlc = false
				end
			end

			local amount_in_inventory = managers.blackmarket:get_item_amount(global_value, type, item, true)

			if pass_infamous and pass_dlc and pass_qlvl then
				local weight = item_tweak.weight or tweak_data.lootdrop.DEFAULT_WEIGHT
				local type_weight_mod_func = tweak_data.lootdrop.type_weight_mod_funcs[type]

				if type_weight_mod_func then
					weight = weight * type_weight_mod_func(global_value, type, item)
				end

				if amount_in_inventory > 0 then
					weight = weight * (item_tweak.got_item_weight_mod or tweak_data.lootdrop.got_item_weight_mod or 0.5)
				end

				if not item_tweak.max_in_inventory or amount_in_inventory < item_tweak.max_in_inventory then
					table.insert(droppable_items[type], {
						entry = item,
						global_value = global_value,
						weight = weight
					})
				else
					table.insert(maxed_inventory_items[type], {
						entry = item,
						global_value = global_value,
						weight = weight
					})
				end
			end
		end

		if #droppable_items[type] == 0 then
			droppable_items[type] = nil
		end
	end

	return droppable_items, maxed_inventory_items
end

function LootDropManager:new_make_casino_drop(setup_data, return_data)
	local pc = managers.experience:level_to_stars() * 10
	return_data = return_data or {}
	local infamous_chance, infamous_base_chance, infamous_base_multiplier = self:infamous_chance(setup_data)
	local infamous_success = false

	for i = 1, setup_data.rolls_amount do
		if math.rand(1) < infamous_chance then
			infamous_success = true

			break
		end
	end

	local droppable_items, maxed_inventory_items = self:droppable_items(setup_data.item_pc or 40, infamous_success, setup_data and setup_data.skip_types)
	local global_value, entry = nil
	
	return_data.item_tbl = {}
	return_data.items = {}
	return_data.progress = {
		total = setup_data.rolls_amount
	}
	local co = coroutine.create(function ()
		local itr = 0
		local generate_speed = math.max(5, setup_data.rolls_amount / 1000)
		for i = 1, setup_data.rolls_amount do
			local weighted_type_chance = {}
			local sum = 0

			for type, items in pairs(droppable_items) do
				weighted_type_chance[type] = tweak_data.lootdrop.WEIGHTED_TYPE_CHANCE[pc][type]
				sum = sum + weighted_type_chance[type]
			end

			if setup_data and setup_data.preferred_type and setup_data.preferred_chance then
				local increase = setup_data.preferred_chance * sum
				weighted_type_chance[setup_data.preferred_type] = (weighted_type_chance[setup_data.preferred_type] or 0) + increase
				sum = sum + increase
			end

			local normalized_chance = {}

			for type, items in pairs(droppable_items) do
				normalized_chance[type] = weighted_type_chance[type] > 0 and weighted_type_chance[type] / sum or 0
			end

			local pc_type = setup_data and setup_data.preferred_type_drop or self:_get_type_items(normalized_chance, true)
			local drop_table = droppable_items[pc_type] or maxed_inventory_items[pc_type]

			if drop_table then
				sum = 0

				for index, item_data in ipairs(drop_table) do
					sum = sum + item_data.weight
				end

				normalized_chance = {}

				for index, item_data in ipairs(drop_table) do
					normalized_chance[index] = item_data.weight / sum
				end

				local dropped_index = self:_get_type_items(normalized_chance, true)
				local dropped_item = drop_table[dropped_index]

				if setup_data.bet == "cash" then
					managers.money:deduct_from_total(setup_data.casino_fee)
				elseif setup_data.bet == "coins" then
					managers.custom_safehouse:deduct_coins(setup_data.casino_fee * 0.00001)
				else
					managers.money:deduct_from_offshore(setup_data.casino_fee)
					if type(managers.money.dispatch_event) ~= "nil" then
						managers.money:dispatch_event("casino_fee_paid", setup_data.casino_fee)
					end
				end
				
				managers.blackmarket:add_to_inventory(dropped_item.global_value, pc_type, dropped_item.entry)

				global_value = dropped_item.global_value
				entry = dropped_item.entry
			end

			local item_str = string.format("%s_%s_%s", global_value, pc_type, entry)
			if return_data.item_tbl[item_str] then
				return_data.item_tbl[item_str] = return_data.item_tbl[item_str] + 1
			else
				table.insert(return_data.items, {
					global_value = global_value,
					type_items = pc_type,
					item_entry = entry
				})
				return_data.item_tbl[item_str] = 1
			end

			itr = itr + 1

			if itr > generate_speed then
				coroutine.yield()

				itr = 0
				return_data.progress.current = i
				droppable_items, maxed_inventory_items = self:droppable_items(item_pc or 40, infamous_success, setup_data and setup_data.skip_types)
			end
		end
	end)
	local result = coroutine.resume(co)
	local status = coroutine.status(co)

	return co
end

function LootDropManager:sell_stashed_items(casino_data, return_data)
	return_data = return_data or {}
	return_data.items = {}
	return_data.item_tbl = {}
	return_data.progress = {
		total = casino_data.rolls_amount
	}

	local co = coroutine.create(function()
		local itr = 0
		local generate_speed = math.max(5, casino_data.rolls_amount / 1000)
		local counted = 0
		local total_cash_gained = 0
		local for_sale = self:get_stashed_items(casino_data.preferred_type)

		while counted < casino_data.rolls_amount do
			if #for_sale == 0 then
				break
			end
			
			local random_item_index = math.max(math.random(#for_sale), 1)
			local item = for_sale[random_item_index]
			local global_value = item.global_value
			local category = item.type_items
			local id = item.item_entry
			local cost = item.cost

			managers.blackmarket:remove_item(global_value, category, id)
			managers.blackmarket:alter_global_value_item(global_value, category, nil, id, Idstring("remove_from_inventory"))

			local item_str = string.format("%s_%s_%s", global_value, category, id)
			if return_data.item_tbl[item_str] then
				return_data.item_tbl[item_str] = return_data.item_tbl[item_str] + 1
			else
				table.insert(return_data.items, {
					global_value = global_value,
					type_items = category,
					item_entry = id,
					cost = cost
				})
				return_data.item_tbl[item_str] = 1
			end

			counted = counted + 1
			total_cash_gained = total_cash_gained + cost
			return_data.progress.current = counted
			item.amount = item.amount - 1

			if item.amount <= 0 then
				table.remove(for_sale, random_item_index)
			end
			
			itr = itr + 1

			if itr > generate_speed then
				coroutine.yield()
				itr = 0
			end
		end
		
		return_data.money_gained = total_cash_gained
		managers.money:_add_to_total(total_cash_gained, {
			no_offshore = true
		})
	end)

	local result = coroutine.resume(co)
	local status = coroutine.status(co)

	return co
end

function LootDropManager:infamous_chance(setup_data)
	local infamous_diff = 1

	if not setup_data or not setup_data.disable_difficulty then
		local difficulty_stars = managers.job:current_difficulty_stars() or 0
		infamous_diff = tweak_data.lootdrop.risk_infamous_multiplier[difficulty_stars] or 1
	end

	local chance = tweak_data.lootdrop.global_values.infamous.chance
	local multiplier = managers.player:upgrade_value("player", "passive_loot_drop_multiplier", 1) * managers.player:upgrade_value("player", "loot_drop_multiplier", 1) * infamous_diff * (setup_data and setup_data.increase_infamous or 1)

	if type(managers.experience.current_rank) ~= "nil" and managers.experience:current_rank() > 0 then
		for infamy, item in pairs(tweak_data.infamy.items) do
			if managers.infamy:owned(infamy) and item.upgrades and item.upgrades.infamous_lootdrop then
				multiplier = multiplier * item.upgrades.infamous_lootdrop
			end
		end
	end

	return chance * multiplier, chance, multiplier
end

function LootDropManager:get_stashed_items(preferred_item)
	local function get_item_cost(global_value, category, id)
		local cost = 0
		local sell_mul = (tweak_data:get_value("money_manager", "sell_mask_multiplier") or 0)
		if category == "weapon_mods" then
			cost = managers.money:get_weapon_part_sell_value(id, global_value)
		elseif category == "masks" then
			cost = managers.money:get_mask_sell_value(id, global_value)
		elseif category == "mask_colors" or category == "colors" or category == "materials" or category == "textures" then
			local cosmetic_category = category
			if category == "colors" and type(tweak_data.blackmarket.mask_colors) == "table" then
				cosmetic_category = "mask_colors"
			end
			
			cost = managers.money:get_mask_part_price(cosmetic_category, id, global_value) * sell_mul
		end
		
		if cost == 0 then
			local part_name_converter = {
				masks = "mask",
				textures = "pattern",
				materials = "material",
				colors = "color",
				mask_colors = "color"
			}
			local category_value = part_name_converter[category] or "mask"
			local mask_color_mul = category == "mask_colors" and 0.5 or 1
			local gv_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", global_value) or 1
			local pv = tweak_data:get_value("money_manager", "masks", category_value .. "_value", 1) * mask_color_mul or 0
			
			cost = math.round(pv * gv_multiplier) * sell_mul
		end
		
		return cost
	end
	
	local allowed_category = {
		mask_colors = true,
		colors = true,
		masks = true,
		materials = true,
		textures = true,
		weapon_mods = true,
	}

	local all_items = {}
	local total_amount = 0
	local total_cost = 0
	for global_value, gv in pairs(Global.blackmarket_manager.inventory) do
		for category, cv in pairs(gv) do
			for id, amount in pairs(cv) do
				local droppable = tweak_data.blackmarket[category] and tweak_data.blackmarket[category][id] and tweak_data.blackmarket[category][id].pcs and table.size(tweak_data.blackmarket[category][id].pcs) > 0
				local prefered = preferred_item == category or preferred_item == "none"
				if preferred_item == "colors" and category == "mask_colors" then
					prefered = true
				end
				
				if prefered and allowed_category[category] and (droppable or category == "mask_colors" or global_value == "gage_pack_jobs") then
					local cost = get_item_cost(global_value, category, id)
					table.insert(all_items, {
						global_value = global_value,
						type_items = category,
						item_entry = id,
						amount = amount,
						cost = cost
					})
					total_amount = total_amount + amount
					total_cost = total_cost + (cost * amount)
				end
			end
		end
	end
	
	return all_items, total_amount, total_cost
end
