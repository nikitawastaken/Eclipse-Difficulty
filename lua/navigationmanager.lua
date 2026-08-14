-- Nav seg ids have been changed to string, attempt to access them both ways
Hooks:PostHook(NavigationManager, "_load_nav_data", "sh__load_nav_data", function(self)
	setmetatable(self._nav_segments, {
		__index = function(t, k)
			return type(k) == "number" and rawget(t, tostring(k)) or nil
		end
	})
end)
