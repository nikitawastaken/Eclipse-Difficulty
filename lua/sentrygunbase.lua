-- Unregister sentry guns to prevent enemies from getting stuck/cheesed
-- Enemies will still shoot sentries but they won't actively path towards them
Hooks:PostHook(SentryGunBase, "setup", "sh_setup", SentryGunBase.unregister)

Hooks:PostHook(SentryGunBase, "init", "eclipse_init",
function(self, unit)
    self._state_data = self._state_data or {}
end)

Hooks:PostHook(SentryGunBase, "update", "eclipse_update",
function(self, unit, t, dt)
    self:_update_omniscience(t, dt)
end)

function SentryGunBase:_update_omniscience(t, dt)
	if not tweak_data.player.omniscience then
		if self._state_data.omniscience_t then
			self._state_data.omniscience_t = nil
		end
		return
	end

	self._state_data.omniscience_t = self._state_data.omniscience_t or t + tweak_data.player.omniscience.start_t

	if self._state_data.omniscience_t <= t then
		local sensed_targets = World:find_units_quick("sphere", self._unit:movement():m_pos(), tweak_data.player.omniscience.sense_radius, managers.slot:get_mask("trip_mine_targets"))

		for _, unit in ipairs(sensed_targets) do
			if alive(unit) and not unit:base():char_tweak().is_escort then
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
