function ECMJammerBase:set_active(active)
	active = active and true

	if self._jammer_active == active then
		return
	end

	if Network:is_server() then
		local owner_base = alive(self:owner()) and self:owner().base and self:owner():base()

		if active then
			self._alert_filter = self:owner():movement():SO_access()
			local jam_cameras, jam_pagers, jam_police_comms, block_snipers = nil

			if self._owner_id == 1 then
				jam_cameras = managers.player:has_category_upgrade("ecm_jammer", "affects_cameras")
				jam_pagers = managers.player:has_category_upgrade("ecm_jammer", "affects_pagers")
				jam_police_comms = managers.player:has_category_upgrade("ecm_jammer", "affects_police_comms")
				block_snipers = managers.player:has_category_upgrade("ecm_jammer", "blocks_snipers")

				self:contour_interaction()
			else
				jam_cameras = owner_base and owner_base:upgrade_value("ecm_jammer", "affects_cameras")
				jam_pagers = owner_base and owner_base:upgrade_value("ecm_jammer", "affects_pagers")
				jam_police_comms = owner_base and owner_base:upgrade_value("ecm_jammer", "affects_police_comms")
				block_snipers = owner_base and owner_base:upgrade_value("ecm_jammer", "blocks_snipers")
			end

			managers.groupai:state():register_ecm_jammer(self._unit, {
				call = true,
				camera = jam_cameras,
				pager = jam_pagers,
				police_comms = jam_police_comms,
				block_snipers = block_snipers,
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

-- ECM Feedback crash fix
function ECMJammerBase:_set_feedback_active(state)
	state = state and true

	if state == self._feedback_active then
		return
	end

	if Network:is_server() then
		local owner_base = alive(self:owner()) and self:owner().base and self:owner():base()
		if state then
			self._unit:interaction():set_active(false, true)

			local t = TimerManager:game():time()
			self._feedback_clbk_id = "ecm_feedback" .. tostring(self._unit:key())
			self._feedback_interval = tweak_data.upgrades.ecm_feedback_interval or 1.5
			self._feedback_range = tweak_data.upgrades.ecm_jammer_base_range
			local duration_mul = 1

			if self._owner_id == 1 then
				duration_mul = duration_mul * managers.player:upgrade_value("ecm_jammer", "feedback_duration_boost", 1)
				duration_mul = duration_mul * managers.player:upgrade_value("ecm_jammer", "feedback_duration_boost_2", 1)
			else
				duration_mul = duration_mul * ((owner_base and owner_base:upgrade_value("ecm_jammer", "feedback_duration_boost")) or 1)
				duration_mul = duration_mul * ((owner_base and owner_base:upgrade_value("ecm_jammer", "feedback_duration_boost_2")) or 1)
			end

			self._feedback_duration = math.lerp(tweak_data.upgrades.ecm_feedback_min_duration or 15, tweak_data.upgrades.ecm_feedback_max_duration or 20, math.random()) * duration_mul
			self._feedback_expire_t = t + self._feedback_duration
			local first_impact_t = t + math.lerp(0.1, 1, math.random())

			managers.enemy:add_delayed_clbk(self._feedback_clbk_id, callback(self, self, "clbk_feedback"), first_impact_t)
			self:_send_net_event(self._NET_EVENTS.feedback_start)
		else
			if self._feedback_clbk_id then
				managers.enemy:remove_delayed_clbk(self._feedback_clbk_id)

				self._feedback_clbk_id = nil
			end

			self:_send_net_event(self._NET_EVENTS.feedback_stop)

			if alive(self._owner) then
				local retrigger = false

				if self._owner_id == 1 then
					retrigger = managers.player:has_category_upgrade("ecm_jammer", "can_retrigger")
				else
					retrigger = (owner_base and owner_base:upgrade_value("ecm_jammer", "can_retrigger"))
				end

				if retrigger then
					self._chk_feedback_retrigger_t = tweak_data.upgrades.ecm_feedback_retrigger_interval or 60
				end
			end
		end
	end

	if state then
		print("PUKE!")
		self._g_glow_feedback_green:set_visibility(true)
		self._g_glow_feedback_red:set_visibility(false)

		if not self._puke_sound_event then
			self._puke_sound_event = self._unit:sound_source():post_event("ecm_jammer_puke_signal")
		end

		self._unit:contour():remove("deployable_interactable")
		self._unit:contour():add("deployable_active")
	else
		self._g_glow_feedback_green:set_visibility(false)
		self._g_glow_feedback_red:set_visibility(false)

		if self._puke_sound_event then
			self._puke_sound_event:stop()

			self._puke_sound_event = nil

			self._unit:sound_source():post_event("ecm_jammer_puke_signal_stop")
		end

		if self._unit:contour() then
			self._unit:contour():remove("deployable_active")
		end
	end

	self._feedback_active = state
end

--Sync outline when feedback is ready so every player can see ECM and activate it
Hooks:PostHook(ECMJammerBase, "contour_interaction", "contour_interaction_feedback_ready_outline_sync", function(self)
	if managers.player:has_category_upgrade("ecm_jammer", "can_activate_feedback") and managers.network:session() and self._unit:contour() then
		self._unit:contour():add("deployable_interactable", true)
	end
end)

Hooks:PostHook(ECMJammerBase, "_set_feedback_active", "_set_feedback_active_ready_outline_sync", function(self, state)
	if state then
		self._unit:contour():remove("deployable_interactable", true)
		self._unit:contour():add("deployable_active")
	else
		if self._unit:contour() then
			self._unit:contour():remove("deployable_interactable", true)
			self._unit:contour():remove("deployable_active")
		end
	end
end)
