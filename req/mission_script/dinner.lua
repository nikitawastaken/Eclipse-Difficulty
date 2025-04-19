--Awesome layout ranomization from ASS
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local disabled = {
	values = {
		enabled = false,
	},
}
local snipers_amount = {
	values = {
		amount = normal and 2 or hard and 3 or 4,
	},
}
local garage_door_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields,
}
local van_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local yard_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local escape_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local container_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
local chance_all_containers_closed = normal and 0 or hard and 0.0125 or 0.025
local chance_zero_traversal_covers = normal and 0 or 0.05
local chance_zero_top_containers = chance_zero_traversal_covers
local chance_disable_catwalk_far = normal and 0 or 0.25
local chance_no_keycard = normal and 0.1 or hard and 0.2 or 0.4
local zero_traversal_covers = math.random() < chance_zero_traversal_covers
local zero_top_containers = math.random() < chance_zero_top_containers
local all_containers_closed = math.random() < chance_all_containers_closed
return {
	[101061] = {
		ponr = {
			length = 200,
			player_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	[103218] = disabled,
	[103606] = {
		reinforce = {
			{
				name = "catwalk_far",
				force = 3,
				position = Vector3(-8550, 8995, 330),
			},
		},
	},
	[103607] = {
		reinforce = {
			{
				name = "catwalk_near",
				force = 3,
				position = Vector3(-8240, 7460, 330),
			},
		},
	},
	-- Disable a few vanilla reinforce points
	[104143] = disabled,
	[104144] = disabled,
	-- Slightly slower difficulty ramp up
	[101357] = {
		values = {
			difficulty = 0.5,
		},
	},
	[102158] = disabled,
	[101696] = {
		difficulty = 0.75,
		on_executed = {
			{ id = 102804, delay = 0 },
		},
	},
	[104186] = {
		on_executed = {
			{ id = 102162, delay = 0 },
		},
	},
	[105038] = math.random() < chance_no_keycard and disabled or nil,
	[103563] = math.random() < chance_disable_catwalk_far and disabled or nil,
	[102900] = {
		values = {
			amount = zero_top_containers and 10 or hard and 3 or 1,
			amount_random = 10,
		},
	},
	[100007] = {
		values = {
			amount = zero_traversal_covers and 13 or hard and 3 or 1,
			amount_random = 7,
		},
	},
	[102246] = container_open_chance,
	[102253] = container_open_chance,
	[102260] = container_open_chance,
	[102278] = container_open_chance,
	[102296] = container_open_chance,
	[102301] = container_open_chance,
	[102307] = container_open_chance,
	[102313] = container_open_chance,
	[102331] = container_open_chance,
	[102348] = container_open_chance,
	[103923] = container_open_chance,
	[103939] = container_open_chance,
	[104950] = container_open_chance,
	[101880] = {
		values = {
			amount = eclipse and 3 or 1,
			amount_random = hard and 2 or 0,
		},
	},
	[100770] = {
		values = {
			amount = normal and 2 or hard and 1 or 0,
			amount_random = 2,
		},
	},
	-- The camping spot from PDTH is more likely to be blocked on higher difficulties
	[103194] = {
		values = {
			chance = overkill_and_above and 60 or 20,
		},
	},
	-- Spawn scripted dozer after some time
	[103477] = {
		on_executed = {
			{ id = 400054, delay = 30 },
		},
	},
	--PDTH styled ambushes
	[102524] = {
		on_executed = {
			--be gone
			{ id = 102442, remove = true },
			--trigger ambushes after 10 seconds
			{ id = 400052, delay = 10 },
			{ id = 400053, delay = 10 },
			{ id = 400054, delay = 10 },
			{ id = 400055, delay = 10 },
		},
	},
	[102505] = {
		values = {
			elements = {
				400004,
				400005,
				400006,
			},
		},
	},
	[102506] = {
		values = {
			elements = {
				400001,
				400002,
				400003,
			},
		},
	},
	[102511] = {
		values = {
			elements = {
				400007,
				400008,
				400009,
			},
		},
	},
	[102512] = {
		values = {
			elements = {
				400010,
				400011,
				400012,
			},
		},
	},
	--disable the slaughterhouse dozer and enable 2nd one nearby container area when the drill is finished
	[105117] = {
		on_executed = {
			{ id = 400055, delay = 90 },
			{ id = 400045, delay = 0 },
		},
	},
	-- add new spawngroup to the container area
	[102370] = {
		values = {
			spawn_groups = {
				400026,
				101533,
				102013,
				102198,
				101763,
				102843,
				102832,
				104296,
				101715,
			},
		},
	},
	-- Force 2 SWAT vans to spawn regardless of difficulty
	[101808] = disabled,
	[101807] = disabled,
	[102696] = disabled,
	[102697] = {
		values = {
			difficulty_normal = "true",
			difficulty_hard = "true",
		},
	},
	-- tweak swat vans arrival to be indentical to PDTH
	[101809] = {
		on_executed = {
			{ id = 101621, delay = 0.750 },
		},
	},
	-- limit scripted van dozers to 1 (just in case if it might spawn like 3 or 4 dozers due to being strong in Eclipse)
	[101576] = {
		values = {
			trigger_times = 1,
		},
	},
	[101636] = {
		values = {
			trigger_times = 1,
		},
	},
	[103378] = disabled,
	[103382] = disabled,
	-- nerf sniper spawns
	[101213] = snipers_amount,
	[101217] = snipers_amount,
	[101219] = snipers_amount,
	[101222] = snipers_amount,
	[101224] = snipers_amount,
	-- Spawn group delays
	[400026] = van_spawn,
	[101528] = garage_door_spawn,
	[101476] = garage_door_spawn,
	[101523] = garage_door_spawn,
	[101324] = yard_spawn,
	[101501] = window_spawn,	
	[104307] = escape_spawn,
	[104308] = escape_spawn,
	[103344] = escape_spawn,
	[103376] = escape_spawn,
	[103378] = escape_spawn,
	[103379] = escape_spawn,
	[103381] = escape_spawn,
	[103382] = escape_spawn,
	[103383] = escape_spawn,
	[101763] = container_spawn,
	[102013] = container_spawn,
	[102198] = container_spawn,
	[102832] = container_spawn,
	[102843] = container_spawn,	
	[101301] = roof_spawn,
	[101533] = roof_spawn,	
	[103489] = cloaker_spawn,
	[101715] = cloaker_spawn,
}
