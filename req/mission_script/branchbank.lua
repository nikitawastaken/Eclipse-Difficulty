local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local player_1 = {
	values = {
		player_1 = true,
	},
}
local tear_gas_amount = {
	values = {
		amount = normal and 2 or hard and 3 or 4,
	},
}
local gate_chance = {
	values = {
		chance = normal and 25 or hard and 50 or 75,
	},
}
local reinforce = {
	on_executed = {
		{ id = 100364, delay = 0 },
	},
}
local reinforce_amount = {
	values = {
		amount = 3,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local ambush_chance = (is_pro_job and 1.25 or 1) * (diff_i - 2) * 15
return {
	-- DW Trailer Skulldozer spawn event
	-- disable the dozer during startup
	[100004] = {
		on_executed = {
			{ id = 400004, delay = 3 },
		},
	},
	-- enable the dozer when things go loud
	[100568] = {
		on_executed = {
			{ id = 400003, delay = 0 },
		},
	},
	-- spawn him when the far van escape gets triggered on Eclipse (DW Trailer throwback)
	[104452] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	-- special ambush chance increase
	[103072] = {
		chance = ambush_chance,
	},
	[105563] = player_1,
	[105574] = player_1,
	-- restore unused cloaker ambush spawns
	[105571] = enabled,
	[105584] = enabled,
	[105607] = enabled,
	-- enable max diff after 2 instead of 3 assault waves
	[101307] = {
		values = {
			amount = 2,
		},
	},
	-- enable spawns sooner
	[103882] = {
		on_executed = {
			{ id = 100251, delay = 30 },
			{ id = 105774, delay = 20 },
		},
	},
	-- random plank amounts
	[105129] = {
		values = {
			amount = 4,
			amount_random = 6,
		},
	},
	--skylight chance
	[104324] = {
		values = {
			chance = 50,
		},
	},
	[101930] = {
		values = {
			difficulty_easy_wish = false,
		},
	},
	[101934] = {
		values = {
			difficulty_easy_wish = true,
		},
	},
	-- police car amount
	[103879] = {
		values = {
			amount = normal and 1 or 2,
		},
	},
	-- sniper amount
	[101200] = {
		values = {
			amount = normal and 1 or hard and 2 or 3,
		},
	},
	-- cloaker spawns
	[105571] = enabled,
	[105584] = enabled,
	[105607] = enabled,
	-- vault gate chance
	[100195] = gate_chance,
	[100196] = gate_chance,
	-- enable all street reinforce spots when first responders arrive, increase the amount of enemies for reinforce points
	[104727] = reinforce,
	[104728] = reinforce,
	[104729] = reinforce,
	[104730] = reinforce,
	[100369] = reinforce_amount,
	[102091] = reinforce_amount,
	[100370] = reinforce_amount,
	--spawnpoint delays
	[100246] = {
		values = {
			interval = 10,
		},
	},
	[101211] = {
		values = {
			interval = 30,
		},
		groups = preferred.no_cops_agents_shields,
	},
}
