local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local construction_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
}
local bridge_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents,
}
local scripted_swat_wall_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- add FFO
	[100082] = {
		ponr = {
			length = 120,
			length_balance_mul = { 1.25, 1.25, 1, 1 },
		},
	},
	-- Disable hunt
	[101598] = disabled,
	-- Spawn some SWATs when the wall has been breached on Overkill and above
	[101224] = {
		on_executed = {
			{ id = 400013, delay = 0 },
		},
	},
	-- add additional snipers to escape section
	-- elementrandom
	[101642] = {
		on_executed = {
			{ id = 400016, delay = 0 },
			{ id = 400017, delay = 0 },
			{ id = 400018, delay = 0 },
		},
	},
	-- on death
	[101640] = {
		values = {
			elements = {
				101638,
				101639,
				400016,
				400017,
				400018,
			},
		},
	},
	-- change preffereds for scripted blown up wall group
	[400006] = scripted_swat_wall_spawn,
	[400012] = scripted_swat_wall_spawn,
	-- Spawn group intervals
	[101063] = construction_spawn,
	[100979] = construction_spawn,
	[100996] = construction_spawn,
	[100997] = construction_spawn,
	[100381] = bridge_spawn,
	[100532] = bridge_spawn,
	[100214] = bridge_spawn,
	[100228] = bridge_spawn,
	[100004] = bridge_spawn,
	[100005] = bridge_spawn,
	[100279] = bridge_spawn,
	[100280] = bridge_spawn,
	[100408] = bridge_spawn,
	[100409] = bridge_spawn,
	[100411] = bridge_spawn,
	[100412] = bridge_spawn,
	[100418] = bridge_spawn,
	[100434] = bridge_spawn,
	[100374] = bridge_spawn,
	[100225] = bridge_spawn,
	[100226] = bridge_spawn,
	[100467] = bridge_spawn,
	[100377] = bridge_spawn,
}
