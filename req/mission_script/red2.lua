local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_eclipse and is_pro_job

local diff_scaling = diff_i / 8
local hard_above = diff_i >= 3
local overkill_above = diff_i >= 5

local security_guard_1 = scripted_enemy.security_1
local shield = is_eclipse_pro and scripted_enemy.elite_shield or scripted_enemy.shield
local cloaker = scripted_enemy.cloaker
local heavy_swat = scripted_enemy.heavy_swat_2
local taser = scripted_enemy.taser_1
local bulldozer = scripted_enemy.bulldozer_1
local bulldozer_2 = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local close_shutters_chance = (normal and 20 or hard and 40 or 60) + (is_pro_job and 20 or 0)
local basement_ambush_chance = (normal and 25 or hard and 45 or 65) + (is_pro_job and 10 or 0)
local basement_enemies_amount = 2
local random_dozers = {
	bulldozer,
	bulldozer_2,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}

local vault_count = 4
local vault_ambush_chance = 0.5

local disabled = {
	values = {
		enabled = false,
	},
}
local filter_overkill_above = {
	values = Eclipse.utils.set_diff_groups("overkill_above"),
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}

local vault_ambush_enemy = bulldozer

if math.random() < vault_ambush_chance then
	vault_ambush_enemy = scripted_enemy.elite_bulldozer_2
	vault_count = 2
end

