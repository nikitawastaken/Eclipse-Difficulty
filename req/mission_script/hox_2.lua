local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred

local normal, hard, eclipse = Eclipse.utils.diff_groups()
local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()

local fbi_agents = {
	Idstring("units/payday2/characters/ene_fbi_office_1/ene_fbi_office_1"),
	Idstring("units/payday2/characters/ene_fbi_office_2/ene_fbi_office_2"),
	Idstring("units/payday2/characters/ene_fbi_office_3/ene_fbi_office_3"),
	Idstring("units/payday2/characters/ene_fbi_office_4/ene_fbi_office_4"),
	Idstring("units/payday2/characters/ene_fbi_female_2/ene_fbi_female_2"),
	Idstring("units/payday2/characters/ene_fbi_female_3/ene_fbi_female_3"),
	Idstring("units/payday2/characters/ene_fbi_female_4/ene_fbi_female_4"),
}
local fbi_agent = {
	enemy = fbi_agents,
}

local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local elite_sniper = scripted_enemy.elite_sniper

local regular_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local eclipse_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}

local exit_dozer = {
	enemy = is_eclipse and eclipse_dozers or regular_dozers,
}
local exit_dozer_chance = (is_pro_job and 1.5 or 1) * (diff_i * 10)

local light_harasser = swat_1
local heavy_harasser = is_eclipse and { Idstring(heavy_1), Idstring(heavy_1), Idstring(elite_sniper) } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}

local side_building1 = {
	values = {
		interval = 15,
	},
}
local side_building2 = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields,
}
local upper_floor = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields,
}
local side_building3 = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields,
}
local atrium_roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local atrium_elevator_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local archives_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- add ponr state
	[102221] = {
		set_ponr_state = true,
	},
	[101871] = {
		values = {
			enabled = false,
		},
	},
	[101890] = {
		values = {
			on_executed = {
				{ delay = 0, id = 101891 },
				{ delay = 0, id = 102016 },
				{ delay = 0, id = 102218 },
				{ delay = 0, id = 101374 },
				{ delay = 0, id = 102239 },
				{ delay = 12, id = 102354 },
				{ delay = 0, id = 100087 },
			},
		},
	},
	-- Tweak keycard spawns
	[101218] = { -- Extra keycard, now also spawns on Normal aka Hard
		values = {
			difficulty_hard = true,
		},
	},
	[102220] = {
		values = {
			difficulty_hard = false,
		},
	},
	-- No extra checkpoint keycard on Pro Job
	[103764] = {
		on_executed = {
			{ id = 101469, remove = is_pro_job and true or nil },
		},
	},
	-- Lower upstairs keycard chance, you're getting a good camping spot anyway
	[101628] = {
		values = {
			chance = 30,
		},
	},
	-- Worse keycard RNG on Eclipse
	[101746] = {
		values = {
			chance = is_eclipse and 25 or 50,
		},
	},
	-- Add new reinforce
	[100109] = { -- Atrium, always active
		reinforce = {
			{
				name = "atrium_lower",
				force = 4,
				position = Vector3(-200, 4200, -500),
			},
		},
	},
	--[[
	[104460] = { -- Corridors around the operations room
		reinforce = {
			{
				name = "corridor1",
				force = 2,
				position = Vector3(1800, -150, -100),
			},
			{
				name = "corridor2",
				force = 2,
				position = Vector3(600, 2225, -100)
			},
			{
				name = "corridor3",
				force = 2,
				position = Vector3(-1000, 2225, -100)
			},
		},
	},
]]
	[100732] = { -- Activate operations room reinforce when the players are doing objectives
		reinforce = {
			{
				name = "operations_room",
				force = 3,
				position = Vector3(-200, 300, 0),
			},
		},
	},
	[100733] = {
		reinforce = {
			{ name = "operations_room" },
		},
	},
	-- Randomise initial FBI agent amounts
	[101195] = {
		values = {
			amount = normal and 4 or 6,
			amount_random = 6,
		},
	},
	-- Force Riker spawn
	[101198] = {
		values = {
			participate_to_group_ai = false,
		},
	},
	[101210] = {
		on_executed = {
			{ delay = 0, id = 101198 },
		},
	},
	[101212] = {
		on_executed = {
			{ remove = true, id = 101198 },
		},
	},
	-- Exit Bulldozer
	[102218] = {
		values = {
			chance = exit_dozer_chance,
		},
	},
	[102214] = exit_dozer,
	-- Spawnpoint delays
	[101662] = side_building1,
	[100140] = side_building1,
	[101672] = side_building2,
	[101677] = side_building2,
	[100139] = side_building2,
	[100007] = side_building3,
	[101667] = side_building3,
	[100694] = upper_floor,
	[101441] = upper_floor,
	[100131] = upper_floor,
	[100128] = atrium_roof_spawn,
	[100130] = atrium_roof_spawn,
	[101687] = archives_spawn,
	[101682] = archives_spawn,
	[101688] = atrium_elevator_spawn,
	-- Holy FBI agents, Batman...
	[101490] = fbi_agent,
	[101492] = fbi_agent,
	[101493] = fbi_agent,
	[101494] = fbi_agent,
	[101495] = fbi_agent,
	[101496] = fbi_agent,
	[101497] = fbi_agent,
	[101498] = fbi_agent,
	[101499] = fbi_agent,
	[101500] = fbi_agent,
	[101501] = fbi_agent,
	[101502] = fbi_agent,
	[101503] = fbi_agent,
	[101504] = fbi_agent,
	[101505] = fbi_agent,
	[101506] = fbi_agent,
	[101214] = fbi_agent,
	[101215] = fbi_agent,
	[101199] = fbi_agent,
	[101200] = fbi_agent,
	[101201] = fbi_agent,
	[101202] = fbi_agent,
	[101203] = fbi_agent,
	[101204] = fbi_agent,
	[101205] = fbi_agent,
	[101206] = fbi_agent,
	[101208] = fbi_agent,
	-- Holy harassers, Batman...
	[100803] = harasser,
	[100332] = harasser,
	[100906] = harasser,
	[100922] = harasser,
	[100938] = harasser,
	[100954] = harasser,
	[100969] = harasser,
	[100985] = harasser,
	[101001] = harasser,
	[101017] = harasser,
	[101033] = harasser,
	[101049] = harasser,
	[101065] = harasser,
	[101081] = harasser,
	[101097] = harasser,
	[101113] = harasser,
	[101129] = harasser,
	[101145] = harasser,
	[101161] = harasser,
	[101177] = harasser,
	[100884] = harasser,
	[100334] = harasser,
	[100907] = harasser,
	[100923] = harasser,
	[100939] = harasser,
	[100955] = harasser,
	[100970] = harasser,
	[100986] = harasser,
	[101002] = harasser,
	[101018] = harasser,
	[101034] = harasser,
	[101050] = harasser,
	[101066] = harasser,
	[101082] = harasser,
	[101098] = harasser,
	[101114] = harasser,
	[101130] = harasser,
	[101146] = harasser,
	[101162] = harasser,
	[101178] = harasser,
	[100885] = harasser,
	[100336] = harasser,
	[100908] = harasser,
	[100924] = harasser,
	[100940] = harasser,
	[100956] = harasser,
	[100971] = harasser,
	[100987] = harasser,
	[101003] = harasser,
	[101019] = harasser,
	[101035] = harasser,
	[101051] = harasser,
	[101067] = harasser,
	[101083] = harasser,
	[101099] = harasser,
	[101115] = harasser,
	[101131] = harasser,
	[101147] = harasser,
	[101163] = harasser,
	[101179] = harasser,
}
