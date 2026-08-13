---@module Watchdogs Day 1
local M = {}
local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101263, notify_unit_sequence = "open_light", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100514, notify_unit_sequence = "open_light", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
local optsWindowBreakAreaTrigger = {
	enabled = true,
	instigator = "enemies",
	width = 115,
	depth = 353,
	height = 285,
	trigger_times = 1,
	on_executed = {
		{ id = 400018, delay = 0 },
	},
}
local optsWindowBreak = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103787, notify_unit_sequence = "destroy_glass", time = 0 },
	},
}
local optsCrateNavlink01 = get_navlink_so_opts("e_nl_down_2m", Vector3(1425, 2325, 210), 2, false, true, true)
local optsCrateNavlink02 = get_navlink_so_opts("e_nl_down_2m", Vector3(1625, 2325, 0), 2, false, true, true)
local optsWindowNavlink = get_navlink_so_opts("e_nl_up_5_down_1m", Vector3(1900, 1075, 400), 4, true, true, true)

M.elements = {
	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(-2099, 2783, -19.999), Rotation(-12, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(-2160.623, 2796.068, -19.999), Rotation(-12, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(-2088.836, 2845.247, -19.999), Rotation(-12, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(-2147.525, 2857.722, -19.999), Rotation(-12, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_group_1", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400008, "swat_van_spawn_5", Vector3(-5661, 49, -19.999), Rotation(82, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "swat_van_spawn_6", Vector3(-5670.325, -17.348, -19.999), Rotation(82, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "swat_van_spawn_7", Vector3(-5734.697, 56.328, -19.999), Rotation(82, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_8", Vector3(-5743.604, -7.049, -19.999), Rotation(82, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400012, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400013, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400014, "swat_group_2", { 400008, 400009, 400010, 400011 }, 0, opts_swat_group),

	-- Add new navlinks
	Eclipse.mission_elements.gen_so(400015, "crate_navlink01", Vector3(1300, 2325, 400), Rotation(-90, 0, 0), optsCrateNavlink01),
	Eclipse.mission_elements.gen_so(400016, "crate_navlink02", Vector3(1475, 2325, 210), Rotation(-90, 0, 0), optsCrateNavlink02),
	Eclipse.mission_elements.gen_areatrigger(400017, "window_break_area_trigger", Vector3(1750, 1110, 550), Rotation(0, 0, 0), optsWindowBreakAreaTrigger),
	Eclipse.mission_elements.gen_object_editor(400018, "window_break_sequence", Vector3(1675, 1110, 550), Rotation(0, 0, 0), optsWindowBreak),
	Eclipse.mission_elements.gen_so(400019, "window_navlink", Vector3(1575, 1075, 0), Rotation(-90, 0, 0), optsWindowNavlink),
}

return M
