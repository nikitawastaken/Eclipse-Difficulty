local preferred = Eclipse.preferred

local street_spawn = {
	values = {
		interval = 15,
	},
}
local catwalk_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	[101144] = {
		ponr = {
			length = 240,
			player_mul = { 1.2, 1.1, 1, 0.9 },
		},
	},
	-- replace the turrets with spawngroups
	[100450] = {
		on_executed = {
			{ id = 101164, remove = true },
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[101293] = {
		on_executed = {
			{ id = 101294, remove = true },
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	-- Spawn Group delays
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
	[100699] = street_spawn,
	[100711] = street_spawn,
	[100719] = street_spawn,
	[100760] = street_spawn,
	[100767] = street_spawn,
	[102827] = catwalk_spawn,
	[101687] = roof_spawn,
}
