local tmp_rot = Rotation()
local tmp_vec1 = Vector3()

Hooks:PreHook(IngameAccessCamera, "at_exit", "camerarot_at_exit", function(self)
	local camera_unit = self:current_camera():camera_unit()
	if not camera_unit then
		return
	end

	camera_unit:base():sync_control_state(false)
end)

Hooks:OverrideFunction(IngameAccessCamera, "update", function(self, t, dt)
	if _G.IS_VR then
		local active_menu = managers.menu:active_menu()
		if active_menu and active_menu.name == "ingame_access_camera_menu" then
			self._controller:set_active(true)
		else
			self._controller:set_active(false)
		end
	end

	if self._no_feeds then
		return
	end

	t = managers.player:player_timer():time()
	dt = managers.player:player_timer():delta_time()

	local roll = 0
	local access_camera = self:current_camera()
	if access_camera and access_camera.is_moving and access_camera:is_moving() then
		local m_rot = self._cam_unit:camera():get_original_rotation()

		if m_rot then
			access_camera:m_camera_rotation(m_rot)
			roll = mrotation.roll(m_rot)
		end

		access_camera:m_camera_position(tmp_vec1)
		self._cam_unit:set_position(tmp_vec1)
	end

	local camera_unit = access_camera:camera_unit()
	local camera_base = camera_unit and camera_unit:base()
	if not camera_base or camera_base:has_control() then
		local look_d = self._controller:get_input_axis("look")
		if _G.IS_VR then
			look_d = self._controller:get_input_axis("touchpad_primary")

			if math.abs(look_d.x) < 0.01 then
				self._target_yaw = self._yaw
			end

			if math.abs(look_d.y) < 0.01 then
				self._target_pitch = self._pitch
			end
		end

		local zoomed_value = self._cam_unit:camera():zoomed_value()

		self._target_yaw = self._target_yaw - look_d.x * zoomed_value

		if self._yaw_limit ~= -1 then
			self._target_yaw = math.clamp(self._target_yaw, -self._yaw_limit, self._yaw_limit)
		end

		self._target_pitch = self._target_pitch + look_d.y * zoomed_value

		if self._pitch_limit ~= -1 then
			self._target_pitch = math.clamp(self._target_pitch, -self._pitch_limit, self._pitch_limit)
		end

		local yaw_diff = self._target_yaw - self._yaw
		local pitch_diff = self._target_pitch - self._pitch
		local angle_diff = math.pythagoras(yaw_diff, pitch_diff)
		if angle_diff > 0 then
			local step_rate = dt * 10

			self._yaw = math.step(self._yaw, self._target_yaw, step_rate * math.abs(yaw_diff) / angle_diff)
			self._pitch = math.step(self._pitch, self._target_pitch, step_rate * math.abs(pitch_diff) / angle_diff)
		end

		self._cam_unit:camera():set_offset_rotation(self._yaw, self._pitch, roll)

		if camera_base and camera_base:can_rotate() then
			local time_since_sync = self._last_sent_rot_t and t - self._last_sent_rot_t
			if camera_base:controlling_peer() and (not time_since_sync or time_since_sync > 0.1) then -- Host approved our control, we can send rotation updates
				camera_base:sync_target_rotation(self._yaw, self._pitch, true, time_since_sync)
				self._last_sent_rot_t = t
			end

			camera_base:apply_rotations(self._yaw, self._pitch)
		end
	else
		self._yaw, self._pitch = camera_base:current_rotation()
		self._target_yaw, self._target_pitch = self._yaw, self._pitch

		self._cam_unit:camera():set_offset_rotation(self._yaw, self._pitch, roll)
	end

	local move_d = self._controller:get_input_axis("move")
	if _G.IS_VR then
		move_d = self._controller:get_input_axis("touchpad_secondary")
	end

	self._cam_unit:camera():modify_fov(-move_d.y * dt * 12)

	if self._do_show_camera then
		self._do_show_camera = false

		managers.hud:set_access_camera_destroyed(access_camera:value("destroyed"))
	end

	local units = World:find_units_quick("all", 3, 16, 21, managers.slot:get_mask("enemies"))
	local amount = 0

	for i, unit in ipairs(units) do
		if World:in_view_with_options(unit:movement():m_head_pos(), 0, 0, 4000) then
			local ray = nil
			if camera_unit then
				ray = self._cam_unit:raycast("ray", unit:movement():m_head_pos(), self._cam_unit:position(), "ray_type", "ai_vision", "slot_mask", managers.slot:get_mask("world_geometry"), "ignore_unit", camera_unit, "report")
			else
				ray = self._cam_unit:raycast("ray", unit:movement():m_head_pos(), self._cam_unit:position(), "ray_type", "ai_vision", "slot_mask", managers.slot:get_mask("world_geometry"), "report")
			end

			if not ray then
				amount = amount + 1

				managers.hud:access_camera_track(amount, self._cam_unit:camera()._camera, unit:movement():m_head_pos())

				if self._last_access_camera and not self._last_access_camera:value("destroyed") and managers.player:upgrade_value("player", "sec_camera_highlight", false) and unit:base()._tweak_table and (managers.groupai:state():whisper_mode() and tweak_data.character[unit:base()._tweak_table].silent_priority_shout or tweak_data.character[unit:base()._tweak_table].priority_shout) then
					managers.game_play_central:auto_highlight_enemy(unit, true)
				end
			end
		end
	end

	managers.hud:access_camera_track_max_amount(amount)
end)

Hooks:PostHook(IngameAccessCamera, "_show_camera", "camerarot_show_camera", function(self)
	local current_camera = self:current_camera()
	local camera_unit = current_camera:camera_unit()
	local cam_base = camera_unit and camera_unit:base()
	if not cam_base or not cam_base:can_rotate() then
		return
	end

	cam_base:sync_control_state(true)

	if cam_base:has_control() then
		cam_base:stop_current_rotation()
	end

	self._last_sent_rot_t = nil

	local original_rot = tmp_rot
	camera_unit:m_rotation(original_rot)

	mrotation.set_yaw_pitch_roll(original_rot, original_rot:yaw() - 180, original_rot:pitch() - 5, original_rot:roll()) -- pitch - 5 is magical correction value for base model pitch

	self._yaw, self._pitch = cam_base:current_rotation()
	self._target_yaw, self._target_pitch = self._yaw, self._pitch

	self._cam_unit:camera():set_rotation(original_rot)
	self._cam_unit:camera():set_offset_rotation(self._yaw, self._pitch, 0)
end)

function IngameAccessCamera:current_camera()
	return self._cameras[self._camera_data.index].access_camera
end