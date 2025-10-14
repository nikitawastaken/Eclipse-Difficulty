---@module Drill Unit Overrides
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
	},
	["big"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			forbid_sabotage = true,
		},
	},
	["glace"] = {
		[("units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam"):key()] = {
			forbid_reenforce = true,
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
