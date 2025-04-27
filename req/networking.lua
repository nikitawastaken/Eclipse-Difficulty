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

---Sends networked data with a message id to the host
---@param id string @Unique name of the data to send
---@param data string @Data to send
function NetworkHelper:SendToHost(id, data)
	if self:IsClient() then
		local host_id = managers.network:session()._server_peer:id()
		self:SendToPeer(host_id, id, data)
	end
end

---Encodes networked data and handles Vector3/Rotation properly
---@param data table @Data to serialize
---@return string @Data serialized as a string
function NetworkHelper:encode(data)
	for k, v in pairs(data) do
		-- You better hope no networked tables have this in somehow :skull:
		if type_name(v) == "Vector3" then
			data[k] = { "Vector3", vector_to_string(v) }
		elseif type_name(v) == "Rotation" then
			data[k] = { "Rotation", rotation_to_string(v) }
		elseif type_name(v) == "boolean" then
			data[k] = { "Boolean", tostring(v) }
		end
	end

	return json.encode(data)
end

---Decodes networked data and handles Vector3/Rotation properly
---@param data string @Data to deserialize
---@return table @Data deserialized as a lua table
function NetworkHelper:decode(data)
	local t = json.decode(data)
	for k, v in pairs(data) do
		if type_name(v) == "table" then
			if v[1] == "Vector3" then
				t[k] = math.string_to_vector(v[2])
			elseif v[1] == "Rotation" then
				t[k] = math.string_to_rotation(v[2])
			elseif v[1] == "Boolean" then
				t[k] = v[2] == "true"
			end
		end
	end

	return t
end

NetworkHelper:AddReceiveHook("Eclipse_CopLogicTrade.enter", "eclipse_hostage_trade_hook", function(data, sender)
	local params = NetworkHelper:decode(data)
	local unit = Eclipse.utils.get_unit_from_id(params.unit_id)
	if not unit or not alive(unit) then
		return
	end

	CopLogicTrade.hostage_trade(unit, params.enable, params.trade_success, params.skip_hint, params.is_custody_trade)
end)

NetworkHelper:AddReceiveHook("Eclipse_HuskCopBrain:on_trade", "eclipse_on_trade_hook", function(data, sender)
	local params = NetworkHelper:decode(data)
	local unit = Eclipse.utils.get_unit_from_id(params.unit_id)
	if not unit or not alive(unit) then
		return
	end
	if not NetworkHelper:IsHost() then
		-- How???
		return
	end

	local is_custody_trade = params.type == "custody"
	unit:brain():on_trade(params.position, params.rotation, true, is_custody_trade)
	NetworkHelper:SendToPeers(
		"Eclipse_HuskCopBrain:on_trade2",
		NetworkHelper:encode({
			position = params.position,
			rotation = params.rotation,
			type = params.type,
		})
	)
end)

NetworkHelper:AddReceiveHook("Eclipse_HuskCopBrain:on_trade2", "eclipse_on_trade_hook2", function(data, sender)
	if NetworkHelper:IsClient() then
		local params = NetworkHelper:decode(data)
		local is_custody_trade = params.type == "custody"
		managers.trade:on_hostage_traded(params.position, params.rotation, is_custody_trade)
	end
end)

NetworkHelper:AddReceiveHook("Eclipse_TradeManager:trade_restore_resources", "eclipse_trade_sync_hook", function(data, sender)
	local params = NetworkHelper:decode(data)
	local is_recon_over = params.is_recon_over == "yes"

	local has_trading_delay_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_assault_delay")
	local has_trading_ammo_upgrade = managers.player:has_team_category_upgrade("player", "resource_trading_ammo")
	local unit = managers.player:player_unit()

	unit:character_damage():restore_lives(1)

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

				unit:sound():play("pickup_ammo_health_boost", nil, true)
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
end)
