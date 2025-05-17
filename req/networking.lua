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

-- Store chunked data
Eclipse.network_data = {}

NetworkHelper.Chunk = {
	prefix = "%begin%",
	suffix = "%end%",
}

-- Rework this function to allow chunking of network strings
function NetworkHelper:SendStringThroughChat(message, receivers, chunk, chunk_id)
	if chunk then
		self:ChunkStringThroughChat(message, receivers, chunk_id)
	else
		for _, peer in pairs(receivers or self:GetPeers()) do
			if peer:ip_verified() then
				peer:send("send_chat_message", NetworkHelper.HiddenChannel, message)
			end
		end

		local local_peer = managers.network and managers.network:session() and managers.network:session():local_peer()
		BLT:Log(LogLevel.INFO, string.format("[NetworkHelper] %s: %s", local_peer and local_peer:name() or "", message))
	end
end

-- Ghetto chunker
function NetworkHelper:ChunkStringThroughChat(message, receivers, chunk_id)
	local position
	local msg = NetworkHelper.Chunk.prefix .. message:sub(1, 100)
	local first_chunk = NetworkHelper.AllPeersString:format(NetworkHelper.AllPeers, chunk_id, msg)
	position = 101
	self:SendStringThroughChat(first_chunk, receivers)
	while true do
		if position + 101 < message:len() then
			msg = message:sub(position, position + 100)
			local chunk = NetworkHelper.AllPeersString:format(NetworkHelper.AllPeers, chunk_id, msg)
			position = position + 101
			self:SendStringThroughChat(chunk, receivers)
		else
			msg = message:sub(position) .. NetworkHelper.Chunk.suffix
			local chunk = NetworkHelper.AllPeersString:format(NetworkHelper.AllPeers, chunk_id, msg)
			self:SendStringThroughChat(chunk, receivers)
			break
		end
	end
end

---Sends networked data with a message id to the host
---@param id string @Unique name of the data to send
---@param data string @Data to send
function NetworkHelper:SendToHost(id, data)
	if self:IsClient() then
		local host_id = managers.network:session()._server_peer:id()
		self:SendToPeer(host_id, id, data)
	end
end

---Sends networked data with a message id to the host, chunked
---@param id string @Unique name of the data to send
---@param data string @Data to send
function NetworkHelper:SendToHostChunk(id, data)
	if self:IsClient() then
		local host_id = managers.network:session()._server_peer:id()
		self:SendToPeerChunk(host_id, id, data)
	end
end

---Sends networked data with a message id to all connected players, chunked
---@param id string @Unique name of the data to send
---@param data string @Data to send
function NetworkHelper:SendToPeersChunk(id, data)
	self:SendStringThroughChat(data, self:GetPeers(), true, id)
end

---Sends networked data with a message id to a specific player, chunked
---@param peer_id integer @Peer ID of the player to send the data to
---@param id string @Unique name of the data to send
---@param data string @Data to send
function NetworkHelper:SendToPeerChunk(peer_id, id, data)
	self:SendStringThroughChat(data, { self:GetPeers()[peer_id] }, true, id)
end

---Encodes networked data and handles Vector3/Rotation/Bools properly
---@param data table @Data to serialize
---@return string @Data serialized as a string
function NetworkHelper:encode(data)
	for k, v in pairs(data) do
		-- You better hope no networked tables have this in somehow :skull:
		if type_name(v) == "Vector3" then
			data[k] = {
				serialized_data_type = "Vector3",
				serialized_data = vector_to_string(v),
			}
		elseif type_name(v) == "Rotation" then
			data[k] = {
				serialized_data_type = "Rotation",
				serialized_data = rotation_to_string(v),
			}
		elseif type_name(v) == "boolean" then
			data[k] = {
				serialized_data_type = "Boolean",
				serialized_data = tostring(v),
			}
		end
	end

	return json.encode(data)
end

---Decodes networked data and handles Vector3/Rotation/Bools properly
---@param data string @Data to deserialize
---@return table @Data deserialized as a lua table
function NetworkHelper:decode(data)
	local t = json.decode(data)
	for k, v in pairs(t) do
		if type_name(v) == "table" and v.serialized_data_type then
			if v.serialized_data_type == "Vector3" then
				t[k] = math.string_to_vector(v.serialized_data)
			elseif v.serialized_data_type == "Rotation" then
				t[k] = math.string_to_rotation(v.serialized_data)
			elseif v.serialized_data_type == "Boolean" then
				t[k] = v.serialized_data == "true"
			end
		end
	end

	return t
end

function NetworkHelper:IsChunk(hook_id, data)
	return Eclipse.network_data[hook_id] or data:find("^(%%begin%%)") or data:find("(%%end%%)$") and true
end

function NetworkHelper:ReceiveChunks(hook_id, data)
	if data:find("^(%%begin%%)") then
		Eclipse.network_data[hook_id] = data:sub(NetworkHelper.Chunk.prefix:len() + 1)
	-- Chunk suffix check
	elseif data:find("(%%end%%)$") then
		Eclipse.network_data[hook_id] = Eclipse.network_data[hook_id] .. data:sub(1, data:len() - NetworkHelper.Chunk.suffix:len())
		local t = Eclipse.network_data[hook_id]
		Eclipse.network_data[hook_id] = nil
		return t
	-- In between the first and last chunk
	elseif Eclipse.network_data[hook_id] then
		Eclipse.network_data[hook_id] = Eclipse.network_data[hook_id] .. data
	end
	return false
end

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
	NetworkHelper:SendToPeers(
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
