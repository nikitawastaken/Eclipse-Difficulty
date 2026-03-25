-- Security Camera Rework by Hoppip
if not Network:is_server() then
	return
end

core:import("CoreElementInstance")

local function check_executed_objects(trigger, current, checked)
	if not current or checked[current] then
		return
	end

	checked[current] = true

	for _, params in pairs(current._values.on_executed) do
		local element = managers.mission:get_element_by_id(params.id)
		local element_class = getmetatable(element)

		if element_class == ElementSecurityCamera and not element._values.ai_enabled then
			local camera_unit = element._values.camera_u_id and element:_fetch_unit_by_unit_id(element._values.camera_u_id)
			if camera_unit then
				camera_unit:base()._operator_triggers = camera_unit:base()._operator_triggers or {}
				camera_unit:base()._operator_triggers[trigger] = trigger
			end
		elseif element_class == CoreElementInstance.ElementInstanceOutput and element._output_elements then
			for _, output_element in pairs(element._output_elements) do
				check_executed_objects(trigger, output_element, checked)
			end
		end

		check_executed_objects(trigger, element, checked)
	end
end

Hooks:PostHook(ElementEnemyDummyTrigger, "on_script_activated", "on_script_activated_security_camera_rework", function(self)
	if self._values.event == "death" or self._values.event == "tied" or self._values.event == "alerted" then
		check_executed_objects(self, self, {})
	end
end)
