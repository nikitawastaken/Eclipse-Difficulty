local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()

local murkywater_1 = scripted_enemy.murkywater_1
local murkywater_2 = scripted_enemy.murkywater_2
local shield = scripted_enemy.shield
local taser = scripted_enemy.taser
local cloaker = scripted_enemy.cloaker
local bulldozer = scripted_enemy.bulldozer_1

local diff_scaling = diff_i / 8

local enabled_chance_cloakers = math.random() < diff_scaling
local enabled_chance_shields_and_tazer = math.random() < diff_scaling
local enabled_chance_shields_and_tazer_2 = math.random() < diff_scaling
local enabled_chance_shields_and_dozer = math.random() < diff_scaling

local spawn_cloakers = {
	enabled = hard_and_above and enabled_chance_cloakers,
	on_executed = { 
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 }
	}
}
local spawn_shields_and_taser_1 = {
	enabled = enabled_chance_shields_and_tazer,
	on_executed = { 
		{ id = 400004, delay = 0 },
		{ id = 400005, delay = 0 },
		{ id = 400006, delay = 0 }
	}
}
local spawn_shields_and_taser_2 = {
	enabled = enabled_chance_shields_and_tazer_2,
	on_executed = { 
		{ id = 400007, delay = 0 },
		{ id = 400008, delay = 0 },
		{ id = 400009, delay = 0 }
	}
}
local spawn_shields_and_dozer = {
	enabled = hard_and_above and enabled_chance_shields_and_dozer,
	on_executed = { 
		{ id = 400010, delay = 0 },
		{ id = 400011, delay = 0 },
		{ id = 400012, delay = 0 }
	}
}
local spawn_murkies = {
	enabled = true,
	trigger_times = 1,
	on_executed = { 
		{ id = 400028, delay = 0 },
		{ id = 400029, delay = 0 },
		{ id = 400030, delay = 0 },
		{ id = 400031, delay = 0 },
		{ id = 400032, delay = 8 },
		{ id = 400033, delay = 8 },
		{ id = 400034, delay = 8 },
		{ id = 400035, delay = 8 },
		{ id = 400036, delay = 16 },
		{ id = 400037, delay = 16 },
		{ id = 400038, delay = 16 },
		{ id = 400039, delay = 16 },
		{ id = 400058, delay = 24 },
		{ id = 400059, delay = 24 },
		{ id = 400060, delay = 24 },
		{ id = 400061, delay = 24 }
	}
}
local optsBesiegeDummy = {
    participate_to_group_ai = true,
    enabled = true,
    spawn_action = "e_sp_armored_truck_1st"
}
local optsCloaker = {
    enemy = cloaker,
	on_executed = { 
		{ id = 400057, delay = 3 }
	},
    enabled = true
}
local optsTaser = {
    enemy = taser,
	on_executed = { 
		{ id = 400057, delay = 3 }
	},
    enabled = true
}
local optsShield = {
    enemy = shield,
	on_executed = { 
		{ id = 400057, delay = 3 }
	},
    enabled = true
}
local optsBulldozer_Ambush = {
    enemy = bulldozer,
	on_executed = { 
		{ id = 400057, delay = 3 }
	},
    enabled = true
}
local spawn_dozer_1 = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400019, delay = 0 }
	}
}
local spawn_dozer_2 = {
	enabled = true,
	trigger_times = 1,
	on_executed = { 
		{ id = 400020, delay = 0 }
	}
}
local optsBulldozer = {
    enemy = bulldozer,
	on_executed = {
        { id = 400021, delay = 0 }
    },
    enabled = true
}
local optsBulldozer_SO = {
    SO_access = "4096",
	path_style = "none",
	scan = true,
	interval = 2,
    so_action = "AI_hunt"
}
local optsHunt_SO = {
    SO_access = tostring(1024+2048+4096+8192),
	path_style = "none",
	scan = true,
	interval = 2,
    so_action = "AI_hunt"
}
local optsMurky_SMG = {
    enemy = murkywater_1,
	participate_to_group_ai = true,
    enabled = true
}
local optsMurky_Rifle = {
    enemy = murkywater_2,
	participate_to_group_ai = true,
    enabled = true
}
local optsrespawn_murkies_1 = {
	on_executed = { 
		{ id = 400028, delay = 15 },
		{ id = 400029, delay = 15 },
		{ id = 400030, delay = 15 },
		{ id = 400031, delay = 15 }
	},
	elements = { 
		400028
	},
    event = "death"
}
local optsrespawn_murkies_2 = {
	on_executed = { 
		{ id = 400032, delay = 15 },
		{ id = 400033, delay = 15 },
		{ id = 400034, delay = 15 },
		{ id = 400035, delay = 15 }
	},
	elements = { 
		400032
	},
    event = "death"
}
local optsrespawn_murkies_3 = {
	on_executed = { 
		{ id = 400036, delay = 15 },
		{ id = 400037, delay = 15 },
		{ id = 400038, delay = 15 },
		{ id = 400039, delay = 15 }
	},
	elements = { 
		400036
	},
    event = "death"
}
local optsrespawn_murkies_4 = {
	on_executed = { 
		{ id = 400058, delay = 15 },
		{ id = 400059, delay = 15 },
		{ id = 400060, delay = 15 },
		{ id = 400061, delay = 15 }
	},
	elements = { 
		400058
	},
    event = "death"
}
local optsrespawn_dozer_1 = {
	on_executed = { 
		{ id = 400019, delay = 180 }
	},
	elements = { 
		400019
	},
    event = "death"
}
local optsrespawn_dozer_2 = {
	on_executed = { 
		{ id = 400020, delay = 180 }
	},
	elements = { 
		400020
	},
    event = "death"
}
local van_spawngroup  = {
	spawn_groups = {
		400026
	}
}
local disable_dozer = {
	enabled = true,
	toggle = "off",
	elements = { 
		400019
	}
}
local disable_murkies = {
	enabled = true,
	toggle = "off",
	elements = { 
		400040,
		400041,
		400042,
		400062
	}
}

