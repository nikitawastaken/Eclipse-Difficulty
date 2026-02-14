---@module Election Day (Day 1)
local M = {}

local is_pro_job = Eclipse.utils.is_pro_job()

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
}
local chopper_amount = {
	amount = is_pro_job and 2 or 1,
	amount_random = 1,
	on_executed = {
		{ id = 104074, delay = 0, delay_rand = 10 },
		{ id = 104125, delay = 0, delay_rand = 10 },
		{ id = 104126, delay = 0, delay_rand = 10 },
	},
}
local optsspawnSWATs_1 = {
	on_executed = {
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local optsspawnSWATs_2 = {
	on_executed = {
		{ id = 400012, delay = 0 },
	},
	enabled = true,
}
local optsspawnSWATs_3 = {
	on_executed = {
		{ id = 400018, delay = 0 },
	},
	enabled = true,
}

local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- swat chopper 1
	Eclipse.mission_elements.gen_dummy(400001, "swat_chopper_spawn_1", Vector3(7662, 1527, 268.240), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_chopper_spawn_2", Vector3(7598, 1522, 268.240), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_chopper_spawn_3", Vector3(7670, 1600, 268.240), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_chopper_spawn_4", Vector3(7598, 1588, 268.240), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_spawngroup(400006, "swat_group_1", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- swat chopper 2
	Eclipse.mission_elements.gen_dummy(400007, "swat_chopper_spawn_5", Vector3(3878, 3927, 806.369), Rotation(-180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "swat_chopper_spawn_6", Vector3(3801, 3927, 806.369), Rotation(-180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "swat_chopper_spawn_7", Vector3(3739, 3927, 806.369), Rotation(-180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "swat_chopper_spawn_8", Vector3(3685, 3927, 806.369), Rotation(-180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400011, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_spawngroup(400012, "swat_group_2", { 400007, 400008, 400009, 400010 }, 0, opts_swat_group),

	-- swat chopper 3
	Eclipse.mission_elements.gen_dummy(400013, "swat_chopper_spawn_9", Vector3(-882, 1769, 822.404), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400014, "swat_chopper_spawn_10", Vector3(-882, 1823, 822.404), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400015, "swat_chopper_spawn_11", Vector3(-882, 1884, 822.404), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "swat_chopper_spawn_12", Vector3(-882, 1945, 822.404), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400017, "spawn_swats_3", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_spawngroup(400018, "swat_group_3", { 400013, 400014, 400015, 400016 }, 0, opts_swat_group),

	-- chopper spawner
	Eclipse.mission_elements.gen_element_random(400019, "random_chopper_spawner", chopper_amount),
}

return M
