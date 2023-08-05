return {
	-- Disable instant difficulty increase
	[100122] = {
		values = {
			enabled = false
		}
	},
	-- Loud, slightly delay police response
	[100109] = {
		values = {
			base_delay = 30
		}
	},
	[100129] = {
		difficulty = 0.4,
		reinforce = {
			{
				name = "auction_room",
				force = 2,
				position = Vector3(0, 2000, -100)
			},
			{
				name = "outside",
				force = 2,
				position = Vector3(0, -3300, -50)
			}
		},
		on_executed = {
			{ id = 100127, delay = 0 },
			{ id = 103905, delay = 0 },
			{ id = 103910, delay = 0 },
			{ id = 103912, delay = 0 },
			{ id = 103913, delay = 0 }
		}
	},
	-- Disable area report triggers
	[100140] = {
		values = {
			enabled = false
		}
	},
	[106783] = {
		values = {
			enabled = false
		}
	},
	[103926] = {
		values = {
			enabled = false
		}
	},
	[106784] = {
		values = {
			enabled = false
		}
	},
	-- Slow down roof spawns
	[102667] = {
		values = {
			interval = 20
		}
	},
	[106776] = {
		values = {
			interval = 20
		}
	},
	[106767] = {
		values = {
			interval = 20
		}
	},
	[106764] = {
		values = {
			interval = 20
		}
	},
	[100694] = {
		values = {
			interval = 30
		}
	},
	[100154] = {
		values = {
			interval = 30
		}
	},
	-- Slow down storage spawns
	[102303] = {
		values = {
			interval = 40
		}
	},
	[103662] = {
		values = {
			interval = 20
		}
	},
	[104089] = {
		values = {
			interval = 40
		}
	},
	-- Slow down and adjust storage window spawns
	[103522] = {
		values = {
			interval = 60
		},
		groups = {
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false,
			tac_bull_rush = false
		}
	},
	[101175] = {
		values = {
			enabled = false
		}
	},
	[101177] = {
		set_ponr_state = true
	}
}