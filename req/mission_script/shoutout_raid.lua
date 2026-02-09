local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local disabled = {
	values = {
		enabled = false,
	},
}
local close_spawn = {
	values = {
		interval = 10,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local inside_loot_drop = {
	loot_drop = {
		{ name = "point_init" },
		{ name = "container_point", position = Vector3(4225, -1550, 975) }, -- ditto
	},
}
local outside_loot_drop = {
	loot_drop = {
		{ name = "point_init" },
		{ name = "container_point", position = Vector3(-1975, -5100, 1375) },
	},
}
local dozer_in_the_container_amount = is_eclipse and 2 or 1
	
return {
	[101731] = {
		ponr = { -- Trigger once, warhead case opened
			length = 480,
			player_mul = { 1.5, 1.125, 1, 1 },
		},
	},
	[100109] = { -- Police
		reinforce = {
			{
				name = "catwalk",
				force = 2,
				position = Vector3(-3650, -1850, 1400),
			},
			{
				name = "warehouse_entrance",
				force = 2,
				position = Vector3(100, -2075, 975),
			},
			{
				name = "central",
				force = 4,
				position = Vector3(2650, -125, 975),
			},
			{
				name = "near_longfellow01",
				force = 2,
				position = Vector3(-1925, 25, 975),
			},
			{
				name = "near_longfellow02",
				force = 2,
				position = Vector3(-3000, 150, 975),
			},
		},
	},
	-- add one additional dozer in the container on Death Wish
	[107061] = {
		values = {
			amount = dozer_in_the_container_amount,
		},
	},
	-- disable turret logic
	[106492] = disabled,
	-- Add a loot drop points based on the location of the nuke container
	[100356] = disabled,
	[100353] = {
		loot_drop = {
			{ name = "point_init", position = Vector3(4225, -1550, 975) }, -- vanilla loot dropoff location, moved to the mission script patch for disabling later
		},
	},
	[102851] = outside_loot_drop, -- container_chosen_001
	[102866] = outside_loot_drop, -- container_chosen_002
	[102872] = outside_loot_drop, -- container_chosen_003
	[102882] = outside_loot_drop, -- container_chosen_004
	[102886] = outside_loot_drop, -- container_chosen_005
	[102892] = outside_loot_drop, -- container_chosen_006
	[102905] = outside_loot_drop, -- container_chosen_007
	[102913] = inside_loot_drop, -- container_chosen_008
	[102974] = inside_loot_drop, -- container_chosen_009
	[102996] = inside_loot_drop, -- container_chosen_010
	[103001] = inside_loot_drop, -- container_chosen_011
	[103004] = inside_loot_drop, -- container_chosen_012
	[103022] = inside_loot_drop, -- container_chosen_013
	-- Spawn group intervals
	[100132] = close_spawn,
	[103919] = close_spawn,
	[100007] = close_spawn,
	[100131] = roof_spawn,
	[101008] = roof_spawn,
	[101153] = roof_spawn,
	[101473] = roof_spawn,
}
