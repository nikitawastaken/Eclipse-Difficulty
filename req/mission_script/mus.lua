local disabled = {
	values = {
		enabled = false
	},
}
local enabled = {
	values = {
		enabled = true
	},
}
local window_spawn1 = {
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
local window_spawn2 = {
	values = {
		interval = 45,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
return {
	[100022] = {
		on_executed = {
			{ id = 100109, delay = 30 }
		}
	},
	--spawn group delays
	[102317] = disabled,
	[101258] = disabled,
	[102225] = disabled,
	[102224] = disabled,
	[102226] = disabled,
	[100007] = window_spawn1,
	[102148] = window_spawn1,
	[102399] = window_spawn1,
	[102400] = window_spawn1,
	[101959] = window_spawn2,
	[101946] = window_spawn2,
}