local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local standard_init_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local tower_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local heavy_swats = {
	enemy = {
		[scripted_enemy.heavy_swat_1] = get_difficulty_group_specific_value({ 4, 2, 1 }),
		[scripted_enemy.heavy_swat_2] = 3,
	}
}
local death_row_spawns = {
	on_executed = {
		{ id = 101678, delay = 0 },
		{ id = 101679, delay = 0 },
		{ id = 101680, delay = 0 },
		{ id = 101681, delay = 0 },
		{ id = 101682, delay = 0 },
	}
}
local cell_unlock_timer = 60 + (diff_i * 10) * (is_pro_job and 1.5 or 1)
local ai_remove_area_triggers = {
	values = {
		instigator = "enemies_all",
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
return {
	-- Combine some navigation areas
	[133004] = {
		ai_area = {
			{ 2, 72 },
			{ 4, 80 },
			{ 6, 81 },
			{ 32, 82, 83 },
			{ 52, 91 },
			{ 56, 97, 125 },
			{ 57, 99 },
			{ 73, 74 },
			{ 84, 85 },
			{ 89, 90 },
			{ 92, 124 },
			{ 93, 94 },
		},
	},
	-- Allow bot navigation earlier
	[102736] = {
		on_executed = {
			{ id = 103049, delay = 1 },
		},
	},
	-- Fix dominated enemies never being removed when moving on
	[100998] = ai_remove_area_triggers,
	[100991] = ai_remove_area_triggers,
	[100985] = ai_remove_area_triggers,
	[100984] = ai_remove_area_triggers,
	-- Adjust watchtower door logic
	-- Door is openable immediately, but the lever is not interactable until the normal time
	[101547] = {
		on_executed = {
			{ id = 101689, remove = true },
			{ id = 102902, delay = 0 },
		},
	},
	[100963] = {
		on_executed = {
			{ id = 102902, remove = true },
		},
	},
	-- No regular PONR, replace with FFO on Pro Jobs
	[101161] = disabled,
	[102736] = {
		ponr = {
			length = 300,
			length_balance_mul = { 1.25, 1, 1, 1 },
		},
		on_executed = {
			{ id = 101689, delay = 0 },
		},
	},
	-- Extended cell unlock timer slightly on high difficulties (even more on Pro Jobs)
	[101402] = {
		values = {
			timer = cell_unlock_timer,
		},
	},
	-- Disable hiding Cloaker spots, they are very poorly set up (and unnecessary on this heist)
	[100800] = disabled,
	-- Replace some Murky guards with heavy SWAT
	[101059] = heavy_swats, -- Intro
	[101060] = heavy_swats,
	[101061] = heavy_swats,
	[101064] = heavy_swats,
	[101065] = heavy_swats,
	[101066] = heavy_swats,
	[101067] = heavy_swats,
	[101068] = heavy_swats,
	[101367] = heavy_swats, -- Door-openers
	[101664] = heavy_swats,
	[101665] = heavy_swats,
	[101666] = heavy_swats,
	[101667] = heavy_swats,
	[101669] = heavy_swats, -- Security
	[101670] = heavy_swats,
	[101671] = heavy_swats,
	[101672] = heavy_swats,
	[101949] = heavy_swats,
	[101950] = heavy_swats,
	[101694] = heavy_swats, -- Cell block A entrance
	[101695] = heavy_swats,
	[101696] = heavy_swats,
	[101697] = heavy_swats,
	[102627] = disabled, -- Cells ambush (their SOs aren't set up correctly and honestly aren't really worthwhile)
	[102628] = disabled,
	[101366] = heavy_swats, -- Laundry/canteen entrance
	[101756] = heavy_swats,
	[101757] = heavy_swats,
	[101368] = heavy_swats,
	[101369] = heavy_swats,
	[101673] = heavy_swats, -- Turret room
	[101676] = heavy_swats,
	[103327] = heavy_swats,
	[103425] = heavy_swats,
	[101675] = heavy_swats,
	[103423] = heavy_swats,
	[103424] = heavy_swats,
	[101674] = heavy_swats,
	[101678] = heavy_swats, -- Death row
	[101679] = heavy_swats,
	[101680] = heavy_swats,
	[101681] = heavy_swats,
	[101682] = heavy_swats,
	[100596] = heavy_swats, -- Watchtower
	-- Add unused ambush spawns
	[100362] = {
		on_executed = {
			{ id = 101694, delay = 0 },
			{ id = 101695, delay = 0 },
			{ id = 101696, delay = 0 },
			{ id = 101697, delay = 0 },
			{ id = 101366, delay = 0 },
			{ id = 101368, delay = 0 },
			{ id = 101369, delay = 0 },
			{ id = 101757, delay = 0 },
			{ id = 101756, delay = 0 },
		},
	},
	[103326] = death_row_spawns,
	[102975] = death_row_spawns,
	-- Spawn group intervals
	[100821] = standard_spawn,
	[100875] = standard_spawn,
	[102431] = standard_spawn,
	[100007] = standard_spawn,
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100663] = standard_spawn,
	[100669] = standard_spawn,
	[100675] = standard_spawn,
	[100741] = standard_init_spawn,
	[100131] = standard_init_spawn,
	[101365] = tower_spawn,
	[103529] = tower_spawn,
	[100888] = flank_spawn,
	[100951] = flank_spawn,
	[101420] = flank_spawn,
}
