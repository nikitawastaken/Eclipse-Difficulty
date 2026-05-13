Hooks:PostHook(DramaTweakData, "init", "eclipse_init", function(self)
	self.drama_actions = { criminal_hurt = 0.5, criminal_dead = 0.2, criminal_disabled = 0.1 }
	self.drama_gain_balance_mul = { 1.35, 1.05, 0.75, 0.45 }
	self.drama_decay_rate_balance_mul = { 0.8, 0.9, 1, 1.1 }
	self.decay_period = 30
	self.max_dis = 6000
	self.max_dis_mul = 1
	self.low = 0.1
	self.peak = 1
	self.assault_fade_end = 0.15
	self.spawn_rate_scaling = { 0.1, 0.4 }
	self.assault_start_add = 1
	self.special_spawn_drama_add = {
		shield = 0.05,
		taser = 0.075,
		tank = 0.15,
		spooc = 0.075,
		medic = 0.05,
		marksman = 0.05,
	}
	self.drama_weight_muls = {
		-- Drama decay rate
		decay_rate = {
			[0.1] = 1.1,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.7,
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
			[0.7] = 0.9,
			[1.0] = 0.7,
		},
		tank = {
			[0.1] = 1.3,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.7,
		},
		spooc = {
			[0.1] = 1.3,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.7,
		},
		marksman = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.8,
		},
		supporting_special = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.9,
			[1.0] = 0.8,
		},
	}
end)
