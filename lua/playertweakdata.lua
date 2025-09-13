local is_eclipse = Eclipse.utils.is_eclipse()
local is_overkill = Eclipse.utils.is_overkill()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job

local function diff_lerp(value_1, value_2)
	return Eclipse.utils.diff_lerp(value_1, value_2)
end

function PlayerTweakData:_set_easy() end

function PlayerTweakData:_set_normal()
	self.damage.MIN_DAMAGE_INTERVAL = is_pro_job and 0.35 or 0.4

	self.damage.custody_ammo_confiscated = 0.15
	self.damage.custody_health_drained = 0.15

	self.suspicion.max_value = 8
	self.suspicion.range_mul = 0.8
	self.suspicion.buildup_mul = 0.8
end

function PlayerTweakData:_set_hard()
	self.damage.MIN_DAMAGE_INTERVAL = is_pro_job and 0.3 or 0.35

	self.damage.custody_ammo_confiscated = 0.3
	self.damage.custody_health_drained = 0.3

	self.suspicion.max_value = 9
	self.suspicion.range_mul = 1
	self.suspicion.buildup_mul = 1
end

function PlayerTweakData:_set_overkill()
	self.damage.MIN_DAMAGE_INTERVAL = is_pro_job and 0.25 or 0.3

	self.damage.custody_ammo_confiscated = 0.45
	self.damage.custody_health_drained = 0.45

	self.suspicion.max_value = 10
	self.suspicion.range_mul = 1.2
	self.suspicion.buildup_mul = 1.2
end

function PlayerTweakData:_set_overkill_145()
	self.damage.MIN_DAMAGE_INTERVAL = is_pro_job and 0.2 or 0.25

	self.damage.custody_ammo_confiscated = 0.6
	self.damage.custody_health_drained = 0.6

	self.suspicion.max_value = 11
	self.suspicion.range_mul = 1.4
	self.suspicion.buildup_mul = 1.4
end

function PlayerTweakData:_set_easy_wish()
	self.damage.MIN_DAMAGE_INTERVAL = is_pro_job and 0.15 or 0.2

	self.damage.custody_ammo_confiscated = 0.75
	self.damage.custody_health_drained = 0.75

	self.suspicion.max_value = 12
	self.suspicion.range_mul = 1.7
	self.suspicion.buildup_mul = 1.7
end

function PlayerTweakData:_set_singleplayer() end

Hooks:PostHook(PlayerTweakData, "init", "eclipse__init", function(self)
	self.gravity = -982

	self.damage.ARMOR_BREAK_MIN_DAMAGE_INTERVAL = 0.15

	self.damage.respawn_time_penalty = 0
	--self.damage.automatic_respawn_time = 210 + (is_eclipse and 90 or is_overkill and 60 or 0) + (is_pro_job and 60 or 0)
	self.damage.custody_ammo_confiscated = 0.4
	self.damage.custody_health_drained = 0.4

	self.fall_health_damage = 0.6

	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
	self.omniscience.target_resense_t = 0

	self.damage.DOWNED_TIME_DEC = is_eclipse_pro and 15 or is_pro_job and 10 or 0
	self.damage.DOWNED_TIME_MIN = is_eclipse_pro and 5 or is_pro_job and 10 or 30

	local revive_health = diff_lerp(0.6, 0.3)

	self.damage.REVIVE_HEALTH_STEPS = is_pro_job and { revive_health, revive_health * 0.66, revive_health * 0.33 } or { revive_health }

	self.suppression.max_value = 5
	self.suppression.receive_mul = 1
	self.suppression.tolerance = 0
end)
