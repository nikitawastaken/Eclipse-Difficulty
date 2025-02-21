local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()

local sniper_interval = normal and 60 or hard and 40 or 30

local atrium_spawn = {
	values = {
		interval = 10,
	},
}
local ladder_spawn = {
	values = {
		interval = 15,
	},
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
return {
	[104782] = {
		ponr = {
			length = 420,
			player_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	-- new reinforce
	[102758] = {
		reinforce = {
			{
				name = "atrium_left",
				force = 2,
				position = Vector3(-400, 100, 0),
			},
			{
				name = "atrium_right",
				force = 2,
				position = Vector3(-400, -3250, 0),
			},
		},
	},
	-- Vault is open, diff 1
	[104599] = {
		difficulty = 1,
	},
	-- Prevent sniper respawn delays becoming ridiculously small as more assaults pass
	[100082] = {
		on_executed = {
			{ id = 100321, remove = true },
		},
	},
	[100446] = {
		on_executed = {
			{ id = 100321, delay = 0 },
		},
	},
	[103702] = {
		values = {
			interval = sniper_interval,
		},
	},
	[100438] = {
		values = {
			interval = sniper_interval,
		},
	},
	-- spawn group delays
	[100439] = atrium_spawn,
	[100431] = atrium_spawn,
	[104838] = atrium_spawn,
	[101794] = ladder_spawn,
	[101795] = ladder_spawn,
	[103702] = window_spawn,
	[100438] = window_spawn,
	[102792] = cloaker_spawn,
	[103435] = cloaker_spawn,
	[103437] = cloaker_spawn,
}
