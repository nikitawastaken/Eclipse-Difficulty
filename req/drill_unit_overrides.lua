---@module Drill Unit Overrides
local calc_team_ai_wgt = Eclipse.utils.calculate_team_ai_weight
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local normal, hard, eclipse = Eclipse.utils.diff_groups()

local armadillo_drill = { -- Armored Transport Trucks in Transport heists
	drill = {
		{
			timer = 120,
			jam_times = 2,
			forbid_reenforce = true,
		},
	},
}
local evil_nightmare_safe = {
	drill = {
		{
			timer = 666, -- Dallas, my friend, the devil.
			forbid_reenforce = true,
			forbid_sabotage = true,
			disable_upgrades = true,
		},
	},
}
local security_door_solo_friendly = {
	drill = {
		{
			timer = 120,
			timer_init_balance_mul = {
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				3 / 4,
				3 / 4,
				1,
				1,
			},
			jam_times = { 1, 2 },
		},
	},
}
local big_vault_door = {
	drill = {
		{
			timer = 90,
			timer_init_balance_mul = {
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				2 / 3,
				2 / 3,
				1,
				1,
			},
			jam_times = 1,
			forbid_reenforce = true,
		},
	},
}
local ranc_cage_door = {
	[100024] = {
		drill = {
			{
				timer_init_balance_mul = {
					team_ai_balance_mul_weight = calc_team_ai_wgt(2),
					2 / 3,
					2 / 3,
					1,
					1,
				},
				can_jam = false,
				forbid_reenforce = true,
			},
		},
	},
}
local teddy_moo_saw = {
	drill = {
		{
			timer = 180,
		},
	},
}
local chca_vault_saw = {
	timer_dt_balance_mul = {
		team_ai_balance_mul_weight = calc_team_ai_wgt(2),
		6 / 8,
		7 / 8,
		1,
		1,
	},
	jam_times = {
		is_balance_mul = true,
		team_ai_balance_mul_weight = calc_team_ai_wgt(2),
		1,
		1,
		2,
		2,
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
					disable_upgrades = true,
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
					disable_upgrades = true,
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
			disable_upgrades = true,
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
			disable_upgrades = true,
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
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				8 / 10,
				9 / 10,
				1,
				1,
			},
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calc_team_ai_wgt(1),
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
			timer_dt_balance_mul = {
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				8 / 10,
				9 / 10,
				1,
				1,
			},
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calc_team_ai_wgt(1),
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
		[103891] = big_vault_door, -- Gates inside the vault
		[102905] = big_vault_door,
		[103298] = big_vault_door,
		[103351] = big_vault_door,
		[103340] = big_vault_door,
		[103637] = big_vault_door,
		[104082] = big_vault_door,
		[101729] = big_vault_door,
	},
	["chas"] = {
		[("units/payday2/equipment/gen_interactable_hack_computer/gen_interactable_hack_computer_b"):key()] = {
			timer = 150 + (is_pro_job and 30 or 0),
		},
	},
	["chca"] = {
		["chca_vault_001"] = {
			[100011] = chca_vault_saw,
			[100079] = chca_vault_saw,
			[100080] = chca_vault_saw,
			[100122] = chca_vault_saw,
		},
	},
	["dah"] = {
		[("units/pd2_dlc_dah/props/dah_prop_hack_box/dah_prop_hack_ipad_unit"):key()] = {
			timer = 240,
			jam_times = 2,
			can_jam = true,
		},
	},
	["deep"] = {
		["deep_server_door_001"] = {
			[100049] = {
				drill = {
					{
						timer = 120,
						timer_init_balance_mul = {
							team_ai_balance_mul_weight = calc_team_ai_wgt(2),
							3 / 4,
							3 / 4,
							1,
							1,
						},
						jam_times = { 1, 2 },
					},
				},
			},
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
		-- For testing tweaking inside instances
		--[[
		["glace_prison_bus_001"] = {
			[100038] = {
				timer = 20,
			},
		},
		["glace_prison_bus_002"] = {
			[100038] = {
				timer = 30,
			},
		},
		["glace_prison_bus_003"] = {
			[100038] = {
				timer = 40,
			},
		},
		]]
	},
	["haunted"] = {
		[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = {
			timer = 666, -- Spooky scary devil number
			forbid_reenforce = true,
			forbid_sabotage = true,
			disable_upgrades = true,
		},
		[100224] = evil_nightmare_safe,
		[100419] = evil_nightmare_safe,
		[100420] = evil_nightmare_safe,
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
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				{ 1, 2 },
				{ 2, 2 },
				{ 2, 3 },
				{ 3, 3 },
			},
			forbid_sabotage = true,
		},
	},
	["nightclub"] = {
		[104445] = security_door_solo_friendly,
		[300050] = security_door_solo_friendly,
		[300957] = security_door_solo_friendly,
		[301068] = security_door_solo_friendly,
	},
	["nmh"] = {
		[("units/pd2_dlc_nmh/props/nmh_interactable_teddy_saw/nmh_interactable_teddy_saw"):key()] = {
			timer = 180,
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
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				2 / 3,
				2 / 3,
				1,
				1,
			},
			jam_times = 1,
		},
	},
	["ranc"] = {
		["ranc_cage_door_001"] = ranc_cage_door,
		["ranc_cage_door_002"] = ranc_cage_door,
		["ranc_cage_door_003"] = ranc_cage_door,
		["ranc_cage_door_004"] = ranc_cage_door,
		["ranc_cage_door_005"] = ranc_cage_door,
		["ranc_cage_door_006"] = ranc_cage_door,
		["ranc_cage_door_007"] = ranc_cage_door,
		["ranc_cage_door_008"] = ranc_cage_door,
		["ranc_cage_door_009"] = ranc_cage_door,
		["ranc_cage_door_010"] = ranc_cage_door,
		["ranc_cage_door_011"] = ranc_cage_door,
		["ranc_cage_door_012"] = ranc_cage_door,
		["ranc_cage_door_013"] = ranc_cage_door,
		["ranc_cage_door_014"] = ranc_cage_door,
		["ranc_cage_door_015"] = ranc_cage_door,
	},
	["red2"] = {
		[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = {
			jam_times = {
				is_balance_mul = true,
				team_ai_balance_mul_weight = calc_team_ai_wgt(2),
				{ 1, 2 },
				{ 2, 2 },
				{ 2, 3 },
				{ 3, 3 },
			},
			forbid_sabotage = true,
		},
	},
	["trai"] = {
		[101874] = security_door_solo_friendly,
		[101013] = security_door_solo_friendly,
	},
}

return M
