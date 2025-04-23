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
		enabled = is_eclipse and false or true,
	},
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
		values = {
			enemy = dozer_spawn,
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
}
