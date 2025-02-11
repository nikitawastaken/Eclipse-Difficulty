local disabled = {
	values = {
		enabled = false
	}
}
local staircase_spawn = {
	values = {
		interval = 10,
	},
}
local exit_spawn = {
	values = {
		interval = 15,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
	},
}
local vent_spawn = {
	values = {
		interval = 20,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
return {
	--delay SWAT response
	[102675] = {
		on_executed = {
			{ id = 103225, delay = 20 }
		}
	},
	--diff 1, blow wall
	[104057] = disabled,
	[103279] = {
		on_executed = {
			{ id = 104066, delay = 5 }
		}
	},
	-- alert all civs on mask up and delay panic button SO
	[102518] = {
		on_executed = {
			{ id = 102540, delay = 10 }
		},
		func = function()
			for _, u_data in pairs(managers.enemy:all_civilians()) do
				u_data.unit:movement():set_cool(false)
			end
		end
	},
	-- enable flashlights when power is cut
	[103469] = {
		flashlight = true
	},
	[103470] = {
		flashlight = false
	},
	-- disable most reinforce points
	[103706] = disabled,
	[103707] = disabled,
	[103847] = disabled,
	-- spawn group delays
	[100407] = staircase_spawn,
	[100414] = exit_spawn,
	[100420] = exit_spawn,
	[103683] = vent_spawn,
	[103086] = vent_spawn,
	[103111] = vent_spawn,
	[101740] = vent_spawn,
	[103097] = vent_spawn,
	[103761] = vent_spawn,
	[103479] = vent_spawn,
	[103751] = vent_spawn,
	[103099] = vent_spawn,
	[103104] = vent_spawn,
	[103273] = vent_spawn,
	[100406] = vent_spawn,
	[103134] = vent_spawn,
	[103113] = vent_spawn,
}