---@module log
local M = {}
M.log_file = Eclipse.mod_path .. "log.txt"
M.Level = {
	INFO = "info",
	DEBUG = "debug",
	WARN = "warn",
	ERROR = "error",
}
M._level = M.Level.INFO
M.enabled = {
	info = true,
	debug = true,
	warn = true,
	error = true,
	all = true,
}
M._spam_t = 0
M._spam_buff = {}
M._spam_sep = "\n" .. string.rep("=-", 10) .. "="
M._spam_prev_msg = ""

local function get_time()
	return os.date("%d-%m-%y %H:%M:%S", os.time())
end

function M.log(...)
	return M[M._level](...)
end

function M.info(...)
	if M.enabled.all and M.enabled.info then
		local f = io.open(M.log_file, "a")
		if f then
			local args = { ... }
			local log = tostring(table.remove(args, 1))
			f:write(table.concat({ get_time() .. " [INFO]: " .. log, unpack(args) }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.debug(...)
	if M.enabled.all and M.enabled.debug then
		local f = io.open(M.log_file, "a")
		if f then
			local args = { ... }
			local log = tostring(table.remove(args, 1))
			f:write(table.concat({ get_time() .. " [DEBUG]: " .. log, unpack(args) }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.warn(...)
	if M.enabled.all and M.enabled.warn then
		local f = io.open(M.log_file, "a")
		if f then
			local args = { ... }
			local log = tostring(table.remove(args, 1))
			f:write(table.concat({ get_time() .. " [WARN]: " .. log, unpack(args) }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.error(...)
	if M.enabled.all and M.enabled.error then
		local f = io.open(M.log_file, "a")
		if f then
			local args = { ... }
			local log = tostring(table.remove(args, 1))
			f:write(table.concat({ get_time() .. " [ERROR]: " .. log, unpack(args) }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.set_file(f)
	M.log_file = f
end

function M.chat_spam(id, msg)
	if not Utils:IsInGameState() or not Utils:IsInHeist() then
		return
	end

	local t = Application:time()
	M._spam_buff[id] = msg
	local chat_msg
	if not managers.groupai:state():whisper_mode() and (M._spam_t + 2) < t then
		if table.size(M._spam_buff) > 0 then
			M._spam_t = t
			chat_msg = ""
			for _, buff in pairs(M._spam_buff) do
				chat_msg = chat_msg .. buff .. "\n"
			end
		else
			chat_msg = "All tests passed."
		end
	end
	if chat_msg and chat_msg ~= M._spam_prev_msg then
		Eclipse:log_chat(chat_msg .. M._spam_sep)
		M.info(chat_msg)
		M._spam_prev_msg = chat_msg
	end
end

-- Allow this table to be called as a function
local mt = {
	__call = function(self, level, ...)
		if level == M.Level.DEBUG then
			self.debug(unpack({ ... }))
		elseif level == M.Level.WARN then
			self.warn(unpack({ ... }))
		elseif level == M.Level.ERROR then
			self.error(unpack({ ... }))
		elseif level == M.Level.INFO then
			self.info(unpack({ ... }))
		else -- default to global log
			self.log(level, unpack({ ... }))
		end
	end,
}
setmetatable(M, mt)

return M
