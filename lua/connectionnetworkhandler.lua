function ConnectionNetworkHandler:finish_trade(is_recon_over)
	if self._verify_gamestate(self._gamestate_filter.waiting_for_respawn) then
		return
	end

	local has_trading_delay_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_assault_delay")
	local has_trading_ammo_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_ammo")
	local unit = managers.player:player_unit()

	managers.player:player_unit():character_damage():restore_lives(1)

	-- resource trading for ammo upgrade
	if has_trading_ammo_upgrade then
		local inventory = unit:inventory()

		if not unit:character_damage():dead() and inventory then
			local available_selections = {}

			for i, weapon in pairs(inventory:available_selections()) do
				if inventory:is_equipped(i) then
					table.insert(available_selections, 1, weapon)
				else
					table.insert(available_selections, weapon)
				end
			end

			for _, weapon in ipairs(available_selections) do
				if not self._weapon_category or self._weapon_category == weapon.unit:base():weapon_tweak_data().categories[1] then
					weapon.unit:base():add_ammo(amount_of_pickups, false)
					managers.hud:set_ammo_amount(weapon.unit:base():selection_index(), weapon.unit:base():ammo_info())

					unit:sound():play("pickup_ammo_health_boost", nil, true)
				end
			end
		end
	end

	if has_trading_delay_upgrade and not is_recon_over then
		managers.hud:show_hint({ text = managers.localization:text("hint_trade_down_ammo_restored_assault_delay") })
	elseif has_trading_ammo_upgrade then
		managers.hud:show_hint({ text = managers.localization:text("hint_trade_down_ammo_restored") })
	else
		managers.hud:show_hint({ text = managers.localization:text("hint_trade_down_restored") })
	end
end
