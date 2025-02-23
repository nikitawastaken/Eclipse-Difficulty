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

-- bring back old hitflash for pro-jobs
local ids_hdr_post_processor = Idstring("hdr_post_processor")
local ids_hdr_post_composite = Idstring("post_DOF")
local mvec1 = Vector3()
local ids_dof_settings = Idstring("settings")
local ids_radial_offset = Idstring("radial_offset")
local ids_LUT_post = Idstring("color_grading_post")
local temp_vec_1 = Vector3()
local temp_vec_2 = Vector3()
local ids_LUT_settings = Idstring("lut_settings")
local ids_LUT_settings_a = Idstring("LUT_settings_a")
local ids_LUT_settings_b = Idstring("LUT_settings_b")
local ids_LUT_contrast = Idstring("contrast")
function CoreEnvironmentControllerManager:set_post_composite(t, dt)
	local vp = managers.viewport:first_active_viewport()

	if not vp then
		return
	end

	if self._occ_dirty then
		self._occ_dirty = false

		self:_refresh_occ_params(vp)
	end

	if self._fov_ratio_dirty then
		self:_refresh_fov_ratio_params(vp)

		self._fov_ratio_dirty = false
	end

	if self._vp ~= vp or not alive(self._material) then
		local hdr_post_processor = vp:vp():get_post_processor_effect("World", ids_hdr_post_processor)

		if hdr_post_processor then
			local post_composite = hdr_post_processor:modifier(ids_hdr_post_composite)

			if not post_composite then
				return
			end

			self._material = post_composite:material()

			if not self._material then
				return
			end

			self._vp = vp

			self:_update_post_effects()
		end
	end

	local camera = vp:camera()
	local color_tweak = mvec1

	if camera then
		-- Nothing
	end

	if self._old_vp ~= vp then
		self._occ_dirty = true
		self._fov_ratio_dirty = true

		self:refresh_render_settings()

		self._old_vp = vp
	end

	local blur_zone_val = 0
	blur_zone_val = self:_blurzones_update(t, dt, camera:position())

	if self._hit_some > 0 then
		local hit_fade = dt * 1.5
		self._hit_some = math.max(self._hit_some - hit_fade, 0)
		self._hit_right = math.max(self._hit_right - hit_fade, 0)
		self._hit_left = math.max(self._hit_left - hit_fade, 0)
		self._hit_up = math.max(self._hit_up - hit_fade, 0)
		self._hit_down = math.max(self._hit_down - hit_fade, 0)
		self._hit_front = math.max(self._hit_front - hit_fade, 0)
		self._hit_back = math.max(self._hit_back - hit_fade, 0)
	end

	local flashbang = 0
	local flashbang_flash = 0

	if self._current_flashbang > 0 then
		local flsh = self._current_flashbang
		self._current_flashbang = math.max(self._current_flashbang - dt * 0.08 * self._flashbang_multiplier * self._flashbang_duration, 0)
		flashbang = math.min(self._current_flashbang, 1)
		self._current_flashbang_flash = math.max(self._current_flashbang_flash - dt * 0.9, 0)
		flashbang_flash = math.min(self._current_flashbang_flash, 1)
	end

	local concussion = 0

	if self._current_concussion > 0 then
		self._current_concussion = math.max(self._current_concussion - dt * 0.08 * self._concussion_multiplier * self._concussion_duration, 0)
		concussion = math.min(self._current_concussion, 1)
	end

	local hit_some_mod = 1 - self._hit_some
	hit_some_mod = hit_some_mod * hit_some_mod * hit_some_mod
	hit_some_mod = 1 - hit_some_mod
	local downed_value = self._downed_value / 100
	local death_mod = math.max(1 - self._health_effect_value - 0.5, 0) * 2
	local blur_zone_flashbang = blur_zone_val + flashbang
	local flash_1 = math.pow(flashbang, 0.4)
	flash_1 = flash_1 + math.pow(concussion, 0.4)
	local flash_2 = math.pow(flashbang, 16) + flashbang_flash

	if self._custom_dof_settings then
		self._material:set_variable(ids_dof_settings, self._custom_dof_settings)
	elseif flash_1 > 0 then
		self._material:set_variable(ids_dof_settings, Vector3(math.min(self._hit_some * 10, 1) + blur_zone_flashbang * 0.4, math.min(blur_zone_val + downed_value * 2 + flash_1, 1), 10 + math.abs(math.sin(t * 10) * 40) + downed_value * 3))
	else
		self._material:set_variable(ids_dof_settings, Vector3(math.min(self._hit_some * 10, 1) + blur_zone_flashbang * 0.4, math.min(blur_zone_val + downed_value * 2, 1), 1 + downed_value * 3))
	end

	self._material:set_variable(ids_radial_offset, Vector3((self._hit_left - self._hit_right) * 0.2, (self._hit_up - self._hit_down) * 0.2, self._hit_front - self._hit_back + blur_zone_flashbang * 0.1))
	self._material:set_variable(Idstring("contrast"), self._base_contrast + self._hit_some * 0.25)

	if self._chromatic_enabled then
		self._material:set_variable(Idstring("chromatic_amount"), self._base_chromatic_amount + blur_zone_val * 0.3 + flash_1 * 0.5)
	else
		self._material:set_variable(Idstring("chromatic_amount"), 0)
	end

	self:_update_dof(t, dt)

	local lut_post = vp:vp():get_post_processor_effect("World", ids_LUT_post)

	if lut_post then
		local lut_modifier = lut_post:modifier(ids_LUT_settings)

		if not lut_modifier then
			return
		end

		self._lut_modifier_material = lut_modifier:material()

		if not self._lut_modifier_material then
			return
		end
	end

	local hurt_mod = 1 - self._health_effect_value
	local health_diff = math.clamp((self._old_health_effect_value - self._health_effect_value) * 4, 0, 1)
	self._old_health_effect_value = self._health_effect_value

	if self._health_effect_value_diff < health_diff then
		self._health_effect_value_diff = health_diff
	end

	self._health_effect_value_diff = math.max(self._health_effect_value_diff - dt * 0.5, 0)
	self._buff_effect_value = math.min(self._buff_effect_value + dt * 0.5, 0)

	mvector3.set(temp_vec_1, Vector3(math.clamp(self._health_effect_value_diff * 1.3 * (1 + hurt_mod * 1.3), 0, 1.2), 0, math.min(blur_zone_val + self._HE_blinding, 1)))
	mvector3.add(temp_vec_1, Vector3(self._buff_effect_value, self._buff_effect_value, self._buff_effect_value, 0.5))
	self._lut_modifier_material:set_variable(ids_LUT_settings_a, temp_vec_1)

	local last_life = 0

	if self._last_life then
		last_life = math.clamp((hurt_mod - 0.5) * 2, 0, 1)
	end

	if not self._screenflash_colors_setup then
		self:set_screenflash_colors_clbks()
	end

	self:_handle_screenflash(flash_2, 0, 0)
    -- this entire overwrite mess just to replace this single line
	mvector3.set_static(temp_vec_2, last_life, math.max(0, flash_2 + math.clamp(hit_some_mod * 2, 0, 1) * 0.25 + blur_zone_val * 0.15), 0)
	self._lut_modifier_material:set_variable(ids_LUT_settings_b, temp_vec_2)
	self._lut_modifier_material:set_variable(ids_LUT_contrast, flashbang * 0.5)
end

Hooks:PostHook(CoreEnvironmentControllerManager, "init", "eclipse_init", function(self)
	if is_pro_job then
		self._hit_amount = 0.3
	end
end)

function CoreEnvironmentControllerManager:hit_feedback_front()
	if is_pro_job then
		self._hit_front = math.min(self._hit_front + self._hit_amount, 1)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_back()
	if is_pro_job then
		self._hit_back = math.min(self._hit_back + self._hit_amount, 1)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_right()
	if is_pro_job then
		self._hit_right = math.min(self._hit_right + self._hit_amount, 1)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_left()
	if is_pro_job then
		self._hit_left = math.min(self._hit_left + self._hit_amount, 1)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_up()
	if is_pro_job then
		self._hit_up = math.min(self._hit_up + self._hit_amount, 1)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1)
	end
end

function CoreEnvironmentControllerManager:hit_feedback_down()
	if is_pro_job then
		self._hit_down = math.min(self._hit_down + self._hit_amount, 1)
		self._hit_some = math.min(self._hit_some + self._hit_amount, 1)
	end
end
