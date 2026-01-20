-- Put unit names in these lists as strings, NOT Idstrings
-- Make sure there is a function
local prefix_lookup_for_humans = {
	american_cop_filtered_list = {
		func = function(self, nr_variations)
			return "l" .. nr_variations .. "d_"
		end,
		-- US Blue SWAT
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		"units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		-- US FBI SWAT
		"units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		"units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		-- US GenSec
		"units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36",
		"units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870",
		-- US Zeals
		"units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat",
		"units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy",
		"units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		-- Constantine GenSec SWATs
		"units/pd2_mod_ttr/characters/ene_fbi_gensec_1/ene_fbi_gensec_1",
		"units/pd2_mod_ttr/characters/ene_fbi_gensec_2/ene_fbi_gensec_2",
		"units/pd2_mod_ttr/characters/ene_swat_gensec_shield/ene_swat_gensec_shield",
		"units/pd2_mod_ttr/characters/ene_fbi_gensec_heavy/ene_fbi_gensec_heavy",
		"units/pd2_mod_ttr/characters/ene_fbi_gensec_heavy_r870/ene_fbi_gensec_heavy_r870",
		"units/pd2_mod_ttr/characters/ene_fbi_gensec_shield/ene_fbi_gensec_shield",
		"units/pd2_mod_ttr/characters/ene_marshal_gensec/ene_marshal_gensec",
	},
	american_cop_list = {
		func = function(self, nr_variations)
			return "l" .. nr_variations .. "n_"
		end,
		-- DC Street Cops
		"units/payday2/characters/ene_cop_1/ene_cop_1",
		"units/payday2/characters/ene_cop_2/ene_cop_2",
		"units/payday2/characters/ene_cop_3/ene_cop_3",
		"units/payday2/characters/ene_cop_4/ene_cop_4",
		"units/payday2/characters/ene_cop_1_fat/ene_cop_1_fat",
		"units/payday2/characters/ene_cop_2_fat/ene_cop_2_fat",
		"units/payday2/characters/ene_cop_3_fat/ene_cop_3_fat",
		"units/payday2/characters/ene_cop_4_fat/ene_cop_4_fat",
		-- LA Street Cops
		"units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1",
		"units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2",
		"units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3",
		"units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4",
		"units/pd2_dlc_rvd/characters/ene_la_cop_1_fat/ene_la_cop_1_fat",
		"units/pd2_dlc_rvd/characters/ene_la_cop_2_fat/ene_la_cop_2_fat",
		"units/pd2_dlc_rvd/characters/ene_la_cop_3_fat/ene_la_cop_3_fat",
		"units/pd2_dlc_rvd/characters/ene_la_cop_4_fat/ene_la_cop_4_fat",
		-- SF Street Cops
		"units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_01_fat/ene_male_chas_police_01_fat",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_02_fat/ene_male_chas_police_02_fat",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_03_fat/ene_male_chas_police_03_fat",
		"units/pd2_dlc_chas/characters/ene_male_chas_police_04_fat/ene_male_chas_police_04_fat",
		-- Coast Guard
		"units/pd2_dlc_chca/characters/ene_coast_guard_1/ene_coast_guard_1",
		"units/pd2_dlc_chca/characters/ene_coast_guard_2/ene_coast_guard_2",
		"units/pd2_dlc_chca/characters/ene_coast_guard_3/ene_coast_guard_3",
		"units/pd2_dlc_chca/characters/ene_coast_guard_4/ene_coast_guard_4",
		-- Texas Rangers
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01_fat/ene_male_ranc_ranger_01_fat",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02_fat/ene_male_ranc_ranger_02_fat",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03_fat/ene_male_ranc_ranger_03_fat",
		"units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04_fat/ene_male_ranc_ranger_04_fat",
		-- US Blue SWAT
		"units/payday2/characters/ene_swat_1/ene_swat_1",
		"units/payday2/characters/ene_swat_2/ene_swat_2",
		"units/payday2/characters/ene_swat_3/ene_swat_3",
		"units/payday2/characters/ene_sniper_1/ene_sniper_1",
		-- US FBI Agents
		"units/payday2/characters/ene_fbi_1/ene_fbi_1",
		"units/payday2/characters/ene_fbi_2/ene_fbi_2",
		"units/payday2/characters/ene_fbi_3/ene_fbi_3",
		-- US FBI SWAT
		"units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		"units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		"units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		"units/payday2/characters/ene_sniper_2/ene_sniper_2",
		-- US GenSec
		"units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
		"units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		"units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
		"units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870",
		"units/payday2/characters/ene_sniper_3/ene_sniper_3",
		-- GenSec Operators
		"units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1",
		"units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2",
		-- FBI Ready Teams
		"units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1",
		"units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2",
	},
	american_taser_list = {
		func = function(self, nr_variations)
			return "tsr_"
		end,
		"units/payday2/characters/ene_tazer_1/ene_tazer_1",
		"units/payday2/characters/ene_tazer_r870/ene_tazer_r870",
		"units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer",
	},
	american_cloaker_list = {
		func = function(self, nr_variations)
			return "clk_"
		end,
		"units/payday2/characters/ene_spook_1/ene_spook_1",
	},
	american_medic_list = {
		func = function(self, nr_variations)
			return "mdc_"
		end,
		"units/payday2/characters/ene_medic_m4/ene_medic_m4",
		"units/payday2/characters/ene_medic_r870/ene_medic_r870",
	},
	american_dozer_list = {
		func = function(self, nr_variations)
			return "bdz_"
		end,
		"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
		"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
		"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
		"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic",
		"units/pd2_dlc_drm/characters/ene_bulldozer_medic_classic/ene_bulldozer_medic_classic",
		"units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",
		"units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2",
		"units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3",
		"units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun",
		"units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic",
	},
	-- Scary gruff filtered lines, reserve for mercs and whatnot
	l5d_list = {
		func = function(self, nr_variations)
			return "l5d_"
		end,
		"units/payday2/characters/ene_city_shield/ene_city_shield",
	},
	-- list that has 3 random voices, should be used only for mercs and us soldiers
	l5n_l3n_l2n_list = {
		func = function(self, nr_variations)
			local rand = math.random()
			if rand < 0.33 then
				return "l5n_"
			elseif rand < 0.66 then
				return "l3n_"
			else
				return "l2n_"
			end
		end,
		-- Murky guards
		"units/payday2/characters/ene_murkywater_1/ene_murkywater_1",
		"units/payday2/characters/ene_murkywater_2/ene_murkywater_2",
		"units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light",
		"units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security",
		"units/pd2_dlc_des/characters/ene_murkywater_not_security_1/ene_murkywater_not_security_1",
		"units/pd2_dlc_des/characters/ene_murkywater_not_security_2/ene_murkywater_not_security_2",
		-- Bellmead guards
		"units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1",
		"units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2",
		"units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3",
		-- US Army
		"units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1",
		"units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2",
		"units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3",
		"units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4",
	},
	-- list that has 2 random voices, used only for american shields (sans GenSec Shield)
	l1d_l4d_shield_list = {
		func = function(self, nr_variations)
			local rand = math.random()
			if rand < 0.5 then
				return "l1d_"
			else
				return "l4d_"
			end
		end,
		"units/payday2/characters/ene_shield_1/ene_shield_1",
		"units/payday2/characters/ene_shield_2/ene_shield_2",
	},
	female_enemy_list = {
		func = function(self, nr_variations)
			return "fl1n_"
		end,
		-- US Street Cops
		"units/payday2/characters/ene_cop_female_1/ene_cop_female_1",
		"units/payday2/characters/ene_cop_female_2/ene_cop_female_2",
		-- Overkill MC Biker
		"units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1",
		"units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2",
		"units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3",
	},
	--[[
	russian_taser_list = {
		func = function(self, nr_variations)
			return "rtsr_"
		end,
	},
	russian_cloaker_list = {
		func = function(self, nr_variations)
			return "rclk_"
		end,
	},
	russian_medic_list = {
		func = function(self, nr_variations)
			return "rmdc_"
		end,
	},
	]]
	russian_merc_list = {
		func = function(self, nr_variations)
			return "r" .. nr_variations .. "n_"
		end,
		-- Custom stuff below
		"units/pd2_dlc_mad/characters/ene_rus_security_1/ene_rus_security_1",
		"units/pd2_dlc_mad/characters/ene_rus_security_2/ene_rus_security_2",
		"units/pd2_dlc_mad/characters/ene_rus_security_3/ene_rus_security_3",
		"units/pd2_dlc_mad/characters/ene_rus_cop_1/ene_rus_cop_1",
		"units/pd2_dlc_mad/characters/ene_rus_cop_2/ene_rus_cop_2",
		"units/pd2_dlc_mad/characters/ene_rus_cop_3_mp5/ene_rus_cop_3_mp5",
		"units/pd2_dlc_mad/characters/ene_rus_cop_3_r870/ene_rus_cop_3_r870",
		"units/pd2_dlc_mad/characters/ene_rus_cop_4_m4/ene_rus_cop_4_m4",
		"units/pd2_dlc_mad/characters/ene_rus_cop_4_r870/ene_rus_cop_4_r870",
		"units/pd2_dlc_mad/characters/ene_rus_fsb_m4/ene_rus_fsb_m4",
		"units/pd2_dlc_mad/characters/ene_rus_fsb_r870/ene_rus_fsb_r870",
		"units/pd2_dlc_mad/characters/ene_rus_fsb_heavy_m4/ene_rus_fsb_heavy_m4",
		"units/pd2_dlc_mad/characters/ene_rus_fsbcity_g36/ene_rus_fsbcity_g36",
		"units/pd2_dlc_mad/characters/ene_rus_fsbcity_r870/ene_rus_fsbcity_r870",
		"units/pd2_dlc_mad/characters/ene_rus_fsbcity_heavy_g36/ene_rus_fsbcity_heavy_g36",
		"units/pd2_dlc_mad/characters/ene_rus_fsbzeal_akmsu/ene_rus_fsbzeal_akmsu",
		"units/pd2_dlc_mad/characters/ene_rus_fsbzeal_heavy_ak47_ass/ene_rus_fsbzeal_heavy_ak47_ass",
		"units/pd2_dlc_mad/characters/ene_rus_shield_c45/ene_rus_shield_c45",
		"units/pd2_dlc_mad/characters/ene_rus_shield_sr2/ene_rus_shield_sr2",
		"units/pd2_dlc_mad/characters/ene_rus_shield_sr2_city/ene_rus_shield_sr2_city",
		"units/pd2_dlc_mad/characters/ene_rus_sniper/ene_rus_sniper",
	},
    biker_gangsters_list = {
		func = function(self, nr_variations)
			return "bik" .. nr_variations .. "_"
		end,
		"units/payday2/characters/ene_biker_1/ene_biker_1",
		"units/payday2/characters/ene_biker_2/ene_biker_2",
		"units/payday2/characters/ene_biker_3/ene_biker_3",
		"units/payday2/characters/ene_biker_4/ene_biker_4",
	},
    cobra_gangsters_list = {
		func = function(self, nr_variations)
        local level_id = Eclipse.utils.level_id()
            if level_id == "man" then
            return "l5n"
         else
			return "ict" .. nr_variations .. "_"
		end,
		"units/payday2/characters/ene_gang_black_1/ene_gang_black_1",
		"units/payday2/characters/ene_gang_black_2/ene_gang_black_2",
		"units/payday2/characters/ene_gang_black_3/ene_gang_black_3",
		"units/payday2/characters/ene_gang_black_4/ene_gang_black_4",
	},
    latin_gangsters_list = {
		func = function(self, nr_variations)
			return "lt" .. nr_variations .. "_"
		end,
        -- Regular/Mendoza gangsters
		"units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1",
		"units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2",
		"units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3",
		"units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4",
        -- Ernesto Sosa's gangsters
        "units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_01/ene_bolivian_thug_outdoor_01",
		"units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_02/ene_bolivian_thug_outdoor_02",
		"units/pd2_dlc_friend/characters/ene_thug_indoor_01/ene_thug_indoor_01",
		"units/pd2_dlc_friend/characters/ene_thug_indoor_02/ene_thug_indoor_02",
        "units/pd2_dlc_friend/characters/ene_thug_indoor_03/ene_thug_indoor_03",
		"units/pd2_dlc_friend/characters/ene_thug_indoor_04/ene_thug_indoor_04",
        "units/pd2_dlc_friend/characters/ene_security_manager/ene_security_manager",
        -- Border Crossing's gangsters
        "units/pd2_dlc_mex/characters/ene_mex_thug_outdoor_01/ene_mex_thug_outdoor_01",
		"units/pd2_dlc_mex/characters/ene_mex_thug_outdoor_02/ene_mex_thug_outdoor_02",
		"units/pd2_dlc_mex/characters/ene_mex_thug_outdoor_03/ene_mex_thug_outdoor_03",
		"units/pd2_dlc_mex/characters/ene_mex_security_guard/ene_mex_security_guard",
        "units/pd2_dlc_mex/characters/ene_mex_security_guard_2/ene_mex_security_guard_2",
		"units/pd2_dlc_mex/characters/ene_mex_security_guard_3/ene_mex_security_guard_3",
        -- Buluc's men
        "units/pd2_dlc_fex/characters/ene_guard_dog_mask/ene_guard_dog_mask",
		"units/pd2_dlc_fex/characters/ene_guard_dog_mask_no_pager/ene_guard_dog_mask_no_pager",
		"units/pd2_dlc_fex/characters/ene_guard_jaguar_mask/ene_guard_jaguar_mask",
		"units/pd2_dlc_fex/characters/ene_guard_jaguar_mask_no_pager/ene_guard_jaguar_mask_no_pager",
        "units/pd2_dlc_fex/characters/ene_guard_owl_mask/ene_guard_owl_mask",
		"units/pd2_dlc_fex/characters/ene_guard_owl_mask_no_pager/ene_guard_owl_mask_no_pager",
        "units/pd2_dlc_fex/characters/ene_guard_serpent_mask/ene_guard_serpent_mask",
		"units/pd2_dlc_fex/characters/ene_guard_serpent_mask_no_pager/ene_guard_serpent_mask_no_pager",
        "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex",
        -- Yufu Wang's men
        -- there is no chinese gangster vo so they use latin vo instead
        "units/pd2_dlc_chas/characters/ene_male_triad_gang_1/ene_male_triad_gang_1",
		"units/pd2_dlc_chas/characters/ene_male_triad_gang_2/ene_male_triad_gang_2",
		"units/pd2_dlc_chas/characters/ene_male_triad_gang_3/ene_male_triad_gang_3",
		"units/pd2_dlc_chas/characters/ene_male_triad_gang_4/ene_male_triad_gang_4",
        "units/pd2_dlc_chas/characters/ene_male_triad_gang_5/ene_male_triad_gang_5",
		"units/pd2_dlc_chca/characters/ene_triad_cruise_1/ene_triad_cruise_1",
        "units/pd2_dlc_chca/characters/ene_triad_cruise_2/ene_triad_cruise_2",
		"units/pd2_dlc_chca/characters/ene_triad_cruise_3/ene_triad_cruise_3",
        "units/pd2_dlc_pent/characters/ene_male_triad_penthouse_1/ene_male_triad_penthouse_1",
        "units/pd2_dlc_pent/characters/ene_male_triad_penthouse_2/ene_male_triad_penthouse_2",
        "units/pd2_dlc_pent/characters/ene_male_triad_penthouse_3/ene_male_triad_penthouse_3",
        "units/pd2_dlc_pent/characters/ene_male_triad_penthouse_4/ene_male_triad_penthouse_4",
	},
	russian_mobster_list = {
		func = function(self, nr_variations)
			return "rt" .. nr_variations .. "_"
		end,
		"units/payday2/characters/ene_gang_russian_1/ene_gang_russian_1",
		"units/payday2/characters/ene_gang_russian_2/ene_gang_russian_2",
		"units/payday2/characters/ene_gang_russian_3/ene_gang_russian_3",
		"units/payday2/characters/ene_gang_russian_4/ene_gang_russian_4",
		"units/payday2/characters/ene_gang_russian_5/ene_gang_russian_5",
		"units/pd2_dlc_pent/characters/ene_male_security_penthouse_1/ene_male_security_penthouse_1",
		"units/pd2_dlc_pent/characters/ene_male_security_penthouse_2/ene_male_security_penthouse_2",
		-- Custom stuff below
		"units/pd2_mod_ttr/characters/ene_gang_mobster_1_pager/ene_gang_mobster_1_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_2_pager/ene_gang_mobster_2_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_3_pager/ene_gang_mobster_3_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_4_pager/ene_gang_mobster_4_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_5/ene_gang_mobster_5",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_5_pager/ene_gang_mobster_5_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_6/ene_gang_mobster_6",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_6_pager/ene_gang_mobster_6_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_7_pager/ene_gang_mobster_7_pager",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_armored/ene_gang_mobster_armored",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_armored_2/ene_gang_mobster_armored_2",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_clubowner/ene_gang_mobster_clubowner",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_vip_1/ene_gang_mobster_vip_1",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_vip_2/ene_gang_mobster_vip_2",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_enforcer/ene_gang_mobster_enforcer",
		"units/pd2_mod_ttr/characters/ene_gang_mobster_clubsecurity/ene_gang_mobster_clubsecurity",
	},
	bexico_cop_list = {
		func = function(self, nr_variations)
			return "m" .. nr_variations .. "n_"
		end,
		-- Federales Street Cops
		"units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01",
		"units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02",
		"units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03",
		"units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04",
		-- Federales Agents
		"units/pd2_dlc_bex/characters/ene_policia_agent_01/ene_policia_agent_01",
		"units/pd2_dlc_bex/characters/ene_policia_agent_02/ene_policia_agent_02",
		"units/pd2_dlc_bex/characters/ene_policia_agent_03/ene_policia_agent_03",
		-- Cartel faction below
		"units/pd2_mod_ttr/characters/ene_cartel_commando/ene_cartel_commando",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier/ene_cartel_soldier",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_2/ene_cartel_soldier_2",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_3/ene_cartel_soldier_3",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_4/ene_cartel_soldier_4",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_shotgun_1/ene_cartel_soldier_shotgun_1",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_shotgun_2/ene_cartel_soldier_shotgun_2",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_shotgun_3/ene_cartel_soldier_shotgun_3",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_shotgun_4/ene_cartel_soldier_shotgun_4",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_heavy/ene_cartel_soldier_heavy",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_heavy_shotgun/ene_cartel_soldier_heavy_shotgun",
		"units/pd2_mod_ttr/characters/ene_cartel_shield/ene_cartel_shield",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_1/ene_cartel_soldier_fbi_1",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_2/ene_cartel_soldier_fbi_2",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_3/ene_cartel_soldier_fbi_3",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_4/ene_cartel_soldier_fbi_4",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_shotgun_1/ene_cartel_soldier_fbi_shotgun_1",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_shotgun_2/ene_cartel_soldier_fbi_shotgun_2",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_shotgun_3/ene_cartel_soldier_fbi_shotgun_3",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_fbi_shotgun_4/ene_cartel_soldier_fbi_shotgun_4",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_heavy_fbi/ene_cartel_soldier_heavy_fbi",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_heavy_fbi_shotgun/ene_cartel_soldier_heavy_fbi_shotgun",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_1/ene_cartel_soldier_city_1",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_2/ene_cartel_soldier_city_2",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_3/ene_cartel_soldier_city_3",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_4/ene_cartel_soldier_city_4",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_shotgun_1/ene_cartel_soldier_city_shotgun_1",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_shotgun_2/ene_cartel_soldier_city_shotgun_2",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_shotgun_3/ene_cartel_soldier_city_shotgun_3",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_city_shotgun_4/ene_cartel_soldier_city_shotgun_4",
		"units/pd2_mod_ttr/characters/ene_cartel_soldier_heavy_city/ene_cartel_soldier_heavy_city",
	},
	bexico_taser_list = {
		func = function(self, nr_variations)
			return "mtsr_"
		end,
		"units/pd2_mod_ttr/characters/ene_cartel_tazer/ene_cartel_tazer",
		"units/pd2_mod_ttr/characters/ene_cartel_tazer_normal/ene_cartel_tazer_normal",
	},
	bexico_cloaker_list = {
		func = function(self, nr_variations)
			return "mclk_"
		end,
		"units/pd2_mod_ttr/characters/ene_cartel_scout/ene_cartel_scout",
	},
	bexico_dozer_list = {
		func = function(self, nr_variations)
			return "mbdz_"
		end,
		"units/pd2_mod_ttr/characters/ene_cartel_bulldozer/ene_cartel_bulldozer",
		"units/pd2_mod_ttr/characters/ene_cartel_bulldozer_2/ene_cartel_bulldozer_2",
		"units/pd2_mod_ttr/characters/ene_cartel_bulldozer_3/ene_cartel_bulldozer_3",
		"units/pd2_mod_ttr/characters/ene_cartel_grenadier/ene_cartel_grenadier",
		"units/pd2_mod_ttr/characters/ene_cartel_grenadier_2/ene_cartel_grenadier_2",
	},
}

---@module Prefix Lookup By Unit Name
local M = {}
for unit_type, list in pairs(prefix_lookup_for_humans) do
	local func = list.func
	list.func = nil
	if not func then
		Eclipse:warn_console("No prefix func found for unit type %s", unit_type)
	else
		for _, unit_name in pairs(list) do
			M[Idstring(unit_name):key()] = func
			M[Idstring(unit_name .. "_husk"):key()] = func
		end
	end
end
prefix_lookup_for_humans = nil

return M
