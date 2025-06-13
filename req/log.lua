---@module log
local M = {}
M.log_file = Eclipse.mod_path .. "log.txt"
M.enabled = {
	info = true,
	debug = true,
	warn = true,
	error = true,
	all = true,
}

function M.log(...)
	if M.enabled.all and M.enabled.info then
		local f = io.open(M.log_file, "a")
		if f then
			f:write(table.concat({ "[INFO]:", ... }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.debug(...)
	if M.enabled.all and M.enabled.debug then
		local f = io.open(M.log_file, "a")
		if f then
			f:write(table.concat({ "[DEBUG]:", ... }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.warn(...)
	if M.enabled.all and M.enabled.warn then
		local f = io.open(M.log_file, "a")
		if f then
			f:write(table.concat({ "[WARN]:", ... }, "\t") .. "\n")
			f:close()
		end
	end
end

function M.error(...)
	if M.enabled.all and M.enabled.error then
		local f = io.open(M.log_file, "a")
		if f then
			f:write(table.concat({ "[ERROR]:", ... }, "\t") .. "\n")
			f:close()
		end
	end
end

-- Allow this table to be called as a function
local mt = {
	__call = function(self, level, ...)
		if level == "debug" then
			self.debug(unpack({ ... }))
		elseif level == "warn" then
			self.warn(unpack({ ... }))
		elseif level == "error" then
			self.error(unpack({ ... }))
		else -- default to info log
			self.log(level, unpack({ ... }))
		end
	end,
}
setmetatable(M, mt)

return M
