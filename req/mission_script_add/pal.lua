local difficulty = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local sniper = (difficulty >= 5 and "units/payday2/characters/ene_sniper_2/ene_sniper_2") or "units/payday2/characters/ene_sniper_1/ene_sniper_1"
local eclipse = difficulty == 6
local overkill_above = difficulty >= 5

local optsSniper_1 = {
	enemy = sniper,
	on_executed = {
        { id = 100675, delay = 0 },
    },
    enabled = true
}
local optsSniper_2 = {
	enemy = sniper,
	on_executed = {
        { id = 400006, delay = 0 },
    },
    enabled = true
}
local optsSniper_3 = {
	enemy = sniper,
	on_executed = {
        { id = 400007, delay = 0 },
    },
    enabled = overkill_above
}
local optsSniper_4 = {
	enemy = sniper,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = {
        { id = 400008, delay = 2.5 },
    },
    enabled = overkill_above
}
local optsSniper_5 = {
	enemy = sniper,
	spawn_action = "e_sp_up_2_75_down_1_25m",
	on_executed = {
        { id = 400009, delay = 3 },
    },
    enabled = eclipse
}
local optsrespawn_sniper_1 = {
	on_executed = { 
		{ id = 400001, delay = 30 }
	},
	elements = { 
		400001
	},
    event = "death"
}
local optsrespawn_sniper_2 = {
	on_executed = { 
		{ id = 400002, delay = 30 }
	},
	elements = { 
		400002
	},
    event = "death"
}
local optsrespawn_sniper_3 = {
	on_executed = { 
		{ id = 400003, delay = 30 }
	},
	elements = { 
		400003
	},
    event = "death"
}
local optsrespawn_sniper_4 = {
	on_executed = { 
		{ id = 400004, delay = 30 }
	},
	elements = { 
		400004
	},
    event = "death"
}
local optsrespawn_sniper_5 = {
	on_executed = { 
		{ id = 400005, delay = 30 }
	},
	elements = { 
		400005
	},
    event = "death"
}
local optsSniper_SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
    so_action = "AI_sniper"
}
local disable_2nd_police_cruiser = {
	enabled = true,
	toggle = "off",
	elements = { 
		100704
	}
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
	can_not_be_muted = true
}

return {
    elements = {
        --Snipers
		restoration:gen_dummy(
            400001,
            "sniper_1",
            Vector3(4082, 2186, 120.142),
            Rotation(-180, 0, -0),
            optsSniper_1
        ),
		restoration:gen_dummy(
            400002,
            "sniper_2",
            Vector3(2978, -744, 126.059),
            Rotation(180, 0, -0),
            optsSniper_2
        ),
		restoration:gen_dummy(
            400003,
            "sniper_3",
            Vector3(-3153, 8429, 26.021),
            Rotation(90, -0, -0),
            optsSniper_3
        ),
		restoration:gen_dummy(
            400004,
            "sniper_4",
            Vector3(502, -3577, 29.736),
            Rotation(-167, 0, -0),
            optsSniper_4
        ),
		restoration:gen_dummy(
            400005,
            "sniper_5",
            Vector3(-8202, 1491, 25.860),
            Rotation(-90, 0, -0),
            optsSniper_5
        ),
		restoration:gen_so(
            400006,
            "sniper_spot_so_1",
            Vector3(-3192, 1184, 517.520),
            Rotation(0, 0, -0),
            optsSniper_SO
        ),
		restoration:gen_so(
            400007,
            "sniper_spot_so_2",
            Vector3(-3328, 3703, 445.786),
            Rotation(161, 0, -0),
            optsSniper_SO
        ),
		restoration:gen_so(
            400008,
            "sniper_spot_so_3",
            Vector3(-1797.890, 1042.875, 415.609),
            Rotation(46, -0, -0),
            optsSniper_SO
        ),
		restoration:gen_so(
            400009,
            "sniper_spot_so_4",
            Vector3(-4513, 384, 500.223),
            Rotation(0, 0, -0),
            optsSniper_SO
        ),
		restoration:gen_dummytrigger(
            400010,
            "respawn_sniper_1",
            Vector3(-2400, -3677, 375),
            Rotation(90, -0, -0),
            optsrespawn_sniper_1
        ),
		restoration:gen_dummytrigger(
            400011,
            "respawn_sniper_2",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_sniper_2
        ),
		restoration:gen_dummytrigger(
            400012,
            "respawn_sniper_3",
            Vector3(-2400, -3677, 375),
            Rotation(90, -0, -0),
            optsrespawn_sniper_3
        ),
		restoration:gen_dummytrigger(
            400013,
            "respawn_sniper_4",
            Vector3(-2400, -3577, 375),
            Rotation(90, -0, -0),
            optsrespawn_sniper_4
        ),
		restoration:gen_dummytrigger(
            400014,
            "respawn_sniper_5",
            Vector3(-2400, -3677, 375),
            Rotation(90, -0, -0),
            optsrespawn_sniper_5
        ),
		restoration:gen_toggleelement(
            400015,
            "disable_the_cruiser",
            disable_2nd_police_cruiser
        ),
		restoration:gen_dialogue(
            400016,
            "they_sending_snipers",
            Bain_sendsnipers
        )
    }
}