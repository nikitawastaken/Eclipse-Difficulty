Hooks:PostHook(DramaTweakData, "init", "eclipse_init", function(self)
	self.drama_actions = { criminal_hurt = 0.5, criminal_dead = 0.2, criminal_disabled = 0.1 }
	self.drama_balance_mul = { 1.3, 1.1, 0.8, 0.4 }
	self.decay_period = 30
	self.max_dis = 6000
	self.max_dis_mul = 0.5
	self.low = 0.1
	self.peak = 1
	self.assault_fade_end = 0.15
	self.spawn_rate_scaling = { 0.1, 0.4 }
	self.assault_start_add = 1
	self.special_spawn_drama_add = {
		shield = 0.025,
		taser = 0.05,
		tank = 0.1,
		spooc = 0.05,
		medic = 0.025,
		marksman = 0.05,
	}
	self.drama_group_weight_muls = {
		cs_shield = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.8,
			[1.0] = 0.6,
		},
		cs_taser = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.8,
			[1.0] = 0.6,
		},
		cs_bulldozer = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.7,
			[1.0] = 0.4,
		},
		fbi_cloaker = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.7,
			[1.0] = 0.4,
		},
		elite_sniper = {
			[0.1] = 1.2,
			[0.4] = 1,
			[0.7] = 0.8,
			[1.0] = 0.6,
		},
	}
	self.drama_group_weight_muls.fbi_shield = self.drama_group_weight_muls.cs_shield
	self.drama_group_weight_muls.elite_shield = self.drama_group_weight_muls.cs_shield
	self.drama_group_weight_muls.fbi_taser = self.drama_group_weight_muls.cs_taser
	self.drama_group_weight_muls.elite_taser = self.drama_group_weight_muls.cs_taser
	self.drama_group_weight_muls.fbi_bulldozer = self.drama_group_weight_muls.cs_bulldozer
	self.drama_group_weight_muls.elite_bulldozer = self.drama_group_weight_muls.cs_bulldozer
end)