return {
    elements = {
        --Ambush
        Eclipse.mission_elements.gen_dummy(
            400001,
            "cloaker_1",
            Vector3(-12545, 7176, 4.995),
            Rotation(-180, 0, -0),
            optsCloaker
        ),
        Eclipse.mission_elements.gen_dummy(
            400002,
            "cloaker_2",
            Vector3(-12458, 7282, 4.995),
            Rotation(-180, 0, -0),
            optsCloaker
        ),
		Eclipse.mission_elements.gen_dummy(
            400003,
            "cloaker_3",
            Vector3(-12607, 7282, 4.995),
            Rotation(-180, 0, -0),
            optsCloaker
        ),
		Eclipse.mission_elements.gen_dummy(
            400004,
            "shield_1",
            Vector3(-12073, 7142, 4.995),
            Rotation(-180, 0, -0),
            optsShield
        ),
        Eclipse.mission_elements.gen_dummy(
            400005,
            "shield_2",
            Vector3(-11981, 7142, 4.995),
            Rotation(-180, 0, -0),
            optsShield
        ),
		Eclipse.mission_elements.gen_dummy(
            400006,
            "taser_1",
            Vector3(-12023, 7209, 4.995),
            Rotation(-180, 0, -0),
            optsTaser
        ),
		Eclipse.mission_elements.gen_dummy(
            400007,
            "shield_3",
            Vector3(-13408, 7176, 4.995),
            Rotation(-180, 0, -0),
            optsShield
        ),
        Eclipse.mission_elements.gen_dummy(
            400008,
            "shield_4",
            Vector3(-13334, 7176, 4.995),
            Rotation(-180, 0, -0),
            optsShield
        ),
		Eclipse.mission_elements.gen_dummy(
            400009,
            "taser_2",
            Vector3(-13371, 7262, 4.995),
            Rotation(-180, 0, -0),
            optsTaser
        ),
		Eclipse.mission_elements.gen_dummy(
            400010,
            "shield_3",
            Vector3(-13666, 6195, 4.995),
            Rotation(0, 0, -0),
            optsShield
        ),
        Eclipse.mission_elements.gen_dummy(
            400011,
            "shield_4",
            Vector3(-13756, 6195, 4.995),
            Rotation(0, 0, -0),
            optsShield
        ),
		Eclipse.mission_elements.gen_dummy(
            400012,
            "bulldozer_1",
            Vector3(-13707, 6078, 4.995),
            Rotation(0, 0, -0),
            optsBulldozer_Ambush
        ),
		--Dozers
		Eclipse.mission_elements.gen_dummy(
            400019,
            "bulldozer_2",
            Vector3(-8785, 3730, -72),
            Rotation(-90, 0, -0),
            optsBulldozer
        ),
		Eclipse.mission_elements.gen_dummy(
            400020,
            "bulldozer_3",
            Vector3(-13231, 6749, 889.902),
            Rotation(90, 0, -0),
            optsBulldozer
        ),
		Eclipse.mission_elements.gen_so(
            400021,
            "dozer_hunt_so",
            Vector3(3600, 2473, -1200),
            Rotation(0, 0, 0),
            optsBulldozer_SO
        ),
		--Van Spawngroup
		Eclipse.mission_elements.gen_dummy(
            400022,
            "van_dummy_1",
            Vector3(-15438.496, 5177.672, -81.025),
            Rotation(170, 0, -0),
            optsBesiegeDummy
        ),
		Eclipse.mission_elements.gen_dummy(
            400023,
            "van_dummy_2",
            Vector3(-15371.752, 5177.833, -81.025),
            Rotation(172, 0, -0),
            optsBesiegeDummy
        ),
		Eclipse.mission_elements.gen_dummy(
            400024,
            "van_dummy_3",
            Vector3(-15495.743, 4220.271, -81.025),
            Rotation(-171, 0, -0),
            optsBesiegeDummy
        ),
		Eclipse.mission_elements.gen_dummy(
            400025,
            "van_dummy_4",
            Vector3(-15430.557, 4230.596, -81.025),
            Rotation(-171, 0, -0),
            optsBesiegeDummy
        ),
		Eclipse.mission_elements.gen_spawngroup(
			400026,
			"van_spawngroup",
			{400022, 400023, 400024, 400025},
			5
		),
		Eclipse.mission_elements.gen_preferedadd(
            400027,
            "spawn_the_van_spawngroup",
            van_spawngroup
        ),
		--Murkies & Respawns
		Eclipse.mission_elements.gen_dummy(
            400028,
            "murky_1",
            Vector3(-8611, 3648, -72),
            Rotation(-90, 0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummy(
            400029,
            "murky_2",
            Vector3(-8611, 3750, -72),
            Rotation(-90, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400030,
            "murky_3",
            Vector3(-8525, 3669, -72),
            Rotation(-90, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400031,
            "murky_4",
            Vector3(-8525, 3750, -72),
            Rotation(-90, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400032,
            "murky_5",
            Vector3(-7567, 7768, 898.834),
            Rotation(0, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400033,
            "murky_6",
            Vector3(-7653, 7768, 898.834),
            Rotation(0, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400034,
            "murky_7",
            Vector3(-7653, 7838, 898.834),
            Rotation(0, 0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummy(
            400035,
            "murky_8",
            Vector3(-7567, 7838, 898.834),
            Rotation(0, 0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummy(
            400036,
            "murky_9",
            Vector3(-6933, 9746, 9.261),
            Rotation(90, -0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400037,
            "murky_10",
            Vector3(-6933, 9666, 9.261),
            Rotation(90, -0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400038,
            "murky_11",
            Vector3(-7011, 9744, 9.261),
            Rotation(90, -0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummy(
            400039,
            "murky_12",
            Vector3(-7011, 9668, 9.261),
            Rotation(90, -0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummytrigger(
            400040,
            "respawn_murkies_1",
            Vector3(-2400, -3677, 375),
            Rotation(90, -0, -0),
            optsrespawn_murkies_1
        ),
		Eclipse.mission_elements.gen_dummytrigger(
            400041,
            "respawn_murkies_2",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_murkies_2
        ),
		Eclipse.mission_elements.gen_dummytrigger(
            400042,
            "respawn_murkies_3",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_murkies_3
        ),
		Eclipse.mission_elements.gen_dummytrigger(
            400043,
            "respawn_dozer_1",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_dozer_1
        ),
		Eclipse.mission_elements.gen_dummytrigger(
            400044,
            "respawn_dozer_2",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_dozer_2
        ),
		Eclipse.mission_elements.gen_toggleelement(
            400045,
            "disable_dozer",
            disable_dozer
        ),
		Eclipse.mission_elements.gen_missionscript(
            400046,
            "spawn_murkies",
            spawn_murkies
        ),
		Eclipse.mission_elements.gen_missionscript(
            400050,
            "spawn_cloakers",
            spawn_cloakers
        ),
		Eclipse.mission_elements.gen_missionscript(
            400051,
            "spawn_shields_and_taser_1",
            spawn_shields_and_taser_1
        ),
		Eclipse.mission_elements.gen_missionscript(
            400052,
            "spawn_shields_and_taser_2",
            spawn_shields_and_taser_2
        ),
		Eclipse.mission_elements.gen_missionscript(
            400053,
            "spawn_shields_and_dozer",
            spawn_shields_and_dozer
        ),
		Eclipse.mission_elements.gen_missionscript(
            400054,
            "spawn_dozer_1",
            spawn_dozer_1
        ),
		Eclipse.mission_elements.gen_missionscript(
            400055,
            "spawn_dozer_2",
            spawn_dozer_2
        ),
		Eclipse.mission_elements.gen_toggleelement(
            400056,
            "disable_murkies",
            disable_murkies
        ),
		Eclipse.mission_elements.gen_so(
            400057,
            "hunt_so",
            Vector3(3600, 2473, -1200),
            Rotation(0, 0, 0),
            optsHunt_SO
        ),
		Eclipse.mission_elements.gen_dummy(
            400058,
            "murky_13",
            Vector3(-11422.900, 5427.540, 282.287),
            Rotation(-30, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400059,
            "murky_14",
            Vector3(-11450.400, 5379.910, 282.287),
            Rotation(-30, 0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummy(
            400060,
            "murky_15",
            Vector3(-11472.900, 5340.940, 282.287),
            Rotation(-30, 0, -0),
            optsMurky_SMG
        ),
		Eclipse.mission_elements.gen_dummy(
            400061,
            "murky_16",
            Vector3(-11496.900, 5299.370, 282.287),
            Rotation(-30, 0, -0),
            optsMurky_Rifle
        ),
		Eclipse.mission_elements.gen_dummytrigger(
            400062,
            "respawn_murkies_4",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_murkies_4
        )
    }
}
