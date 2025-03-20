-- Don't replace spawns on custom enemy spawner map
local level_id = Global.game_settings and Global.game_settings.level_id
if Global.editor_mode or level_id == "modders_devmap" or level_id == "Enemy_Spawner" then
	ElementSpawnEnemyDummy.chk_used_mapped_names = function() end
	ElementSpawnEnemyDummy.get_replacement_enemy_name = function() end
	ElementSpawnEnemyDummy.replace_enemy_name = function() end

	Eclipse:log("Editor/Spawner mode is active, spawn group fixes disabled")
	return
end

-- Map to correct incorrect faction spawns
ElementSpawnEnemyDummy.faction_mapping = {
	CS = {
		swat_1 = {
			"units/payday2/characters/ene_swat_1/ene_swat_1",
			"units/payday2/characters/ene_swat_3/ene_swat_3",
		},
		swat_2 = "units/payday2/characters/ene_swat_2/ene_swat_2",
		heavy_1 = "units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		heavy_2 = "units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		sniper = "units/payday2/characters/ene_sniper_1/ene_sniper_1",
		elite_sniper = "units/payday2/characters/ene_sniper_3/ene_sniper_3",
		shield = "units/payday2/characters/ene_shield_2/ene_shield_2",
		elite_shield = "units/payday2/characters/ene_city_shield/ene_city_shield",
		medic = {
			"units/payday2/characters/ene_medic_m4/ene_medic_m4",
			"units/payday2/characters/ene_medic_r870/ene_medic_r870",
		},
		taser = {
			"units/payday2/characters/ene_tazer_1/ene_tazer_1",
			"units/payday2/characters/ene_tazer_r870/ene_tazer_r870",
		},
		bulldozer = {
			"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
			"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
		},
		elite_bulldozer = {
			"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
			"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic",
		},
	},
	FBI = {
		swat_1 = {
			"units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
			"units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		},
		swat_2 = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		heavy_1 = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		heavy_2 = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		sniper = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
		elite_sniper = "units/payday2/characters/ene_sniper_3/ene_sniper_3",
		shield = "units/payday2/characters/ene_shield_1/ene_shield_1",
		elite_shield = "units/payday2/characters/ene_city_shield/ene_city_shield",
		medic = {
			"units/payday2/characters/ene_medic_m4/ene_medic_m4",
			"units/payday2/characters/ene_medic_r870/ene_medic_r870",
		},
		taser = {
			"units/payday2/characters/ene_tazer_1/ene_tazer_1",
			"units/payday2/characters/ene_tazer_r870/ene_tazer_r870",
		},
		bulldozer = {
			"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
			"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
		},
		elite_bulldozer = {
			"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
			"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic",
		},
	},
	Elite = {
		swat_1 = {
			"units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
			"units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
		},
		swat_2 = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		heavy_1 = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		heavy_2 = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		sniper = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
		elite_sniper = "units/payday2/characters/ene_sniper_3/ene_sniper_3",
		shield = "units/payday2/characters/ene_shield_1/ene_shield_1",
		elite_shield = "units/payday2/characters/ene_city_shield/ene_city_shield",
		medic = {
			"units/payday2/characters/ene_medic_m4/ene_medic_m4",
			"units/payday2/characters/ene_medic_r870/ene_medic_r870",
		},
		taser = {
			"units/payday2/characters/ene_tazer_1/ene_tazer_1",
			"units/payday2/characters/ene_tazer_r870/ene_tazer_r870",
		},
		bulldozer = {
			"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
			"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
		},
		elite_bulldozer = {
			"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
			"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic",
		},
	},
	Zeal = {
		swat_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat",
		swat_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2",
		heavy_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy",
		heavy_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2",
		shield = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		medic_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4",
		medic_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870",
		taser = "units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer",
		cloaker = "units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker",
	},
}

ElementSpawnEnemyDummy.enemy_mapping = {
	[("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = "swat_1",
	[("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = "swat_2",
	[("units/payday2/characters/ene_swat_3/ene_swat_3"):key()] = "swat_1",
	[("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = "heavy_1",
	[("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = "heavy_2",
	[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "swat_1",
	[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "swat_2",
	[("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"):key()] = "swat_1",
	[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = "heavy_1",
	[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = "heavy_2",
	[("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = "swat_1",
	[("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = "swat_2",
	[("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = "swat_2",
	[("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = "swat_1",
	[("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = "heavy_1",
	[("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = "heavy_2",
	[("units/payday2/characters/ene_sniper_1/ene_sniper_1"):key()] = "sniper",
	[("units/payday2/characters/ene_sniper_2/ene_sniper_2"):key()] = "sniper",
	[("units/payday2/characters/ene_sniper_3/ene_sniper_3"):key()] = "elite_sniper",
	[("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = "shield",
	[("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = "shield",
	[("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = "elite_shield",
	[("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = "cloaker",
	[("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = "medic",
	[("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = "medic",
	[("units/payday2/characters/ene_tazer_1/ene_tazer_1"):key()] = "taser",
	[("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"):key()] = "taser",
	[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = "bulldozer",
	[("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"):key()] = "bulldozer",
	[("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = "bulldozer",
	[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"):key()] = "bulldozer",
	[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = "bulldozer",
	[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"):key()] = "bulldozer",
	[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = "bulldozer", -- that's a green dozer
	[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"):key()] = "bulldozer", -- that's a blackdozer
	[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4"):key()] = "elite_bulldozer", -- that's a skulldozer
	[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1"):key()] = "elite_bulldozer", -- that's a minigundozer
	[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = "bulldozer",
	[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"):key()] = "bulldozer",
	[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale"):key()] = "elite_bulldozer",
	[("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45"):key()] = "shield",
	[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"):key()] = "shield",
	[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg"):key()] = "shield",
	[("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"):key()] = "shield",
	[("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"):key()] = "shield",
	[("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield"):key()] = "shield",
	[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"):key()] = "shield",
	[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"):key()] = "shield",
	[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp"):key()] = "sniper",
	[("units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2"):key()] = "sniper",
	[("units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper"):key()] = "sniper",
	[("units/pd2_dlc_bex/characters/ene_swat_policia_sniper/ene_swat_policia_sniper"):key()] = "sniper",
	[("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass"):key()] = "taser",
	[("units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1"):key()] = "taser",
	[("units/pd2_dlc_bph/characters/ene_murkywater_tazer/ene_murkywater_tazer"):key()] = "taser",
	[("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale"):key()] = "taser",
	[("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"):key()] = "cloaker",
	[("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1"):key()] = "cloaker",
	[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = "cloaker",
	[("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale"):key()] = "cloaker",
	[("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"):key()] = "medic",
	[("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"):key()] = "medic",
	[("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"):key()] = "medic",
	[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"):key()] = "medic",
	[("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"):key()] = "medic",
	[("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"):key()] = "medic",
	[("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"):key()] = "medic",
	[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"):key()] = "medic",
	[("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/ene_male_marshal_marksman_1"):key()] = "swat_1",
	[("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_1/ene_male_marshal_shield_1"):key()] = "shield",
	[("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2"):key()] = "swat_1",
	[("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_2/ene_male_marshal_shield_2"):key()] = "shield",

	--Eclipse exclusive units
	[("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1"):key()] = "soldier_1",
	[("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2"):key()] = "soldier_2",
	[("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3"):key()] = "soldier_2",
	--[("units/pd2_dlc_army/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"):key()] = "soldier_tank",
}

ElementSpawnEnemyDummy.unit_alternatives = {
	-- Fat variant alternatives
	-- Security
	[("units/payday2/characters/ene_security_1/ene_security_1"):key()] = {
		["units/payday2/characters/ene_security_1/ene_security_1"] = 4,
		["units/payday2/characters/ene_security_1_fat/ene_security_1_fat"] = 1,
	},
	[("units/payday2/characters/ene_security_2/ene_security_2"):key()] = {
		["units/payday2/characters/ene_security_2/ene_security_2"] = 4,
		["units/payday2/characters/ene_security_2_fat/ene_security_2_fat"] = 1,
	},
	[("units/payday2/characters/ene_security_3/ene_security_3"):key()] = {
		["units/payday2/characters/ene_security_3/ene_security_3"] = 3,
		["units/payday2/characters/ene_security_3_fat/ene_security_3_fat"] = 1,
	},
	-- Beat Cops
	[("units/payday2/characters/ene_cop_1/ene_cop_1"):key()] = {
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = 6,
		["units/payday2/characters/ene_cop_1_fat/ene_cop_1_fat"] = 1,
	},
	[("units/payday2/characters/ene_cop_2/ene_cop_2"):key()] = {
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = 4,
		["units/payday2/characters/ene_cop_2_fat/ene_cop_2_fat"] = 1,
	},
	[("units/payday2/characters/ene_cop_3/ene_cop_3"):key()] = {
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = 8,
		["units/payday2/characters/ene_cop_3_fat/ene_cop_3_fat"] = 1,
	},
	[("units/payday2/characters/ene_cop_4/ene_cop_4"):key()] = {
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = 6,
		["units/payday2/characters/ene_cop_4_fat/ene_cop_4_fat"] = 1,
	},
	-- LAPD Beat Cops
	[("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"] = 6,
		["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1_fat"] = 1,
	},
	[("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"] = 4,
		["units/pd2_dlc_rvd/characters/ene_la_cop_2_fat/ene_la_cop_2_fat"] = 1,
	},
	[("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"] = 8,
		["units/pd2_dlc_rvd/characters/ene_la_cop_3_fat/ene_la_cop_3_fat"] = 1,
	},
	[("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"] = 6,
		["units/pd2_dlc_rvd/characters/ene_la_cop_4_fat/ene_la_cop_4_fat"] = 1,
	},
	-- SFPD Beat Cops
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"] = 6,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01_fat"] = 1,
	},
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"] = 4,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_02_fat/ene_male_chas_police_02_fat"] = 1,
	},
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"] = 8,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_03_fat/ene_male_chas_police_03_fat"] = 1,
	},
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"] = 6,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_04_fat/ene_male_chas_police_04_fat"] = 1,
	},
	-- Texas Rangers
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"] = 6,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01_fat/ene_male_ranc_ranger_01_fat"] = 1,
	},
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"] = 4,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02_fat/ene_male_ranc_ranger_02_fat"] = 1,
	},
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"] = 4,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03_fat/ene_male_ranc_ranger_03_fat"] = 1,
	},
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"] = 4,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04_fat/ene_male_ranc_ranger_04_fat"] = 1,
	},
}

Hooks:PostHook(ElementSpawnEnemyDummy, "init", "eclipse_init", function(self)
	self._enemy_table = self._values.enemy_table
	self._values.enemy_table = nil
end)

function ElementSpawnEnemyDummy:chk_used_mapped_names(force)
	if not self._used_mapped_names or force then
		self._used_mapped_names = {}

		local function try_add_mapped_name(name)
			local mapped_name = self.enemy_mapping[name:key()]

			if mapped_name then
				self._used_mapped_names[mapped_name] = mapped_name
			end
		end

		if not self._enemy_table then
			try_add_mapped_name(self._enemy_name)
		else
			for _, name in pairs(self._enemy_table) do
				try_add_mapped_name(name)
			end
		end
	end

	return self._used_mapped_names
end

function ElementSpawnEnemyDummy:get_replacement_enemy_name(tier)
	local faction = self.faction_mapping[tier or managers.groupai:state():_get_scripted_tier()]

	if not faction then
		return nil
	end

	local used_mapped_names = self:chk_used_mapped_names()
	if not used_mapped_names or not next(used_mapped_names) then
		return nil
	end

	local add
	local enemy_table = {}
	for mapped in pairs(used_mapped_names) do
		add = faction[mapped]

		if type(add) == "table" then
			table.list_append(enemy_table, add)
		elseif add then
			table.insert(enemy_table, add)
		end
	end

	-- nil if none, non-table name if one
	if #enemy_table < 2 then
		return enemy_table[1]
	end

	return enemy_table
end

function ElementSpawnEnemyDummy:replace_enemy_name(name)
	name = name or self:get_replacement_enemy_name()

	if not name then
		return
	end

	if type(name) == "table" then
		self._enemy_table = name
		self._enemy_name = name[1]
	else
		self._enemy_table = nil
		self._enemy_name = name
	end
end

function ElementSpawnEnemyDummy:get_unit_alternative(name)
	local alternative_data = self.unit_alternatives[name:key()]

	if not alternative_data or not next(alternative_data) then
		return nil
	end

	local alternative_selector = WeightedSelector:new()
	for alt_name, alt_weight in pairs(alternative_data) do
		alternative_selector:add(alt_name, alt_weight)
	end

	return Idstring(alternative_selector:select())
end

local access_replacement = {
	cop = "fbi",
}

local produce_original = ElementSpawnEnemyDummy.produce
function ElementSpawnEnemyDummy:produce(params, ...)
	-- give assault-spawned beat cops fbi access to keep them from getting stuck
	if params and params.name then
		params.name = self:get_unit_alternative(params.name) or params.name

		local unit = produce_original(self, params, ...)
		local u_brain = alive(unit) and unit:brain()
		local logic_data = u_brain and u_brain._logic_data
		local replace_access = access_replacement[logic_data and logic_data.SO_access_str]
		local converted_access = replace_access and managers.navigation:convert_access_flag(replace_access)
		if converted_access then
			u_brain._SO_access = converted_access
			logic_data.SO_access = converted_access
			logic_data.SO_access_str = replace_access
		end

		return unit
	end

	if self._enemy_table then
		local new_enemy_name = table.random(self._enemy_table)

		-- Idstring on an Idstring crashes
		-- TODO: redo mission script patches to use string enemy names rather than Idstrings
		if type(new_enemy_name) == "userdata" then
			self._enemy_name = new_enemy_name
		elseif new_enemy_name then
			self._enemy_name = Idstring(new_enemy_name)
		end
	end

	local original_enemy_name = self._enemy_name
	self._enemy_name = self:get_unit_alternative(original_enemy_name) or original_enemy_name

	local unit = produce_original(self, params, ...)

	self._enemy_name = original_enemy_name

	return unit
end
