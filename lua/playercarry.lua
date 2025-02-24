function PlayerCarry:_perform_jump(jump_vec)
	local max_mul, min_mul
	for _, name in pairs(self._tweak_data_name) do
		if not max_mul then
			max_mul = tweak_data.carry.types[name].jump_modifier
		else
			local val = tweak_data.carry.types[name].jump_modifier
			if val > max_mul then
				min_mul = max_mul
				max_mul = val
			else
				min_mul = val
			end
		end
	end

	local multiplier
	if min_mul then
		multiplier = min_mul * (max_mul + 0.5 * (1 - max_mul))
	elseif not max_mul then
		multiplier = 1
	else
		multiplier = max_mul + 0.5 * (1 - max_mul)
	end

	mvector3.multiply(jump_vec, multiplier)

	PlayerCarry.super._perform_jump(self, jump_vec)
end

function PlayerCarry:_get_max_walk_speed(...)
	local max_mul, min_mul
	for _, name in pairs(self._tweak_data_name) do
		if not max_mul then
			max_mul = tweak_data.carry.types[name].move_speed_modifier
		else
			local val = tweak_data.carry.types[name].move_speed_modifier
			if val > max_mul then
				min_mul = max_mul
				max_mul = val
			else
				min_mul = val
			end
		end
	end

	local multiplier
	if min_mul then
		multiplier = min_mul * (max_mul + 0.5 * (1 - max_mul))
	elseif not max_mul then
		multiplier = 1
	else
		multiplier = max_mul + 0.5 * (1 - max_mul)
	end

	--[[ if managers.player:has_category_upgrade("carry", "movement_penalty_nullifier") then
		multiplier = 1
	else ]]
	multiplier = math.clamp(multiplier * managers.player:upgrade_value("carry", "movement_speed_multiplier", 1), 0, 1)
	multiplier = math.clamp(multiplier * managers.player:upgrade_value("player", "mrwi_carry_speed_multiplier", 1), 0, 1)
	-- end

	if managers.player:has_category_upgrade("player", "armor_carry_bonus") then
		local base_max_armor = armor_init + managers.player:body_armor_value("armor") + managers.player:body_armor_skill_addend()
		local mul = managers.player:upgrade_value("player", "armor_carry_bonus", 1)

		for i = 1, base_max_armor do
			multiplier = multiplier * mul
		end

		multiplier = math.clamp(multiplier, 0, 1)
	end

	local mutator = nil

	if managers.mutators:is_mutator_active(MutatorCG22) then
		mutator = managers.mutators:get_mutator(MutatorCG22)
	elseif managers.mutators:is_mutator_active(MutatorPiggyRevenge) then
		mutator = managers.mutators:get_mutator(MutatorPiggyRevenge)
	end

	if mutator and mutator.get_bag_speed_increase_multiplier then
		multiplier = multiplier * mutator:get_bag_speed_increase_multiplier()
	end

	return PlayerCarry.super._get_max_walk_speed(self, ...) * multiplier
end

function PlayerCarry:_check_use_item(t, input)
	local new_action = nil
	local action_wanted = input.btn_use_item_release and self._throw_time and t and t < self._throw_time

	if input.btn_use_item_press then
		self._throw_down = true
		self._second_press = false
		self._throw_time = t + PlayerCarry.throw_limit_t
	end

	if action_wanted then
		managers.player:drop_carry()
		new_action = true
	end

	if self._throw_down then
		if input.btn_use_item_release then
			self._throw_down = false
			self._second_press = false

			return PlayerCarry.super._check_use_item(self, t, input)
		elseif self._throw_time < t then
			if not self._second_press then
				input.btn_use_item_press = true
				self._second_press = true
			end

			return PlayerCarry.super._check_use_item(self, t, input)
		end
	end

	return new_action
end

-- Modify carrying state
-- TODO: Don't hardcode the state to check the second bag carried
function PlayerCarry:_enter(enter_data)
	local my_carry_data = managers.player:get_my_carry_data()

	if my_carry_data and my_carry_data[1] then
		local carry_data = tweak_data.carry[my_carry_data[1].carry_id]
		self._tweak_data_name = { carry_data.type }
	else
		self._tweak_data_name = {}
	end

	if self._ext_movement:nav_tracker() then
		managers.groupai:state():on_criminal_recovered(self._unit)
	end

	local skip_equip = enter_data and enter_data.skip_equip

	if not self:_changing_weapon() and not skip_equip then
		if not self._state_data.mask_equipped then
			self._state_data.mask_equipped = true
			local equipped_mask = managers.blackmarket:equipped_mask()
			local peer_id = managers.network:session() and managers.network:session():local_peer():id()
			local mask_id = managers.blackmarket:get_real_mask_id(equipped_mask.mask_id, peer_id)
			local equipped_mask_type = tweak_data.blackmarket.masks[mask_id].type

			self._camera_unit:anim_state_machine():set_global((equipped_mask_type or "mask") .. "_equip", 1)
			self:_start_action_equip(self:get_animation("mask_equip"), 1.6)
		else
			self:_start_action_equip(self:get_animation("equip"))
		end
	end

	managers.job:set_memory("kill_count_carry", nil, true)
	managers.job:set_memory("kill_count_no_carry", nil, true)
	self:_upd_attention()
end

function PlayerCarry:set_tweak_data()
	--no op
end

function PlayerCarry:add_tweak_data(name)
	table.insert(self._tweak_data_name, name)

	self:_check_dye_pack()
end

function PlayerCarry:remove_tweak_data(name)
	for i, id in pairs(self._tweak_data_name) do
		if id == name then
			self._tweak_data_name[i] = nil
			break
		end
	end
end

function PlayerCarry:_check_action_run(...)
	if managers.player:has_category_upgrade("carry", "movement_penalty_nullifier") then
		PlayerCarry.super._check_action_run(self, ...)
	else
		local can_run = true
		for _, name in pairs(self._tweak_data_name) do
			if tweak_data.carry.types[name] and not tweak_data.carry.types[name].can_run then
				can_run = false
				break
			end
		end
		if can_run then
			PlayerCarry.super._check_action_run(self, ...)
		end
	end
end

function PlayerCarry:_get_walk_headbob(...)
	local max_mul, min_mul
	for _, name in pairs(self._tweak_data_name) do
		if not max_mul then
			max_mul = tweak_data.carry.types[name].move_speed_modifier
		else
			local val = tweak_data.carry.types[name].move_speed_modifier
			if val > max_mul then
				min_mul = max_mul
				max_mul = val
			else
				min_mul = val
			end
		end
	end

	local multiplier
	if min_mul then
		multiplier = min_mul * (max_mul + 0.5 * (1 - max_mul))
	elseif not max_mul then
		multiplier = 1
	else
		multiplier = max_mul + 0.5 * (1 - max_mul)
	end

	multiplier = math.clamp(multiplier * managers.player:upgrade_value("carry", "movement_speed_multiplier", 1), 0, 1)
	multiplier = math.clamp(multiplier * managers.player:upgrade_value("player", "mrwi_carry_speed_multiplier", 1), 0, 1)
	return PlayerCarry.super._get_walk_headbob(self, ...) * multiplier
end
