-- Flag SOs that are absolutely, 100% hiding Cloaker SOs
local function flag_followup_sos(self)
	local followup_elements = self._values.mode == "recurring_cloaker_spawn" and self._values.followup_elements
	if not followup_elements then
		return
	end

	for _, id in pairs(followup_elements) do
		local element = self:get_mission_element(id)
		local values = element and element:values()
		if values then
			values.SO_group_hiding_cloaker_SO = true
		else
			Eclipse:warn_console(string.format("Hiding Cloaker SO %u does not exist or does not have values", id))
		end
	end
end

Hooks:PreHook(ElementSpecialObjectiveGroup, "on_executed", "eclipse_on_executed", flag_followup_sos)
Hooks:PreHook(ElementSpecialObjectiveGroup, "client_on_executed", "eclipse_client_on_executed", flag_followup_sos)
