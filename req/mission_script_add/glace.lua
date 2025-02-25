---@module Green Bridge
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job

local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield
local taser = scripted_enemy.taser
local bulldozer = scripted_enemy.bulldozer_1

local diff_scaling = diff_i / 8

local enabled_chance_taser_and_shields = math.random() < diff_scaling
local enabled_chance_dozer = math.random() < diff_scaling
local enabled_chance_dozer_scaffold = math.random() < diff_scaling
local enabled_chance_shield_scaffold = math.random() < diff_scaling

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
local optsDefend_and_Sniper_SO = {
	SO_access = tostring(2048 + 8192),
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsrespawn_dozer = {
	on_executed = {
		{ id = 101320, delay = 30, delay_rand = 10 },
	},
	elements = {
		101320,
	},
	event = "death",
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
	Eclipse.mission_elements.gen_spawngroup(400015, "construct_enemy_group_011", { 101146, 101147, 101148, 101149, 101150 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400016, "construct_enemy_group_012", { 101115, 101114, 101121, 101123, 101127 }, 0),
}

return M
