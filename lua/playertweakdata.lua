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


Hooks:PostHook(PlayerTweakData, "_init_rpk", "eclipse_init_rpk", function(self)
	local pivot_shoulder_translation = Vector3(10.6, 27.7166, -4.93564)
	local pivot_shoulder_rotation = Rotation(0.1067, -0.0850111, 0.629008)
	local pivot_head_translation = Vector3(0, 28, 0)  -- 6, 30, -1
	local pivot_head_rotation = Rotation(0, 0, 0) -- 0, 0, -5
	self.stances.rpk.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.rpk.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
end)


Hooks:PostHook(PlayerTweakData, "_init_hk21", "eclipse_init_hk21", function(self)
	local pivot_shoulder_translation = Vector3(8.54, 8, -3.29)
	local pivot_shoulder_rotation = Rotation(7.08051E-6, 0.00559065, 3.07211E-4)
	local pivot_head_translation = Vector3(0, 10, 0) -- 8, 10, -1
	local pivot_head_rotation = Rotation(0, 0, 0) -- 0.2, 0.2, -8
	self.stances.hk21.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.hk21.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
end)


Hooks:PostHook(PlayerTweakData, "_init_m249", "eclipse_init_m249", function(self)
	local pivot_shoulder_translation = Vector3(10.716, 4, -0.55)
	local pivot_shoulder_rotation = Rotation(0.106596, -0.0844502, 0.629187)    
	local pivot_head_translation = Vector3(0, 12, 0) -- 9.5, 11, -2
	local pivot_head_rotation = Rotation(0, 0, 0) -- 0, 0, -5
	self.stances.m249.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m249.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
end)

Hooks:PostHook(PlayerTweakData, "_init_mg42", "eclipse_init_mg42", function(self)
	local pivot_shoulder_translation = Vector3(10.713, 47.8277, 0.873785)
	local pivot_shoulder_rotation = Rotation(0.10662, -0.0844545, 0.629209)
	local pivot_head_translation = Vector3(0, 40, 0) -- 3, 30, -2
	local pivot_head_rotation = Rotation(0, 0, 0) -- 0, 0, -2
	self.stances.mg42.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mg42.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
end)


Hooks:PostHook(PlayerTweakData, "_init_par", "eclipse_init_par", function(self)
	local pivot_shoulder_translation = Vector3(10.020, 5, -3.94)
	local pivot_shoulder_rotation = Rotation(0, -0.0844502, 0.629187)
	local pivot_head_translation = Vector3(0, 12, 0) -- 6, 4, 2
	local pivot_head_rotation = Rotation(0, 0, 0) -- 0, 0, -5
	self.stances.par.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.par.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
end)


Hooks:PostHook(PlayerTweakData, "_init_m60", "eclipse_init_m60", function(self)
	local pivot_shoulder_translation = Vector3(10.713, 47.8277, 0.873785)
	local pivot_shoulder_rotation = Rotation(0.10662, -0.0844545, 0.629209)
	local pivot_head_translation = Vector3(0, 40, 0) -- 7.5, 6, -2
	local pivot_head_rotation = Rotation(0, 0, 0) -- 0, 0, -5
	self.stances.m60.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m60.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
end)
