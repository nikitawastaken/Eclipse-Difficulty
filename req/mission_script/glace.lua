local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
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
local construct_lower_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local escape_spawn = {
	values = {
		interval = 30,
	},
}
local saw_spawn = {
	values = {
		interval = 45,
	},
}
local construct_upper_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local escape_guaranteed_spawn = {
	values = {
		spawn_type = "group_guaranteed",
	},
	groups = preferred.no_cops_agents,
}

return {
	[100533] = {
		ponr = {
			length = 20,
			player_mul = { 2, 1.5, 1, 1 },
		},
	},
	[100521] = {
		values = {
			enabled = false,
		},
	},
	-- delay SWAT choppers
	[100065] = {
		on_executed = {
			{ id = 100828, delay = 60, delay_rand = 60 },
		},
	},
	-- Add new reinforce
	[100529] = {
		on_executed = {
			{ id = 101591, delay = 30 }, -- saw spawns
		},
		reinforce = {
			{
				name = "bridge",
				force = 5,
				position = Vector3(-1300, -15585, 5800),
			},
		},
	},
	[101238] = { -- add construction spawns
		reinforce = {
			{ name = "bridge" },
			{
				name = "construct1",
				force = 3,
				position = Vector3(-1425, -18825, 5800),
			},
			{
				name = "construct2",
				force = 3,
				position = Vector3(-840, -21830, 5800),
			},
			{
				name = "construct3",
				force = 3,
				position = Vector3(-1300, -24585, 5800),
			},
		},
	},
	[101593] = { -- escape bridge spawns
		reinforce = {
			{ name = "construct1" },
			{ name = "construct2" },
			{ name = "construct3" },
		},
	},
	-- disable the entire attack heli
	[100657] = {
		values = {
			enabled = false,
		},
	},
	-- replace the cloaker spawn with dozer and make him participate to group ai
	[101320] = {
		enemy = is_eclipse and eclipse_dozers or regular_dozers,
		values = {
			participate_to_group_ai = true,
		},
	},
	-- trigger spawns during escape part
	[103111] = {
		on_executed = {
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
			{ id = 400004, delay = 0 },
		},
	},
	-- trigger spawns in scaffolding part
	[103543] = {
		on_executed = {
			{ id = 400005, delay = 0 },
			{ id = 400006, delay = 0 },
			{ id = 400007, delay = 0 },
			{ id = 400008, delay = 0 },
		},
	},
	-- tweak special scaffolding spawn event
	[105159] = {
		on_executed = {
			{ id = 400027, delay = 0 },
			{ id = 101320, remove = true },
		},
	},
	-- add spawns to nearby scaffolding
	[103255] = {
		on_executed = {
			{ id = 400025, delay = 60, delay_rand = 30 },
		},
	},
	-- disable dozer spawn once George the pilot gets Kauzo out
	[100121] = {
		func = function(self)
			local turn_it_off = self:get_mission_element(400027)

			if turn_it_off then
				turn_it_off:set_enabled(false)
			end
		end,
	},
	-- fix escape spawngroups not working as intended
	[100638] = escape_guaranteed_spawn,
	[101812] = escape_guaranteed_spawn,
	[101819] = escape_guaranteed_spawn,
	[101826] = escape_guaranteed_spawn,
	[101987] = escape_guaranteed_spawn,
	[102003] = escape_guaranteed_spawn,
	[102004] = escape_guaranteed_spawn,
	[102005] = escape_guaranteed_spawn,
	[102006] = escape_guaranteed_spawn,
	[102007] = escape_guaranteed_spawn,
	[102008] = escape_guaranteed_spawn,
	[102009] = escape_guaranteed_spawn,
	-- change preferreds
	[101176] = { -- saw spawns
		values = {
			spawn_groups = {
				101250, -- 0s
				101847, -- 0s
				103886, -- 0s
				101156, -- 45s
				101159, -- 45s
				100867, -- 75s
				101153, -- 75s
			},
		},
	},
	[101239] = { -- escape bridge spawns
		values = {
			spawn_groups = {
				101250, -- 0s
				101847, -- 0s
				103886, -- 0s
				101251, -- 45s
				101252, -- 45s
			},
		},
	},
	[100669] = { -- escape bridge spawns 1
		values = {
			spawn_groups = {
				101588, -- 30s
				101589, -- 30s
				102131, -- 30s
				102132, -- 30s
			},
		},
	},
	-- Spawn group intervals
	[101588] = escape_spawn,
	[101589] = escape_spawn,
	[102131] = escape_spawn,
	[102132] = escape_spawn,
	[101244] = construct_lower_spawn,
	[101246] = construct_lower_spawn,
	[101247] = construct_lower_spawn,
	[101156] = saw_spawn,
	[101159] = saw_spawn,
	[101251] = saw_spawn,
	[101252] = saw_spawn,
	[101242] = construct_upper_spawn,
	[101243] = construct_upper_spawn,
	[101245] = construct_upper_spawn,
	[100867] = flank_spawn,
	[101153] = flank_spawn,
}
