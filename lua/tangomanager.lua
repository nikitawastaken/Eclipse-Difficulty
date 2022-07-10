-- unlock arbiter (hydrogen)
local original_function = original_function or TangoManager.load
    function TangoManager:load(cache, version)
    	local state = cache.Tango
    	if state and state.version == TangoManager.SAVE_DATA_VERSION then
    		for _, saved_challenge in ipairs(state.challenges or {}) do
    			saved_challenge.completed = true
    	end
    end
    return original_function(self, cache, version)
end