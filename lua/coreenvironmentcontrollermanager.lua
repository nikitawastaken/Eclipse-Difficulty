local tmp_vec = Vector3()
local is_pro_job = Eclipse.utils.is_pro_job()

-- Make flashbangs scale with look direction instead of a flat reduction at some certain angle
Hooks:OverrideFunction(CoreEnvironmentControllerManager, "test_line_of_sight", function(self, test_pos, min_distance, dot_distance, max_distance)
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

Hooks:PostHook(CoreEnvironmentControllerManager, "init", "eclipse_init", function(self)
	if is_pro_job then
		self._hit_amount = 0.45
	end
end)

function CoreEnvironmentControllerManager:hit_feedback_front()
	if is_pro_job then
		self._hit_front = math.min(self._hit_front + self._hit_amount, 1.5)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1.5)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_back()
	if is_pro_job then
		self._hit_back = math.min(self._hit_back + self._hit_amount, 1.5)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1.5)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_right()
	if is_pro_job then
		self._hit_right = math.min(self._hit_right + self._hit_amount, 1.5)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1.5)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_left()
	if is_pro_job then
		self._hit_left = math.min(self._hit_left + self._hit_amount, 1.5)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1.5)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_up()
	if is_pro_job then
		self._hit_up = math.min(self._hit_up + self._hit_amount, 1.5)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1.5)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_down()
	if is_pro_job then
		self._hit_down = math.min(self._hit_down + self._hit_amount, 1.5)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1.5)
	end
end