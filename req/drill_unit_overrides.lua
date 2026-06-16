---@module Drill Unit Overrides
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local normal, hard, eclipse = Eclipse.utils.diff_groups()

local max_nr_team_ai = tweak_data.group_ai.max_nr_team_ai
local calculate_team_ai_weight = Eclipse.utils.calculate_team_ai_weight

local armadillo_drill = { -- Armored Transport Trucks in Transport heists
	drill = {
		{
			timer = 120,
			jam_times = { 1, 2 },
			forbid_reenforce = true,
		},
	},
}
local security_door_solo_friendly = { 
	drill = {
		{
			timer_init_balance_mul = {
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 2),
				1 / 2,
				2 / 3,
				1,
				1,
			},
			jam_times = 1,
		},
	},
}

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
		[100006] = armadillo_drill,
		[100007] = armadillo_drill,
		[100021] = armadillo_drill,
		[100022] = armadillo_drill,
		[100023] = armadillo_drill,
		[100024] = armadillo_drill,
		[100025] = armadillo_drill,
		[100097] = armadillo_drill,
		[100100] = armadillo_drill,
		[100101] = armadillo_drill,
		[100226] = armadillo_drill,
		[100227] = armadillo_drill,
	},
	["arm_fac"] = {
		[100006] = armadillo_drill,
		[100007] = armadillo_drill,
		[100021] = armadillo_drill,
		[100022] = armadillo_drill,
		[100023] = armadillo_drill,
		[100024] = armadillo_drill,
		[100025] = armadillo_drill,
		[100097] = armadillo_drill,
		[100100] = armadillo_drill,
		[100101] = armadillo_drill,
		[100226] = armadillo_drill,
		[100227] = armadillo_drill,
	},
	["arm_hcm"] = {
		[100006] = armadillo_drill,
		[100007] = armadillo_drill,
		[100021] = armadillo_drill,
		[100022] = armadillo_drill,
		[100023] = armadillo_drill,
		[100024] = armadillo_drill,
		[100025] = armadillo_drill,
		[100097] = armadillo_drill,
		[100100] = armadillo_drill,
		[100101] = armadillo_drill,
		[100226] = armadillo_drill,
		[100227] = armadillo_drill,
	},
	["arm_par"] = {
		[100006] = armadillo_drill,
		[100007] = armadillo_drill,
		[100021] = armadillo_drill,
		[100022] = armadillo_drill,
		[100023] = armadillo_drill,
		[100024] = armadillo_drill,
		[100025] = armadillo_drill,
		[100097] = armadillo_drill,
		[100100] = armadillo_drill,
		[100101] = armadillo_drill,
		[100226] = armadillo_drill,
		[100227] = armadillo_drill,
	},
	["arm_und"] = {
		[100007] = armadillo_drill,
		[100021] = armadillo_drill,
		[100022] = armadillo_drill,
		[100023] = armadillo_drill,
		[100024] = armadillo_drill,
		[100025] = armadillo_drill,
		[100097] = armadillo_drill,
		[100100] = armadillo_drill,
	},
	["bex"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			timer_dt_balance_mul = {
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 2),
				8 / 10,
				9 / 10,
				1,
				1,
			},
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 1),
				{ 1, 2 },
				{ 2, 2 },
				{ 2, 3 },
				{ 3, 3 },
			},
			forbid_sabotage = true,
		},
		[("units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small_no_jam"):key()] = {
			timer = 120,
		},
	},
	["big"] = {
		[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = {
			timer_dt_balance_mul = {
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 2),
				8 / 10,
				9 / 10,
				1,
				1,
			},
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 1),
				{ 1, 2 },
				{ 2, 3 },
				{ 3, 4 },
				{ 4, 5 },
			},
			forbid_sabotage = true,
		},
		[101490] = security_door_solo_friendly, -- Steel security doors
		[102834] = security_door_solo_friendly,
		[103009] = security_door_solo_friendly,
		[104582] = security_door_solo_friendly,
		[104584] = security_door_solo_friendly,
		[104585] = security_door_solo_friendly,
		[100331] = security_door_solo_friendly,
		[103322] = security_door_solo_friendly,
		[105317] = security_door_solo_friendly,
		[106336] = security_door_solo_friendly,
		[103891] = security_door_solo_friendly, -- Gates inside the vault
		[102905] = security_door_solo_friendly,
		[103298] = security_door_solo_friendly,
		[103351] = security_door_solo_friendly,
		[103340] = security_door_solo_friendly,
		[103637] = security_door_solo_friendly,
		[104082] = security_door_solo_friendly,
		[101729] = security_door_solo_friendly,
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
	["mia_2"] = {
		[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = {
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 1),
				{ 1, 2 },
				{ 2, 2 },
				{ 2, 3 },
				{ 3, 3 },
			},
			forbid_sabotage = true,
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
	["peta2"] = {
		[("units/pd2_dlc_peta/equipment/pta_interactable_door_drill/pta_interactable_door_drill"):key()] = {
			timer = 90,
			timer_init_balance_mul = {
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 1),
				4 / 6,
				5 / 6,
				1,
				1,
			},
			jam_times = 1,
		},
	},
	["red2"] = {
		[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = {
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calculate_team_ai_weight(max_nr_team_ai, 1),
				{ 1, 2 },
				{ 2, 2 },
				{ 2, 3 },
				{ 3, 3 },
			},
			forbid_sabotage = true,
		},
	},
}

return M
