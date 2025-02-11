return {
    --Beat Cops
    --They only have 2 types, 1 type is using either c45 or bronco and the 2 type is using either mp5 or r870 to mimic 4 cop types
    --Will remove it once proper SFPD/Texas coppers will be made
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"):key()] = { "c45", "raging_bull" },
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"):key()] = { "mp5", "r870" },
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"):key()] = { "c45", "raging_bull" },
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"):key()] = { "mp5", "r870" },
    --Specials
    [("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = "r870_tank",
	[("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"):key()] = "aa12_tank",
	[("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"):key()] = "m249_tank",
	[("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"):key()] = "benelli_tank",
	[("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"):key()] = "benelli_tank",
    [("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = "mp5",
	[("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = { "beretta92", "mp5_tactical" },
    --Misc (Scripted Murkies, Gangsters etc.)
    --FBI ready teams
    [("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"):key()] = {"m4", "mp5"},
    [("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"):key()] = {"m4", "mp5"},
    --Murkywater (scripted)
    [("units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light"):key()] = { "ump", "scar_murky" },
    [("units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security"):key()] = { "ump", "scar_murky" },
    --Bosses
    --the Commissar has now rpk instead of m249
    [("units/payday2/characters/ene_gang_mobster_boss/ene_gang_mobster_boss"):key()] = "rpk_lmg",
    --Bikers (the Overkill MC)
    [("units/payday2/characters/ene_biker_1/ene_biker_1"):key()] = {"c45", "mac11", "mossberg", "ak47" },
    [("units/payday2/characters/ene_biker_2/ene_biker_3"):key()] = {"c45", "mac11", "mossberg", "ak47" },
    [("units/payday2/characters/ene_biker_3/ene_biker_3"):key()] = {"c45", "mac11", "mossberg", "ak47" },
    [("units/payday2/characters/ene_biker_4/ene_biker_4"):key()] = {"c45", "mac11", "mossberg", "ak47" },
    --woman bikers have broncos instead of c45
    [("units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1"):key()] = {"raging_bull", "mac11", "mossberg", "ak47" },
    [("units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2"):key()] = {"raging_bull", "mac11", "mossberg", "ak47" },
	[("units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3"):key()] = {"raging_bull", "mac11", "mossberg", "ak47" },
    --Russian Gangsters (not to be confused with mobsters from Hotline Miami)
    --they have akmsu's instead of mac11 as their smgs
    [("units/payday2/characters/ene_gang_russian_1/ene_gang_russian_1"):key()] = {"c45", "akmsu_smg", "mossberg" },
    [("units/payday2/characters/ene_gang_russian_2/ene_gang_russian_2"):key()] = {"c45", "akmsu_smg", "mossberg" },
	[("units/payday2/characters/ene_gang_russian_3/ene_gang_russian_3"):key()] = {"c45", "akmsu_smg", "mossberg" },
    [("units/payday2/characters/ene_gang_russian_4/ene_gang_russian_4"):key()] = {"c45", "akmsu_smg", "mossberg" },
    [("units/payday2/characters/ene_gang_russian_5/ene_gang_russian_5"):key()] = {"c45", "akmsu_smg", "mossberg" },
    --Cobras (vicious pricks that even Hector's people don't deal with)
    [("units/payday2/characters/ene_gang_black_1/ene_gang_black_1"):key()] = {"c45", "mac11", "mossberg" },
    [("units/payday2/characters/ene_gang_black_2/ene_gang_black_2"):key()] = {"c45", "mac11", "mossberg" },
	[("units/payday2/characters/ene_gang_black_3/ene_gang_black_3"):key()] = {"c45", "mac11", "mossberg" },
    [("units/payday2/characters/ene_gang_black_4/ene_gang_black_4"):key()] = {"c45", "mac11", "mossberg" },
    --Mexicans (the mendoza cartel is threatning us, but this town is ours)
    --broncos instead of c45
    [("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"):key()] = {"raging_bull", "akmsu_smg", "mossberg", "ak47" },
    [("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"):key()] = {"raging_bull", "akmsu_smg", "mossberg", "ak47" },
	[("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"):key()] = {"raging_bull", "akmsu_smg", "mossberg", "ak47" },
    [("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"):key()] = {"raging_bull", "akmsu_smg", "mossberg", "ak47" },
    --Sosa's men
    --outdoor guards have weaker weapons while indoor ones get an upgrade
    [("units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_01/ene_bolivian_thug_outdoor_01"):key()] = {"c45", "mac11", "mossberg"},
    [("units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_02/ene_bolivian_thug_outdoor_02"):key()] = {"c45", "mac11", "mossberg"},
    --indoor guards have an upgrade
    [("units/pd2_dlc_friend/characters/ene_thug_indoor_01/ene_thug_indoor_01"):key()] = {"raging_bull", "mac11", "r870", "ak47"},
    [("units/pd2_dlc_friend/characters/ene_thug_indoor_02/ene_thug_indoor_02"):key()] = {"raging_bull", "mac11", "r870", "ak47"},
    [("units/pd2_dlc_friend/characters/ene_thug_indoor_03/ene_thug_indoor_03"):key()] = {"raging_bull", "mac11", "r870", "ak47"},
    [("units/pd2_dlc_friend/characters/ene_thug_indoor_04/ene_thug_indoor_04"):key()] = {"raging_bull", "mac11", "r870", "ak47"},
    --security manager has bronco now
    [("units/pd2_dlc_friend/characters/ene_security_manager/ene_security_manager"):key()] = "raging_bull",
    --Yufu Wang's men
    [("units/pd2_dlc_chas/characters/ene_male_triad_gang_1/ene_male_triad_gang_1"):key()] = {"c45", "mac11", "mossberg" },
    [("units/pd2_dlc_chas/characters/ene_male_triad_gang_2/ene_male_triad_gang_2"):key()] = {"c45", "mac11", "mossberg" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_gang_3/ene_male_triad_gang_3"):key()] = {"c45", "mac11", "mossberg" },
    [("units/pd2_dlc_chas/characters/ene_male_triad_gang_4/ene_male_triad_gang_4"):key()] = {"c45", "mac11", "mossberg" },
    [("units/pd2_dlc_chas/characters/ene_male_triad_gang_5/ene_male_triad_gang_5"):key()] = {"c45", "mac11", "mossberg" },
    [("units/pd2_dlc_chca/characters/ene_triad_cruise_1/ene_triad_cruise_1"):key()] = {"c45", "raging_bull"},
	[("units/pd2_dlc_chca/characters/ene_triad_cruise_2/ene_triad_cruise_2"):key()] = {"c45", "raging_bull"},
	[("units/pd2_dlc_chca/characters/ene_triad_cruise_3/ene_triad_cruise_3"):key()] = {"c45", "raging_bull"},
    [("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_1/ene_male_triad_penthouse_1"):key()] = {"c45", "mac11", "r870", "ak47" },
    [("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_2/ene_male_triad_penthouse_2"):key()] = {"c45", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_3/ene_male_triad_penthouse_3"):key()] = {"c45", "mac11", "r870", "ak47" },
    [("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_4/ene_male_triad_penthouse_4"):key()] = {"c45", "mac11", "r870", "ak47" },
}
