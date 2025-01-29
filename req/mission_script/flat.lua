-- more ASS edits
-- also resmod stuff
local enabled_blocked_roof_access = math.random() < 0.45
local enabled = {
	values = {
        enabled = true
	}
}
local disabled = {
	values = {
        enabled = false
	}
}
local retrigger = {
	values = {
		trigger_times = 0
	},
}
local roof_spawn = {
	values = {
		interval = 40
	}
}
return {
	-- add point of no return
	[101016] = {
		ponr = {
			length = 180,
			player_mul = { 1.33, 1.167, 1, 1 },
		}
	},
	--Restore roof access blockade
	[100095] = {
		on_executed = {
			{ id = 100569, remove = true },
			{ id = 400064, delay = 0 }
		}
	},
	[100297] = {
		values = {
			enabled = enabled_blocked_roof_access
		},
		on_executed = {
			{id = 103611, delay = 0},
			{id = 400065, delay = 0}
		}
	},
	[100569] = enabled,
	[103610] = enabled,
	[103611] = enabled,
	[103648] = {
		on_executed = {
			{ id = 103611, remove = true }
		}
	},
	--stop with the smoke bombs, jeez....
	[103034] = disabled,
	[103106] = disabled,
	--Disable cloaker spawns on startup
	[102263] = {
		on_executed = {
			{ id = 400039, delay = 3 }
		}
	},
	--Add missing navlinks
	[103247] = {
		on_executed = {
			{ id = 102468, delay = 0 },
			{ id = 104179, delay = 0 },
			{ id = 102455, delay = 0 },
			{ id = 104720, delay = 0 },
			{ id = 102454, delay = 0 },
			{ id = 104721, delay = 0 },
			{ id = 102453, delay = 0 },
			{ id = 104341, delay = 0 },
			{ id = 104338, delay = 0 },
			{ id = 104342, delay = 0 },
			{ id = 104343, delay = 0 },
			{ id = 103402, delay = 0 },
			{ id = 103888, delay = 0 },
			{ id = 103890, delay = 0 },
			{ id = 102377, delay = 0 },
			{ id = 104709, delay = 0 },
			{ id = 102399, delay = 0 },
			{ id = 104708, delay = 0 },
			{ id = 102401, delay = 0 },
			{ id = 104707, delay = 0 }
		}
	},
	--Trigger event spawns after each start of the assault wave
	[104656] = {
		on_executed = {
			{ id = 400015, delay = 30 },
			{ id = 400020, delay = 60 },
			{ id = 400037, delay = 75 }
		}
	},
	--Spawn Shields after placing the last c4
	[101787] = {
		on_executed = {
			{ id = 400043, delay = 0}
		}
	},
	--Spawn Rooftop Heavy SWATs after killing all of the snipers
	--Enable Cloaker spawns
	[104573] = {
		on_executed = {
			{ id = 400025, delay = 15 },
			{ id = 400038, delay = 0 }
		}
	},
	--Change chopper squad
	[101658] = {
		on_executed = {
			{ id = 104561, remove = true },
			{ id = 400032, delay = 17 }
		}
	},
	--Trigger dozer spawn
	[104706] = {
		on_executed = {
			{ id = 400040, delay = 0 },
			{ id = 400042, delay = 0 }
		}
	},
	--Cops now spawn when you open the red door rather than when killing Chavez (like in PDTH)
	[101853] = {
		on_executed = {
			{ id = 104691, remove = true}
		}
	},
	--Spawn Heavy SWAT squad if it's overkill above
	[102680] = {
		on_executed = {
			{ id = 104691, delay = 0},
			{ id = 400001, delay = 7.5}
		}
	},
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
	[102501] = disabled,
	[103181] = disabled,
	-- re-allow sniper respawns
	[104556] = disabled,
	-- reenable far sniper
	[101521] = enabled,
	[101599] = {
		values = {
			trigger_times = 0,
			enabled = true
		}
	},
	[103143] = retrigger,
	[103134] = retrigger,
	[103137] = retrigger,
	[103130] = retrigger,
	[103126] = retrigger,
	[102833] = retrigger,
	[101801] = retrigger,
	[102614] = retrigger,
	[102612] = retrigger,
	[103148] = retrigger,
	[103168] = retrigger,
	[100793] = retrigger,
	[100645] = retrigger,
	[103111] = retrigger,
	[100693] = retrigger,
	-- slow down roof spawns, these are really fuckng annoying
	[104650] = roof_spawn,
	[100504] = roof_spawn,
	[100505] = roof_spawn,
	[100509] = roof_spawn,
	[100396] = roof_spawn,
	-- disable panic room reenforce (sh disables the other two points, and this heist doesnt really need it)
	[103348] = disabled,
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
				{ delay = 0, id = 101591 },
				{ delay = 0, id = 101573 },
				{ delay = 0, id = 100350 }
			}
		}
	},
}
