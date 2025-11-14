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
end)

Hooks:PostHook(DoctorBagBase, "update", "eclipse_update", function(self)
	if not managers.groupai:state():check_deployable_nav_seg(self._deployed_nav_seg_id) and not self._empty then
		managers.groupai:state():add_deployable_reenforce(self:get_name_id(), self._unit, self._unit:position(), self._deployed_nav_seg_id)
	elseif self._empty then
		managers.groupai:state():remove_deployable_reenforce(self._unit, self._deployed_nav_seg_id)
	end
end)

