SentryGunBase.DEPLOYEMENT_COST = { 0.65, 0.9, 0.9 }
SentryGunBase.AMMO_MUL = { 2, 3 }

-- Unregister sentry guns to prevent enemies from getting stuck/cheesed
-- Enemies will still shoot sentries but they won't actively path towards them
Hooks:PostHook(SentryGunBase, "setup", "sh_setup", SentryGunBase.unregister)

-- Create table for sixth sense timing data
Hooks:PostHook(SentryGunBase, "init", "eclipse_init", function(self, unit)
	self._state_data = self._state_data or {}
end)

-- Check if sentries can mark
function SentryGunBase:has_marking()
	return self._sentry_marking or false
end

-- Workaround to the normal sentry unregistration
Hooks:PostHook(SentryGunBase, "on_death", "eclipse_sentry_on_death", function(self)
	managers.groupai:state():unregister_marking_sentry(self._unit)
end)

Hooks:PostHook(SentryGunBase, "pre_destroy", "eclipse_sentry_pre_destroy", function(self)
	managers.groupai:state():unregister_marking_sentry(self._unit)
end)

-- Register the sentry as marking to the group ai state
Hooks:PostHook(SentryGunBase, "setup", "eclipse_sentry_setup", function(self, owner)
	local sentry_owner = nil
	if owner and owner:base().upgrade_value then
		sentry_owner = owner
	end
	self._sentry_marking = PlayerSkill.has_skill("sentry_gun", "standstill_omniscience", sentry_owner)
	managers.groupai:state():register_marking_sentry(self._unit)
end)

-- Create new sixth sense function
function SentryGunBase:_update_omniscience(t, dt)
	if not self:has_marking() then
		if self._state_data.omniscience_t then
			self._state_data.omniscience_t = nil
		end

		return
	end

	self._state_data.omniscience_t = self._state_data.omniscience_t or t + tweak_data.player.omniscience.start_t

	if self._state_data.omniscience_t <= t then
		local sensed_targets = World:find_units_quick("sphere", self._unit:movement():m_pos(), tweak_data.player.omniscience.sense_radius, managers.slot:get_mask("trip_mine_targets"))

		for _, unit in ipairs(sensed_targets) do
			if alive(unit) and not unit:base():char_tweak().is_escort and not unit:base():has_tag("spooc") then
				self._state_data.omniscience_units_detected = self._state_data.omniscience_units_detected or {}

				if not self._state_data.omniscience_units_detected[unit:key()] or self._state_data.omniscience_units_detected[unit:key()] <= t then
					self._state_data.omniscience_units_detected[unit:key()] = t + tweak_data.player.omniscience.target_resense_t

					managers.game_play_central:auto_highlight_enemy(unit, true)

					break
				end
			end
		end
		self._state_data.omniscience_t = t + tweak_data.player.omniscience.interval_t
	end
end
