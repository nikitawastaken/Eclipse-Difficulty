---@module Drill Unit Overrides
local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()

local M = {
	["arm_cro"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			forbid_reenforce = true,
		},
	},
	["arm_fac"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			forbid_reenforce = true,
		},
	},
	["arm_for"] = {
		[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = {
			forbid_reenforce = true,
		},
	},
	["arm_hcm"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			forbid_reenforce = true,
		},
	},
	["arm_par"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			forbid_reenforce = true,
		},
	},
	["arm_und"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			forbid_reenforce = true,
		},
	},
	["bex"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			forbid_sabotage = true,
		},
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small_no_jam"):key()] = {
			timer = 120,
		},
	},
	["big"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			forbid_sabotage = true,
		},
	},
	["chas"] = {
		[("units/payday2/equipment/gen_interactable_hack_computer/gen_interactable_hack_computer_b"):key()] = {
			timer = 150 + is_pro_job and 30 or 0,
		},
	},
	["glace"] = {
		[("units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam"):key()] = {
			timer = 240,
			jam_times = 2,
			can_jam = true,
			forbid_reenforce = true,
		},
		[("units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam_rotated"):key()] = {
			timer = 240,
			jam_times = 2,
			can_jam = true,
			forbid_reenforce = true,
		},
	},
	["hox_1"] = {
		[("units/payday2/equipment/gen_interactable_hack_computer/gen_interactable_hack_computer_b"):key()] = {
			timer = (normal and 30 or hard and 60 or 90) + (is_pro_job and 30 or 0),
		},
	},
	["man"] = {
		[("units/pd2_dlc_jolly/equipment/gen_interactable_saw/gen_interactable_saw"):key()] = {
			timer = 240,
		},
	},
	["pal"] = {
		[("units/world/props/suburbia_hackbox/suburbia_hackbox"):key()] = {
			timer = 240,
			jam_times = 2,
			can_jam = true,
		},
	},
	["red2"] = {
		[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = {
			forbid_sabotage = true,
		},
	},
}

return M
