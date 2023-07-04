function PlayerTweakData:_set_normal()
	self.damage.REVIVE_HEALTH_STEPS = {0.7}
	self.damage.MIN_DAMAGE_INTERVAL = 0.4
end

function PlayerTweakData:_set_hard()
	self.damage.REVIVE_HEALTH_STEPS = {0.6}
	self.damage.MIN_DAMAGE_INTERVAL = 0.3
end

function PlayerTweakData:_set_overkill()
	self.damage.REVIVE_HEALTH_STEPS = {0.5}
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
end

function PlayerTweakData:_set_overkill_145()
	self.damage.REVIVE_HEALTH_STEPS = {0.4}
	self.damage.MIN_DAMAGE_INTERVAL = 0.2
end

function PlayerTweakData:_set_easy_wish()
	self.damage.REVIVE_HEALTH_STEPS = {0.4}
	self.damage.MIN_DAMAGE_INTERVAL = 0.15
end


Hooks:PostHook(PlayerTweakData, "init", "eclipse__init", function (self)
	self.damage.respawn_time_penalty = 0
	self.damage.BLEED_OUT_HEALTH_INIT = 23
	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
	self.omniscience.target_resense_t = 0
	self.damage.REGENERATE_TIME = 4.5
	self.damage.DOWNED_TIME = 30
	self.damage.DOWNED_TIME_DEC = 0
	self.damage.DOWNED_TIME_MIN = 30
	self.damage.automatic_respawn_time = nil
end)

-- Game too hard for single player appparently????
function PlayerTweakData:_set_singleplayer()
end