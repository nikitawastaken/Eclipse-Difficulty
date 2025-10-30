---@module Aftershock
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()

local enabled_chance_wall_cloaker = math.random() <= 0.4

local cloaker = scripted_enemy.cloaker
local sniper = scripted_enemy.sniper

local optsCloaker = {
	enemy = cloaker,
	participate_to_group_ai = true,
	enabled = enabled_chance_wall_cloaker,
	on_executed = {
		{ id = 400015, delay = 0 },
	},
}
local optsSniper_1 = {
	enemy = sniper,
	enabled = true,
	on_executed = {
		{ id = 400019, delay = 0 },
	},
}
local optsSniper_2 = {
	enemy = sniper,
	enabled = true,
	spawn_action = "e_sp_up_ledge",
	on_executed = {
		{ id = 400020, delay = 0 },
	},
}
local optsSniper_3 = {
	enemy = sniper,
	enabled = true,
	spawn_action = "e_sp_up_ledge",
	on_executed = {
		{ id = 400021, delay = 0 },
	},
}
local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
}
local optsBesiegeDummy_dizzy_1 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_dizzy_get_up",
}
local optsBesiegeDummy_dizzy_2 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_dizzy_stand",
}
local optsspawnwallSWATs = {
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400012, delay = 0 },
		{ id = 400014, delay = 0 },
	},
	enabled = overkill_and_above,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 5,
}
local optsHideSpoocSO = {
	SO_access = "1024",
	scan = true,
	needs_pos_rsrv = true,
	align_position = true,
	align_rotation = true,
	so_action = "e_so_idle_by_container",
}
local optsSniperSO = {
	scan = true,
	needs_pos_rsrv = true,
	align_position = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}


M.elements = {
	-- swat group 1 near the breached wall
	Eclipse.mission_elements.gen_dummy(400001, "swat_wall_spawn_1", Vector3(11589.867, 7975.423, 11.267), Rotation(145, 0, 0), optsBesiegeDummy_dizzy_1),
	Eclipse.mission_elements.gen_dummy(400002, "swat_wall_spawn_2", Vector3(11708.645, 7892.254, 11.267), Rotation(145, 0, 0), optsBesiegeDummy_dizzy_1),
	Eclipse.mission_elements.gen_dummy(400003, "swat_wall_spawn_3", Vector3(11797.932, 7829.734, 11.267), Rotation(145, 0, 0), optsBesiegeDummy_dizzy_1),
	Eclipse.mission_elements.gen_dummy(400004, "swat_wall_spawn_4", Vector3(11757.989, 8084.767, 11.267), Rotation(145, 0, 0), optsBesiegeDummy_dizzy_2),
	Eclipse.mission_elements.gen_dummy(400005, "swat_wall_spawn_5", Vector3(11954.427, 7976.519, 11.267), Rotation(145, 0, 0), optsBesiegeDummy_dizzy_2),
	Eclipse.mission_elements.gen_spawngroup(400006, "swat_group_1", { 400001, 400002, 400003, 400004, 400005 }, 0, opts_swat_group),
	-- swat group 2 near the breached wall
	Eclipse.mission_elements.gen_dummy(400007, "swat_wall_spawn_6", Vector3(12036.003, 8438.227, 11.267), Rotation(145, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "swat_wall_spawn_7", Vector3(11998.860, 8209.093, 11.267), Rotation(145, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "swat_wall_spawn_8", Vector3(12174.897, 8094.375, 11.267), Rotation(145, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "swat_wall_spawn_9", Vector3(12179.191, 8342.848, 11.267), Rotation(145, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "swat_wall_spawn_10", Vector3(12350.558, 8217.974, 11.267), Rotation(145, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400012, "swat_group_2", { 400007, 400008, 400009, 400010, 400011 }, 0, opts_swat_group),
	
	Eclipse.mission_elements.gen_missionscript(400013, "spawn_wall_swats", optsspawnwallSWATs),
	-- cloaker near the breached wall (40% chance to spawn)
	Eclipse.mission_elements.gen_dummy(400014, "spooc", Vector3(12547, 7718, 11.267), Rotation(90, 0, 0), optsCloaker),
	Eclipse.mission_elements.gen_so(400015, "spooc_hide_so", Vector3(12503, 7730, 11.267), Rotation(90, 0, 0), optsHideSpoocSO),
	-- new snipers spawns for the escape sequence
	Eclipse.mission_elements.gen_dummy(400016, "sniper_1", Vector3(15655.032, 8364.143, 28.784), Rotation(0, 0, 0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400017, "sniper_2", Vector3(12988, 10409, 339.274), Rotation(-137, 0, 0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400018, "sniper_3", Vector3(14093.412, 8040.106, 339.274), Rotation(44, 0, 0), optsSniper_3),
	Eclipse.mission_elements.gen_so(400019, "sniper_spot_so_1", Vector3(16368.941, 9536.400, 28.784), Rotation(95, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400020, "sniper_spot_so_2", Vector3(13172.806, 10416.908, 339.274), Rotation(-174, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400021, "sniper_spot_so_3", Vector3(14153.112, 8297.195, 339.274), Rotation(46, 0, 0), optsSniper_SO),
	
}
return M
