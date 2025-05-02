local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local swat_1 = scripted_enemy.swat_1
local elite_sniper = scripted_enemy.elite_sniper
local harasser_enemy = is_eclipse and { [swat_1] = 6, [elite_sniper] = 1 } or swat_1
local harasser = {
	enemy = harasser_enemy,
}
local window_spawn1 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields,
}
local skylight_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local window_spawn2 = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Fix harasser respawn delay
	[102807] = {
		on_executed = {
			{ id = 102804, delay = 30 },
		},
	},
	-- Spawn group delays
	-- Election Day got butchered pretty badly when spawn group intervals were standardised.
	-- While the original intervals would've been more than enough, I decided to slow down the skylight rappels further to make holding out under the catwalks a bit less annoying.
	[100021] = window_spawn1,
	[100132] = window_spawn1,
	[100145] = window_spawn1,
	[100147] = window_spawn1,
	[100131] = skylight_spawn,
	[100146] = skylight_spawn,
	[100148] = skylight_spawn,
	[100149] = window_spawn2,
	[100150] = window_spawn2,
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
