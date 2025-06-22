local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local regular_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local eclipse_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local dozer_spawn = is_eclipse and eclipse_dozers or diff_i > 3 and regular_dozers or green_bulldozer
local dozer_chance = (is_eclipse and 0.4 or diff_i > 3 and 0.2 or 0.1) + (is_pro_job and 0.3 or 0)
local double_dozers = {
	values = {
		enabled = not is_eclipse and true or false,
	},
}
local wall_far_spawn = {
	values = {
		interval = 15,
	},
}
local lab_lower_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields,
}
local lab_upper_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local wall_close_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local lumber_lower_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local lumber_upper_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Disable instant difficulty increase
	[101980] = {
		values = {
			enabled = false,
		},
	},
	[101596] = {
		difficulty = 0.5,
	},
	-- use unused lab spawn as random dozer unit
	-- first remove him from element toggle so he actually spawns in
	[101813] = {
		values = {
			elements = {
				100300,
				100301,
			},
		},
	},
	-- second, change enemy spawn and position
	[101053] = {
		enemy = dozer_spawn,
		values = {
			enabled = dozer_chance,
			position = Vector3(1421.624, 2495.052, -800.000),
			rotation = Rotation(138.000, 0, -0),
		},
	},
	-- lastly, use area trigger to spawn him
	[100335] = {
		on_executed = {
			{ id = 101053, delay = 0 },
		},
	},
	-- disable single dozer mission scripts on eclipse
	[101733] = double_dozers,
	[101734] = double_dozers,
	[100854] = double_dozers,
	-- fix this mission script not actually spawning skulldozers
	[101698] = {
		on_executed = {
			{ id = 101691, delay = 0 },
			{ id = 101692, delay = 0 },
		},
	},
	-- spawn group delays
	[100052] = wall_far_spawn,
	[100286] = wall_far_spawn,
	[100317] = lab_lower_spawn,
	[100305] = lab_upper_spawn,
	[100311] = lab_upper_spawn,
	[101015] = lab_upper_spawn,
	[101016] = lab_upper_spawn,	
	[100038] = wall_close_spawn,
	[100044] = wall_close_spawn,	
	[100268] = lumber_lower_spawn,
	[100278] = lumber_lower_spawn,
	[100279] = lumber_lower_spawn,
	[100280] = lumber_upper_spawn,
}
