Hooks:PostHook(DramaTweakData, "init", "eclipse_init", function(self)
	self.drama_actions = { -- player actions that build drama, identical to Vanilla
		criminal_hurt = 0.5,
		criminal_dead = 0.2,
		criminal_disabled = 0.1,
	}
	self.max_dis_mul = 1 -- distance does not affect 'criminal_hurt' drama gain
	self.drama_gain_team_ai_mul = 0.5 -- additional 'criminal_hurt' drama gain multiplier for Team AI
	self.assault_fade_end = 0.15 -- drama threshold for ending the regroup phase
	self.assault_start_add = 1 -- drama spike during the anticipation phase
	self.special_spawn_drama_add = {
		shield = 0.05,
		taser = 0.075,
		tank = 0.15,
		spooc = 0.075,
		medic = 0.05,
		marksman = 0.05,
	}
	self.drama_gain_balance_mul = { 1.25, 1, 0.75, 0.5 } -- 'criminal_hurt' drama gain balance multiplier
	self.drama_decay_rate_balance_mul = { 0.7, 0.8, 0.9, 1 }
	self.special_spawn_drama_add_balance_mul = {
		shield = { 1.15, 1.1, 1.05, 1 },
		taser = { 1.3, 1.2, 1.1, 1 },
		tank = { 1.45, 1.3, 1.15, 1 },
		spooc = { 1.3, 1.2, 1.1, 1 },
		medic = { 1.15, 1.1, 1.05, 1 },
		marksman = { 1.15, 1.1, 1.05, 1 },
	}
	self.drama_weight_muls = {
		-- Drama decay rate
		decay_rate = {
			[0.1] = 0.8,
			[0.4] = 1,
			[0.7] = 1.1,
			[1.0] = 1.2,
		},
		-- Spawn rate
		spawn_rate = {
			[0.1] = 0.7,
			[0.4] = 1,
			[0.7] = 1,
			[1.0] = 1.3,
		},
		-- Hiding Cloaker respawn interval
		hiding_cloaker_interval = {
			[0.1] = 0.8,
			[0.4] = 1,
			[0.7] = 1.1,
			[1.0] = 1.2,
		},
		-- Special unit spawns
		shield = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.8,
		},
		taser = {
			[0.1] = 1.3,
			[0.4] = 1,
			[0.7] = 0.85,
			[1.0] = 0.7,
		},
		tank = {
			[0.1] = 1.3,
			[0.4] = 1,
			[0.7] = 0.85,
			[1.0] = 0.7,
		},
		spooc = {
			[0.1] = 1.3,
			[0.4] = 1,
			[0.7] = 0.85,
			[1.0] = 0.7,
		},
		marksman = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.8,
		},
		supporting_special = { -- Medics as well as Tasers and Cloakers outside their dedicated groups
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.8,
		},
	}
end)
