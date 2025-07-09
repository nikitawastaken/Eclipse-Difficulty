local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local disabled = {
	values = {
		enabled = false,
	},
}
local farm_far_spawn = {
	values = {
		interval = 10,
	},
}
local that_fucking_bush_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
local farm_close_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- add point of no return
	[100580] = { -- All goats secured
		ponr = {
			length = 180,
			player_mul = { 2, 1.25, 1, 1 },
		},
		values = {
			callback = function() -- Somebody call the National Guard!
				if not normal then
					managers.groupai:state():enabled_timed_group(1)
				end
			end,
		},
	},
	[101707] = disabled, -- Disable hunt
	-- Tweak one of the bridge spawngroups
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
	-- Disable one reinforce point on the bridge, increase the force of the other from 2 to 3
	[101385] = {
		values = {
			amount = 3,
		},
	},
	[101386] = disabled,
	-- Spawn group delays
	-- Most of the spawns during the farm section are slower now akin to the original version.
	-- Fuck the bush spawngroup or something.
	[100131] = farm_far_spawn,
	[100132] = farm_far_spawn,
	[100133] = farm_far_spawn,
	[100128] = farm_close_spawn,
	[100130] = farm_close_spawn,
	[101217] = that_fucking_bush_spawn,
}
