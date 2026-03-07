-- Disable mission waypoins if No Outlines mutator enabled
function ElementWaypoint:on_executed(instigator)
	if not self._values.enabled then
		return
	end
	
	if managers.mutators:modify_value("ElementWaypoint:NoOutlines", false) then
		return
	end

	if self._values.only_on_instigator and instigator ~= managers.player:player_unit() then
		ElementWaypoint.super.on_executed(self, instigator)

		return
	end

	if not self._values.only_in_civilian or managers.player:current_state() == "civilian" then
		local text = managers.localization:text(self._values.text_id)

		managers.hud:add_waypoint(self._id, {
			distance = true,
			state = "sneak_present",
			present_timer = 0,
			text = text,
			icon = self._values.icon,
			position = self._values.position
		})
	elseif managers.hud:get_waypoint_data(self._id) then
		managers.hud:remove_waypoint(self._id)
	end

	ElementWaypoint.super.on_executed(self, instigator)
end