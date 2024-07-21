function PlayerTweakData:_set_normal()
	self.damage.REVIVE_HEALTH_STEPS = { 0.7 }
	self.damage.MIN_DAMAGE_INTERVAL = 0.4

	self.suspicion.max_value = 8
	self.suspicion.range_mul = 0.8
	self.suspicion.buildup_mul = 0.8
end

function PlayerTweakData:_set_hard()
	self.damage.REVIVE_HEALTH_STEPS = { 0.6 }
	self.damage.MIN_DAMAGE_INTERVAL = 0.3

	self.suspicion.max_value = 9
	self.suspicion.range_mul = 1
	self.suspicion.buildup_mul = 1
end

function PlayerTweakData:_set_overkill()
	self.damage.REVIVE_HEALTH_STEPS = { 0.5 }
	self.damage.MIN_DAMAGE_INTERVAL = 0.25

	self.suspicion.max_value = 10
	self.suspicion.range_mul = 1.2
	self.suspicion.buildup_mul = 1.2
end

function PlayerTweakData:_set_overkill_145()
	self.damage.REVIVE_HEALTH_STEPS = { 0.4 }
	self.damage.MIN_DAMAGE_INTERVAL = 0.2

	self.suspicion.max_value = 11
	self.suspicion.range_mul = 1.4
	self.suspicion.buildup_mul = 1.4
end

function PlayerTweakData:_set_easy_wish()
	self.damage.REVIVE_HEALTH_STEPS = { 0.4 }
	self.damage.MIN_DAMAGE_INTERVAL = 0.15

	self.suspicion.max_value = 12
	self.suspicion.range_mul = 1.7
	self.suspicion.buildup_mul = 1.7
end

Hooks:PostHook(PlayerTweakData, "init", "eclipse__init", function(self)
	self.damage.respawn_time_penalty = 0
	self.damage.BLEED_OUT_HEALTH_INIT = 23
	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
	self.omniscience.target_resense_t = 0
	-- self.damage.REGENERATE_TIME = 4.5
	self.damage.DOWNED_TIME = 30
	self.damage.DOWNED_TIME_DEC = 0
	self.damage.DOWNED_TIME_MIN = 30
	self.max_nr_following_hostages = 0
end)

-- Game too hard for single player appparently????
function PlayerTweakData:_set_singleplayer() end
