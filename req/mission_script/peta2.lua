local preferred = Eclipse.preferred
local farm_far_spawn = {
	values = {
		interval = 10,
	},
}
local farm_close_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local that_fucking_bush_spawn = {
	values = {
		interval = 25,
	},
}
return {
	-- add point of no return
	[100580] = {
		ponr = {
			length = 120,
			player_mul = { 2, 1.25, 1, 1 },
		},
	},
	[102374] = {
		values = {
			elements = {
				102376,
				102377,
				102378,
				102379,
				102380,
			},
		},
	},
	[101707] = {
		values = {
			enabled = false,
		},
	},
	-- Spawn group delays
	-- Most of the spawns during the farm section are slower now akin to the original version.
	-- Sadly the weird bush groups (which are split to also spawn enemies under the bridge) are the only spawn groups during the bridge section, so they kind of had to stay fast-ish
	[100131] = farm_far_spawn,
	[100132] = farm_far_spawn,
	[100133] = farm_far_spawn,
	[100128] = farm_close_spawn,
	[100130] = farm_close_spawn,
	[101217] = that_fucking_bush_spawn,
	[102374] = that_fucking_bush_spawn,
}
