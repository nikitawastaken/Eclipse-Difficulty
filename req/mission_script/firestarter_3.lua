local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local random_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local heli_dozer = random_dozers
local player_1 = {
	values = {
		player_1 = true,
	},
}
local tear_gas_amount = {
	values = {
		amount = 1,
		amount_random = normal and 1 or hard and 2 or 3,
	},
}
local gate_chance = {
	chance = normal and 25 or hard and 50 or 75,
}
local initial_reinforce = {
	on_executed = {
		{ id = 100364, delay = 0 },
	},
}
local initial_reinforce_amount = {
	values = {
		amount = 3,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local extra_cop_car_chance = diff_i_no_easy * 0.25
local cop_car_amount = {
	values = {
		amount = 1,
	},
	func = function(self)
		if math.random() < extra_cop_car_chance then
			self._values.amount = (self._values.amount or 0) + 1
		end
	end,
}
local sniper_amount = {
	values = {
		amount = 1 + (is_pro_job and 1 or 0),
		amount_random = normal and 0 or hard and 1 or 2,
	},
}
local swat_vans_amount = eclipse and 2 or 1
local ambush_chance = (is_pro_job and 1.5 or 1) * diff_i_no_easy * 15
local street_spawn = {
	values = {
		interval = 15,
	},
}
local parking_lot_spawn = {
	values = {
		interval = 15,
	},
}
local cloaker_spawn = {
	values = {
		interval = 180,
	},
}
return {
	[101559] = {
		ponr = {
			length = 240,
			player_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	-- DW Trailer Skulldozer spawn event
	-- disable the dozer during startup
	[100004] = {
		on_executed = {
			{ id = 400004, delay = 3 },
			{ id = 400072, delay = 2 }, -- vault ambush for fs day 3
		},
	},
	-- enable the dozer when things go loud
	[100568] = {
		on_executed = {
			{ id = 400003, delay = 0 },
		},
	},
	-- spawn him when the far van escape gets triggered on Eclipse (DW Trailer throwback)
	[104452] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	-- trigger the ambush when the vault opens
	-- left
	[100311] = {
		on_executed = {
			{ id = 400055, delay = 0 },
		},
	},
	-- right
	[102160] = {
		on_executed = {
			{ id = 400056, delay = 0 },
		},
	},
	-- trigger cops loot drop off on alarm
	[102133] = {
		on_executed = {
			{ id = 102206, delay = 0 },
			{ id = 400068, delay = 0 }, -- enable the ambush
		},
	},
	-- randomize heli dozers
	[101785] = { enemy = heli_dozer },
	[101786] = { enemy = heli_dozer },
	-- special ambush chance increase
	[103072] = {
		chance = ambush_chance,
	},
	[105563] = player_1,
	[105574] = player_1,
	[105588] = player_1,
	-- restore unused cloaker ambush spawns
	[105571] = enabled,
	[105584] = enabled,
	[105607] = enabled,
	-- restore unused ambush event
	[105586] = {
		values = {
			width = 2000,
			depth = 3000,
		},
	},
	-- disable shield
	[105608] = disabled,
	-- tweak swat vans
	[104738] = {
		on_executed = {
			{ id = 102206, remove = true }, -- why it enables loot drop off for cops here?
			{ id = 104733, remove = true },
			{ id = 400010, delay = 0 },
		},
	},
	[104739] = {
		on_executed = {
			{ id = 105214, remove = true },
			{ id = 400017, delay = 0 },
		},
	},
	-- make the swat vans trigger instantly
	[104735] = {
		on_executed = {
			{ id = 104736, delay = 0 },
		},
	},
	[105660] = {
		on_executed = {
			{ id = 104737, delay = 0 },
		},
	},
	[105655] = disabled,
	[105659] = disabled,
	-- allow swat vans on all difficulties
	[103540] = {
		on_executed = {
			{ id = 104734, delay = 0 },
			{ id = 105648, remove = true },
		},
	},
	-- trigger on end assault
	[101304] = {
		on_executed = {
			{ id = 103540, delay = 10 },
		},
	},
	-- add 3 new heli events to the elementrandom script
	-- 2 events on eclipse
	[104734] = {
		values = {
			amount = swat_vans_amount,
		},
		on_executed = {
			{ id = 400025, delay = 0, delay_rand = 10 },
			{ id = 400031, delay = 0, delay_rand = 10 },
			{ id = 400037, delay = 0, delay_rand = 10 },
		},
	},
	-- disable the dozer chopper event if the heli1 gas event has been triggered
	[101424] = {
		on_executed = {
			{ id = 400074, delay = 0 },
		},
	},
	-- enable the dozer chopper after heli1 gas event finishes deploying units
	[101428] = {
		on_executed = {
			{ id = 400073, delay = 0 },
		},
	},
	-- Delay initial diff
	[100251] = {
		on_executed = {
			{ id = 100438, delay = 30 },
		},
	},
	-- make the SWAT events happen earlier
	[100438] = {
		on_executed = {
			{ id = 103540, delay = 0 },
		},
	},
	-- enable spawns sooner
	[103882] = {
		on_executed = {
			{ id = 100251, delay = 30 },
			{ id = 105774, delay = 20 },
		},
	},
	-- tweak how enemies from gas chopper work
	-- first disable the spawn script that makes them come to gas SO spot
	[101436] = disabled,
	-- make so heavies deploy the tear gas on difficulties lower than eclipse, otherwise it's the elite dozer
	-- heavies
	[101433] = {
		on_executed = {
			{ id = 102296, delay = 0, remove = eclipse and true or nil },
		},
	},
	[105620] = {
		on_executed = {
			{ id = 102296, delay = 0, remove = eclipse and true or nil },
		},
	},
	-- dozers
	[101785] = {
		on_executed = {
			{ id = 102296, delay = 0 },
		},
	},
	[101786] = {
		on_executed = {
			{ id = 102296, delay = 0 },
		},
	},
	-- random plank amounts
	[105129] = {
		values = {
			amount = 4,
			amount_random = 6,
		},
	},
	--skylight chance
	[104324] = {
		chance = eclipse and 100 or 50,
	},
	[101930] = {
		values = {
			difficulty_easy_wish = false,
		},
	},
	[101934] = {
		values = {
			difficulty_easy_wish = true,
		},
	},
	-- police car amount
	[103879] = cop_car_amount,
	-- sniper amount
	[101200] = sniper_amount,
	-- vault gate chance
	[100195] = gate_chance,
	[100196] = gate_chance,
	-- enable all street initial_reinforce spots when first responders arrive, increase the amount of enemies for initial_reinforce points
	[104727] = initial_reinforce,
	[104728] = initial_reinforce,
	[104729] = initial_reinforce,
	[104730] = initial_reinforce,
	[100369] = initial_reinforce_amount,
	[102091] = initial_reinforce_amount,
	[100370] = initial_reinforce_amount,
	-- disable drill and escape reinforce (it's done automatically now)
	[101125] = disabled,
	[101126] = disabled,
	[105331] = disabled,
	-- Spawn group intervals
	[100246] = street_spawn,
	[100249] = street_spawn,
	[100250] = street_spawn,
	[101211] = parking_lot_spawn,
	[103742] = cloaker_spawn,
	[102914] = cloaker_spawn,
	[102917] = cloaker_spawn,
	[102922] = cloaker_spawn,
	[103458] = cloaker_spawn,
	[103460] = cloaker_spawn,
	[103487] = cloaker_spawn,
	[103498] = cloaker_spawn,
	[103518] = cloaker_spawn,
	[103520] = cloaker_spawn,
	[103525] = cloaker_spawn,
	[103550] = cloaker_spawn,
	[103562] = cloaker_spawn,
}
