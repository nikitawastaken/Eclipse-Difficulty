local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local harasser_enemy = is_eclipse and { [scripted_enemy.swat_1] = 9, [scripted_enemy.elite_sniper] = 1 } or scripted_enemy.swat_1
local gensec_security = { [scripted_enemy.gensec_1] = 3, [scripted_enemy.gensec_2] = 1 }
local harasser = {
	enemy = harasser_enemy,
}
local gensec_enemy = {
	enemy = gensec_security,
}
local enabled = {
	values = {
		enabled = true,
	},
}
local window_far_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_cops_agents_shields,
}
local skylight_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local window_close_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- Combine some navigation areas
	[101157] = {
		ai_area = {
			{ 1, 2 },
			{ 18, 116 },
			{ 17, 25 },
			{ 19, 52 },
			{ 92, 97 },
			{ 9, 90 },
			{ 24, 91, 109 },
			{ 23, 27, 108 },
			{ 93, 106 },
			{ 21, 26, 75 },
			{ 56, 115 },
			{ 59, 107 },
			{ 83, 114 },
			{ 70, 71 },
			{ 81, 88 },
			{ 47, 50 },
			{ 48, 49, 68 },
			{ 36, 104 },
			{ 35, 103 },
			{ 34, 102 },
			{ 33, 101 },
		},
	},
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
	-- replace Regular Security with GenSec
	[100670] = gensec_enemy,
	[100671] = gensec_enemy,
	[100672] = gensec_enemy,
	[100673] = gensec_enemy,
	[100674] = gensec_enemy,
	[100675] = gensec_enemy,
	[100676] = gensec_enemy,
	[100677] = gensec_enemy,
	[100678] = gensec_enemy,
	[100679] = gensec_enemy,
	[100605] = gensec_enemy,
	[100606] = gensec_enemy,
	[100607] = gensec_enemy,
	[100608] = gensec_enemy,
	[104997] = gensec_enemy,
	[105057] = gensec_enemy,
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
