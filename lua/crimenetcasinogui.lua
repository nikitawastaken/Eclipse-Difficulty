-- Offshore casino rework
function CrimeNetCasinoGui:_place_bet()
	if self._betting then
		return
	end

	local secure_cards, increase_infamous, preferred_card = self:_crimenet_casino_additional_cost()

	if not managers.money:can_afford_casino_fee(secure_cards, increase_infamous, preferred_card) then
		return
	end

	local params = {
		dialog = "menu_cn_casino_pay_fee",
		contract_fee = managers.experience:cash_string(managers.money:get_cost_of_casino_fee(secure_cards, increase_infamous, preferred_card)),
		offshore = managers.experience:cash_string(managers.money:offshore()),
		yes_func = callback(self, self, "_crimenet_casino_pay_fee")
	}
	
	local currency = managers.menu:active_menu().logic:selected_node():item("bet_item"):value()
	if currency == "sell_items" then
		params.dialog = "menu_cn_casino_sell_items"
		params.contract_fee = managers.experience:experience_string(managers.menu:active_menu().logic:selected_node():item("rolls_item"):value())
	elseif currency == "cash" then
		params.dialog = "menu_cn_casino_pay_cash"
		params.offshore = managers.experience:cash_string(managers.money:total())
	elseif currency == "coins" then
		params.dialog = "menu_cn_casino_pay_coins"
		params.offshore = managers.experience:experience_string(managers.custom_safehouse and managers.custom_safehouse:coins())
		params.contract_fee = managers.experience:experience_string(managers.money:get_cost_of_casino_fee(secure_cards, increase_infamous, preferred_card, 0.00001))
	end

	managers.menu:show_confirm_pay_casino_fee(params)
end

function CrimeNetCasinoGui:_crimenet_casino_pay_fee()
	local secure_cards, increase_infamous, preferred_item = self:_crimenet_casino_additional_cost()

	if not managers.money:can_afford_casino_fee(secure_cards, increase_infamous, preferred_item) then
		return
	end

	if managers.menu:active_menu().logic:selected_node():item("preferred_item") then
		local card_secured = secure_cards or 0
		local card_drops = {
			math.random(3) <= card_secured and preferred_item
		}

		if card_drops[1] then
			card_secured = card_secured - 1
		end

		card_drops[2] = card_secured == 2 and managers.lootdrop:specific_fake_loot_pc(preferred_item) or card_secured == 1 and card_secured == math.random(3) and managers.lootdrop:specific_fake_loot_pc(preferred_item)

		if card_drops[2] then
			card_secured = card_secured - 1
		end

		card_drops[3] = card_secured > 0 and managers.lootdrop:specific_fake_loot_pc(preferred_item)

		local function get_random_item_pc()
			local plvl = managers.experience:current_level()
			local stars = managers.experience:level_to_stars()
			local pc = stars * 10
			local pcs = tweak_data.lootdrop.STARS[stars].pcs
			local chance_curve = tweak_data.lootdrop.STARS_CURVES[stars]
			local start_chance = tweak_data.lootdrop.PC_CHANCE[stars]
			local no_pcs, item_pc = nil

			no_pcs = #pcs

			for i = 1, no_pcs do
				local chance = no_pcs > 1 and math.lerp(start_chance, 1, math.pow((i - 1) / (no_pcs - 1), chance_curve)) or 1
				local roll = math.rand(1)
				if roll <= chance then

					item_pc = pcs[i]

					break
				end
			end

			return item_pc
		end

		local setup_data = {
			casino_fee = managers.money:get_cost_of_casino_fee(secure_cards, increase_infamous, preferred_item),
			preferred_type = preferred_item,
			preferred_type_drop = card_drops[1],
			preferred_chance = tweak_data:get_value("casino", "prefer_chance"),
			increase_infamous = increase_infamous and tweak_data:get_value("casino", "infamous_chance"),
			bet = managers.menu:active_menu().logic:selected_node():item("bet_item"):value(),
			rolls_amount = managers.menu:active_menu().logic:selected_node():item("rolls_item"):value() or 1,
			item_pc = get_random_item_pc(),
			disable_difficulty = true,
			skip_types = {}
		}

		if setup_data.rolls_amount == 1 then
			if setup_data.bet == "cash" then
				managers.money:deduct_from_total(setup_data.casino_fee)
			elseif setup_data.bet == "coins" then
				managers.custom_safehouse:deduct_coins(setup_data.casino_fee * 0.00001)
			else
				managers.money:deduct_from_offshore(setup_data.casino_fee)
				-- if type(managers.money.dispatch_event) ~= "nil" then
					managers.money:dispatch_event("casino_fee_paid", setup_data.casino_fee)
				-- end
			end

			managers.menu:active_menu().logic:refresh_node()
		end

		managers.menu:open_node((setup_data.bet == "sell_items" or setup_data.rolls_amount > 1) and "offshore_casino_claim_rewards" or "crimenet_contract_casino_lootdrop", {setup_data})
	end
end