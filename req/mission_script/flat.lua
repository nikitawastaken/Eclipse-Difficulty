	-- more ASS edits

return {
	-- more oppressive open door amounts
	[103455] = {
		values = {
			amount = 0,
			amount_random = 2,
		},
	},
	[103490] = {
		values = {
			amount_random = 0,
		},
	},
	[103618] = {
		values = {
			amount = 0,
			amount_random = 3,
		},
	},
	-- Disable roof/stairs reinforcement
	[102501] = {
		values = {
			enabled = false
		}
	},
	[103181] = {
		values = {
			enabled = false
		}
	},
	-- re-allow sniper respawns
	[104556] = {
		values = {
			enabled = false,
		},
	},
	-- reenable far sniper
	[101521] = {
		values = {
			enabled = true
		}
	},
	[101599] = {
		values = {
			trigger_times = 0,
			enabled = true
		}
	},
	[103143] = {
		values = {
			trigger_times = 0,
		},
	},
	[103134] = {
		values = {
			trigger_times = 0,
		},
	},
	[103137] = {
		values = {
			trigger_times = 0,
		},
	},
	[103130] = {
		values = {
			trigger_times = 0,
		},
	},
	[103126] = {
		values = {
			trigger_times = 0,
		},
	},
	[102833] = {
		values = {
			trigger_times = 0,
		},
	},
	[101801] = {
		values = {
			trigger_times = 0,
		},
	},
	[102614] = {
		values = {
			trigger_times = 0,
		},
	},
	[102612] = {
		values = {
			trigger_times = 0,
		},
	},
	[103148] = {
		values = {
			trigger_times = 0,
		},
	},
	[103168] = {
		values = {
			trigger_times = 0,
		},
	},
	[100793] = {
		values = {
			trigger_times = 0,
		},
	},
	[100645] = {
		values = {
			trigger_times = 0,
		},
	},
	[103111] = {
		values = {
			trigger_times = 0,
		},
	},
	[100693] = {
		values = {
			trigger_times = 0,
		},
	},
	-- slow down roof spawns, these are really fuckng annoying
	[104650] = {
		values = {
			interval = 40,
		},
	},
	[100504] = {
		values = {
			interval = 40,
		},
	},
	[100505] = {
		values = {
			interval = 40,
		},
	},
	[100509] = {
		values = {
			interval = 40,
		},
	},
	[100396] = {
		values = {
			interval = 40,
		},
	},
	-- disable panic room reenforce (sh disables the other two points, and this heist doesnt really need it)
	[103348] = {
		values = {
			enabled = false,
		},
	},
	-- ambush line fix ?  hasnt been working for me since forever
	[100501] = {
		values = {
			use_play_func = true,
		},
	},
	-- reduce delay on mask up when ambushed (this triggers loud)
	[102329] = {
		on_executed = {
			{ id = 102332, delay = 1.5, },
		},
	},
	-- reenable alleyway drop
	[102261] = {
		values = {
			on_executed = {
				{delay = 0, id = 101591},
				{delay = 0, id = 101573},
				{delay = 0, id = 100350}
			}
		}
	},
	-- add point of no return
	[101016] = {
	ponr = 180
	}
}
