---@module Green Bridge
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job

local shield = scripted_enemy.shield
local sniper = scripted_enemy.sniper
local cloaker = scripted_enemy.cloaker
local swat = scripted_enemy.swat_1
local elite_shield = scripted_enemy.elite_shield
local taser = scripted_enemy.taser_1
local bulldozer = scripted_enemy.bulldozer_1

local diff_scaling = diff_i / 8

local enabled_chance_taser_and_shields = math.random() <= diff_scaling
local enabled_chance_dozer = math.random() <= diff_scaling
local enabled_chance_dozer_scaffold = math.random() <= diff_scaling
local enabled_chance_shield_scaffold = math.random() <= diff_scaling

local optsBulldozer = {
	enemy = bulldozer,
	enabled = overkill_and_above and enabled_chance_dozer,
}
local optsBulldozer_scaffold = {
	enemy = bulldozer,
	enabled = is_eclipse and enabled_chance_dozer_scaffold,
}
local optsShield_1 = {
	enemy = is_eclipse_pro and elite_shield or shield,
	on_executed = {
		{ id = 400009, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_taser_and_shields,
}
local optsShield_2 = {
	enemy = is_eclipse_pro and elite_shield or shield,
	on_executed = {
		{ id = 400010, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_taser_and_shields,
}
local optsShield_scaff_1 = {
	enemy = is_eclipse_pro and elite_shield or shield,
	on_executed = {
		{ id = 400012, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_shield_scaffold,
}
local optsShield_scaff_2 = {
	enemy = is_eclipse_pro and elite_shield or shield,
	on_executed = {
		{ id = 400013, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_shield_scaffold,
}
local optsTaser = {
	enemy = taser,
	on_executed = {
		{ id = 400011, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_taser_and_shields,
}
local optsSWAT_1 = {
	enemy = swat,
	spawn_action = "e_sp_crh_to_std_rifle",
	on_executed = {
		{ id = 400023, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_2 = {
	enemy = swat,
	spawn_action = "e_sp_crh_to_std_rifle",
	on_executed = {
		{ id = 400024, delay = 0 },
	},
	enabled = true,
}
local optsSniper_1 = {
	enemy = sniper,
	spawn_action = "e_sp_crh_to_std_rifle",
	on_executed = {
		{ id = 400021, delay = 0 },
	},
	enabled = true,
}
local optsSniper_2 = {
	enemy = sniper,
	spawn_action = "e_sp_crh_to_std_rifle",
	on_executed = {
		{ id = 400022, delay = 0 },
	},
	enabled = true,
}
local optsCloaker = {
	enemy = cloaker,
	spawn_action = "e_sp_climb_up_11m_down_0_7m",
	participate_to_group_ai = true,
	enabled = true,
}
local optsDefend_and_Sniper_SO = {
	SO_access = tostring(128 + 512 + 2048 + 8192),
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsrespawn_scaffold_spawn = {
	on_executed = {
		{ id = 400027, delay = 50, delay_rand = 10 },
	},
	elements = {
		101320,
		400026,
	},
	event = "death",
}
local optsspawnSWATs = {
	on_executed = { { id = 400017, delay = 0 }, { id = 400018, delay = 0 }, { id = 400019, delay = 0 }, { id = 400020, delay = 0 } },
	enabled = true,
}
local spawn_random_cloaker_dozer = {
	amount = 1,
	on_executed = {
		{ id = 101320, delay = 0 },
		{ id = 400026, delay = 0 },
	},
}

M.elements = {
	--spawns near the escape (Similiar to PDTH)
	Eclipse.mission_elements.gen_dummy(400001, "dozer_stairs", Vector3(-3129, -48029, 5030.316), Rotation(90, -0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400002, "shield_stairs_1", Vector3(-2520.983, -47546.961, 5370.570), Rotation(-87, -0, -0), optsShield_1),
	Eclipse.mission_elements.gen_dummy(400003, "shield_stairs_2", Vector3(-2524.437, -47481.051, 5372.570), Rotation(-87, -0, -0), optsShield_2),
	Eclipse.mission_elements.gen_dummy(400004, "taser_stairs", Vector3(-2994, -47502, 5225.499), Rotation(-90, -0, -0), optsTaser),

	--scaffolding spawns
	Eclipse.mission_elements.gen_dummy(400005, "shield_scaffolding_1", Vector3(-4100, -22849, 7115.008), Rotation(0, -0, -0), optsShield_scaff_1),
	Eclipse.mission_elements.gen_dummy(400006, "shield_scaffolding_2", Vector3(-2781.016, -23341.270, 7115.008), Rotation(90, -0, -0), optsShield_scaff_2),
	Eclipse.mission_elements.gen_dummy(400007, "dozer_scaffolding_1", Vector3(-3102, -23325, 6519.008), Rotation(90, -0, -0), optsBulldozer_scaffold),
	Eclipse.mission_elements.gen_dummy(400008, "dozer_scaffolding_2", Vector3(-3580, -22030, 6519.008), Rotation(90, -0, -0), optsBulldozer_scaffold),
	Eclipse.mission_elements.gen_so(400009, "shield_blockade_so_1", Vector3(-2520.983, -47546.961, 5370.570), Rotation(-87, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400010, "shield_blockade_so_2", Vector3(-2524.437, -47481.051, 5372.570), Rotation(-87, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400011, "taser_blockade_so_1", Vector3(-2994, -47502, 5225.499), Rotation(-90, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400012, "shield_scaffold_blockade_so_1", Vector3(-4100, -22849, 7115.008), Rotation(0, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400013, "shield_scaffold_blockade_so_2", Vector3(-2781.016, -23341.270, 7115.008), Rotation(90, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_dummytrigger(400014, "respawn_bulldozer", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_dozer),
	Eclipse.mission_elements.gen_spawngroup(400015, "construct_enemy_group_011", { 101146, 101147, 101148, 101149, 101150 }, 15),
	Eclipse.mission_elements.gen_spawngroup(400016, "construct_enemy_group_012", { 101115, 101114, 101121, 101123, 101127 }, 15),
	Eclipse.mission_elements.gen_dummy(400017, "sniper_scaffolding_1", Vector3(558, -22816, 6998.516), Rotation(0, 0, 0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400018, "sniper_scaffolding_2", Vector3(558, -22863, 6998.516), Rotation(0, 0, 0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400019, "swat_scaffolding_1", Vector3(558, -22720, 6998.516), Rotation(-180, 0, 0), optsSWAT_1),
	Eclipse.mission_elements.gen_dummy(400020, "swat_scaffolding_2", Vector3(558, -22664, 6998.516), Rotation(-180, 0, 0), optsSWAT_2),
	Eclipse.mission_elements.gen_so(400021, "sniper_so_1", Vector3(-42, -22833, 6998.516), Rotation(90, 0, 0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400022, "sniper_so_2", Vector3(-42, -22269, 6998.516), Rotation(90, 0, 0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400023, "swat_so_1", Vector3(-42, -22633, 6998.516), Rotation(90, 0, 0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400024, "swat_so_2", Vector3(-42, -22419, 6998.516), Rotation(90, 0, 0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_missionscript(400025, "spawn_swats", optsspawnSWATs),

	Eclipse.mission_elements.gen_dummy(400026, "spooc_scaffolding", Vector3(1285, -22260, 7757.596), Rotation(0, 0, 0), optsCloaker),
	Eclipse.mission_elements.gen_element_random(400027, "random_scaffolding_special", spawn_random_cloaker_dozer),
}

return M
