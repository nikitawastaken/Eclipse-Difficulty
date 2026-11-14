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

local construct_far_spawn = {
	values = {
		interval = 10,
	},
}
local construct_mid_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local construct_close_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local saw_far_spawn = {
	values = {
		interval = 30,
	},
}
local saw_mid_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_bulldozers,
}
local saw_close_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_shields_bulldozers,
}
local escape_guaranteed_spawn = {
	values = {
		spawn_type = "group_guaranteed",
	},
	groups = preferred.no_cops_agents,
}

return {
	[102295] = {
		reinforce = {
			{
				name = "construct01",
				force = 2,
				position = Vector3(-1000, -20500, 5800),
			},
			{
				name = "construct02",
				force = 2,
				position = Vector3(-1000, -24500, 5800),
			},
		},
		ponr = {
			length = 480,
			length_balance_mul = { 1.5, 1.25, 1, 0.75 },
		},
	},
	[100521] = disabled, -- disable hunt
	[100121] = { -- obj_link_complete_005 (Prisoner taken away)
		reinforce = { -- disable construction reinforce
			{ name = "construct01" },
			{ name = "construct02" },
		},
		on_executed = {
			{ id = 400035, delay = 0 },
		},
		func = function(self) -- disable dozer spawn once George the pilot gets Kauzo out
			local turn_it_off = self:get_mission_element(400027)

			if turn_it_off then
				turn_it_off:set_enabled(false)
			end
		end,
	},
	-- Delay initial preferreds
	[100529] = {
		on_executed = {
			{ id = 101591, delay = 30 }, -- saw spawns
		},
	},
	-- Delay SWAT choppers
	[100065] = {
		on_executed = {
			{ id = 100828, delay = 30, delay_rand = 60 },
		},
	},
	-- Enable enemies at the escape
	[101834] = enabled,
	[101988] = enabled,
	[101989] = enabled,
	[101990] = enabled,
	-- Disable the entire attack heli
	[100657] = disabled,
	-- Don't outline/mark interrupting enemies
	[103530] = disabled,
	[103442] = disabled,
	-- Replace the cloaker spawn with dozer and make him participate to group ai
	[101320] = {
		enemy = is_eclipse and eclipse_dozers or regular_dozers,
		values = {
			participate_to_group_ai = true,
		},
	},
	-- Trigger spawns during escape part
	[103111] = {
		on_executed = {
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
			{ id = 400004, delay = 0 },
		},
	},
	-- Trigger spawns in scaffolding part
	[103543] = {
		on_executed = {
			{ id = 400005, delay = 0 },
			{ id = 400006, delay = 0 },
			{ id = 400007, delay = 0 },
			{ id = 400008, delay = 0 },
		},
	},
	-- Tweak special scaffolding spawn event
	[105159] = {
		on_executed = {
			{ id = 400027, delay = 0 },
			{ id = 101320, remove = true },
		},
	},
	-- Add spawns to nearby scaffolding
	[103255] = {
		on_executed = {
			{ id = 400025, delay = 30, delay_rand = 60 },
		},
	},
	-- Extend the plane arrival timer
	[102371] = { -- plane_time_60sec
		values = {
			time = 180 + (is_pro_job and 60 or 0), -- vanilla: 60
		},
	},
	[102366] = { -- plane_time_30sec
		values = {
			time = 120, -- vanilla: 30
		},
	},
	[103039] = { -- plane_time_20sec
		values = {
			time = 60, -- vanilla: 20
		},
	},
	-- Change the chance for George to grab the balloon on his first attempt
	[100616] = {
		values = {
			chance = get_difficulty_group_specific_value({ 45, 30, 15 }),
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
	-- Remove spawn groups closest to the broken bridge part (and add a few groups from the construction site)
	[101176] = { -- add_prefered_saw_spawns
		values = {
			spawn_groups = { 101847, 103886, 101250, 400015 },
		},
		-- Add additioanl "saw" prefereds to introduce groups close to the prison transports with a delay
		on_executed = {
			{ id = 400028, delay = 60, delay_rand = 90 },
			{ id = 400030, delay = 30, delay_rand = 60 },
			{ id = 400032, delay = 0, delay_rand = 30 },
		},
	},
	[101239] = { -- add_prefered_escape_bridge_spawns
		values = {
			spawn_groups = { 101255, 101587, 101258, 101254, 101586, 102131, 101847, 103886, 101250, 400015 },
		},
	},
	-- Remove the new preferreds with the other "saw" preferreds
	[101178] = { -- remove_prefered_saw_spawns
		on_executed = {
			{ id = 400029, delay = 0 },
			{ id = 400031, delay = 0 },
			{ id = 400033, delay = 0 },
		},
	},
	-- Scripted difficulty scaling
	[102633] = { -- obj_link_complete_002 (Found the Prisoner)
		on_executed = {
			{ id = 400034, delay = 0 },
		},
	},
	[102295] = { -- at the top (Reached the top of the scaffolding with the Prisoner)
		on_executed = {
			{ id = 400035, delay = 0 },
		},
	},
	-- Spawn group intervals
	[101247] = construct_far_spawn,
	[101244] = construct_far_spawn,
	[101246] = construct_mid_spawn,
	[101242] = construct_close_spawn,
	[101243] = construct_close_spawn,
	[101245] = construct_close_spawn,
	[101156] = saw_far_spawn,
	[101159] = saw_far_spawn,
	[101154] = saw_mid_spawn,
	[101160] = saw_mid_spawn,
	[100867] = saw_close_spawn,
	[101153] = saw_close_spawn,
	[101155] = saw_close_spawn,
	[101157] = saw_close_spawn,
	[101158] = saw_close_spawn,
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
