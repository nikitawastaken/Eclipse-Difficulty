Hooks:PostHook(PlayerTweakData, "_set_overkill_290", "eclipse__set_overkill_290", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.1
	self.damage.BLEED_OUT_HEALTH_INIT = 23
	self.damage.REVIVE_HEALTH_STEPS = {0.6}
	self.damage.respawn_time_penalty = 0
	self.damage.DOWNED_TIME = 30
	self.damage.DOWNED_TIME_DEC = 0
	self.damage.DOWNED_TIME_MIN = 30
end)

local _set_overkill_290_orig = PlayerTweakData._set_overkill_290
function PlayerTweakData:_set_sm_wish()
	_set_overkill_290_orig(self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.05
end


Hooks:PostHook(PlayerTweakData, "init", "eclipse__init", function (self)
	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
	self.damage.REGENERATE_TIME = 4.5
end)

-- Game too hard for single player appparently????
function PlayerTweakData:_set_singleplayer()
end