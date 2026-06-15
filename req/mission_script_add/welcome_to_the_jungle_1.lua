---@module Big Oil Day 1
local M = {}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101379, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 101379, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsspawnvanSWATs = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
local optsenable_birds_area_1 = {
	enabled = true,
	elements = {
		103353,
	},
}
local optsenable_birds_area_2 = {
	enabled = true,
	elements = {
		103358,
	},
}
local optsenable_birds_area_3 = {
	enabled = true,
	elements = {
		103383,
	},
}
local optsenable_birds_area_4 = {
	enabled = true,
	elements = {
		103387,
	},
}
local optsenable_birds_area_5 = {
	enabled = true,
	elements = {
		103391,
	},
}
local optsenable_birds_area_6 = {
	enabled = true,
	elements = {
		103395,
	},
}
local optsenable_birds_area_7 = {
	enabled = true,
	elements = {
		103399,
	},
}
local optsenable_birds_area_8 = {
	enabled = true,
	elements = {
		103403,
	},
}
local optsenable_birds_area_9 = {
	enabled = true,
	elements = {
		103407,
	},
}
local optsenable_birds_area_10 = {
	enabled = true,
	elements = {
		103411,
	},
}
local optsenable_birds_area_11 = {
	enabled = true,
	elements = {
		103415,
	},
}
local spawn_random_birds = {
	amount = 4,
	trigger_times = 1,
	on_executed = {
		{ id = 400010, delay = 0 },
		{ id = 400011, delay = 0 },
		{ id = 400012, delay = 0 },
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
		{ id = 400015, delay = 0 },
		{ id = 400016, delay = 0 },
		{ id = 400017, delay = 0 },
		{ id = 400018, delay = 0 },
		{ id = 400019, delay = 0 },
		{ id = 400020, delay = 0 },
	},
}

M.elements = {
	-- swat van
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(7602, -9027, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(7615.272, -8970.512, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(7675.528, -9042.923, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(7688.350, -8987.384, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats", optsspawnvanSWATs),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_group", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),
	
	-- restore birds event
	Eclipse.mission_elements.gen_toggleelement(400010, "enable_birds_1", optsenable_birds_area_1),
	Eclipse.mission_elements.gen_toggleelement(400011, "enable_birds_2", optsenable_birds_area_2),
	Eclipse.mission_elements.gen_toggleelement(400012, "enable_birds_3", optsenable_birds_area_3),
	Eclipse.mission_elements.gen_toggleelement(400013, "enable_birds_4", optsenable_birds_area_4),
	Eclipse.mission_elements.gen_toggleelement(400014, "enable_birds_5", optsenable_birds_area_5),
	Eclipse.mission_elements.gen_toggleelement(400015, "enable_birds_6", optsenable_birds_area_6),
	Eclipse.mission_elements.gen_toggleelement(400016, "enable_birds_7", optsenable_birds_area_7),
	Eclipse.mission_elements.gen_toggleelement(400017, "enable_birds_8", optsenable_birds_area_8),
	Eclipse.mission_elements.gen_toggleelement(400018, "enable_birds_9", optsenable_birds_area_9),
	Eclipse.mission_elements.gen_toggleelement(400019, "enable_birds_10", optsenable_birds_area_10),
	Eclipse.mission_elements.gen_toggleelement(400020, "enable_birds_11", optsenable_birds_area_11),
	
	Eclipse.mission_elements.gen_element_random(400021, "enable_random_birds_location", spawn_random_birds),
	
}

return M
