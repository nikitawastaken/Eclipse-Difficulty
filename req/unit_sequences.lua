local head_sequences = {
	security = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"disable_face",
		},
	},
	security_fat = {
		material = { 1, 2 },
		run_sequence = {
			"fat_head_init",
			"disable_face",
		},
	},
	security_female = {
		run_sequence = {
			"head_init",
		},
	},
	hrt = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"balaclava_cop_base",
		},
	},
	hrt_alt = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"disable_head",
		},
	},
	soldier_a = {
		material = 2,
		run_sequence = {
			"head_init",
			"disable_face",
			"disable_arms",
		},
	},
	soldier_b = {
		material = 2,
		run_sequence = {
			"head_init",
			"disable_arms",
			"random_balaclava_swat_rare",
		},
	},
	heavy_swat = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_heavy_swat",
			"disable_arms",
		},
	},
	swat_a = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_swat_common",
			"disable_arms",
		},
	},
	swat_b = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_swat_rare",
			"disable_arms",
		},
	},
	swat_c = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_swat",
			"disable_arms",
		},
	},
	swat_d = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"balaclava_swat_base",
			"disable_arms",
		},
	},
	fbi_swat_a = {
		material = { 1, 2 },
		run_sequence = {
			"set_random_balaclava",
			"head_init",
			"random_balaclava_swat_common",
			"disable_arms",
		},
	},
	fbi_swat_b = {
		material = { 1, 2 },
		run_sequence = {
			"set_random_balaclava",
			"head_init",
			"random_balaclava_swat_rare",
			"disable_arms",
		},
	},
	fbi_swat_c = {
		material = { 1, 2 },
		run_sequence = {
			"set_random_balaclava",
			"head_init",
			"random_balaclava_swat",
			"disable_arms",
		},
	},
	fbi_swat_d = {
		material = { 1, 2 },
		run_sequence = {
			"set_random_balaclava",
			"head_init",
			"balaclava_swat_base",
			"disable_arms",
		},
	},
	bulldozer = {
		run_sequence = {
			"head_init",
			"disable_head",
			"disable_arms",
		},
	},
	medic = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_medic",
			"disable_arms",
		},
	},
	cloaker = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"disable_head",
			"disable_arms",
		},
	},
	swat_arms_a = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_swat_common",
		},
	},
	swat_arms_b = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_swat_rare",
		},
	},
	swat_arms_c = {
		material = { 1, 2 },
		run_sequence = {
			"head_init",
			"random_balaclava_swat",
		},
	},
}
---@module Unit Sequences
local M = {
	["units/payday2/characters/ene_security_1/ene_security_1"] = { name = "security_1", head = head_sequences.security },
	["units/payday2/characters/ene_security_2/ene_security_2"] = { name = "security_2", head = head_sequences.security },
	["units/payday2/characters/ene_security_3/ene_security_3"] = { name = "security_3", head = head_sequences.security },
	
	["units/payday2/characters/ene_security_1_fat/ene_security_1_fat"] = { name = "security_1_fat", head = head_sequences.security_fat },
	["units/payday2/characters/ene_security_2_fat/ene_security_2_fat"] = { name = "security_2_fat", head = head_sequences.security_fat },
	["units/payday2/characters/ene_security_3_fat/ene_security_3_fat"] = { name = "security_3_fat", head = head_sequences.security_fat },
	
	["units/pd2_dlc_short/characters/ene_security_1_undominatable/ene_security_1_undominatable"] = { name = "security_1", head = head_sequences.security },
	["units/pd2_dlc_short/characters/ene_security_2_undominatable/ene_security_2_undominatable"] = { name = "security_2", head = head_sequences.security },
	["units/pd2_dlc_short/characters/ene_security_3_undominatable/ene_security_3_undominatable"] = { name = "security_3", head = head_sequences.security },
	
	["units/payday2/characters/ene_security_female_1/ene_security_female_1"] = { name = "security_female_1", head = head_sequences.security_female },
	["units/payday2/characters/ene_security_female_2/ene_security_female_2"] = { name = "security_female_2", head = head_sequences.security_female },
	
	["units/payday2/characters/ene_security_4/ene_security_4"] = { name = "security_4", head = head_sequences.security },
	["units/payday2/characters/ene_security_5/ene_security_5"] = { name = "security_5", head = head_sequences.security },
	["units/payday2/characters/ene_security_6/ene_security_6"] = { name = "security_6", head = head_sequences.security },
	["units/payday2/characters/ene_security_7/ene_security_7"] = { name = "security_7", head = head_sequences.security },
	["units/payday2/characters/ene_security_8/ene_security_8"] = { name = "security_8", head = head_sequences.security },
	
	["units/payday2/characters/ene_cop_1/ene_cop_1"] = { name = "cop_1", head = head_sequences.security },
	["units/payday2/characters/ene_cop_2/ene_cop_2"] = { name = "cop_2", head = head_sequences.security },
	["units/pd2_dlc_short/characters/ene_cop_2_shr/ene_cop_2_shr"] = { name = "cop_2", head = head_sequences.security },
	["units/payday2/characters/ene_cop_3/ene_cop_3"] = { name = "cop_3", head = head_sequences.security },
	["units/payday2/characters/ene_cop_4/ene_cop_4"] = { name = "cop_4", head = head_sequences.security },
	
	["units/payday2/characters/ene_cop_1_fat/ene_cop_1_fat"] = { name = "cop_1_fat", head = head_sequences.security_fat },
	["units/payday2/characters/ene_cop_2_fat/ene_cop_2_fat"] = { name = "cop_2_fat", head = head_sequences.security_fat },
	["units/payday2/characters/ene_cop_3_fat/ene_cop_3_fat"] = { name = "cop_3_fat", head = head_sequences.security_fat },
	["units/payday2/characters/ene_cop_4_fat/ene_cop_4_fat"] = { name = "cop_4_fat", head = head_sequences.security_fat },
	
	["units/payday2/characters/ene_cop_female_1/ene_cop_female_1"] = { name = "cop_female_1", head = head_sequences.security_female },
	["units/payday2/characters/ene_cop_female_2/ene_cop_female_2"] = { name = "cop_female_2", head = head_sequences.security_female },
	
	["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = { name = "fbi_1", head = head_sequences.security },
	["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = { name = "fbi_2", head = head_sequences.security },
	["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = { name = "fbi_3", head = head_sequences.hrt },
	
	["units/payday2/characters/ene_prisonguard_male_1/ene_prisonguard_male_1"] = { name = "prisonguard_1", head = head_sequences.security },
	["units/payday2/characters/ene_prisonguard_female_1/ene_prisonguard_female_1"] = { name = "prisonguard_female_1", head = head_sequences.security_female },
	
	["units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"] = { name = "gensec_1", head = head_sequences.security },
	["units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"] = { name = "gensec_2", head = head_sequences.security },
	
	["units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"] = { name = "gensec_operator_1", head = head_sequences.swat_b },
	["units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"] = { name = "gensec_operator_1", head = head_sequences.swat_b },
	
	["units/payday2/characters/ene_secret_service_1/ene_secret_service_1"] = { name = "secret_service_1", head = head_sequences.security },
	["units/payday2/characters/ene_secret_service_2/ene_secret_service_2"] = { name = "secret_service_1", head = head_sequences.security },
	["units/pd2_dlc_short/characters/ene_secret_service_1_undominatable/ene_secret_service_1_undominatable"] = { name = "secret_service_1", head = head_sequences.security },
	["units/pd2_dlc_casino/characters/ene_secret_service_1_casino/ene_secret_service_1_casino"] = { name = "secret_service_1_casino", head = head_sequences.security },
	["units/pd2_dlc_fex/characters/ene_secret_service_fex/ene_secret_service_fex"] = { name = "secret_service_1", head = head_sequences.security },
	
	["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = { name = "murkywater_1", head = head_sequences.swat_b },
	["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = { name = "murkywater_1", head = head_sequences.swat_b },
	
	["units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light"] = { name = "murkywater_1", head = head_sequences.swat_b },
	["units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security"] = { name = "murkywater_1", head = head_sequences.swat_b },
	["units/pd2_dlc_des/characters/ene_murkywater_not_security_1/ene_murkywater_not_security_1"] = { name = "murkywater_1", head = head_sequences.swat_b },
	["units/pd2_dlc_des/characters/ene_murkywater_not_security_2/ene_murkywater_not_security_2"] = { name = "murkywater_1", head = head_sequences.swat_b },
	
	["units/payday2/characters/ene_swat_1/ene_swat_1"] = { name = "swat_1", head = head_sequences.swat_b },
	["units/payday2/characters/ene_swat_2/ene_swat_2"] = { name = "swat_2", head = head_sequences.swat_a },
	["units/payday2/characters/ene_swat_3/ene_swat_3"] = { name = "swat_3", head = head_sequences.swat_a },
	["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = { name = "swat_heavy_1", head = head_sequences.heavy_swat },
	["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = { name = "swat_heavy_2", head = head_sequences.heavy_swat },
	["units/payday2/characters/ene_shield_2/ene_shield_2"] = { name = "shield_2", head = head_sequences.swat_d },
	["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = { name = "sniper_1", head = head_sequences.swat_b },
		
	["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = { name = "fbi_swat_1", head = head_sequences.fbi_swat_b },
	["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = { name = "fbi_swat_2", head = head_sequences.fbi_swat_a },
	["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = { name = "fbi_swat_3", head = head_sequences.fbi_swat_a },
	["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = { name = "sniper_2", head = head_sequences.fbi_swat_b },
	["units/payday2/characters/ene_shield_1/ene_shield_1"] = { name = "shield_1", head = head_sequences.swat_d },
	
	["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = { name = "fbi_heavy_1", head = head_sequences.swat_d },
	["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = { name = "fbi_heavy_2", head = head_sequences.swat_d },
	
	["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = { name = "city_heavy_1", head = head_sequences.swat_d },
	["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = { name = "city_heavy_2", head = head_sequences.swat_d },
	
	["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = { name = "city_swat_1", head = head_sequences.heavy_swat },
	["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = { name = "city_swat_2", head = head_sequences.heavy_swat },
	["units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"] = { name = "city_swat_2", head = head_sequences.heavy_swat },
	["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = { name = "city_swat_3", head = head_sequences.heavy_swat },
	["units/payday2/characters/ene_sniper_3/ene_sniper_3"] = { name = "sniper_3", head = head_sequences.fbi_swat_b },
	["units/payday2/characters/ene_city_shield/ene_city_shield"] = { name = "shield_3", head = head_sequences.swat_d },

	["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = { name = "taser_1", head = head_sequences.swat_b },
	["units/payday2/characters/ene_tazer_r870/ene_tazer_r870"] = { name = "taser_2", head = head_sequences.cloaker },

	["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = { name = "medic_1", head = head_sequences.medic },
	["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = { name = "medic_2", head = head_sequences.medic },
	
	["units/payday2/characters/ene_spook_1/ene_spook_1"] = { name = "spook_1", head = head_sequences.cloaker },
	
	["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = { name = "bulldozer_1", head = head_sequences.bulldozer },
	["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = { name = "bulldozer_2", head = head_sequences.bulldozer },
	["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = { name = "bulldozer_3", head = head_sequences.bulldozer },
	["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = { name = "bulldozer_headless", head = head_sequences.bulldozer },
	["units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5"] = { name = "bulldozer_headless_black", head = head_sequences.bulldozer },
	["units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"] = { name = "bulldozer_4", head = head_sequences.bulldozer },
	["units/pd2_dlc_drm/characters/ene_bulldozer_medic_classic/ene_bulldozer_medic_classic"] = { name = "bulldozer_medic", head = head_sequences.bulldozer },
	
	["units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"] = { name = "mcmansion_security_1", head = head_sequences.swat_c },
	["units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"] = { name = "mcmansion_security_1", head = head_sequences.swat_c },
	
	["units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1"] = { name = "soldier_1", head = head_sequences.soldier_a },
	["units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2"] = { name = "soldier_2", head = head_sequences.soldier_b },
	["units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3"] = { name = "soldier_3", head = head_sequences.soldier_b },
	["units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4"] = { name = "soldier_4", head = head_sequences.soldier_b },

	["units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"] = { name = "hvh_cop_1", head = head_sequences.security },
	["units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"] = { name = "hvh_cop_2", head = head_sequences.security },
	["units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"] = { name = "hvh_cop_3", head = head_sequences.security },
	["units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"] = { name = "hvh_cop_4", head = head_sequences.security },
	
	["units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"] = { name = "hvh_fbi_1", head = head_sequences.security },
	["units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"] = { name = "hvh_fbi_2", head = head_sequences.security },
	["units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3"] = { name = "hvh_fbi_3", head = head_sequences.hrt },

	["units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"] = { name = "hvh_swat_1", head = head_sequences.swat_b },
	["units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"] = { name = "hvh_swat_2", head = head_sequences.swat_a },
	["units/pd2_dlc_hvh/characters/ene_swat_hvh_3/ene_swat_hvh_3"] = { name = "hvh_swat_3", head = head_sequences.swat_a },
	["units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"] = { name = "hvh_swat_heavy_1", head = head_sequences.heavy_swat },
	["units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"] = { name = "hvh_swat_heavy_2", head = head_sequences.heavy_swat },
	["units/pd2_dlc_hvh/characters/ene_sniper_hvh_1/ene_sniper_hvh_1"] = { name = "hvh_sniper_1", head = head_sequences.swat_b },
	["units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"] = { name = "hvh_shield_2", head = head_sequences.swat_d },
	
	["units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"] = { name = "hvh_fbi_swat_1", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"] = { name = "hvh_fbi_swat_2", head = head_sequences.fbi_swat_a },
	["units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3"] = { name = "hvh_fbi_swat_3", head = head_sequences.fbi_swat_a },
	["units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2"] = { name = "hvh_sniper_2", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"] = { name = "hvh_shield_1", head = head_sequences.swat_d },

	["units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1"] = { name = "hvh_city_swat_1", head = head_sequences.heavy_swat },
	["units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2"] = { name = "hvh_city_swat_2", head = head_sequences.heavy_swat },
	["units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3"] = { name = "hvh_city_swat_3", head = head_sequences.heavy_swat },
	["units/pd2_dlc_hvh/characters/ene_sniper_hvh_3/ene_sniper_hvh_3"] = { name = "hvh_sniper_3", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_hvh/characters/ene_city_shield_hvh/ene_city_shield_hvh"] = { name = "hvh_shield_3", head = head_sequences.swat_d },

	["units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"] = { name = "hvh_fbi_heavy_1", head = head_sequences.swat_d },
	["units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870"] = { name = "hvh_fbi_heavy_2", head = head_sequences.swat_d },
	["units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_1/ene_city_heavy_hvh_1"] = { name = "hvh_city_heavy_1", head = head_sequences.swat_d },
	["units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_r870/ene_city_heavy_hvh_r870"] = { name = "hvh_city_heavy_2", head = head_sequences.swat_d },

	["units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1"] = { name = "hvh_taser_1", head = head_sequences.swat_b },
	["units/pd2_dlc_hvh/characters/ene_tazer_hvh_r870/ene_tazer_hvh_r870"] = { name = "hvh_taser_2", head = head_sequences.cloaker },

	["units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"] = { name = "hvh_medic_1", head = head_sequences.medic },
	["units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"] = { name = "hvh_medic_2", head = head_sequences.medic },
	
	["units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1"] = { name = "hvh_spook_1", head = head_sequences.cloaker },

	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"] = { name = "hvh_bulldozer_1", head = head_sequences.bulldozer },
	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"] = { name = "hvh_bulldozer_2", head = head_sequences.bulldozer },
	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"] = { name = "hvh_bulldozer_3", head = head_sequences.bulldozer },
	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_4/ene_bulldozer_hvh_4"] = { name = "hvh_bulldozer_4", head = head_sequences.bulldozer },
	["units/pd2_dlc_hvh/characters/ene_bulldozer_medic_hvh/ene_bulldozer_medic_hvh"] = { name = "hvh_bulldozer_medic", head = head_sequences.bulldozer },

	["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"] = { name = "la_cop_1", head = head_sequences.security },
	["units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"] = { name = "la_cop_2", head = head_sequences.security },
	["units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"] = { name = "la_cop_3", head = head_sequences.security },
	["units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"] = { name = "la_cop_4", head = head_sequences.security },
	
	["units/pd2_dlc_rvd/characters/ene_la_cop_1_fat/ene_la_cop_1_fat"] = { name = "la_cop_1_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_rvd/characters/ene_la_cop_2_fat/ene_la_cop_2_fat"] = { name = "la_cop_2_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_rvd/characters/ene_la_cop_3_fat/ene_la_cop_3_fat"] = { name = "la_cop_3_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_rvd/characters/ene_la_cop_4_fat/ene_la_cop_4_fat"] = { name = "la_cop_4_fat", head = head_sequences.security_fat },

	["units/pd2_dlc_bph/characters/ene_murkywater_cop_1/ene_murkywater_cop_1"] = { name = "cop_1", head = head_sequences.security },
	["units/pd2_dlc_bph/characters/ene_murkywater_cop_2/ene_murkywater_cop_2"] = { name = "cop_2", head = head_sequences.security },
	["units/pd2_dlc_bph/characters/ene_murkywater_cop_3/ene_murkywater_cop_3"] = { name = "cop_3", head = head_sequences.security },
	["units/pd2_dlc_bph/characters/ene_murkywater_cop_4/ene_murkywater_cop_4"] = { name = "cop_4", head = head_sequences.security },
	
	["units/pd2_dlc_bph/characters/ene_murkywater_agent_1/ene_murkywater_agent_1"] = { name = "fbi_1", head = head_sequences.security },
	["units/pd2_dlc_bph/characters/ene_murkywater_agent_2/ene_murkywater_agent_2"] = { name = "fbi_2", head = head_sequences.security },
	["units/pd2_dlc_bph/characters/ene_murkywater_agent_3/ene_murkywater_agent_3"] = { name = "fbi_3", head = head_sequences.hrt_alt },	

	["units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"] = { name = "swat_1", head = head_sequences.swat_b },
	["units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"] = { name = "swat_2", head = head_sequences.swat_a },
	["units/pd2_dlc_bph/characters/ene_murkywater_light_mp5/ene_murkywater_light_mp5"] = { name = "swat_3", head = head_sequences.swat_a },
	["units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy"] = { name = "swat_heavy_1", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bph/characters/ene_murkywater_heavy_r870/ene_murkywater_heavy_r870"] = { name = "swat_heavy_2", head = head_sequences.heavy_swat },

	["units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"] = { name = "fbi_swat_1", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"] = { name = "fbi_swat_2", head = head_sequences.fbi_swat_a },
	["units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5"] = { name = "fbi_swat_3", head = head_sequences.fbi_swat_a },

	["units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"] = { name = "city_swat_1", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"] = { name = "city_swat_2", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5"] = { name = "city_swat_3", head = head_sequences.heavy_swat },
		
	["units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi/ene_murkywater_heavy_fbi"] = { name = "fbi_heavy_1", head = head_sequences.swat_d },
	["units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi_r870/ene_murkywater_heavy_fbi_r870"] = { name = "fbi_heavy_2", head = head_sequences.swat_d },
	["units/pd2_dlc_bph/characters/ene_murkywater_heavy_city/ene_murkywater_heavy_city"] = { name = "city_heavy_1", head = head_sequences.swat_d },
	["units/pd2_dlc_bph/characters/ene_murkywater_heavy_city_r870/ene_murkywater_heavy_city_r870"] = { name = "city_heavy_2", head = head_sequences.swat_d },

	["units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"] = { name = "spook_1", head = head_sequences.cloaker },

	["units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"] = { name = "medic_1", head = head_sequences.medic },
	["units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"] = { name = "medic_2", head = head_sequences.medic },

	["units/pd2_dlc_bph/characters/ene_murkywater_tazer/ene_murkywater_tazer"] = { name = "taser_1", head = head_sequences.swat_b },
	["units/pd2_dlc_bph/characters/ene_murkywater_tazer_r870/ene_murkywater_tazer_r870"] = { name = "taser_2", head = head_sequences.cloaker },
		
	["units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"] = { name = "secret_service_bex", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"] = { name = "secret_service_bex", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03"] = { name = "secret_service_bex", head = head_sequences.security },
	
	["units/pd2_dlc_bex/characters/ene_bex_security_01/ene_bex_security_01"] = { name = "bex_security_1", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_bex_security_02/ene_bex_security_02"] = { name = "bex_security_2", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_bex_security_03/ene_bex_security_03"] = { name = "bex_security_3", head = head_sequences.security },
	
	["units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"] = { name = "bex_cop_1", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"] = { name = "bex_cop_2", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03"] = { name = "bex_cop_3", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04"] = { name = "bex_cop_4", head = head_sequences.security },
	
	["units/pd2_dlc_bex/characters/ene_policia_agent_01/ene_policia_agent_01"] = { name = "bex_fbi_1", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_policia_agent_02/ene_policia_agent_02"] = { name = "bex_fbi_2", head = head_sequences.security },
	["units/pd2_dlc_bex/characters/ene_policia_agent_03/ene_policia_agent_03"] = { name = "bex_fbi_3", head = head_sequences.hrt },
	
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"] = { name = "swat_1", head = head_sequences.swat_arms_b },
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"] = { name = "swat_2", head = head_sequences.swat_arms_a },
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_mp5/ene_swat_policia_federale_mp5"] = { name = "swat_3", head = head_sequences.swat_arms_a },
	["units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"] = { name = "swat_heavy_1", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870"] = { name = "swat_heavy_2", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"] = { name = "shield_2", head = head_sequences.swat_d },
	["units/pd2_dlc_bex/characters/ene_swat_policia_sniper/ene_swat_policia_sniper"] = { name = "sniper_1", head = head_sequences.swat_b },
	
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"] = { name = "fbi_swat_1", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"] = { name = "fbi_swat_2", head = head_sequences.fbi_swat_a },
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5"] = { name = "fbi_swat_3", head = head_sequences.fbi_swat_a },
	["units/pd2_dlc_bex/characters/ene_swat_policia_sniper_fbi/ene_swat_policia_sniper_fbi"] = { name = "sniper_2", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"] = { name = "shield_1", head = head_sequences.swat_d },
	
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"] = { name = "city_swat_1", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"] = { name = "city_swat_2", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5"] = { name = "city_swat_3", head = head_sequences.heavy_swat },
	["units/pd2_dlc_bex/characters/ene_swat_policia_sniper_city/ene_swat_policia_sniper_city"] = { name = "sniper_3", head = head_sequences.fbi_swat_b },
	["units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_city/ene_swat_shield_policia_federale_city"] = { name = "shield_3", head = head_sequences.swat_d },
	
	["units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"] = { name = "fbi_heavy_1", head = head_sequences.swat_d },
	["units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"] = { name = "fbi_heavy_2", head = head_sequences.swat_d },
	["units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city/ene_swat_heavy_policia_federale_city"] = { name = "city_heavy_1", head = head_sequences.swat_d },
	["units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870"] = { name = "city_heavy_2", head = head_sequences.swat_d },
	
	["units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"] = { name = "medic_1", head = head_sequences.medic },
	["units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"] = { name = "medic_2", head = head_sequences.medic },
	
	["units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale"] = { name = "taser_1", head = head_sequences.swat_b },
	["units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale_r870/ene_swat_tazer_policia_federale_r870"] = { name = "taser_2", head = head_sequences.swat_d },
	
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"] = { name = "bulldozer_1", head = head_sequences.bulldozer },
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"] = { name = "bulldozer_2", head = head_sequences.bulldozer },
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"] = { name = "bulldozer_3", head = head_sequences.bulldozer },
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"] = { name = "bulldozer_4", head = head_sequences.bulldozer },
	["units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale"] = { name = "bulldozer_medic", head = head_sequences.bulldozer },
	
	["units/pd2_dlc_pex/characters/ene_male_office_cop_01/ene_male_office_cop_01"] = { name = "pex_cop_1", head = head_sequences.security },
	["units/pd2_dlc_pex/characters/ene_male_office_cop_02/ene_male_office_cop_02"] = { name = "pex_cop_2", head = head_sequences.security },
	["units/pd2_dlc_pex/characters/ene_male_office_cop_03/ene_male_office_cop_03"] = { name = "pex_cop_3", head = head_sequences.security },
	["units/pd2_dlc_pex/characters/ene_male_office_cop_04/ene_male_office_cop_04"] = { name = "pex_cop_3", head = head_sequences.security },

	["units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"] = { name = "chas_police_1", head = head_sequences.security },
	["units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"] = { name = "chas_police_2", head = head_sequences.security },
	["units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"] = { name = "chas_police_3", head = head_sequences.security },
	["units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"] = { name = "chas_police_4", head = head_sequences.security },
	
	["units/pd2_dlc_chas/characters/ene_male_chas_police_01_fat/ene_male_chas_police_01_fat"] = { name = "chas_police_1_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_chas/characters/ene_male_chas_police_02_fat/ene_male_chas_police_02_fat"] = { name = "chas_police_2_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_chas/characters/ene_male_chas_police_03_fat/ene_male_chas_police_03_fat"] = { name = "chas_police_3_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_chas/characters/ene_male_chas_police_04_fat/ene_male_chas_police_04_fat"] = { name = "chas_police_4_fat", head = head_sequences.security_fat },
	
	["units/pd2_dlc_chca/characters/ene_coast_guard_1/ene_coast_guard_1"] = { name = "coast_guard_1", head = head_sequences.security },
	["units/pd2_dlc_chca/characters/ene_coast_guard_2/ene_coast_guard_2"] = { name = "coast_guard_2", head = head_sequences.security },
	["units/pd2_dlc_chca/characters/ene_coast_guard_3/ene_coast_guard_3"] = { name = "coast_guard_3", head = head_sequences.security },
	["units/pd2_dlc_chca/characters/ene_coast_guard_4/ene_coast_guard_4"] = { name = "coast_guard_4", head = head_sequences.security },
	
	["units/pd2_dlc_chca/characters/ene_security_cruise_1/ene_security_cruise_1"] = { name = "security_cruise_1", head = head_sequences.security },
	["units/pd2_dlc_chca/characters/ene_security_cruise_2/ene_security_cruise_2"] = { name = "security_cruise_2", head = head_sequences.security },
	["units/pd2_dlc_chca/characters/ene_security_cruise_3/ene_security_cruise_3"] = { name = "security_cruise_3", head = head_sequences.security },
	
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"] = { name = "ranc_ranger_1", head = head_sequences.security },
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"] = { name = "ranc_ranger_2", head = head_sequences.security },
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"] = { name = "ranc_ranger_3", head = head_sequences.security },
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"] = { name = "ranc_ranger_4", head = head_sequences.security },
	
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01_fat/ene_male_ranc_ranger_01_fat"] = { name = "ranc_ranger_1_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02_fat/ene_male_ranc_ranger_02_fat"] = { name = "ranc_ranger_2_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03_fat/ene_male_ranc_ranger_03_fat"] = { name = "ranc_ranger_3_fat", head = head_sequences.security_fat },
	["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04_fat/ene_male_ranc_ranger_04_fat"] = { name = "ranc_ranger_4_fat", head = head_sequences.security_fat },
	
	["units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"] = { name = "marshal_security_merc_1", head = head_sequences.swat_arms_a },
	["units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"] = { name = "marshal_security_merc_1", head = head_sequences.swat_arms_c },
	["units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"] = { name = "marshal_security_merc_1", head = head_sequences.swat_arms_a },
	
	["units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy"] = { name = "bulldozer_piggy", head = head_sequences.bulldozer },
	["units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss"] = { name = "bulldozer_snowman", head = head_sequences.bulldozer },
}

return M
