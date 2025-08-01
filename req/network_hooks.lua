-- For Network Hook IDs, the naming convention is as follows:
-- 1. Prefix with Eclipse_
-- 2. Follow with the class name that sends the network string
-- 3. Follow with the method in the class that sends the string
-- 4. In case a single method sends multiple strings, prefix
-- all following strings with an index
--
-- e.g. If you're sending a string from PlayerManager using
-- the function [PlayerManager.do_stuff(...)]
-- then the corresponding ID is "Eclipse_PlayerManager.do_stuff"
-- and if there is another request to send, the corresponding ID
-- would be "Eclipse_PlayerManager.do_stuff2"

NetworkHelper:AddReceiveHook("Eclipse_CopLogicTrade.enter", "eclipse_hostage_trade_hook", function(data, sender)
	if NetworkHelper:IsChunk("Eclipse_CopLogicTrade.enter", data) then
		local t = NetworkHelper:ReceiveChunks("Eclipse_CopLogicTrade.enter", data)
		if t then
			data = t
		else
			return
		end
	end

	local params = NetworkHelper:decode(data)
	local unit = Eclipse.utils.get_unit_from_id(params.unit_id)
	if not unit or not alive(unit) then
		return
	end

	CopLogicTrade.hostage_trade(unit, params.enable, params.trade_success, params.skip_hint, params.is_custody_trade)
	Eclipse.network_data["Eclipse_CopLogicTrade.enter"] = nil
end)

NetworkHelper:AddReceiveHook("Eclipse_HuskCopBrain:on_trade", "eclipse_on_trade_hook", function(data, sender)
	if NetworkHelper:IsChunk("Eclipse_HuskCopBrain:on_trade", data) then
		local t = NetworkHelper:ReceiveChunks("Eclipse_HuskCopBrain:on_trade", data)
		if t then
			data = t
		else
			return
		end
	end

	local params = NetworkHelper:decode(data)
	local unit = Eclipse.utils.get_unit_from_id(params.unit_id)
	if not unit or not alive(unit) then
		return
	end
	if not NetworkHelper:IsHost() then
		-- How???
		return
	end

	local is_custody_trade = params.is_custody_trade
	unit:brain():on_trade(params.position, params.rotation, true, is_custody_trade)
	NetworkHelper:SendToPeersChunk(
		"Eclipse_HuskCopBrain:on_trade2",
		NetworkHelper:encode({
			position = params.position,
			rotation = params.rotation,
			is_custody_trade = is_custody_trade,
		})
	)
end)

NetworkHelper:AddReceiveHook("Eclipse_HuskCopBrain:on_trade2", "eclipse_on_trade_hook2", function(data, sender)
	if NetworkHelper:IsClient() then
		if NetworkHelper:IsChunk("Eclipse_HuskCopBrain:on_trade2", data) then
			local t = NetworkHelper:ReceiveChunks("Eclipse_HuskCopBrain:on_trade2", data)
			if t then
				data = t
			else
				return
			end
		end
		local params = NetworkHelper:decode(data)
		local is_custody_trade = params.is_custody_trade
		managers.trade:on_hostage_traded(params.position, params.rotation, is_custody_trade)
	end
end)

NetworkHelper:AddReceiveHook("Eclipse_TradeManager:trade_restore_resources", "eclipse_trade_sync_hook", function(data, sender)
	if NetworkHelper:IsChunk("Eclipse_TradeManager:trade_restore_resources", data) then
		local t = NetworkHelper:ReceiveChunks("Eclipse_TradeManager:trade_restore_resources", data)
		if t then
			data = t
		else
			return
		end
	end

	-- If you're not in a game, not in a heist, or somehow this got called
	-- when you were in custody, don't continue with the resource trade
	if not Utils:IsInGameState() or not Utils:IsInHeist() or Utils:IsInCustody() then
		return
	end

	local params = NetworkHelper:decode(data)
	local is_recon_over = params.is_recon_over == "yes"

	local has_trading_delay_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_assault_delay")
	local has_trading_ammo_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_ammo")
	local has_trading_health_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_health")
	local amount_of_pickups = managers.player:team_upgrade_value("player", "resource_trading_ammo", 0)
	local amount_of_health = managers.player:team_upgrade_value("player", "resource_trading_health", 0)
	local unit = managers.player:player_unit()

	unit:character_damage():restore_lives(1)

	if has_trading_health_upgrade then
		unit:character_damage():restore_health_percentage(amount_of_health)

		unit:sound():play("pickup_ammo_health_boost", nil, true)
	end

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
				weapon.unit:base():add_ammo(amount_of_pickups, false)
				managers.hud:set_ammo_amount(weapon.unit:base():selection_index(), weapon.unit:base():ammo_info())
			end
		end
	end

	if has_trading_delay_upgrade and not is_recon_over then
		managers.hud:show_hint({ text = managers.localization:text("hint_trade_down_resources_restored_assault_delay") })
	elseif has_trading_health_upgrade then
		managers.hud:show_hint({ text = managers.localization:text("hint_trade_down_resources_restored") })
	else
		managers.hud:show_hint({ text = managers.localization:text("hint_trade_down_restored") })
	end
end)
