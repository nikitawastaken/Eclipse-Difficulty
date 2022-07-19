Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "eclipse__set_sm_wish", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.05
	self.damage.BLEED_OUT_HEALTH_INIT = 23
	self.damage.REVIVE_HEALTH_STEPS = {0.6}
	self.damage.respawn_time_penalty = 7
	self.damage.DOWNED_TIME = 30
	self.damage.DOWNED_TIME_DEC = 0
	self.damage.DOWNED_TIME_MIN = 30
end)

Hooks:PostHook(PlayerTweakData, "init", "eclipse__init", function (self)
-- Fuck armor suppression, all my homies hate armor suppression
	self.suppression.decay_start_delay = 0.35
end)

-- Game too hard for single player appparently????
function PlayerTweakData:_set_singleplayer()
	self.damage.REGENERATE_TIME = 3
end