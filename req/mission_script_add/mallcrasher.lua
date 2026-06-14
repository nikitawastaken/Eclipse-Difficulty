---@module Mallcrasher
local M = {}

local optsATM_Tweaks = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 500860, notify_unit_sequence = "capitol", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 500859, notify_unit_sequence = "capitol", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 301120, notify_unit_sequence = "generic", time = 0 },
		{ id = 4, name = "run_sequence", notify_unit_id = 301128, notify_unit_sequence = "generic", time = 0 },
		{ id = 5, name = "run_sequence", notify_unit_id = 301130, notify_unit_sequence = "generic", time = 0 },
		{ id = 6, name = "run_sequence", notify_unit_id = 301122, notify_unit_sequence = "generic", time = 0 },
		{ id = 7, name = "run_sequence", notify_unit_id = 301136, notify_unit_sequence = "generic", time = 0 },
	},
}

local optsdisable_sniper_1 = {
	enabled = true,
	toggle = "off",
	elements = {
		301605,
	},
}
local optsdisable_sniper_2 = {
	enabled = true,
	toggle = "off",
	elements = {
		301606,
	},
}
local optsdisable_sniper_3 = {
	enabled = true,
	toggle = "off",
	elements = {
		302133,
	},
}
local optsdisable_sniper_4 = {
	enabled = true,
	toggle = "off",
	elements = {
		302134,
	},
}
local optsdisable_sniper_5 = {
	enabled = true,
	toggle = "off",
	elements = {
		302135,
	},
}
local optsenable_sniper_1 = {
	enabled = true,
	elements = {
		301605,
	},
}
local optsenable_sniper_2 = {
	enabled = true,
	elements = {
		301606,
	},
}
local optsenable_sniper_3 = {
	enabled = true,
	elements = {
		302133,
	},
}
local optsenable_sniper_4 = {
	enabled = true,
	elements = {
		302134,
	},
}
local otpsenable_sniper_5 = {
	enabled = true,
	elements = {
		302135,
	},
}

local optssniperdied_1 = {
	on_executed = {
		{ id = 400001, delay = 1 },
	},
	elements = {
		301605,
	},
	event = "death",
}
local optssniperdied_2 = {
	on_executed = {
		{ id = 400002, delay = 1 },
	},
	elements = {
		301606,
	},
	event = "death",
}
local optssniperdied_3 = {
	on_executed = {
		{ id = 400003, delay = 1 },
	},
	elements = {
		302133,
	},
	event = "death",
}
local optssniperdied_4 = {
	on_executed = {
		{ id = 400004, delay = 1 },
	},
	elements = {
		302134,
	},
	event = "death",
}
local optssniperdied_5 = {
	on_executed = {
		{ id = 400005, delay = 1 },
	},
	elements = {
		302135,
	},
	event = "death",
}
local optssniperspawned_1 = {
	on_executed = {
		{ id = 400006, delay = 1 }, -- apperantly they are broken if it's set to 0
	},
	elements = {
		301605,
	},
}
local optssniperspawned_2 = {
	on_executed = {
		{ id = 400007, delay = 1 },
	},
	elements = {
		301606,
	},
}
local optssniperspawned_3 = {
	on_executed = {
		{ id = 400008, delay = 1 },
	},
	elements = {
		302133,
	},
}
local optssniperspawned_4 = {
	on_executed = {
		{ id = 400009, delay = 1 },
	},
	elements = {
		302134,
	},
}
local optssniperspawned_5 = {
	on_executed = {
		{ id = 400010, delay = 1 },
	},
	elements = {
		302135,
	},
}

local optshidefloatinglight = {
	unit_ids = {
		502065,
	},
}

M.elements = {
	-- snipers toggle stuff
	Eclipse.mission_elements.gen_toggleelement(400001, "enable_sniper_1", optsenable_sniper_1),
	Eclipse.mission_elements.gen_toggleelement(400002, "enable_sniper_2", optsenable_sniper_2),
	Eclipse.mission_elements.gen_toggleelement(400003, "enable_sniper_3", optsenable_sniper_3),
	Eclipse.mission_elements.gen_toggleelement(400004, "enable_sniper_4", optsenable_sniper_4),
	Eclipse.mission_elements.gen_toggleelement(400005, "enable_sniper_5", optsenable_sniper_5),
	Eclipse.mission_elements.gen_toggleelement(400006, "disable_sniper_1", optsdisable_sniper_1),
	Eclipse.mission_elements.gen_toggleelement(400007, "disable_sniper_2", optsdisable_sniper_2),
	Eclipse.mission_elements.gen_toggleelement(400008, "disable_sniper_3", optsdisable_sniper_3),
	Eclipse.mission_elements.gen_toggleelement(400009, "disable_sniper_4", optsdisable_sniper_4),
	Eclipse.mission_elements.gen_toggleelement(400010, "disable_sniper_5", optsdisable_sniper_5),
	Eclipse.mission_elements.gen_dummytrigger(400011, "sniper_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_1),
	Eclipse.mission_elements.gen_dummytrigger(400012, "sniper_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_2),
	Eclipse.mission_elements.gen_dummytrigger(400013, "sniper_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_3),
	Eclipse.mission_elements.gen_dummytrigger(400014, "sniper_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_4),
	Eclipse.mission_elements.gen_dummytrigger(400015, "sniper_spawned_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_5),
	Eclipse.mission_elements.gen_dummytrigger(400016, "sniper_died_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_1),
	Eclipse.mission_elements.gen_dummytrigger(400017, "sniper_died_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_2),
	Eclipse.mission_elements.gen_dummytrigger(400018, "sniper_died_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_3),
	Eclipse.mission_elements.gen_dummytrigger(400019, "sniper_died_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_4),
	Eclipse.mission_elements.gen_dummytrigger(400020, "sniper_died_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_5),

	-- ATM tweaks
	Eclipse.mission_elements.gen_object_editor(400021, "atm_tweaks", Vector3(0, 0, 0), Rotation(0, 0, 0), optsATM_Tweaks),

	-- hide floating traffic light
	Eclipse.mission_elements.gen_disable_unit(400022, "hide_floating_light", Vector3(0, 0, 0), Rotation(0, 0, 0), optshidefloatinglight),
}
return M
