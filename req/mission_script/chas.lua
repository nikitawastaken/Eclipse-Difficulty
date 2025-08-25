local preferred = Eclipse.preferred
local enabled = {
	values = {
		enabled = true,
	},
}
local exclude_shields_dozers = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc" },
}
local exclude_shields = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc", "tank" },
}
local warehouse_preferred_delay = {
	on_executed = {
		{ id = 101196, delay = 15, delay_rand = 30 },
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local close_spawn = {
	values = {
		interval = 15,
	},
}
local building_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local warehouse_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	[100109] = {
		reinforce = { -- Police arrived
			{
				name = "shop_front1",
				force = 3,
				position = Vector3(-2000, 300, -10),
			},
			{
				name = "shop_front2",
				force = 3,
				position = Vector3(-1000, 300, -10),
			},
		},
	},
	[101198] = { -- warehouse door open
		reinforce = {
			{
				name = "tea_shop",
				force = 3,
				position = Vector3(-2900, -1400, 0),
			},
		},
	},
	[101647] = { -- Dragon found, change reinfroce
		reinforce = {
			{ name = "shop_front1" },
			{ name = "shop_front2" },
			{
				name = "back_alley",
				force = 3,
				position = Vector3(-1400, 4900, 540),
			},
			{
				name = "tram_street",
				force = 3,
				position = Vector3(2650, 4300, 575),
			},
		},
	},
	-- make Swat vans drop units
	[103615] = { -- arrive 1
		on_executed = {
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[103612] = { -- arrive 2
		on_executed = {
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	[103611] = { -- arrive 3
		on_executed = {
			{ id = 400019, delay = 0, delay_rand = 5 },
		},
	},
	[103614] = { -- arrive 4
		on_executed = {
			{ id = 400026, delay = 0, delay_rand = 5 },
		},
	},
	[103613] = { -- arrive 5
		on_executed = {
			{ id = 400033, delay = 0, delay_rand = 5 },
		},
	},
	[103610] = { -- arrive 6
		on_executed = {
			{ id = 400040, delay = 0, delay_rand = 5 },
		},
	},
	-- Don't remove some preferreds
	[100606] = {
		on_executed = {
			{ id = 102459, remove = true }, -- 3rd preferred remove
		},
	},
	[100821] = {
		on_executed = {
			{ id = 102459, remove = true }, -- 3rd preferred remove
		},
	},
	[100774] = {
		on_executed = {
			{ id = 102469, remove = true }, -- 5th preferred remove
		},
	},
	-- Delay preferreds inside the warehouse
	[101190] = warehouse_preferred_delay,
	[101791] = warehouse_preferred_delay,
	-- Restrict a few SOs
	[101029] = exclude_shields, -- no Shields
	[101031] = exclude_shields,
	[101033] = exclude_shields,
	[101034] = exclude_shields,
	[101067] = exclude_shields,
	[101066] = exclude_shields,
	[101065] = exclude_shields,
	[101063] = exclude_shields,
	[103062] = exclude_shields,
	[101036] = exclude_shields,
	[101035] = exclude_shields,
	[100978] = exclude_shields_dozers,
	[100985] = exclude_shields_dozers, -- no Shields or Dozers
	[100984] = exclude_shields_dozers,
	[100983] = exclude_shields_dozers,
	[100982] = exclude_shields_dozers,
	[100981] = exclude_shields_dozers,
	[100979] = exclude_shields_dozers,
	[100978] = exclude_shields_dozers,
	-- Should fix enemies getting stuck in that certain spawn point
	-- Yes, this shit was never fixed since the release of this heist lmao
	[101088] = enabled,
	[101238] = enabled,
	[100999] = enabled,
	[101265] = enabled,
	[101262] = enabled,
	[101264] = enabled,
	-- Fixed snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	[100373] = sniper_trigger_times,
	[100374] = sniper_trigger_times,
	[100375] = sniper_trigger_times,
	[100376] = sniper_trigger_times,
	[100377] = sniper_trigger_times,
	-- Spawn group delays
	-- The Dragon Heist is probably one of the less offensive revival era heists in terms of its spawn group distribution, but some improvements could definitely be made to improve their flow.
	-- Most notably, the basement spawns are much much slower and do not spawn Bulldozers or Shields (including the very elegantly placed vent spawns, for some reason the revival era map designers really liked putting whole spawngroups in vents).
	-- Spawn groups that rappel directly onto the street/right next to the tea shop have also been slowed down and restricted to make them less oppressive.
	-- Alleyway and front spawns are slower to improve pacing during early assaults.
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
	[400021] = scripted_swat_van_spawn,
	[400028] = scripted_swat_van_spawn,
	[400035] = scripted_swat_van_spawn,
	[400042] = scripted_swat_van_spawn,
	[100131] = close_spawn,
	[100132] = close_spawn,
	[102713] = close_spawn,
	[100133] = building_spawn,
	[100692] = building_spawn,
	[100694] = building_spawn,
	[100033] = building_spawn,
	[100693] = building_spawn,
	[101006] = building_spawn,
	[101047] = building_spawn,
	[101053] = building_spawn,
	[100007] = warehouse_spawn,
	[100019] = warehouse_spawn,
	[101201] = warehouse_spawn,
	[101133] = warehouse_spawn,
}
