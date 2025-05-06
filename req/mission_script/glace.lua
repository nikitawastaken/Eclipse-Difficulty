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

local sniper_amount = (is_eclipse and 2 or 1) + (is_pro_job and 1 or 0)

local sniper_chopper_amount = {
	values = {
		amount = sniper_amount,
	},
}

local bridge_spawn1 = {
	values = {
		interval = 10,
	},
}
local bridge_spawn2 = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local construct_spawn1 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local saw_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local construct_spawn2 = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_bulldozers,
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
			{ id = 100828, delay = 45 },
		},
	},
	-- Add new reinforce
	[100529] = {
		on_executed = { -- delay SWAT response
			{ id = 100530, delay = 60 }, -- difficulty 0.5
		},
		reinforce = {
			{
				name = "street",
				force = 5,
				position = Vector3(-1350, -15000, 5800),
			},
		},
	},
	[103543] = {
		reinforce = {
			{ name = "street" },
			{
				name = "construct1",
				force = 3,
				position = Vector3(-1350, -21500, 5800),
			},
			{
				name = "construct2",
				force = 3,
				position = Vector3(-1350, -24650, 5800),
			},
		},
	},
	[102323] = {
		reinforce = {
			{ name = "construct1" },
			{ name = "construct2" },
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
	-- add spawns to nearby scaffolding
	[103255] = {
		on_executed = {
			{ id = 400025, delay = 60, delay_rand = 30 },
		},
	},
	-- tweak the amount of sniper choppers
	[102570] = sniper_chopper_amount,
	[102569] = sniper_chopper_amount,
	-- disable dozer spawn once George the pilot gets Kauzo out
	[100121] = {
		func = function(self)
			local turn_this_shit_off = self:get_mission_element(101320)

			if turn_this_shit_off then
				turn_this_shit_off:set_enabled(false)
			end
		end,
	},
	-- sawing section preferreds
	[101176] = {
		values = {
			spawn_groups = {
				400015, -- 5s
				101250, -- 5s
				101159, -- 30s
				101156, -- 30s
				101153, -- 60s
				100867, -- 60s
			},
		},
	},
	-- scaffolding section preferreds
	[101238] = {
		values = {
			spawn_groups = {
				101251, -- 5s,
				101252, -- 5s,
				101847, -- 15s,
				103886, -- 15s,
				101244, -- 30s,
				101246, -- 30s,
				101242, -- 45s,
				--101243, -- 45s,
				--101245, -- 45s,
				400016, -- 60s,
			},
		},
	},
	-- escape section preferreds
	[101239] = {
		values = {
			spawn_groups = {
				400015, -- 5s,
				101250, -- 5s,
				101255, -- 15s,
				101258, -- 15s,
				101587, -- 15s,
				101589, -- 15s,
				102131, -- 15s,
			},
		},
	},
	[101251] = bridge_spawn1,
	[101252] = bridge_spawn1,
	[101847] = bridge_spawn2,
	[103886] = bridge_spawn2,
	[101159] = saw_spawn,
	[101156] = saw_spawn,
	[101244] = construct_spawn1,
	[101246] = construct_spawn1,
	[101242] = construct_spawn2,
	[101243] = construct_spawn2,
	[101245] = construct_spawn2,
	[101153] = flank_spawn,
	[100867] = flank_spawn,
	[400016] = flank_spawn,
}
