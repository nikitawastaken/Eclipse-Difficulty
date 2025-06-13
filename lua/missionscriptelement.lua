core:import("CoreMissionScriptElement")
core:import("CoreClass")

Hooks:PostHook(MissionScriptElement, "execute_on_executed", "eclipse_coremselement_execute_on_executed", function(self, params)
	local instigator = params.instigator
	if self._values.callback and type(self._values.callback) == "function" then
		self._values.callback(instigator)
	end
end)
