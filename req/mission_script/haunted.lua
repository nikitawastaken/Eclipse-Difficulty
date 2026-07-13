local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local is_eclipse = Eclipse.utils.is_eclipse()

local headless_tank = {
	enemy = is_eclipse and { [scripted_enemy.headless_bulldozer_1] = 2, [scripted_enemy.headless_bulldozer_2] = 1 } or scripted_enemy.headless_bulldozer_1,
}

local hide_so_group = { 
	on_executed = {
		{ id = 400060, delay = 0 }, 
	},
}

local helldozer_spawn_delay = {
	on_executed = {
		{ id = 102740, delay = overkill_and_above and 30 or 45, delay_rand = get_difficulty_group_specific_value({ 30, 15, 0 }) },
	},
}
local lurker_spawn_delay = {
	on_executed = {
		{ id = 102717, delay = overkill_and_above and 45 or 60, delay_rand = get_difficulty_group_specific_value({ 45, 30, 15 }) },
	},
}

local nightmare_inner_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
}
local nightmare_outer_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents,
}

return {
	-- Disable SWAT groups/Scripted Titandozers based on whether 'Pro Job' is enabled
	[100079] = { -- startup
		on_executed = {
			{ id = 400050, delay = 0 }, 
			{ id = 400051, delay = 0 },
		},
	},
	-- Activate SWAT group preferreds if they are enabled
	[100454] = { -- hell
		on_executed = {
			{ id = 400048, delay = 30 }, -- haunted_add_spawns_basement
		},
	},
	[102204] = { -- func_sequence_trigger_035 (money revealed, surface open) 
		on_executed = {
			{ id = 400049, delay = 0 }, -- haunted_add_spawns_garage
		},
	},
	-- Reduce Helldozer spawncaps on Overkill and Death Wish
	[102748] = {
		values = {
			value = 3, -- Vanilla: 5
		},
	},
	[102749] = {
		values = {
			value = 4, -- Vanilla: 8
		},
	},
	-- Scale the Helldozer spawn delays
	[101686] = helldozer_spawn_delay,
	[101689] = helldozer_spawn_delay,
	[101692] = helldozer_spawn_delay,
	[102266] = helldozer_spawn_delay,
	[102590] = helldozer_spawn_delay,
	[102588] = helldozer_spawn_delay,
	[102722] = helldozer_spawn_delay,
	[102698] = helldozer_spawn_delay,
	-- Scale the Cloaker spawn delay
	[102709] = lurker_spawn_delay,
	[100456] = lurker_spawn_delay,
	[102741] = lurker_spawn_delay,
	[102742] = lurker_spawn_delay,
	-- Spawn group intervals
	[400005] = nightmare_inner_spawn,
	[400011] = nightmare_inner_spawn,
	[400017] = nightmare_inner_spawn,
	[400023] = nightmare_inner_spawn,
	[400029] = nightmare_inner_spawn,
	[400035] = nightmare_inner_spawn,
	[400041] = nightmare_outer_spawn,
	[400047] = nightmare_outer_spawn,
	-- Give scripted Cloaker spawns hide SOs
	[102700] = hide_so_group,
	[102701] = hide_so_group,
	[102702] = hide_so_group,
	[102703] = hide_so_group,
	[102704] = hide_so_group,
	[102705] = hide_so_group,
	[102706] = hide_so_group,
	[102707] = hide_so_group,
	-- Add Black Titandozers
	[100457] = headless_tank,
	[101402] = headless_tank,
	[101423] = headless_tank,
	[101433] = headless_tank,
	[101441] = headless_tank,
	[101471] = headless_tank,
	[101526] = headless_tank,
	[101553] = headless_tank,
	[101570] = headless_tank,
	[101616] = headless_tank,
	[101628] = headless_tank,
	[101636] = headless_tank,
	[101646] = headless_tank,
	[101657] = headless_tank,
	[101661] = headless_tank,
}
