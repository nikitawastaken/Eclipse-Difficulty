---@module Drill Unit Overrides
local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()

local M = {
	--[[
	-- For testing, now serves as examples
	["branchbank"] = {
		-- Mission door (rear security office door)
		[104625] = {
			drill = {
				{
					timer = 69,
					jam_times = {
						is_balance_mul = true,
						team_ai_balance_mul_weight = 1,
						1,
						2,
						3,
						15,
					},
				},
			},
		},
		-- Mission door (front security office door)
		[100207] = {
			drill = {
				{
					timer = 96,
					jam_times = {
						is_balance_mul = true,
						{ 1, 2 },
						{ 1, 3 },
						{ 1, 3 },
						{ 6, 7 },
					},
				},
			},
		},
		-- Rear lance
		[104466] = {
			timer = 240,
			timer_init_balance_mul = {
				team_ai_balance_mul_weight = 0.5,
				0.25,
				0.5,
				0.75,
				1,
			},
			jam_times = 9,
		},
		-- Front lance
		[104674] = {
			timer = 420,
			timer_dt_balance_mul = {
				team_ai_balance_mul_weight = 0.5,
				0.25,
				0.5,
				0.75,
				1,
			},
			jam_times = {
				4,
				4,
			},
		},
	},
	]]
	["arm_cro"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			timer = 150,
			jam_times = 1,
			forbid_reenforce = true,
		},
	},
	["arm_fac"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			timer = 150,
			jam_times = 1,
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
			timer = 150,
			jam_times = 1,
			forbid_reenforce = true,
		},
	},
	["arm_par"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			timer = 150,
			jam_times = 1,
			forbid_reenforce = true,
		},
	},
	["arm_und"] = {
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small"):key()] = {
			timer = 150,
			jam_times = 1,
			forbid_reenforce = true,
		},
	},
	["bex"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = is_pro_job and 0.5 or 0.33,
				1,
				2,
				3,
				4,
			},
			forbid_sabotage = true,
		},
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small_no_jam"):key()] = {
			timer = 120,
		},
	},
	["big"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = is_pro_job and 0.5 or 0.33,
				{ 1, 2 },
				{ 2, 3 },
				{ 3, 4 },
				{ 4, 5 },
			},
			forbid_sabotage = true,
		},
	},
	["chas"] = {
		[("units/payday2/equipment/gen_interactable_hack_computer/gen_interactable_hack_computer_b"):key()] = {
			timer = 150 + (is_pro_job and 30 or 0),
		},
	},
	["dah"] = {
		[("units/pd2_dlc_dah/props/dah_prop_hack_box/dah_prop_hack_ipad_unit"):key()] = {
			timer = 240,
			jam_times = 2,
			can_jam = true,
		},
	},
	["glace"] = {
		[("units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam"):key()] = {
			timer = 240,
			jam_times = { 2, 3 },
			can_jam = true,
			forbid_reenforce = true,
		},
		[("units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam_rotated"):key()] = {
			timer = 240,
			jam_times = { 2, 3 },
			can_jam = true,
			forbid_reenforce = true,
		},
		[105077] = { -- SWAT van saw at the end
			timer = 60,
			jam_times = 1,
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
		[("units/pd2_dlc_pal/equipment/gen_interactable_drill_small_upright/gen_interactable_drill_small_upright"):key()] = {
			timer = is_eclipse and 360 or 240,
			jam_times = 2 + (is_pro_job and 1 or 0),
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
