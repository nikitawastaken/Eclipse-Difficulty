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
		"units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_tazer_hvh_r870/ene_tazer_hvh_r870",
		"units/pd2_dlc_bph/characters/ene_murkywater_tazer/ene_murkywater_tazer",
		"units/pd2_dlc_bph/characters/ene_murkywater_tazer_r870/ene_murkywater_tazer_r870",
		"units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer",
	},
	american_cloaker_list = {
		func = function(self, nr_variations)
			return "clk_"
		end,
		"units/payday2/characters/ene_spook_1/ene_spook_1",
		"units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1",
		"units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker",
	},
	american_medic_list = {
		func = function(self, nr_variations)
			return "mdc_"
		end,
		"units/payday2/characters/ene_medic_m4/ene_medic_m4",
		"units/payday2/characters/ene_medic_r870/ene_medic_r870",
		"units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4",
		"units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870",
		"units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic",
		"units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870",
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
		"units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3",
		"units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_4/ene_bulldozer_hvh_4",
		"units/pd2_dlc_hvh/characters/ene_bulldozer_medic_hvh/ene_bulldozer_medic_hvh",
		"units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1",
		"units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2",
		"units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3",
		"units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4",
		"units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic",
	},
	-- list that has 3 random voices, should be used for mercs and us soldiers
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
		-- Bellmead Mercs
		"units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1",
		"units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2",
		"units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3",
		-- US Army
		"units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1",
		"units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2",
		"units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3",
		"units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4",
		-- Murkies
		-- Murky Guards
		"units/payday2/characters/ene_murkywater_1/ene_murkywater_1",
		"units/payday2/characters/ene_murkywater_2/ene_murkywater_2",
		"units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light",
		"units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security",
		"units/pd2_dlc_des/characters/ene_murkywater_not_security_1/ene_murkywater_not_security_1",
		"units/pd2_dlc_des/characters/ene_murkywater_not_security_2/ene_murkywater_not_security_2",
		-- Murky Street Cops
		"units/pd2_dlc_bph/characters/ene_murkywater_cop_1/ene_murkywater_cop_1",
		"units/pd2_dlc_bph/characters/ene_murkywater_cop_2/ene_murkywater_cop_2",
		"units/pd2_dlc_bph/characters/ene_murkywater_cop_3/ene_murkywater_cop_3",
		"units/pd2_dlc_bph/characters/ene_murkywater_cop_4/ene_murkywater_cop_4",
		-- Murky Agents
		"units/pd2_dlc_bph/characters/ene_murkywater_agent_1/ene_murkywater_agent_1",
		"units/pd2_dlc_bph/characters/ene_murkywater_agent_2/ene_murkywater_agent_2",
		"units/pd2_dlc_bph/characters/ene_murkywater_agent_3/ene_murkywater_agent_3",
		-- Murky Blue SWAT (Recurits)
		"units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light",
		"units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870",
		"units/pd2_dlc_bph/characters/ene_murkywater_light_mp5/ene_murkywater_light_mp5",
		"units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper",
		-- Murky FBI SWAT (Soldiers)
		"units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi",
		"units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870",
		"units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5",
		"units/pd2_dlc_bph/characters/ene_murkywater_sniper_fbi/ene_murkywater_sniper_fbi",
		-- Murky GenSec (Elites)
		"units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city",
		"units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870",
		"units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5",
		"units/pd2_dlc_bph/characters/ene_murkywater_sniper_city/ene_murkywater_sniper_city",
	},
	-- ditto but radio filtered
	l5d_l3d_l2d_list = {
		func = function(self, nr_variations)
			local rand = math.random()
			if rand < 0.33 then
				return "l5d_"
			elseif rand < 0.66 then
				return "l3d_"
			else
				return "l2d_"
			end
		end,
		-- Murky Blue SWAT (Recurits)
		"units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_light",
		"units/pd2_dlc_bph/characters/ene_murkywater_heavy_r870/ene_murkywater_heavy_r870",
		-- Murky FBI SWAT (Soldiers)
		"units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi/ene_murkywater_heavy_fbi",
		"units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi_r870/ene_murkywater_heavy_fbi_r870",
		-- Murky GenSec (Elites)
		"units/pd2_dlc_bph/characters/ene_murkywater_heavy_city/ene_murkywater_heavy_city",
		"units/pd2_dlc_bph/characters/ene_murkywater_heavy_city_r870/ene_murkywater_heavy_city_r870",
	},
	-- Scary gruff filtered lines, for american elite shields
	l5d_shield_list = {
		func = function(self, nr_variations)
			return "l5d_"
		end,
		"units/payday2/characters/ene_city_shield/ene_city_shield",
		"units/pd2_dlc_bph/characters/ene_murkywater_shield_city/ene_murkywater_shield_city",
	},
	-- list that has 2 random voices, for american shields (sans elite shields)
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
		"units/pd2_dlc_bph/characters/ene_murkywater_shield_fbi/ene_murkywater_shield_fbi",
		"units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield",
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
	--[[
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
	]]
	zombie_cop_list = {
		func = function(self, nr_variations)
			return "z" .. nr_variations .. "n_"
		end,
		-- DC Street Cops
		"units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3",
		"units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4",
		-- US Blue SWAT
		"units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_swat_hvh_3/ene_swat_hvh_3",
		"units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870",
		"units/pd2_dlc_hvh/characters/ene_sniper_hvh_1/ene_sniper_hvh_1",
		-- US FBI Agents
		"units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3",
		-- US FBI SWAT
		"units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3",
		"units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",
		"units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",
		-- US GenSec
		"units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3",
		"units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_1/ene_city_heavy_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_r870/ene_city_heavy_hvh_r870",
		"units/pd2_dlc_hvh/characters/ene_sniper_hvh_3/ene_sniper_hvh_3",
	},
	zombie_shield_list = {
		func = function(self, nr_variations)
			local rand = math.random()
			if rand < 0.5 then
				return "z1n_"
			else
				return "z4n_"
			end
		end,
		"units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1",
		"units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2",
		"units/pd2_dlc_hvh/characters/ene_city_shield_hvh/ene_city_shield_hvh",
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
		-- Federales Blue SWAT
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale",
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870",
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_mp5/ene_swat_policia_federale_mp5",
		"units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale",
		"units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870",
		"units/pd2_dlc_bex/characters/ene_swat_policia_sniper/ene_swat_policia_sniper",
		-- Federales FBI SWAT
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi",
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870",
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5",
		"units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi",
		"units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870",
		"units/pd2_dlc_bex/characters/ene_swat_policia_sniper_fbi/ene_swat_policia_sniper_fbi",
		-- Federales GenSec
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city",
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870",
		"units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5",
		"units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city/ene_swat_heavy_policia_federale_city",
		"units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870",
		"units/pd2_dlc_bex/characters/ene_swat_policia_sniper_city/ene_swat_policia_sniper_city",
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
	bexico_shield_list = {
		func = function(self, nr_variations)
			local rand = math.random()
			if rand < 0.5 then
				return "m1n_"
			else
				return "m4n_"
			end
		end,
		"units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9",
		"units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45",
		"units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_city/ene_swat_shield_policia_federale_city",
	},
	bexico_taser_list = {
		func = function(self, nr_variations)
			return "mtsr_"
		end,
		"units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale",
		"units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale_r870/ene_swat_tazer_policia_federale_r870",
		-- Cartel faction below
		"units/pd2_mod_ttr/characters/ene_cartel_tazer/ene_cartel_tazer",
		"units/pd2_mod_ttr/characters/ene_cartel_tazer_normal/ene_cartel_tazer_normal",
	},
	bexico_cloaker_list = {
		func = function(self, nr_variations)
			return "mclk_"
		end,
		"units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale",
		-- Cartel faction below
		"units/pd2_mod_ttr/characters/ene_cartel_scout/ene_cartel_scout",
	},
	bexico_medic_list = {
		func = function(self, nr_variations)
			return "mmdc_"
		end,
		"units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale",
		"units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870",
	},
	bexico_dozer_list = {
		func = function(self, nr_variations)
			return "mbdz_"
		end,
		"units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870",
		"units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga",
		"units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249",
		"units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun",
		"units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale",
		-- Cartel faction below
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
