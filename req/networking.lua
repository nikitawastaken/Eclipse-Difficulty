-- Store chunked data
Eclipse.network_data = {}

NetworkHelper.Chunk = {
	prefix = "%begin%",
	infix = "%chunk%",
	suffix = "%end%",
}

-- Rework this function to allow chunking of network strings
function NetworkHelper:SendStringThroughChat(message, receivers, chunk, chunk_id)
	if chunk and message:len() > 200 then
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
			msg = NetworkHelper.Chunk.infix .. message:sub(position, position + 100)
			local chunk = NetworkHelper.AllPeersString:format(NetworkHelper.AllPeers, chunk_id, msg)
			position = position + 101
			self:SendStringThroughChat(chunk, receivers)
		else
			msg = NetworkHelper.Chunk.suffix .. message:sub(position)
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
	elseif data:find("^(%%end%%)") then
		Eclipse.network_data[hook_id] = Eclipse.network_data[hook_id] .. data:sub(1, data:len() - NetworkHelper.Chunk.suffix:len())
		local t = Eclipse.network_data[hook_id]
		Eclipse.network_data[hook_id] = nil
		return t
	-- In between the first and last chunk
	elseif data:find("^(%%chunk%%)") and Eclipse.network_data[hook_id] then
		Eclipse.network_data[hook_id] = Eclipse.network_data[hook_id] .. data
	end
	return false
end
