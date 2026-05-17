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
		0.9,
		1,
		1.1,
		1.3,
		1.5,
	})

	-- Multiplier on how quickly you are detected
	-- Unsure if relevant in loud
	self.suspicion.buildup_mul = get_difficulty_specific_value({
		0.9,
		1,
		1.1,
		1.3,
		1.5,
	})

	-- Additioanl detection range and buildup multipliers that scale linearly based on the number of used Strikes
	self.suspicion.strikes_used_mul = is_pro_job and 1.5 or nil

	-- Time it takes for a player to exit the tased state
	self.damage.TASED_RECOVER_TIME = get_difficulty_specific_value({
		1,
		1,
		1,
		2,
		3,
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

	-- Stealth strike system
	self.stealth_strikes = {
		total_amount = get_difficulty_specific_value({ 5, 5, 5, 4, 3 }),
		reason_addends = {
			civilian_kill = 0.5,
			alarm_pager_answered = 1,
			alarm_pager_not_answered = 2,
			alarm_pager_hang_up = 3,
		},
	}
	if is_pro_job then
		self.stealth_strikes.total_amount = self.stealth_strikes.total_amount - 1
	end

	-- Alarm pager "bluff" tables are now only used in the UI.
	local function fill_pager_bluff_table(amount)
		local tbl = {}
		for i = 0, math.max(0, amount - 1) do
			table.insert(tbl, 1)
		end
		return tbl
	end

	self.alarm_pager.bluff_success_chance = fill_pager_bluff_table(self.stealth_strikes.total_amount)
	self.alarm_pager.bluff_success_chance_w_skill = self.alarm_pager.bluff_success_chance
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
	self.put_on_mask_time = self.put_on_mask_time / 2

	self.gravity = -(982 * 1.5)

	self.damage.respawn_time_penalty = 10

	self.movement_state.standard.movement.jump_velocity.z = self.movement_state.standard.movement.jump_velocity.z * 1.25
	self.movement_state.standard.movement.jump_velocity.xy.run = self.movement_state.standard.movement.speed.RUNNING_MAX * 0.5
	self.movement_state.standard.movement.jump_velocity.xy.walk = self.movement_state.standard.movement.speed.STANDARD_MAX * 0.5

	self.fall_health_damage = 0.6

	self.speak_alert_size = 500
	self.running_alert_size = 400

	self.omniscience.start_t = 3
	self.omniscience.interval_t = 1.5
	self.omniscience.target_resense_t = 0

	self.suppression.max_value = 5
	self.suppression.receive_mul = 1
	self.suppression.tolerance = 0
end)

-- LMG Steelsights
Hooks:PostHook(PlayerTweakData, "_init_new_stances", "eclipse_init_new_stances", function(self)
	self.stances.hk21.steelsight.shoulders.translation = Vector3(-8.6, 6, 3.3)
	self.stances.hk21.steelsight.shoulders.rotation = Rotation(-0.108, 0.0860001, -0.628)

	self.stances.m249.steelsight.shoulders.translation = Vector3(-10.75, 6.6, 0.42)
	self.stances.m249.steelsight.shoulders.rotation = Rotation(-0.108, 0.086001, -0.628)

	self.stances.rpk.steelsight.shoulders.translation = Vector3(-10.745, -10.371, 4.81)
	self.stances.rpk.steelsight.shoulders.rotation = Rotation(-0.107988, 0.087, -0.628)

	self.stances.mg42.steelsight.shoulders.translation = Vector3(-10.78, -2.15, -0.9)
	self.stances.mg42.steelsight.shoulders.rotation = Rotation(-0.108, 0.286, 1.32881e-009)

	self.stances.par.steelsight.shoulders.translation = Vector3(-10.05, 9.631, 3.85)
	self.stances.par.steelsight.shoulders.rotation = Rotation(-0.108, 0.0860001, -0.628)

	self.stances.m60.steelsight.shoulders.translation = Vector3(-10.75, -6.369, -0.1)
	self.stances.m60.steelsight.shoulders.rotation = Rotation(-0.208001, 0.286, 5.21102e-011)
end)
