local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_eclipse and is_pro_job

local diff_scaling = diff_i / 8
local hard_above = diff_i >= 3
local overkill_above = diff_i >= 5

local shield = scripted_enemy.shield
local cloaker = scripted_enemy.cloaker
local bulldozer = scripted_enemy.bulldozer_1

local vault_count = 4
local vault_ambush_chance = 0.5

local disabled = {
	values = {
		enabled = false,
	},
}

local vault_ambush_enemy = bulldozer

if math.random() < vault_ambush_chance then
	vault_ambush_enemy = scripted_enemy.elite_bulldozer_2
	vault_count = 2
end

local vault_ambush = {
	values = {
		enemy = vault_ambush_enemy,
	},
}

local bulldozer_spawn = {
	values = {
		enemy = bulldozer,
	},
}

local cloaker_spawn = {
	values = {
		enemy = cloaker,
	},
}

local elevator_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

local skylight_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}

local office_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

local vent_spawn = {
	values = {
		enabled = is_eclipse and true or false,
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

local windows_swat = {
	values = {
		enabled = false,
	},
}

return {
	-- new reinforce
	[101401] = {
		reinforce = {
			{
				name = "lobby",
				force = 3,
				position = Vector3(-1800, 25, 0),
			},
		},
	},
	[101544] = {
		reinforce = {
			{
				name = "matrix",
				force = 2,
				position = Vector3(1600, 1250, 0),
			},
		},
	},
	-- disable forced manager flee objective
	[100665] = disabled,
	-- disable the right vault path
	[105498] = disabled,
	-- nuke swat van
	[105921] = disabled,
	-- disable sniper spawns that I don't like
	[105826] = disabled,
	[101619] = disabled,
	--Let the cops finish their spawn anim before moving into SO spot
	[103720] = {
		on_executed = {
			{ id = 104029, delay = 2.75 },
		},
	},
	[103721] = {
		on_executed = {
			{ id = 104071, delay = 2.75 },
		},
	},
	[103722] = {
		on_executed = {
			{ id = 105734, delay = 2.75 },
		},
	},
	[103723] = {
		on_executed = {
			{ id = 105736, delay = 2.75 },
		},
	},
	[103724] = {
		on_executed = {
			{ id = 100226, delay = 2.75 },
		},
	},
	[103732] = {
		on_executed = {
			{ id = 100077, delay = 2.75 },
		},
	},
	[103737] = {
		on_executed = {
			{ id = 105732, delay = 2.75 },
		},
	},
	-- always force cloaker and taser to spawn like in PDTH
	[100875] = windows_swat,
	[102245] = windows_swat,
	[102271] = windows_swat,
	[102276] = windows_swat,
	-- replace SWAT with cloakers that spawn with taser to match with PDTH
	[100617] = cloaker_spawn,
	[100618] = cloaker_spawn,
	-- vault ambush
	[104132] = vault_ambush,
	[104170] = vault_ambush,
	[104131] = vault_ambush,
	[104169] = vault_ambush,
	[100763] = vault_ambush,
	[104000] = {
		chance = 15 * diff_i,
	},
	[100225] = {
		values = {
			amount = vault_count,
		},
	},
	[103999] = disabled,
	[103985] = disabled,
	[104049] = disabled,
	-- custom spawns
	-- add point of no return and spawn lobby ambushes
	[101660] = {
		ponr = {
			length = 150,
			player_mul = { 1.1, 0.9, 0.7, 0.5 },
		},
		on_executed = {
			{ id = 400000, delay = 0 },
			{ id = 400001, delay = 1 },
			{ id = 400002, delay = 2 },
			{ id = 400003, delay = 3 },
			{ id = 400004, delay = 4 },
			{ id = 400005, delay = 5 },
			{ id = 400006, delay = 6 },
			{ id = 400007, delay = 7 },
			{ id = 400027, delay = 8 },
			{ id = 400028, delay = 9 },
		},
	},
	-- two dozers spawn on e/pj when leaving vault
	-- also two hallway escape shields on ovk+ (chance) and guaranteed on e/pj
	[103705] = {
		on_executed = {
			{ id = 400050, delay = 15 },
			{ id = 400051, delay = 15 },
			{ id = 400015, delay = 15 },
			{ id = 400016, delay = 15 },
		},
	},
	-- spawn two extra dozers on eclipse as a 193+ throwback
	[100850] = {
		on_executed = {
			{ id = 400012, delay = 20 },
			{ id = 400013, delay = 20 },
			{ id = 101953, delay = 100 },
		},
	},
	-- make this Bo Dozer use custom set up AI_Hunt
	[105119] = {
		on_executed = {
			{ id = 400014, delay = 0 },
		},
	},
	-- one extra Bo Dozer
	[101953] = {
		on_executed = {
			{ id = 400011, delay = 1 },
		},
	},
	-- killing Bo The Manager results of spawning two angry dozers
	[100689] = {
		on_executed = {
			{ id = 100682, delay = 0 },
		},
	},
	-- 2 blockade shields in vault area
	[100635] = {
		on_executed = {
			{ id = 400023, delay = 0 },
			{ id = 400024, delay = 0 },
		},
	},
	-- rework the escape sequence scripted spawns
	-- remove spawning the standard spawnpoint group and instead spawn 3 tasers+1 heavy swat as a 145+ throwback on hard and above as chance based event (it's guaranteed to spawn on eclipse)
	-- spawn 2 dozers as a sudden spawn on E/PJ (50% chance)
	[103710] = {
		chance = 100,
		on_executed = {
			{ id = 101400, remove = true },
			{ id = 400017, delay = 0 },
			{ id = 400018, delay = 0 },
			{ id = 400019, delay = 0 },
			{ id = 400020, delay = 0 },
			{ id = 400021, delay = 1, delay_rand = 1 },
			{ id = 400022, delay = 1, delay_rand = 1 },
		},
	},
	-- disable a bunch of vanilla spawns i don't like
	[103595] = disabled,
	[102575] = disabled,
	[103578] = disabled,
	[103669] = disabled,
	-- replace them with cooler ambush
	[100589] = {
		on_executed = {
			{ id = 400031, delay = 0 },
			{ id = 400033, delay = 0 },
			{ id = 400034, delay = 0 },
			{ id = 400036, delay = 0 },
			{ id = 400038, delay = 0 },
			{ id = 400040, delay = 0 },
			{ id = 400042, delay = 0 },
			{ id = 400043, delay = 0 },
			{ id = 400044, delay = 0 },
			{ id = 400045, delay = 0 },
		},
	},
	-- make the rest of vanilla spawns turn into zeals on E/PJ
	-- 2 shields at the bottom of the staircase
	[103693] = {
		values = {
			enemy = shield,
		},
	},
	[103697] = bulldozer_spawn,
	-- door knock dozers
	[103162] = bulldozer_spawn,
	[103163] = bulldozer_spawn,
	[103198] = bulldozer_spawn,
	[103231] = bulldozer_spawn,
	-- ambush cloakers
	[103136] = cloaker_spawn,
	[103143] = cloaker_spawn,
	[103151] = cloaker_spawn,
	-- spawnpoint delays
	[102154] = elevator_spawn,
	[103109] = elevator_spawn,
	[103135] = elevator_spawn,
	[103129] = elevator_spawn,
	[103121] = elevator_spawn,
	[105112] = skylight_spawn,
	[106890] = skylight_spawn,
	[103953] = office_spawn,
	[103081] = office_spawn,
	[103011] = office_spawn,
	[103689] = office_spawn,
	[105200] = vent_spawn,
}
