local disabled = {
	values = {
		enabled = false
	}
}
local enabled = {
	values = {
		enabled = true
	}
}
local flank_spawn = {
	values = {
		interval = 20
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
return {
	-- 1st assault reinforce
	[100511] = {
		reinforce = {
			{
				name = "diff50_reinforce1",
				force = 2,
				position = Vector3(-1500, 800, 0),
			},
			{
				name = "diff50_reinforce2",
				force = 2,
				position = Vector3(-800, 3200, 0),
			},
		},
	},
	-- 2nd assault reinforce
	[103637] = {
		reinforce = {
			{
				name = "diff75_reinforce1",
				force = 2,
				position = Vector3(400, 1200, 0),
			},
			{
				name = "diff75_reinforce2",
				force = 2,
				position = Vector3(900, -800, 0),
			},
		},
	},
	-- spawn Ground Snipers after 3 minutes
	[100486] = {
		on_executed = {
			{ id = 400035, delay = 180 }
		}
	},
	-- spawn Snipers on the ships
	[102182] = {
		on_executed = {
			{ id = 400013, delay = 20 }
		}
	},
	[102388] = {
		on_executed = {
			{ id = 400014, delay = 20 }
		}
	},
	[102335] = {
		on_executed = {
			{ id = 400015, delay = 20 }
		}
	},
	-- disable some sketchy cheat sapwns
	[101007] = disabled,
	[100844] = disabled,
	[102387] = flank_spawn,
	[102331] = flank_spawn,
	[102173] = flank_spawn,
}