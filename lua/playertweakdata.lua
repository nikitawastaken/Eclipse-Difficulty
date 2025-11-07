local is_pro_job = Eclipse.utils.is_pro_job()

local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
local automatic_respawns = false

function PlayerTweakData:_set_presets()
	-- Grace period duration in seconds, reduced on Pro Jobs
	self.damage.MIN_DAMAGE_INTERVAL = get_difficulty_specific_value({
		0.4, -- Easy (+ vanilla Easy if someone gets in there)
		0.35, -- Normal
		0.3, -- Hard
		0.25, -- Overkill
		0.2, -- Death Wish (+ vanilla DW/DS if someone gets in there)
	})
	if is_pro_job then
		self.damage.MIN_DAMAGE_INTERVAL = self.damage.MIN_DAMAGE_INTERVAL - 0.05
	end

	-- Revive health, reduced on subsequent revives on Pro Jobs
	-- Doesn't scale until Hard difficulty
	self.damage.REVIVE_HEALTH_STEPS = {
		get_difficulty_specific_value({
			0.6,
			0.6,
			0.5,
			0.4,
			0.3,
		}),
	}
	if is_pro_job then
		table.insert(self.damage.REVIVE_HEALTH_STEPS, self.damage.REVIVE_HEALTH_STEPS[1] * 0.66)
		table.insert(self.damage.REVIVE_HEALTH_STEPS, self.damage.REVIVE_HEALTH_STEPS[1] * 0.33)
	end

	-- Percentage of max ammo missing when returning from custody
	self.damage.custody_ammo_confiscated = get_difficulty_specific_value({
		0.15,
		0.3,
		0.45,
		0.6,
		0.75,
	})

	-- Percentage of max health missing when returning from custody
	self.damage.custody_health_drained = get_difficulty_specific_value({
		0.15,
		0.3,
		0.45,
		0.6,
		0.75,
	})

	-- Seems to be unused
	self.suspicion.max_value = get_difficulty_specific_value({
		8,
		9,
		10,
		11,
		12,
	})

	-- Multiplier on the range you can be detected from
	-- Unsure if relevant in loud
	self.suspicion.range_mul = get_difficulty_specific_value({
		0.8,
		1,
		1.2,
		1.4,
		1.7,
	})

	-- Multiplier on how quickly you are detected
	-- Unsure if relevant in loud
	self.suspicion.buildup_mul = get_difficulty_specific_value({
		0.8,
		1,
		1.2,
		1.4,
		1.7,
	})

	-- On Pro Jobs, reduce the down timer per down by this many seconds, down to a minimum
	if is_pro_job then
		self.damage.DOWNED_TIME_DEC = get_difficulty_specific_value({
			10,
			10,
			10,
			10,
			15,
		})
		self.damage.DOWNED_TIME_MIN = get_difficulty_specific_value({
			10,
			10,
			10,
			10,
			5,
		})
	else
		self.damage.DOWNED_TIME_DEC = get_difficulty_specific_value({
			0,
			0,
			0,
			0,
			0,
		})
		self.damage.DOWNED_TIME_MIN = get_difficulty_specific_value({
			30,
			30,
			30,
			30,
			30,
		})
	end

	-- If automatic respawns are enabled (shouldn't be unless trading is seriously borked),
	-- automatically respawn custodied players after this long in seconds
	if automatic_respawns then
		self.damage.automatic_respawn_time = get_difficulty_specific_value({
			210,
			210,
			210,
			270,
			300,
		})
		if is_pro_job then
			self.damage.automatic_respawn_time = self.damage.automatic_respawn_time + 60
		end
	else
		self.damage.automatic_respawn_time = nil
	end
end

PlayerTweakData._set_easy = PlayerTweakData._set_presets
PlayerTweakData._set_normal = PlayerTweakData._set_presets
PlayerTweakData._set_hard = PlayerTweakData._set_presets
PlayerTweakData._set_overkill = PlayerTweakData._set_presets
PlayerTweakData._set_overkill_145 = PlayerTweakData._set_presets
PlayerTweakData._set_easy_wish = PlayerTweakData._set_presets
PlayerTweakData._set_overkill_290 = PlayerTweakData._set_presets
PlayerTweakData._set_sm_wish = PlayerTweakData._set_presets

Hooks:OverrideFunction(PlayerTweakData, "_set_singleplayer", function(...) end)

Hooks:PostHook(PlayerTweakData, "init", "eclipse_init", function(self)
	self.put_on_mask_time = 0

	self.gravity = -(982 * 2)

	self.damage.ARMOR_BREAK_MIN_DAMAGE_INTERVAL = 0.15

	self.damage.respawn_time_penalty = 10
	--self.damage.automatic_respawn_time = 210 + (is_eclipse and 90 or is_overkill and 60 or 0) + (is_pro_job and 60 or 0)
	self.damage.custody_ammo_confiscated = 0.4
	self.damage.custody_health_drained = 0.4

	self.movement_state.standard.movement.jump_velocity.z = self.movement_state.standard.movement.jump_velocity.z * 1.5
	self.movement_state.standard.movement.jump_velocity.xy.run = self.movement_state.standard.movement.speed.RUNNING_MAX * 0.5
	self.movement_state.standard.movement.jump_velocity.xy.walk = self.movement_state.standard.movement.speed.STANDARD_MAX * 0.5

	self.fall_health_damage = 0.6

	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
	self.omniscience.target_resense_t = 0

	self.suppression.max_value = 5
	self.suppression.receive_mul = 1
	self.suppression.tolerance = 0
end)
