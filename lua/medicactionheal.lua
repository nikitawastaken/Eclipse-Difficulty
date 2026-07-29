if not Network:is_server() then
	return
end

-- Make bots aware of Medic healing
Hooks:PostHook(MedicActionHeal, "init", "eclipse_init", function(self)
	self._is_sabotaging_action = true
	Eclipse.utils.team_ai_force_attention(self._unit)
end)
