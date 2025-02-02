local normal, hard, eclipse = Eclipse.utils.diff_groups()
local disabled = {
	values = {
        enabled = false
	}
}
local snipers_amount = {
	values = {
		amount = normal and 2 or hard and 3 or 4
	}
}
local garage_door_spawn = {
	values = {
		interval = 10,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
	},
}
local flank_spawn1 = {
	values = {
		interval = 15,
	}
}
local flank_spawn2 = {
	values = {
		interval = 20,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
	},
}
local container_spawn = {
	values = {
		interval = 25,
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
return {
	[101061] = {
		ponr = {
			length = 200,
			player_mul = { 1.5, 1.25, 1, 1 }
		}
	},
	[103218] = disabled,
	-- Slightly slower difficulty ramp up
	[101357] = {
		values = {
			difficulty = 0.6
		}
	},
	--spawn murkies at the start of 1 assault
	--spawn scripted dozer after some time
	[103477] = {
		on_executed = { 
			{ id = 400046, delay = 5 },
			{ id = 400054, delay = 30 }
		}
	},
	--stop spawning murkies after the end of 1st assault
	[102158] = {
		on_executed = { 
			{ id = 400056, delay = 0 }
		}
	},
	--PDTH styled ambushes
	[102524] = {
		on_executed = {
		--be gone
			{ id = 102442, remove = true },
		--trigger ambushes
			{ id = 400052, delay = 0 },
			{ id = 400053, delay = 0 },
			{ id = 400054, delay = 0 },
			{ id = 400055, delay = 0 }
		}
	},
	[102505] = {
		values = {
			elements = {
				400004,
				400005,
				400006
			}
		}
	},
	[102506] = { 
		values = {
			elements = {
				400001,
				400002,
				400003
			}
		}
	},
	[102511] = {
		values = {
			elements = {
				400007,
				400008,
				400009
			}
		}
	},
	[102512] = { 
		values = {
			elements = {
				400010,
				400011,
				400012
			}
		}
	},
	--disable the slaughterhouse dozer and enable 2nd one nearby container area when the drill is finished
	[105117] = {
		on_executed = { 
			{ id = 400055, delay = 90 },
			{ id = 400045, delay = 0 }
		}
	},
	--enable van spawngroup if the 2nd van arrived
	[101656] = {
		on_executed = { 
			{ id = 400027, delay = 10 }
		}
	},
	--Force 2 SWAT vans to spawn regardless of difficulty
	[101808] = disabled,
	[101807] = disabled,
	[102696] = disabled,
	[102697] = {
		values = {
			difficulty_normal = "true",
			difficulty_hard = "true"
		}
	},
	--limit scripted van dozers to 2 (just in case if it might spawn like 4 or 5 dozers)
	[101576] = {
		values = {
            trigger_times = 2
		}
	},
	[101636] = {
		values = {
            trigger_times = 2
		}
	},
	--the camping spot from PDTH is more likely to be blocked on higher difficulties
	[103194] = {
		values = {
			chance = normal and 25 or hard and 50 or 75
		}
	},
	[103378] = disabled,
	[103382] = disabled,
	-- nerf sniper spawns
	[101921] = snipers_chance,
	[101956] = snipers_chance,
	[101213] = snipers_amount,
	[101217] = snipers_amount,
	[101219] = snipers_amount,
	[101222] = snipers_amount,
	[101224] = snipers_amount,
	-- spawngroup intervals
	[101528] = garage_door_spawn,
	[101523] = garage_door_spawn,
	[101476] = garage_door_spawn,
	[102843] = flank_spawn1,
	[101735] = flank_spawn1,
	[102832] = flank_spawn1,
	[102836] = flank_spawn1,
	[102198] = flank_spawn1,
	[101501] = flank_spawn2,
	[101763] = container_spawn,
	[101713] = container_spawn,
	[104794] = container_spawn,
	[104935] = container_spawn,
	[102013] = container_spawn,
	[101533] = container_spawn,
	[101301] = {
		values = {
			interval = 30
		}	
	}
}
