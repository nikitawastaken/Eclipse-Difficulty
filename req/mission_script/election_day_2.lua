local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local swat_1 = scripted_enemy.swat_1
local elite_sniper = scripted_enemy.elite_sniper
local harasser_enemy = is_eclipse and { [swat_1] = 15, [elite_sniper] = 1 } or swat_1
local harasser = {
	enemy = harasser_enemy,
}
local enabled = {
	values = {
		enabled = true,
	},
}
local window_far_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields,
}
local skylight_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local window_close_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- Fix harasser respawn delay
	[102807] = {
		on_executed = {
			{ id = 102804, delay = 30 },
		},
	},
	-- replace the turrets with spawngroups
	-- enable van arrived checks
	[101488] = {
		values = {
			enabled = true,
		},
		on_executed = {
			{ id = 101495, remove = true },
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[101492] = {
		values = {
			enabled = true,
		},
		on_executed = {
			{ id = 101496, remove = true },
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	-- Spawn group intervals
	-- Election Day got butchered pretty badly when spawn group intervals were standardised.
	-- While the original intervals would've been more than enough, I decided to slow down the skylight rappels further to make holding out under the catwalks a bit less annoying.
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
	[100021] = window_far_spawn,
	[100132] = window_far_spawn,
	[100145] = window_far_spawn,
	[100147] = window_far_spawn,
	[100131] = skylight_spawn,
	[100146] = skylight_spawn,
	[100148] = skylight_spawn,
	[100149] = window_close_spawn,
	[100150] = window_close_spawn,
	-- Harassers
	[102732] = harasser,
	[102733] = harasser,
	[102742] = harasser,
	[102428] = harasser,
	[102429] = harasser,
	[102430] = harasser,
	[102444] = harasser,
	[102445] = harasser,
	[102446] = harasser,
	[102460] = harasser,
	[102461] = harasser,
	[102462] = harasser,
	[102762] = harasser,
	[102763] = harasser,
	[102764] = harasser,
	[102778] = harasser,
	[102779] = harasser,
	[102780] = harasser,
	[102794] = harasser,
	[102795] = harasser,
	[102796] = harasser,
	[102810] = harasser,
	[102811] = harasser,
	[102812] = harasser,
	[102826] = harasser,
	[102827] = harasser,
	[102828] = harasser,
}