local ambush_enemies = {
	values = {
		amount = 3 + (is_pro_job and 2 or 0),
		amount_random = 0,
	},
}
local bags_required = {
	values = {
		counter_target = is_eclipse and 6 or 4 + (is_pro_job and 2 or 0),
	},
}
local bags_required_objective = {
	values = {
		amount = is_eclipse and 6 or 4 + (is_pro_job and 2 or 0),
	},
}
local vault_ambush = {
	enemy = vault_ambush_enemy,
}
local bulldozer_spawn = {
	enemy = is_eclipse_pro and random_elite_dozers or diff_i > 3 and random_dozers or bulldozer,
}
local taser_cloaker = {
	enemy = cloaker,
}
local cloaker_escape = {
	enemy = normal and heavy_swat or cloaker,
}
local taser_spawn_1 = {
	enemy = taser,
	spawn_action = "e_sp_kick_enter",
	values = {
		position = Vector3(4819, -1821, -735),
	},
}
local taser_spawn_2 = {
	enemy = taser,
	spawn_action = "e_sp_kick_enter",
	values = {
		position = Vector3(5358, 588, -733),
	},
}
local mga_thermite_event = {
	post_mga_event = "mga_thermite",
}
local mga_vault_event = {
	post_mga_event = { "mga_vault_a", "mga_vault_b", "mga_vault_c" },
}
local elevator_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local skylight_spawn = {
	values = {
		interval = 30,
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
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local forced_off = {
	values = {
		forced = false,
	},
}
return {
	[100057] = {
		ponr = {
			length = 150,
			player_mul = { 1.1, 0.9, 0.7, 0.5 },
		},
	},
	-- Add new reinforce
	[100901] = { -- SWAT incoming
		reinforce = {
			{
				name = "lobby",
				force = 4,
				position = Vector3(-1800, 25, 0),
			},
		},
	},
	[103336] = { -- choose security footage location
		reinforce = {
			{
				name = "cafeteria",
				force = 3,
				position = Vector3(-2350, -2050, -20),
			},
			{
				name = "offices",
				force = 3,
				position = Vector3(-2750, 2050, -20),
			},
		},
	},
	-- disable a few vanilla reinforce spots
	[105905] = disabled, -- counting rooms
	[105910] = disabled, -- vault
	[105902] = disabled, -- left gate
	[105904] = disabled, -- right gate
	-- change the required amount of money bags
	[106692] = bags_required,
	[106946] = bags_required,
	[106947] = bags_required,
	[105019] = bags_required_objective,
	[103032] = bags_required_objective,
	[103033] = bags_required_objective,
	-- allow Overdrill
	[104182] = filter_overkill_above,
	-- allow Bo's dozers on all diffs
	[100682] = filter_easy_above,
	-- disable forced manager flee objective
	[100665] = disabled,
	-- nuke swat van
	[105921] = disabled,
	-- Edit the vault opening ambush
	[100569] = ambush_enemies,
	-- Edit preferreds to make the initial assault have less dense spawns
	[103984] = { -- assault start
		on_executed = {
			{ id = 100043, remove = true }, -- start more preferreds
		},
	},
	[100359] = { -- assault ended
		on_executed = {
			{ id = 100043, delay = 0, delay_rand = 30 }, -- start more preferreds
		},
	},
	--Let the cops finish their spawn anim before moving into SO spot
	[104029] = forced_off,
	[104071] = forced_off,
	[105734] = forced_off,
	[105736] = forced_off,
	[100226] = forced_off,
	[100077] = forced_off,
	[105732] = forced_off,
	-- disable special basement ambushes on startup
	[100326] = {
		on_executed = {
			{ id = 400083, delay = 3 },
		},
	},
	-- enable them on loud
	[101300] = {
		on_executed = {
			{ id = 400084, delay = 0 },
			{ id = 400085, delay = 0 },
		},
	},
	-- always force cloaker and taser to spawn like in PDTH
	[100875] = disabled,
	[102245] = disabled,
	[102271] = disabled,
	[102276] = disabled,
	-- replace SWAT with cloakers that spawn with taser to match with PDTH
	[100617] = taser_cloaker,
	[100618] = taser_cloaker,
	-- change some basement dozers to tasers like in PDTH
	[103163] = taser_spawn_1,
	[103198] = taser_spawn_2,
	-- remove cloakers from basement door suprise
	-- add 1 additonal enemy to random basement ambush
	[100529] = {
		values = {
			amount = basement_enemies_amount,
		},
		on_executed = {
			{ id = 103906, remove = true },
		},
	},
	-- make it trigger from unused area trigger and add chance
	[106042] = {
		on_executed = {
			{ id = 103914, delay = 0 },
		},
	},
	-- restore unused shield army script from pdth
	[105894] = disabled,
	[101544] = {
		on_executed = {
			{ id = 103998, remove = true },
		},
	},
	-- the van drives in when the player is in the vault
	[106547] = {
		on_executed = {
			{ id = 105914, delay = 90, delay_rand = 30 },
		},
	},
	-- lower the chance of swat van spawn and enable it only on ovk above
	[105914] = {
		chance = 40,
		values = {
			enabled = overkill_above,
		},
	},
	-- replace turret with the shield army script
	[105922] = {
		on_executed = {
			{ id = 105924, remove = true },
			{ id = 400059, delay = 0 },
		},
	},
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
	[101544] = {
		on_executed = {
			{ id = 103998, remove = true },
			{ id = 103377, remove = true },
			{ id = 104041, remove = true },
		},
	},
	-- tweak chances for closing shutters and basement ambush
	[102813] = {
		chance = close_shutters_chance,
	},
	[100528] = {
		chance = basement_ambush_chance,
	},
	-- add ambush to conference room
	-- guaranteed chance
	[103756] = {
		chance = 100,
		on_executed = {
			{ id = 400090, delay = 3 },
		},
	},
	-- custom spawns
	-- add spawn lobby ambushes when the gate is on the left side
	[101660] = {
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
			{ id = 105913, remove = true },
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
	-- MORE BANK GUARDS, HUH?! (Spawns extra blockade guards after opening the vault gates on loud)
	-- 2 blockade shields in vault area
	[100635] = {
		on_executed = {
			{ id = 400075, delay = 0 },
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
	-- replace shield on the left with cloaker (heavy swat on easy and normal)
	[103395] = cloaker_escape,
	-- make the rest of vanilla escape spawns turn into gensec on E/PJ
	-- 2 shields at the bottom of the staircase, replaced one shield with bulldozer
	[103693] = { enemy = shield },
	[103697] = bulldozer_spawn,
	-- door knock dozers
	[103162] = bulldozer_spawn,
	[103231] = bulldozer_spawn,
	-- why is there a beat cop instead of security guard in the vault???
	[104001] = { enemy = security_guard_1 },
	-- Play megaphone cop voice lines
	[103232] = mga_thermite_event,
	[101543] = mga_vault_event,
	-- Spawn group intervals
	[102154] = elevator_spawn,
	[103109] = elevator_spawn,
	[103135] = elevator_spawn,
	[103129] = elevator_spawn,
	[103121] = elevator_spawn,
	[105112] = skylight_spawn,
	[106890] = skylight_spawn,
	[103953] = office_spawn,
	[103068] = office_spawn,
	[103081] = office_spawn,
	[103011] = office_spawn,
	[103689] = office_spawn,
	[105200] = vent_spawn,
}
