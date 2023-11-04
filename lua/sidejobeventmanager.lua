-- unlock event stuff
local original_function = original_function or SideJobEventManager.load
    function SideJobEventManager:load(cache, version)
    	local state = cache[self.save_table_name]
        if state and state.version == self.save_version then
    		for _, saved_challenge in ipairs(state.challenges or {}) do
    			saved_challenge.completed = true
    	end
    end
    return original_function(self, cache, version)
end