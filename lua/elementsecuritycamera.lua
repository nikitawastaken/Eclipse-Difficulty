function ElementSecurityCamera:on_executed(instigator)
	if not self._values.enabled or not self._values.camera_u_id then
		return
	end

	local camera_unit = self:_fetch_unit_by_unit_id(self._values.camera_u_id)
	if not camera_unit then
		return
	end

	local ai_state = self._values.ai_enabled and true or false
	local settings = nil
	if ai_state or self._values.apply_settings then
		settings = {
			yaw = self._values.yaw,
			pitch = self._values.pitch,
			fov = self._values.fov,
			detection_range = self._values.detection_range * 100,
			suspicion_range = self._values.suspicion_range * 100,
			detection_delay = {
				self._values.detection_delay_min,
				self._values.detection_delay_max
			}
		}
	end

	camera_unit:base():set_detection_enabled(ai_state, settings, self)
	ElementSecurityCamera.super.on_executed(self, instigator) -- fixed using wrong class
end

ElementSecurityCamera.client_on_executed = ElementSecurityCamera.on_executed