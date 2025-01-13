local tmp_vec = Vector3()

-- Improve following in big nav segments
function TeamAILogicIdle._check_should_relocate(data, my_data, objective)
	local follow_movement = objective.follow_unit:movement()

	local max_allowed_dis_xy = 500
	local max_allowed_dis_z = 250

	if follow_movement:nav_tracker():nav_segment() == data.unit:movement():nav_tracker():nav_segment() then
		max_allowed_dis_xy = max_allowed_dis_xy * 3
	elseif data.unit:raycast("ray", data.unit:movement():m_head_pos(), follow_movement:m_head_pos(), "slot_mask", data.visibility_slotmask, "report") then
		max_allowed_dis_xy = max_allowed_dis_xy / 2
	end

	mvector3.set(tmp_vec, follow_movement:m_newest_pos())
	mvector3.subtract(tmp_vec, data.m_pos)

	if math.abs(tmp_vec.z) > max_allowed_dis_z then
		return true
	end

	mvector3.set_z(tmp_vec, 0)
	return mvector3.length(tmp_vec) > max_allowed_dis_xy
end
