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

-- Mark doctor bags for reinforce groups
Hooks:PostHook(DoctorBagBase, "setup", "eclipse_setup", function(self)
	self._deployed_nav_seg_id = managers.navigation:get_nav_seg_from_pos(self._unit:position(), true)
	
	if tweak_data.group_ai.equipment_reenforce and tweak_data.group_ai.equipment_reenforce[self:get_name_id()] and tweak_data.group_ai.use_equipment_reenforce and not managers.groupai:state():check_deployable_nav_seg(self._deployed_nav_seg_id) then
		managers.groupai:state():set_area_min_police_force(self._unit:key(), 1, self._unit:position())
		managers.groupai:state():register_deployable_nav_seg(self._deployed_nav_seg_id)
	end
end)

Hooks:PostHook(DoctorBagBase, "_set_empty", "eclipse_set_empty", function(self)
	managers.groupai:state():set_area_min_police_force(self._unit:key())
	managers.groupai:state():unregister_deployable_nav_seg(self._deployed_nav_seg_id)
end)
