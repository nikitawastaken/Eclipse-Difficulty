---@module Goat Simulator Day 2
local M = {}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400012, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400018, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_4 = {
	on_executed = {
		{ id = 400024, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(9413, -13961, 2.491), Rotation(25, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(9345.026, -13992.696, 2.491), Rotation(25, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(9388.488, -13908.434, 2.491), Rotation(25, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(9320.515, -13940.130, 2.491), Rotation(25, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_spawngroup(400006, "swat_group_1", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400007, "swat_van_spawn_5", Vector3(10531, -15493, 3.278), Rotation(-4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "swat_van_spawn_6", Vector3(10466.158, -15488.466, 3.278), Rotation(-4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "swat_van_spawn_7", Vector3(10533.771, -15349.061, 3.278), Rotation(-4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "swat_van_spawn_8", Vector3(10469.926, -15434.597, 3.278), Rotation(-4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400011, "spawn_swats_2", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_spawngroup(400012, "swat_group_2", { 400007, 400008, 400009, 400010 }, 0, opts_swat_group),

	-- swat van 3
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_9", Vector3(11217, -15839, -9.155), Rotation(42, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_10", Vector3(11168.696, -15882.493, -9.155), Rotation(42, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400015, "swat_van_spawn_11", Vector3(11181.685, -15796.788, -9.155), Rotation(42, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "swat_van_spawn_12", Vector3(11126.692, -15846.304, -9.155), Rotation(42, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400017, "spawn_swats_3", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_spawngroup(400018, "swat_group_3", { 400013, 400014, 400015, 400016 }, 0, opts_swat_group),

	-- swat van 4
	Eclipse.mission_elements.gen_dummy(400019, "swat_van_spawn_13", Vector3(12788, -18355, 10.487), Rotation(17, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400020, "swat_van_spawn_14", Vector3(12738.272, -18370.203, 10.487), Rotation(17, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400021, "swat_van_spawn_15", Vector3(12274.045, -18305.934, 10.487), Rotation(17, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400022, "swat_van_spawn_16", Vector3(12723.361, -18321.430, 10.487), Rotation(17, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400023, "spawn_swats_4", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_spawngroup(400024, "swat_group_4", { 400019, 400020, 400021, 400022 }, 0, opts_swat_group),
}

return M
