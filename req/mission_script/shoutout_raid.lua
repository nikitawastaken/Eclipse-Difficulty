local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
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
				name = "warehouse_entrance_container",
				force = 2,
				position = Vector3(-650, -2100, 1250),
			},
			{
				name = "central",
				force = 4,
				position = Vector3(2650, -125, 975),
			},
			{
				name = "near_longfellow1",
				force = 2,
				position = Vector3(-1925, 25, 975),
			},
			{
				name = "near_longfellow2",
				force = 2,
				position = Vector3(-3000, 150, 975),
			},
		},
	},
	-- add one additional dozer in the container on Eclipse
	[107061] = {
		values = {
			amount = dozer_in_the_container_amount,
		},
	},
	-- disable turret logic
	[106492] = {
		values = {
			enabled = false,
		},
	},
	-- Spawn group intervals
	[100132] = close_spawn,
	[103919] = close_spawn,
	[100007] = close_spawn,
	[100131] = roof_spawn,
	[101008] = roof_spawn,
	[101153] = roof_spawn,
	[101473] = roof_spawn,
}
