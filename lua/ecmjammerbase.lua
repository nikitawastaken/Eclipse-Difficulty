function ECMJammerBase:set_active(active)
	active = active and true

	if self._jammer_active == active then
		return
	end

	if Network:is_server() then
		local owner_base = alive(self:owner()) and self:owner().base and self:owner():base()

		if active then
			self._alert_filter = self:owner():movement():SO_access()
			local jam_cameras, jam_pagers, jam_police_comms = nil

			if self._owner_id == 1 then
				jam_cameras = managers.player:has_category_upgrade("ecm_jammer", "affects_cameras")
				jam_pagers = managers.player:has_category_upgrade("ecm_jammer", "affects_pagers")
				jam_police_comms = managers.player:has_category_upgrade("ecm_jammer", "affects_police_comms")

				self:contour_interaction()
			else
				jam_cameras = owner_base:upgrade_value("ecm_jammer", "affects_cameras")
				jam_pagers = owner_base:upgrade_value("ecm_jammer", "affects_pagers")
				jam_police_comms = owner_base:upgrade_value("ecm_jammer", "affects_police_comms")
			end

			managers.groupai:state():register_ecm_jammer(self._unit, {
				call = true,
				camera = jam_cameras,
				pager = jam_pagers,
				police_comms = jam_police_comms,
			})

			self:_send_net_event(self._NET_EVENTS.jammer_active)
		else
			managers.groupai:state():register_ecm_jammer(self._unit, false)
		end
	end

	if active then
		if not self._jam_sound_event then
			self._jam_sound_event = self._unit:sound_source():post_event("ecm_jammer_jam_signal")
		end

		self._unit:contour():add("deployable_active")
	else
		if self._jam_sound_event then
			self._jam_sound_event:stop()

			self._jam_sound_event = nil

			self._unit:sound_source():post_event("ecm_jammer_jam_signal_stop")
		end

		if self._unit:contour() then
			self._unit:contour():remove("deployable_active")
		end
	end

	self._jammer_active = active
end
