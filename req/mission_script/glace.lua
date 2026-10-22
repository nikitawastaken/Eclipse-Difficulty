local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()

local enabled = {
	values = {
		enabled = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}

local interrupter = {
	enemy = {
		[scripted_enemy.swat_1] = 3,
		[scripted_enemy.swat_2] = 5,
		[scripted_enemy.cloaker] = get_difficulty_group_specific_value({ 0, 2, 3 }),
		[scripted_enemy.taser_1] = get_difficulty_group_specific_value({ 0, 1, 2 }),
	},
}
local regular_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local eclipse_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}

local construct_lower_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local construct_upper_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local saw_far_spawn = {
	values = {
		interval = 30,
	},
}
local saw_mid_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_bulldozers,
}
local saw_close_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_shields_bulldozers,
}
local escape_spawn = {
	values = {
		interval = 30,
	},
}
local escape_guaranteed_spawn = {
	values = {
		spawn_type = "group_guaranteed",
	},
	groups = preferred.no_cops_agents,
}

return {
	[100121] = { -- obj_link_complete_005 (Prisoner taken away)
		reinforce = { -- disable construction side reinforce
			{ name = "construct01" },
			{ name = "construct02" },
		},
		func = function(self) -- disable dozer spawn once George the pilot gets Kauzo out
			local turn_it_off = self:get_mission_element(400027)

			if turn_it_off then
				turn_it_off:set_enabled(false)
			end
		end,
	},
	[100521] = disabled, -- disable hunt
	-- Add new reinforce
	[100529] = {
		reinforce = {
			{
				name = "bridge",
				force = 5,
				position = Vector3(-1425, -17500, 5800),
			},
		},
		on_executed = {
			{ id = 101591, delay = 45 }, -- saw spawns
		},
	},
	[102295] = { -- at the top
		reinforce = {
			{ name = "bridge" }, -- disable construction bridge reinforce
			{
				name = "construct01",
				force = 3,
				position = Vector3(-1000, -20500, 5800),
			},
			{
				name = "construct02",
				force = 3,
				position = Vector3(-1000, -24500, 5800),
			},
		},
		ponr = {
			length = 480,
			length_balance_mul = { 1.5, 1.25, 1, 0.75 },
		},
	},
	-- delay SWAT choppers
	[100065] = {
		on_executed = {
			{ id = 100828, delay = 30, delay_rand = 60 },
		},
	},
	-- enable enemies at the escape
	[101834] = enabled,
	-- disable the entire attack heli
	[100657] = disabled,
	-- don't outline/mark interrupting enemies
	[103530] = disabled,
	[103442] = disabled,
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
	-- extend the plane arrival timer
	[102371] = { -- plane_time_60sec
		values = {
			timer = 120, -- vanilla: 60
		},
	},
	[102366] = { -- plane_time_30sec
		values = {
			timer = 90, -- vanilla: 30
		},
	},
	[103039] = { -- plane_time_20sec
		values = {
			timer = 80, -- vanilla: 20
		},
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
	-- filters are disabled
	[101988] = enabled,
	[101989] = enabled,
	[101990] = enabled,
	-- Change preferreds
	[101176] = { -- add_prefered_saw_spawns
		values = { -- remove spawns close to the broken bridge part
			spawn_groups = {
				101154,
				101160,
				101156,
				101159,
				103886, -- Add a few construct groups
				101250,
				101847,
			},
		},
	},
	[101239] = { -- add_prefered_escape_bridge_spawns
		values = { -- remove spawns right next to the SWAT van saw
			spawn_groups = {
				101255,
				101587,
				101258,
				--	101252,
				101254,
				101586,
				--	101251,
				102131,
				103886, -- Add a few construct groups
				101847,
			},
		},
	},
	-- Move two "saw" spawngroups to a separate preferred that gets added later
	[101176] = { -- add_prefered_saw_spawns
		on_executed = {
			{ id = 400028, delay = 60, delay_rand = 60 },
		},
	},
	-- Remove it with the other "saw" preferreds
	[101178] = { -- remove_prefered_saw_spawns
		on_executed = {
			{ id = 400029, delay = 0 },
		},
	},
	-- Difficulty scaling
	[102633] = { -- obj_link_complete_002 (Found the Prisoner)
		on_executed = {
			{ id = 400030, delay = 0 },
		},
	},
	[102295] = { -- at the top (Reached the top of the scaffolding with the Prisoner)
		on_executed = {
			{ id = 400031, delay = 0 },
		},
	},
	-- Spawn group intervals
	[101244] = construct_lower_spawn,
	[101246] = construct_lower_spawn,
	[101247] = construct_lower_spawn,
	[101242] = construct_upper_spawn,
	[101243] = construct_upper_spawn,
	[101245] = construct_upper_spawn,
	[101156] = saw_far_spawn,
	[101159] = saw_far_spawn,
	[101154] = saw_mid_spawn,
	[101160] = saw_mid_spawn,
	[100867] = saw_close_spawn,
	[101153] = saw_close_spawn,
	[101157] = saw_close_spawn,
	[101254] = escape_spawn,
	[101255] = escape_spawn,
	[101258] = escape_spawn,
	[102131] = escape_spawn,
	[102132] = escape_spawn,
	[101586] = escape_spawn,
	[101587] = escape_spawn,
	[101588] = escape_spawn,
	[101589] = escape_spawn,
	-- Interrupters are now EVIL
	[104292] = interrupter,
	[104293] = interrupter,
	[104294] = interrupter,
	[104295] = interrupter,
	[105100] = interrupter,
	[105102] = interrupter,
	[105111] = interrupter,
	[105112] = interrupter,
	[105113] = interrupter,
	[105115] = interrupter,
	[105116] = interrupter,
}
