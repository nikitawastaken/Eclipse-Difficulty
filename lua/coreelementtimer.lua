core:module("CoreElementTimer")

--[[
-- Added balance multipliers
-- Does not update digital GUIs properly
Hooks:PreHook(ElementTimer, "update_timer", "eclipse_update_timer", function(self, t, dt)
	if self._values.dt_balance_mul then
		self._timer = self._timer - dt * (managers.groupai:state():_get_balancing_multiplier(self._values.dt_balance_mul, self._values.team_ai_balance_mul_weight) - 1)
	end
end)
]]

-- Added balance multipliers
-- Comes with some handling to update digital GUIs if a dt mod is present
-- Maybe there's a better way to do it but this works for now
Hooks:OverrideFunction(ElementTimer, "update_timer", function(self, t, dt)
	local dt_mod = self._values.dt_balance_mul
	dt_mod = dt_mod and managers.groupai:state():_get_balancing_multiplier(dt_mod, self._values.team_ai_balance_mul_weight) or 1
	self._timer = self._timer - dt * dt_mod

	-- Network spam :dlc:
	if dt_mod ~= 1 then
		self:_update_digital_guis_timer()
	end

	if self._timer <= 0 then
		self:remove_updator()
		self:on_executed()
	end

	for id, cb_data in pairs(self._triggers) do
		if self._timer <= cb_data.time and not cb_data.disabled then
			cb_data.callback()
			self:remove_trigger(id)
		end
	end
end)
