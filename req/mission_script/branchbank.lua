local preferred = Eclipse.preferred
local level_id = Eclipse.utils.level_id()
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
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
		amount = normal and 2 or hard and 3 or 4,
	},
}
local gate_chance = {
	values = {
		chance = normal and 25 or hard and 50 or 75,
	},
}
local reinforce = {
	on_executed = {
		{ id = 100364, delay = 0 },
	},
}
local reinforce_amount = {
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
local swat_vans_amount = eclipse and 2 or 1
local ambush_chance = (is_pro_job and 1.5 or 1) * (diff_i - 2) * 15
local street_spawn = {
	values = {
		interval = 15,
	},
}
local parking_lot_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields,
}
local cloaker_spawn = {
	values = {
		interval = 180,
	},
}
return {
	-- DW Trailer Skulldozer spawn event
	-- disable the dozer during startup
	[100004] = {
		on_executed = {
			{ id = 400004, delay = 3 },
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
	-- vault ambush for fs day 3
	[100004] = {
		on_executed = {
			{ id = 400072, delay = 2 },
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
	-- add 3 heli events to the elementrandom script
	-- 2 events on eclipse
	[104734] = {
		values = {
			amount = swat_vans_amount,
		},
		on_executed = {
			{ id = 400025, delay = 0 },
			{ id = 400031, delay = 0 },
			{ id = 400037, delay = 0 },
			-- these vans are exclusive to firestarter day 3
			{ id = 104735, remove = level_id ~= "firestarter_3" and true or false },
			{ id = 105660, remove = level_id ~= "firestarter_3" and true or false },
		},
	},
	-- make the SWAT events happen earlier if it's Firestater Day 3
	[100438] = {
		on_executed = {
			{ id = 103540, remove = level_id ~= "firestarter_3" and true or false },
		},
	},
	-- enable max diff after 2 instead of 3 assault waves
	[101307] = {
		values = {
			amount = 2,
		},
	},
	-- enable spawns sooner
	[103882] = {
		on_executed = {
			{ id = 100251, delay = 30 },
			{ id = 105774, delay = 20 },
			{ id = 400039, delay = level_id ~= "firestarter_3" and 40 or nil }, -- old swat vans spots restoration (only in bank heist)
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
		values = {
			chance = eclipse and 100 or 50,
		},
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
	[103879] = {
		values = {
			amount = normal and 1 or 2,
		},
	},
	-- sniper amount
	[101200] = {
		values = {
			amount = normal and 1 or hard and 2 or 3,
		},
	},
	-- vault gate chance
	[100195] = gate_chance,
	[100196] = gate_chance,
	-- enable all street reinforce spots when first responders arrive, increase the amount of enemies for reinforce points
	[104727] = reinforce,
	[104728] = reinforce,
	[104729] = reinforce,
	[104730] = reinforce,
	[100369] = reinforce_amount,
	[102091] = reinforce_amount,
	[100370] = reinforce_amount,
	-- Spawn group delays
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
