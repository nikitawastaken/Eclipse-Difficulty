-- Improve following behavior
function TeamAILogicIdle._check_should_relocate(data, my_data, objective)
	local follow_movement = objective.follow_unit:movement()
	if data.unit:raycast("ray", data.unit:movement():m_head_pos(), follow_movement:m_head_pos(), "slot_mask", data.visibility_slotmask, "report") then
		return true
	end

	local follow_pos = follow_movement:m_newest_pos()
	return math.abs(follow_pos.z - data.m_pos.z) > 200 or mvector3.distance_sq(follow_pos, data.m_pos) > 600 ^ 2
end
