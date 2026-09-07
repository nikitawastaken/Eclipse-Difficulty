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

-- Register the deployable for voice lines and reinforce
Hooks:PostHook(DoctorBagBase, "spawn", "eclipse_spawn", function(pos, rot, bits, peer_id)
	local unit = Hooks:GetReturn()

	if peer_id then
		-- Register the deployable for voice lines and reinforce
		local nav_seg_id = managers.navigation:get_nav_seg_from_pos(unit:position(), true)
		local area = managers.groupai:state():get_area_from_nav_seg_id(nav_seg_id)

		managers.groupai:state():register_deployable(unit, area, "doctor_bag")
	end
end)

-- Unregister the deployable for voice lines and reinforce
Hooks:PostHook(DoctorBagBase, "_set_empty", "eclipse_post_set_empty", function(self)
	managers.groupai:state():unregister_deployable(self._unit:key())
end)
