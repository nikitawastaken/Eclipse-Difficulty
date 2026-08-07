function DoctorBagBase:_set_visual_stage()
	local percentage = self._amount / self._max_amount

	if self._unit:damage() then
		-- Fully upgraded doctor bags only display 3 blood bags
		local state = "state_" .. math.ceil(percentage * 3)

		if self._unit:damage():has_sequence(state) then
			self._unit:damage():run_sequence_simple(state)
		end
	end
end

Hooks:PostHook(DoctorBagBase, "setup", "eclipse_setup", function(self)
	-- Register the deployable for voice lines and reinforce
	local nav_seg_id = managers.navigation:get_nav_seg_from_pos(self._unit:position(), true)
	local area = managers.groupai:state():get_area_from_nav_seg_id(nav_seg_id)

	managers.groupai:state():register_deployable(self._unit, area, self:get_name_id())
end)

Hooks:PostHook(DoctorBagBase, "_set_empty", "eclipse__set_empty", function(self)
	-- Unregister the deployable for voice lines and reinforce
	managers.groupai:state():unregister_deployable(self._unit:key())
end)
