Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "eclipse__set_sm_wish", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.05
	self.damage.BLEED_OUT_HEALTH_INIT = 23
	self.damage.REVIVE_HEALTH_STEPS = {0.6}
	self.damage.respawn_time_penalty = 0
	self.damage.DOWNED_TIME = 30
	self.damage.DOWNED_TIME_DEC = 0
	self.damage.DOWNED_TIME_MIN = 30
end)

Hooks:PostHook(PlayerTweakData, "init", "eclipse__init", function (self)
	self.suppression.decay_start_delay = 0.35
	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
end)

-- Game too hard for single player appparently????
function PlayerTweakData:_set_singleplayer()
	self.damage.REGENERATE_TIME = 3
end