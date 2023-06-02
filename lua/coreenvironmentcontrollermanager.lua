local tmp_vec = Vector3()


-- Make flashbangs scale with look direction instead of a flat reduction at some certain angle
Hooks:OverrideFunction(CoreEnvironmentControllerManager, "test_line_of_sight", function (self, test_pos, min_distance, dot_distance, max_distance)
	local vp = managers.viewport:first_active_viewport()

	if not vp then
		return 0
	end

	local camera = vp:camera()

	camera:m_position(tmp_vec)

	local dis = mvector3.direction(tmp_vec, tmp_vec, test_pos)

	if dis > max_distance then
		return 0
	end

	if dis < min_distance then
		return 1
	end

	local cam_fwd = camera:rotation():y()
	local dot_mul = (mvector3.dot(cam_fwd, tmp_vec) + 1) / 2
	local dot_effect = dis > dot_distance and 1 or dis / dot_distance


	return math.map_range_clamped(dis, min_distance, max_distance, 1, 0) * (dot_mul ^ dot_effect)
end)

-- Tone down the red screen on health hits
function CoreEnvironmentControllerManager:set_health_effect_value(health_effect_value)
	self._health_effect_value = health_effect_value * 2
end