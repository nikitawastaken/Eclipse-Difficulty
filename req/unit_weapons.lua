---@module Unit Weapons
local M = {
	--Specials
	[("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"):key()] = "benelli_tank",
	[("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = "mp5",
	[("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = { "beretta92", "mp5_tactical" },
	--Misc (Scripted Murkies, Gangsters etc.)
	--Security guards
	--Regular security
	[("units/payday2/characters/ene_security_1/ene_security_1"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_2/ene_security_2"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_3/ene_security_3"):key()] = "r870", --stronger camera man
	[("units/payday2/characters/ene_security_1_fat/ene_security_1_fat"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_2_fat/ene_security_2_fat"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_3_fat/ene_security_3_fat"):key()] = "r870", --stronger camera man
	[("units/pd2_dlc_short/characters/ene_security_1_undominatable/ene_security_1_undominatable"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_short/characters/ene_security_2_undominatable/ene_security_2_undominatable"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_short/characters/ene_security_3_undominatable/ene_security_3_undominatable"):key()] = "r870", --stronger camera man
	--Mission Specific Guards
	--Big Bank
	[("units/payday2/characters/ene_security_4/ene_security_4"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_5/ene_security_5"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_6/ene_security_6"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_security_7/ene_security_7"):key()] = "r870", --stronger camera man
	--Stealing Xmas
	--fat man has bronco instead of c45
	[("units/payday2/characters/ene_security_8/ene_security_8"):key()] = { raging_bull = 3, mp5 = 1 },
	--Secret Service
	[("units/payday2/characters/ene_secret_service_1/ene_secret_service_1"):key()] = { c45 = 3, mp5 = 1 },
	[("units/payday2/characters/ene_secret_service_2/ene_secret_service_2"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_short/characters/ene_secret_service_1_undominatable/ene_secret_service_1_undominatable"):key()] = { c45 = 3, mp5 = 1 },
	--Red GenSec guards
	[("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"):key()] = { c45 = 3, ump = 1 },
	[("units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"):key()] = { g36 = 2, ump = 1 },
	--Prison guards (accurate to Hoxton Breakout's live action trailer)
	[("units/payday2/characters/ene_prisonguard_male_1/ene_prisonguard_male_1"):key()] = "m4",
	[("units/payday2/characters/ene_prisonguard_female_1/ene_prisonguard_female_1"):key()] = "c45",
	--FBI office agents
	--they have either c45 or bronco
	[("units/payday2/characters/ene_fbi_office_1/ene_fbi_office_1"):key()] = { c45 = 3, raging_bull = 1 },
	[("units/payday2/characters/ene_fbi_office_2/ene_fbi_office_2"):key()] = { c45 = 3, raging_bull = 1 },
	[("units/payday2/characters/ene_fbi_office_3/ene_fbi_office_3"):key()] = { c45 = 3, raging_bull = 1 },
	[("units/payday2/characters/ene_fbi_office_4/ene_fbi_office_4"):key()] = { c45 = 3, raging_bull = 1 },
	[("units/payday2/characters/ene_fbi_female_1/ene_fbi_female_1"):key()] = "raging_bull", --she's Riker's partner so give her bronco
	[("units/payday2/characters/ene_fbi_female_2/ene_fbi_female_2"):key()] = { c45 = 3, raging_bull = 1 },
	[("units/payday2/characters/ene_fbi_female_3/ene_fbi_female_3"):key()] = { c45 = 3, raging_bull = 1 },
	[("units/payday2/characters/ene_fbi_female_4/ene_fbi_female_4"):key()] = { c45 = 3, raging_bull = 1 },
	--fucking Alesso
	[("units/pd2_dlc_arena/characters/ene_guard_security_heavy_1/ene_guard_security_heavy_1"):key()] = { c45 = 4, mp5 = 2, deagle = 1 },
	[("units/pd2_dlc_arena/characters/ene_guard_security_heavy_2/ene_guard_security_heavy_2"):key()] = { c45 = 4, mp5 = 2, deagle = 1 },
	--casino guard gets silenced pistol
	[("units/pd2_dlc_casino/characters/ene_secret_service_1_casino/ene_secret_service_1_casino"):key()] = { beretta92 = 3, raging_bull = 1 },
	--murky sercret service
	[("units/pd2_dlc_vit/characters/ene_murkywater_secret_service/ene_murkywater_secret_service"):key()] = { c45 = 3, ump = 1 },
	--Black Cat guards
	[("units/pd2_dlc_chca/characters/ene_security_cruise_1/ene_security_cruise_1"):key()] = { beretta92 = 3, raging_bull = 1 },
	[("units/pd2_dlc_chca/characters/ene_security_cruise_2/ene_security_cruise_2"):key()] = { beretta92 = 3, raging_bull = 1 },
	[("units/pd2_dlc_chca/characters/ene_security_cruise_3/ene_security_cruise_3"):key()] = { beretta92 = 3, raging_bull = 1 },
	--Penthouse guards
	[("units/pd2_dlc_pent/characters/ene_male_security_penthouse_1/ene_male_security_penthouse_1"):key()] = { "c45", "akmsu_smg", "r870", "ak47" },
	[("units/pd2_dlc_pent/characters/ene_male_security_penthouse_2/ene_male_security_penthouse_2"):key()] = { "c45", "akmsu_smg", "r870", "ak47" },
	--Mexican guards
	[("units/pd2_dlc_bex/characters/ene_bex_security_01/ene_bex_security_01"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_bex/characters/ene_bex_security_02/ene_bex_security_02"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_bex/characters/ene_bex_security_03/ene_bex_security_03"):key()] = "r870", --stronger guard man
	[("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03"):key()] = "r870", --stronger guard man
	--Almir's breakout guards
	[("units/pd2_dlc_pex/characters/ene_male_office_cop_01/ene_male_office_cop_01"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_pex/characters/ene_male_office_cop_02/ene_male_office_cop_02"):key()] = { raging_bull = 3, r870 = 1 },
	[("units/pd2_dlc_pex/characters/ene_male_office_cop_03/ene_male_office_cop_03"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_pex/characters/ene_male_office_cop_04/ene_male_office_cop_04"):key()] = { raging_bull = 3, r870 = 1 },
	--Midland Ranch guards
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_security_1/ene_male_ranc_security_1"):key()] = { "raging_bull", "mac11", "r870", "m4" },
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_security_2/ene_male_ranc_security_2"):key()] = { "raging_bull", "mac11", "r870", "m4" },
	--Bellmead guards
	[("units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"):key()] = { deagle = 3, ump = 2, s552 = 1 },
	[("units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"):key()] = { deagle = 3, ump = 2, s552 = 1 },
	[("units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"):key()] = { deagle = 3, ump = 2, s552 = 1 },
	--FBI ready teams
	[("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"):key()] = { mp5 = 3, m4 = 2, r870 = 1 },
	[("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"):key()] = { mp5 = 3, m4 = 2, r870 = 1 },
	--Murkywater (scripted)
	[("units/payday2/characters/ene_murkywater_1/ene_murkywater_1"):key()] = { ump = 3, scar_murky = 2, benelli = 1 }, --funny benelli
	[("units/payday2/characters/ene_murkywater_2/ene_murkywater_2"):key()] = { ump = 3, scar_murky = 2, benelli = 1 },
	[("units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light"):key()] = { ump = 3, scar_murky = 2, benelli = 1 },
	[("units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security"):key()] = { ump = 3, scar_murky = 2, benelli = 1 },
	[("units/pd2_dlc_des/characters/ene_murkywater_not_security_1/ene_murkywater_not_security_1"):key()] = { ump = 3, scar_murky = 2, benelli = 1 },
	[("units/pd2_dlc_des/characters/ene_murkywater_not_security_2/ene_murkywater_not_security_2"):key()] = { ump = 3, scar_murky = 2, benelli = 1 },
	--Bosses
	--the Commissar has now rpk instead of m249
	[("units/payday2/characters/ene_gang_mobster_boss/ene_gang_mobster_boss"):key()] = "rpk_lmg",
	--Biker boss has a saiga shotgun
	[("units/pd2_dlc_born/characters/ene_gang_biker_boss/ene_gang_biker_boss"):key()] = "saiga",
	--Hector Moralez has a aa12 shotgun
	[("units/pd2_mcmansion/characters/ene_male_hector_2/ene_male_hector_2"):key()] = "aa12",
	--Riker has aa12 shotgun and is stronger than in vanilla
	[("units/payday2/characters/ene_fbi_boss_1/ene_fbi_boss_1"):key()] = "aa12",
	--Garret has bronco
	[("units/pd2_dlc_tag/characters/ene_male_commissioner/ene_male_commissioner"):key()] = "raging_bull",
	--Bikers (the Overkill MC)
	[("units/payday2/characters/ene_biker_1/ene_biker_1"):key()] = { "c45", "mac11", "mossberg", "ak47" },
	[("units/payday2/characters/ene_biker_2/ene_biker_3"):key()] = { "c45", "mac11", "mossberg", "ak47" },
	[("units/payday2/characters/ene_biker_3/ene_biker_3"):key()] = { "c45", "mac11", "mossberg", "ak47" },
	[("units/payday2/characters/ene_biker_4/ene_biker_4"):key()] = { "c45", "mac11", "mossberg", "ak47" },
	--woman bikers have broncos instead of c45
	[("units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1"):key()] = { "raging_bull", "mac11", "mossberg" },
	[("units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2"):key()] = { "raging_bull", "mac11", "mossberg" },
	[("units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3"):key()] = { "raging_bull", "mac11", "mossberg" },
	--Russian Gangsters (not to be confused with mobsters from Hotline Miami)
	--they have akmsu's instead of mac11 as their smgs
	[("units/payday2/characters/ene_gang_russian_1/ene_gang_russian_1"):key()] = { "c45", "akmsu_smg", "mossberg" },
	[("units/payday2/characters/ene_gang_russian_2/ene_gang_russian_2"):key()] = { "c45", "akmsu_smg", "mossberg" },
	[("units/payday2/characters/ene_gang_russian_3/ene_gang_russian_3"):key()] = { "c45", "akmsu_smg", "mossberg" },
	[("units/payday2/characters/ene_gang_russian_4/ene_gang_russian_4"):key()] = { "c45", "akmsu_smg", "mossberg" },
	[("units/payday2/characters/ene_gang_russian_5/ene_gang_russian_5"):key()] = { "c45", "akmsu_smg", "mossberg" },
	--Cobras (vicious pricks that even Hector's people don't deal with)
	[("units/payday2/characters/ene_gang_black_1/ene_gang_black_1"):key()] = { "c45", "mac11", "mossberg" },
	[("units/payday2/characters/ene_gang_black_2/ene_gang_black_2"):key()] = { "c45", "mac11", "mossberg" },
	[("units/payday2/characters/ene_gang_black_3/ene_gang_black_3"):key()] = { "c45", "mac11", "mossberg" },
	[("units/payday2/characters/ene_gang_black_4/ene_gang_black_4"):key()] = { "c45", "mac11", "mossberg" },
	--Mexicans (the mendoza cartel is threatning us, but this town is ours)
	--broncos instead of c45
	[("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"):key()] = { "raging_bull", "mac11", "mossberg", "ak47" },
	[("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"):key()] = { "raging_bull", "mac11", "mossberg", "ak47" },
	[("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"):key()] = { "raging_bull", "mac11", "mossberg", "ak47" },
	[("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"):key()] = { "raging_bull", "mac11", "mossberg", "ak47" },
	--Russian mobsters
	[("units/payday2/characters/ene_gang_mobster_1/ene_gang_mobster_1"):key()] = { "raging_bull", "akmsu_smg", "r870", "ak47" },
	[("units/payday2/characters/ene_gang_mobster_2/ene_gang_mobster_2"):key()] = { "raging_bull", "akmsu_smg", "r870", "ak47" },
	[("units/payday2/characters/ene_gang_mobster_3/ene_gang_mobster_3"):key()] = { "raging_bull", "akmsu_smg", "r870", "ak47" },
	[("units/payday2/characters/ene_gang_mobster_4/ene_gang_mobster_4"):key()] = { "raging_bull", "akmsu_smg", "r870", "ak47" },
	--Sosa's men
	--outdoor guards have weaker weapons while indoor ones get an upgrade
	[("units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_01/ene_bolivian_thug_outdoor_01"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_02/ene_bolivian_thug_outdoor_02"):key()] = { "c45", "mac11", "mossberg" },
	--indoor guards have an upgrade
	[("units/pd2_dlc_friend/characters/ene_thug_indoor_01/ene_thug_indoor_01"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_friend/characters/ene_thug_indoor_02/ene_thug_indoor_02"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_friend/characters/ene_thug_indoor_03/ene_thug_indoor_03"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_friend/characters/ene_thug_indoor_04/ene_thug_indoor_04"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	--security manager has bronco now
	[("units/pd2_dlc_friend/characters/ene_security_manager/ene_security_manager"):key()] = "raging_bull",
	--Border Crossing guards
	--outside guards with weaker guns
	[("units/pd2_dlc_mex/characters/ene_mex_thug_outdoor_01/ene_mex_thug_outdoor_01"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_mex/characters/ene_mex_thug_outdoor_02/ene_mex_thug_outdoor_02"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_mex/characters/ene_mex_thug_outdoor_03/ene_mex_thug_outdoor_03"):key()] = { "c45", "mac11", "mossberg" },
	--indoor guards with better guns
	[("units/pd2_dlc_mex/characters/ene_mex_security_guard/ene_mex_security_guard"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_mex/characters/ene_mex_security_guard_2/ene_mex_security_guard_2"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_mex/characters/ene_mex_security_guard_3/ene_mex_security_guard_3"):key()] = { "raging_bull", "mac11", "r870", "ak47" },
	--Buluc's Mansion guards
	[("units/pd2_dlc_fex/characters/ene_guard_dog_mask/ene_guard_dog_mask"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_dog_mask_no_pager/ene_guard_dog_mask_no_pager"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_jaguar_mask/ene_guard_jaguar_mask"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_jaguar_mask_no_pager/ene_guard_jaguar_mask_no_pager"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_owl_mask/ene_guard_owl_mask"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_owl_mask_no_pager/ene_guard_owl_mask_no_pager"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_serpent_mask/ene_guard_serpent_mask"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_guard_serpent_mask_no_pager/ene_guard_serpent_mask_no_pager"):key()] = "beretta92",
	[("units/pd2_dlc_fex/characters/ene_secret_service_fex/ene_secret_service_fex"):key()] = { c45 = 3, ump = 1 },
	[("units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex"):key()] = { "raging_bull", "mac11", "mossberg" },
	--Yufu Wang's men
	[("units/pd2_dlc_chas/characters/ene_male_triad_gang_1/ene_male_triad_gang_1"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_gang_2/ene_male_triad_gang_2"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_gang_3/ene_male_triad_gang_3"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_gang_4/ene_male_triad_gang_4"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_gang_5/ene_male_triad_gang_5"):key()] = { "c45", "mac11", "mossberg" },
	[("units/pd2_dlc_chca/characters/ene_triad_cruise_1/ene_triad_cruise_1"):key()] = { "c45", "raging_bull" },
	[("units/pd2_dlc_chca/characters/ene_triad_cruise_2/ene_triad_cruise_2"):key()] = { "c45", "raging_bull" },
	[("units/pd2_dlc_chca/characters/ene_triad_cruise_3/ene_triad_cruise_3"):key()] = { "c45", "raging_bull" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_1/ene_male_triad_penthouse_1"):key()] = { "c45", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_2/ene_male_triad_penthouse_2"):key()] = { "c45", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_3/ene_male_triad_penthouse_3"):key()] = { "c45", "mac11", "r870", "ak47" },
	[("units/pd2_dlc_chas/characters/ene_male_triad_penthouse_4/ene_male_triad_penthouse_4"):key()] = { " c45", "mac11", "r870", "ak47" },
	--The Army
	[("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1"):key()] = { c45 = 3, mp5 = 1 },
	[("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2"):key()] = { m4 = 3, benelli = 1 },
	[("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3"):key()] = "m249",
}
return M
