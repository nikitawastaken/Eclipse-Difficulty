local blib_warn
Hooks:Add("BeardLibPreProcessScriptData", "KillBLibWarnBeforeProcessing", function()
	blib_warn = BeardLib.Warn
	function BeardLib:Warn(...)
		-- noop
	end
end)

Hooks:Add("BeardLibProcessScriptData", "UnkillBLibWarnAfterProcessing", function()
	function BeardLib:Warn(...)
		return blib_warn(self, ...)
	end
end)
