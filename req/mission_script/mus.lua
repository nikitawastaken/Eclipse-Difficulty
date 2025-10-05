local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local easy = diff_i == 2
local normal_and_hard = diff_i == 3 or diff_i == 4
local overkill = diff_i == 5
local deathwish = diff_i == 6
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local courtyard_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local staircase_window_spawn = {
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local matrix_window_spawn = {
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local exhibit_rappel_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents,
}
local last_rappel_spawn = {
	groups = preferred.no_cops_agents,
}
return {
	[102425] = {
		ponr = {
			length = 240,
			player_mul = { 1.25, 1.25, 1, 1 },
		},
	},
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 4, 52 },
			{ 136, 129 },
			{ 153, 139 },
			{ 140, 154 },
		},
	},
	-- Add new reinforce
	[100109] = { -- Police arrived
		reinforce = {
			{
				name = "south",
				force = 2,
				position = Vector3(-1300, 200, -350),
			},
			{
				name = "west",
				force = 2,
				position = Vector3(0, 2900, -300),
			},
			{
				name = "north",
				force = 2,
				position = Vector3(1200, 200, -350),
			},
			{
				name = "east",
				force = 2,
				position = Vector3(0, -2500, -300),
			},
		},
		on_executed = { -- standard preferreds
			{ id = 100127, delay = 60 },
		},
	},
	-- restore ground snipers
	[100369] = enabled,
	[100370] = enabled,
	[100371] = enabled,
	[100372] = enabled,
	-- keep other snipers enabled at all times
	[100368] = enabled,
	[100373] = enabled,
	[100374] = enabled,
	-- add missing spawns to elementrandom
	[100366] = {
		on_executed = {
			{ id = 100369, delay = 0 },
			{ id = 100370, delay = 0 },
			{ id = 100371, delay = 0 },
			{ id = 100372, delay = 0 },
		},
	},
	-- scale snipers amount based on difficulty
	[100357] = {
		values = {
			ignore_disabled = false,
		},
	},
	-- 2 snipers on easy
	[100358] = {
		values = {
			enabled = easy,
		},
	},
	-- 3 snipers on normal and hard
	[100359] = {
		values = {
			enabled = normal_and_hard,
		},
	},
	-- 4 snipers on overkill
	[100360] = {
		values = {
			enabled = overkill,
		},
	},
	-- 5 snipers on deathwish
	[100361] = {
		values = {
			enabled = deathwish,
		},
	},
	-- don't disable ground snipers after some point
	[100264] = disabled,
	-- add missing Bain's warning about snipers
	[100363] = {
		on_executed = {
			{ id = 400003, delay = 0 },
			{ id = 400004, delay = 0 },
			{ id = 400002, delay = 2 },
			{ id = 400001, delay = 3 },
		},
	},
	-- don't remove side window spawns
	[102112] = { -- obj 5
		on_executed = {
			{ id = 102126, remove = true },
			{ id = 102147, remove = true },
		},
	},
	[102154] = { -- 1st timelock done
		on_executed = {
			{ id = 102126, remove = true },
			{ id = 102147, remove = true },
			{ id = 100128, delay = 0, delay_rand = 20 }, -- add 40
			{ id = 100130, delay = 0, delay_rand = 20 }, -- add 41
			{ id = 102129, delay = 10, delay_rand = 20 }, -- add 11
		},
	},
	-- don't remove front spawns
	[102159102159] = disabled,
	-- Spawn group intervals
	[100786] = courtyard_spawn,
	[100789] = courtyard_spawn,
	[100790] = courtyard_spawn,
	[100791] = courtyard_spawn,
	[100007] = staircase_window_spawn,
	[102418] = staircase_window_spawn,
	[102399] = matrix_window_spawn,
	[102400] = matrix_window_spawn,
	[100019] = exhibit_rappel_spawn,
	[100809] = exhibit_rappel_spawn,
	[100810] = exhibit_rappel_spawn,
	[100021] = exhibit_rappel_spawn,
	[101946] = exhibit_rappel_spawn,
	[101959] = exhibit_rappel_spawn,
	[101924] = last_rappel_spawn,
	[101941] = last_rappel_spawn,
	[101942] = last_rappel_spawn,
	[101943] = last_rappel_spawn,
}
