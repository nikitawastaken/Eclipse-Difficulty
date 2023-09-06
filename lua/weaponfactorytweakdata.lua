Hooks:PostHook(WeaponFactoryTweakData, "init", "eclipse__init", function(self)
	-- Shotguns
	-- 000
	self.parts.wpn_fps_upg_a_custom.custom_stats = { rays = 6, optimal_distance_addend = 310, near_falloff_addend = 110, damage_near_mul = 0.5, damage_far_mul = 0.85 }
	self.parts.wpn_fps_upg_a_custom_free.custom_stats = self.parts.wpn_fps_upg_a_custom.custom_stats
	self.parts.wpn_fps_upg_a_custom.stats.damage = 5
	self.parts.wpn_fps_upg_a_custom.stats.total_ammo_mod = -6
	self.parts.wpn_fps_upg_a_custom.stats.recoil = -2
	self.parts.wpn_fps_upg_a_custom_free.stats = self.parts.wpn_fps_upg_a_custom.stats
	-- Flechette
	self.parts.wpn_fps_upg_a_piercing.stats.damage = -8
	self.parts.wpn_fps_upg_a_piercing.stats.suppression = 11
	self.parts.wpn_fps_upg_a_piercing.custom_stats = { rays = 12, armor_piercing_add = 1, damage_near_mul = 1.5, damage_far_mul = 1.5 }
	-- AP Slug
	self.parts.wpn_fps_upg_a_slug.stats.total_ammo_mod = -4
	self.parts.wpn_fps_upg_a_slug.stats.spread = 6
	self.parts.wpn_fps_upg_a_slug.stats.recoil = -2
	-- HE Slug
	self.parts.wpn_fps_upg_a_explosive.stats.total_ammo_mod = -8
	self.parts.wpn_fps_upg_a_explosive.stats.damage = 30
	self.parts.wpn_fps_upg_a_explosive.stats.spread = 4
	self.parts.wpn_fps_upg_a_explosive.custom_stats =
		{ ignore_statistic = true, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8, bullet_class = "InstantExplosiveBulletBase", rays = 1, damage_near_mul = 10 }
	-- DB
	self.parts.wpn_fps_upg_a_dragons_breath.stats.total_ammo_mod = -8
	self.parts.wpn_fps_upg_a_dragons_breath.custom_stats.ammo_pickup_max_mul = 0.85
	self.parts.wpn_fps_upg_a_dragons_breath.custom_stats.ammo_pickup_min_mul = 0.85
	self.parts.wpn_fps_upg_a_dragons_breath.custom_stats.fire_dot_data = { dot_trigger_chance = "100", dot_damage = "3", dot_length = "4", dot_trigger_max_distance = "1500", dot_tick_period = "0.25" }
	-- Shell Rack for loco and r880
	self.parts.wpn_fps_shot_r870_body_rack.stats.reload = 2
	self.parts.wpn_fps_shot_r870_body_rack.stats.total_ammo_mod = 0
	self.parts.wpn_fps_shot_r870_body_rack.stats.recoil = -2
	self.parts.wpn_fps_shot_r870_body_rack.stats.concealment = -1
	-- Extended Mag for loco and r880
	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.concealment = -2
	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.recoil = -2
	self.parts.wpn_fps_shot_r870_m_extended.stats.concealment = -2
	self.parts.wpn_fps_shot_r870_m_extended.stats.recoil = -2
	-- extended barrel for raven
	self.parts.wpn_fps_sho_ksg_b_long.stats.extra_ammo = 1
	-- remove stat overrides
	self.wpn_fps_shot_huntsman.override.wpn_fps_upg_a_explosive = nil
	self.wpn_fps_shot_huntsman.override.wpn_fps_upg_a_slug = nil
	self.wpn_fps_shot_b682.override.wpn_fps_upg_a_explosive = nil
	self.wpn_fps_sho_coach.override.wpn_fps_upg_a_explosive = nil
	self.wpn_fps_pis_judge.override.wpn_fps_upg_a_explosive = nil
	self.wpn_fps_pis_judge.override.wpn_fps_upg_a_piercing = nil
	self.wpn_fps_pis_x_judge.override.wpn_fps_upg_a_explosive = nil
	self.wpn_fps_pis_x_judge.override.wpn_fps_upg_a_piercing = nil
	self.wpn_fps_sho_striker.override.wpn_fps_upg_a_slug = nil
	self.wpn_fps_sho_striker.override.wpn_fps_upg_a_custom = nil
	self.wpn_fps_sho_striker.override.wpn_fps_upg_a_custom_free = nil

	-- Secondary Sights
	self.parts.wpn_fps_upg_o_sig.stats.recoil = 0
	self.parts.wpn_fps_upg_o_45rds.stats.recoil = 0
	self.parts.wpn_fps_upg_o_45rds_v2.stats.recoil = 0
	self.parts.wpn_fps_upg_o_45steel.stats.concealment = 0
	self.parts.wpn_fps_upg_o_xpsg33_magnifier.stats.recoil = 0

	-- Weapon-Specific Stuff
	-- Saiga stuff
	self.parts.wpn_fps_sho_basset_m_extended.stats.reload = -2
	self.parts.wpn_fps_sho_saiga_b_short.stats.recoil = -2
	self.parts.wpn_fps_sho_saiga_b_short.stats.concealment = 2
	self.parts.wpn_fps_sho_saiga_fg_holy.stats.recoil = -2
	self.parts.wpn_fps_sho_saiga_fg_holy.stats.concealment = 2
	-- mp5 straight mag
	self.parts.wpn_fps_smg_mp5_m_straight.stats.total_ammo_mod = -5
	self.parts.wpn_fps_smg_mp5_m_straight.custom_stats = { ammo_pickup_max_mul = 0.8 }
	-- union short barrel
	self.parts.wpn_fps_ass_corgi_b_short.stats.spread = -1
	-- bipod nerf
	self.parts.wpn_fps_upg_bp_lmg_lionbipod.stats.recoil = -1
	-- Commando 553 modifications
	self.parts.wpn_fps_ass_s552_body_standard_black.stats = { spread = 0, recoil = -2, concealment = 2 }
	self.parts.wpn_fps_ass_s552_b_long.stats = { spread = 2, concealment = -2 }
	self.parts.wpn_fps_ass_s552_fg_standard_green.stats = { concealment = 2, spread = -1, recoil = -1 }
	self.parts.wpn_fps_ass_s552_fg_railed.stats = { concealment = -3, recoil = 2, spread = 2 }
	self.parts.wpn_fps_ass_s552_g_standard_green.stats = { spread = 1, recoil = 1 }
	-- Falcon modifications
	self.parts.wpn_fps_ass_fal_s_01.stats = { recoil = -2, concealment = 2 }
	self.parts.wpn_fps_ass_fal_s_wood.stats = { recoil = 3, concealment = -2 }
	self.parts.wpn_fps_ass_fal_g_01.stats = { recoil = 1, spread = -2, concealment = 2 }
	-- Akron stuff
	self.parts.wpn_fps_lmg_hcar_barrel_dmr.stats = { extra_ammo = -5, total_ammo_mod = -10, damage = 20, value = 3 }
	self.parts.wpn_fps_lmg_hcar_barrel_dmr.custom_stats = { ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 }
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats = { extra_ammo = 40, total_ammo_mod = 20, damage = -40, value = 1, spread = 1, recoil = 1, fire_rate = 1.667 }
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats = { ammo_pickup_max_mul = 2.25, ammo_pickup_min_mul = 2.25, fire_rate_multiplier = 1.667 }
	-- campbell stuff
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats = { spread = 1, recoil = -1 }
	self.parts.wpn_fps_lmg_kacchainsaw_b_short.stats = { spread = -1, recoil = 1 }
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats = { damage = 40, recoil = -2, spread = 2 }
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.custom_stats = { fire_rate_multiplier = 0.6, ammo_pickup_max_mul = 0.83 }

	-- Weapon Magazines

	-- Speedpull
	self.parts.wpn_fps_m4_upg_m_quick.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_upg_ak_m_quick.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_ass_g36_m_quick.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_ass_aug_m_quick.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_smg_sr2_m_quick.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_smg_mac10_m_quick.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_smg_p90_m_strap.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_smg_fmg9_m_speed.stats = { concealment = -1, reload = 1 }
	self.parts.wpn_fps_snp_awp_m_speed.stats = { concealment = -1, reload = 1 }
	-- L5
	self.parts.wpn_fps_upg_m4_m_l5.stats = { concealment = -1, recoil = 1 }
	-- Expert
	self.parts.wpn_fps_ass_l85a2_m_emag.stats = { concealment = -1, spread = 1 }
	-- Quad
	self.parts.wpn_fps_upg_m4_m_quad.stats = { extra_ammo = 15, reload = -2, concealment = -3 }
	self.parts.wpn_fps_upg_ak_m_quad.stats = { extra_ammo = 15, reload = -2, concealment = -3 }
	-- Tactical
	self.parts.wpn_fps_upg_m4_m_pmag.stats = { value = 2, concealment = -2, recoil = 1, spread = 1 }
	-- Vintage
	self.parts.wpn_fps_upg_m4_m_straight.stats = { concealment = 1, extra_ammo = -3 }
	-- Milspec
	self.parts.wpn_fps_m4_uupg_m_std.stats = { concealment = -1, extra_ammo = 3 }
	-- Low Drag
	self.parts.wpn_fps_upg_ak_m_uspalm.stats = { concealment = -2, recoil = 1, spread = 1 }
	-- Extended Falcon
	self.parts.wpn_fps_ass_fal_m_01.stats = { extra_ammo = 10, concealment = -2 }
	-- Extended Kang Arms
	self.parts.wpn_fps_snp_qbu88_m_extended.stats = { concealment = -2, extra_ammo = 5 }
	-- CE Extender
	self.parts.wpn_fps_sho_m590_b_long.stats = { extra_ammo = 1, concealment = -2 }
	-- Signature SMG extended
	self.parts.wpn_fps_smg_shepheard_mag_extended.stats = { extra_ammo = 5, concealment = -1 }

	-- Gadgets
	-- Military Laser module
	self.parts.wpn_fps_upg_fl_ass_peq15.stats.recoil = 0
	self.parts.wpn_fps_upg_fl_ass_peq15.stats.spread = 2
	-- Tactical Laser module
	self.parts.wpn_fps_upg_fl_ass_smg_sho_peqbox.stats.concealment = 0
	-- Assault Light
	self.parts.wpn_fps_upg_fl_ass_smg_sho_surefire.stats.concealment = 0
	-- extra mag for stryk
	self.parts.wpn_fps_pis_g18c_m_mag_33rnd.stats.reload = -1
	self.wpn_fps_pis_x_g18c.override.wpn_fps_pis_g18c_m_mag_33rnd.stats.reload = -1
	self.parts.wpn_fps_pis_czech_m_extended.stats.reload = -1
	self.wpn_fps_pis_x_czech.override.wpn_fps_pis_czech_m_extended.stats.reload = -1

	-- Conversion kits
	-- ak family
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats = { ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.375 }
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.total_ammo_mod = -7
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.concealment = -6
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -8
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 87
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.custom_stats = { ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.25 }
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.total_ammo_mod = -10
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.concealment = -7
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -11
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 105
	-- car family
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = { ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.1875 }
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.total_ammo_mod = -12
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.concealment = -7
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -11
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 117
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = { ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.375 }
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.total_ammo_mod = -7
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.concealment = -6
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -8
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 87
	-- m308 b-stock
	self.parts.wpn_fps_ass_m14_body_ruger.stats.concealment = 8
	-- gewehr
	self.parts.wpn_fps_ass_g3_b_sniper.custom_stats = { ammo_pickup_min_mul = 1.25, ammo_pickup_max_mul = 0.5 }
	self.parts.wpn_fps_ass_g3_b_sniper.stats.total_ammo_mod = -8
	self.parts.wpn_fps_ass_g3_b_sniper.stats.concealment = -5
	self.parts.wpn_fps_ass_g3_b_sniper.stats.recoil = -11
	self.parts.wpn_fps_ass_g3_b_sniper.stats.damage = 85
	self.parts.wpn_fps_ass_g3_b_short.stats.total_ammo_mod = 11
	self.parts.wpn_fps_ass_g3_b_short.custom_stats = { ammo_pickup_max_mul = 2 }
	-- broomstick
	self.parts.wpn_fps_pis_c96_b_long.custom_stats = { ammo_pickup_min_mul = 0.33, ammo_pickup_max_mul = 0.5 }
	-- ks12
	self.parts.wpn_fps_ass_shak12_body_vks.stats.damage = 64
	self.parts.wpn_fps_ass_shak12_body_vks.stats.concealment = -6
	self.parts.wpn_fps_ass_shak12_body_vks.stats.recoil = -8
	self.parts.wpn_fps_ass_shak12_body_vks.stats.total_ammo_mod = -10
	self.parts.wpn_fps_ass_shak12_body_vks.stats.fire_rate = -3
	self.parts.wpn_fps_ass_shak12_body_vks.custom_stats = { ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.25 }
	self.parts.wpn_fps_ass_shak12_body_vks.custom_stats.fire_rate_multiplier = 0.7
	-- wasp exclusive kit
	self.parts.wpn_fps_smg_fmg9_conversion.stats.recoil = 1
	self.parts.wpn_fps_smg_fmg9_conversion.stats.spread = 1
	-- awp exclusive kits
	self.parts.wpn_fps_snp_awp_conversion_dragonlore.stats = {}
	self.parts.wpn_fps_snp_awp_conversion_dragonlore.custom_stats = {}
	self.parts.wpn_fps_snp_awp_conversion_wildlands.stats = {}

	-- mcshay pack
	self.parts.wpn_fps_upg_ak_body_upperreceiver_zenitco.stats = { value = 3, concealment = -1, damage = 3, spread = -2 }
	self.parts.wpn_fps_m4_uupg_m_strike.stats = { value = 1, extra_ammo = 4, concealment = -2 }
	self.parts.wpn_fps_m4_uupg_upper_radian.stats = { value = 3, spread = 1, recoil = 2 }
	self.parts.wpn_fps_m4_uupg_lower_radian.stats = { value = 1, recoil = 1 }
	self.parts.wpn_fps_uupg_fg_radian.stats = { value = 1, recoil = 2, spread = 1, damage = 2, concealment = -1 }
	self.parts.wpn_fps_m4_uupg_g_billet.stats = { value = 6, spread = 1, recoil = 1 }
	self.parts.wpn_fps_upg_ak_ns_zenitco.stats = { value = 1, concealment = -1, damage = 3, spread = 2, recoil = 1 }
	self.wpn_fps_ass_m16.override.wpn_fps_uupg_fg_radian = { stats = { recoil = 1, concealment = 2 } }

	-- Specials

	-- Flamethrower Tanks
	-- Rare
	self.parts.wpn_fps_fla_mk2_mag_rare.stats.damage = -10
	self.parts.wpn_fps_fla_mk2_mag_rare.stats.concealment = 3
	self.parts.wpn_fps_fla_mk2_mag_rare.custom_stats = { ammo_pickup_max_mul = 1.65, ammo_pickup_min_mul = 1.25 }
	self.parts.wpn_fps_fla_mk2_mag_rare.desc_id = "bm_wp_upg_mk2_rare_desc"
	self.parts.wpn_fps_fla_mk2_mag_rare.has_description = true
	-- Well Done
	self.parts.wpn_fps_fla_mk2_mag_welldone.stats.damage = 10
	self.parts.wpn_fps_fla_mk2_mag_welldone.stats.concealment = -3
	self.parts.wpn_fps_fla_mk2_mag_welldone.custom_stats = { ammo_pickup_max_mul = 1, ammo_pickup_min_mul = 0.75 }
	self.parts.wpn_fps_fla_mk2_mag_welldone.desc_id = "bm_wp_upg_mk2_welldone_desc"
	self.parts.wpn_fps_fla_mk2_mag_welldone.has_description = true

	-- Arrows
	self.parts.wpn_fps_bow_frankish_m_explosive.stats.damage = 0
	self.parts.wpn_fps_bow_frankish_m_poison.stats = { damage = -40 }
	self.parts.wpn_fps_upg_a_crossbow_explosion.stats.damage = 0
	self.parts.wpn_fps_upg_a_crossbow_poison.stats = { damage = -25 }
	self.parts.wpn_fps_bow_ecp_m_arrows_explosive.stats.damage = 0
	self.parts.wpn_fps_bow_ecp_m_arrows_poison.stats = { damage = -15 }
	self.parts.wpn_fps_upg_a_bow_explosion.stats.damage = 0
	self.parts.wpn_fps_upg_a_bow_poison.stats = { damage = -55 }
	self.parts.wpn_fps_bow_arblast_m_explosive.stats.damage = 0 -- apparently none of this matters cause of some vanilla bs
	self.parts.wpn_fps_bow_arblast_m_poison.stats = { damage = -20 } -- same thing

	-- Barrel Extentions

	-- Suppressors
	-- Medium & Rami
	self.parts.wpn_fps_upg_ns_ass_smg_medium.stats = { alert_size = 12, damage = -3, recoil = 1, spread = 1, concealment = -1 }
	self.parts.wpn_fps_lmg_kacchainsaw_ns_suppressor.stats = { alert_size = 12, damage = -3, recoil = 1, spread = 1, concealment = -1 }
	-- PBS
	self.parts.wpn_fps_upg_ns_ass_pbs1.stats.spread = 2
	self.parts.wpn_fps_upg_ns_ass_pbs1.stats.concealment = -3
	-- Tooth Fairy (cavity)
	self.parts.wpn_fps_ass_sub2000_fg_suppressed.stats.damage = -5
	-- KS12-S Long Silencer
	self.parts.wpn_fps_ass_shak12_ns_suppressor.stats.damage = -3
	-- K-B100 Suppressor (ketchnov)
	self.parts.wpn_fps_ass_groza_b_supressor.stats.damage = -1
	-- Silent Killer
	self.parts.wpn_fps_upg_ns_shot_thick.stats.damage = -2
	-- Shh
	self.parts.wpn_fps_upg_ns_sho_salvo_large.stats.damage = -2
	-- Silenced Barrel (lion's roar)
	self.parts.wpn_fps_ass_vhs_b_silenced.stats.damage = -2
	-- Stealth Barrel (car-4)
	self.parts.wpn_fps_m4_uupg_b_sd.stats.damage = -3
	-- Suppressed Barrel (steakout)
	self.parts.wpn_fps_sho_aa12_barrel_silenced.stats.damage = -2
	-- CE Muffler (mosconi12g)
	self.parts.wpn_fps_sho_m590_b_suppressor.stats.damage = -3
	-- Sniper Suppressor (rattlesnake)
	self.parts.wpn_fps_snp_msr_ns_suppressor.stats.damage = -5
	-- Medium Barrel (r700 supp)
	self.parts.wpn_fps_snp_r700_b_medium.stats.damage = -5
	-- Wind Whistler Barrel (rangehitter)
	self.parts.wpn_fps_snp_sbl_b_short.stats.damage = -3
	-- Beak Suppressor (platypus)
	self.parts.wpn_fps_snp_model70_ns_suppressor.stats.damage = -3
	-- Gedämpfter Barrel (lebensauger)
	self.parts.wpn_fps_snp_wa2000_b_suppressed.stats.damage = -3
	-- Silenced Barrel (desert fox)
	self.parts.wpn_fps_snp_desertfox_b_silencer.stats.damage = -3
	-- Contractor Silencer
	self.parts.wpn_fps_snp_tti_ns_hex.stats.damage = -3
	-- Compensated Suppressor (r93)
	self.parts.wpn_fps_snp_r93_b_suppressed.stats.damage = -3
	-- Outlaw's Silened Barrel (repeater)
	self.parts.wpn_fps_snp_winchester_b_suppressed.stats.damage = -5
	-- Tikho Barrel (grom)
	self.parts.wpn_fps_snp_siltstone_b_silenced.stats.damage = -5
	-- Silenced Barrel (nagant)
	self.parts.wpn_fps_snp_mosin_b_sniper.stats.damage = -3
	-- Suppressed Barrel (thanatos)
	self.parts.wpn_fps_snp_m95_barrel_suppressed.stats.damage = -10
	-- Roctec
	self.parts.wpn_fps_upg_ns_pis_medium_gem.stats.damage = -2
	-- Champion's
	self.parts.wpn_fps_upg_ns_pis_large_kac.stats.damage = -2
	-- Standard issue
	self.parts.wpn_fps_upg_ns_pis_medium.stats.damage = -2
	-- Size doesn't matter
	self.parts.wpn_fps_upg_ns_pis_small.stats.damage = -3
	-- Monolith
	self.parts.wpn_fps_upg_ns_pis_large.stats.damage = -2
	-- Asepsis
	self.parts.wpn_fps_upg_ns_pis_medium_slim.stats.damage = -2
	-- Budget
	self.parts.wpn_fps_upg_ns_ass_filter.stats.damage = -2
	-- Jungle Ninja
	self.parts.wpn_fps_upg_ns_pis_jungle.stats.damage = -3
	-- Ninja Barrel (mp5)
	self.parts.wpn_fps_smg_mp5_fg_mp5sd.stats.damage = -2
	-- Silentgear (jackal)
	self.parts.wpn_fps_smg_schakal_ns_silencer.stats.damage = -2
	-- BY90 Wide (akgen)
	self.parts.wpn_fps_smg_vityaz_b_supressed.stats.damage = -2
	-- Silenced Barrel (streetsweeper)
	self.parts.wpn_fps_sho_striker_b_suppressed.stats.damage = -2
	-- Silenced Barrel (goliath)
	self.parts.wpn_fps_sho_rota_b_silencer.stats.damage = -3

	-- Compensators / Nozzles / Muzzles
	-- Stubby
	self.parts.wpn_fps_upg_ns_ass_smg_stubby.stats.damage = 3
	self.parts.wpn_fps_upg_ns_ass_smg_stubby.stats.spread = 3
	self.parts.wpn_fps_upg_ns_ass_smg_stubby.stats.concealment = -1
	-- Tank
	self.parts.wpn_fps_upg_ns_ass_smg_tank.stats.damage = 2
	self.parts.wpn_fps_upg_ns_ass_smg_tank.stats.recoil = 3
	self.parts.wpn_fps_upg_ns_ass_smg_tank.stats.spread = 3
	-- Fire Breather
	self.parts.wpn_fps_upg_ns_ass_smg_firepig.stats.spread = 2
	self.parts.wpn_fps_upg_ns_ass_smg_firepig.stats.recoil = 3
	self.parts.wpn_fps_upg_ns_ass_smg_firepig.stats.suppression = -9
	-- Competitors Compensator
	self.parts.wpn_fps_upg_ass_ns_jprifles.stats.spread = 2
	self.parts.wpn_fps_upg_ass_ns_jprifles.stats.recoil = 4
	-- Funnel of Fun
	self.parts.wpn_fps_upg_ass_ns_linear.stats.recoil = 2
	self.parts.wpn_fps_upg_ass_ns_linear.stats.spread = 2
	self.parts.wpn_fps_upg_ass_ns_linear.stats.suppression = -9
	-- Tactical
	self.parts.wpn_fps_upg_ass_ns_surefire.stats.recoil = 2
	self.parts.wpn_fps_upg_ass_ns_surefire.stats.spread = 4
	self.parts.wpn_fps_upg_ass_ns_surefire.stats.suppression = -1
	-- Ported
	self.parts.wpn_fps_upg_ass_ns_battle.stats.concealment = 0
	self.parts.wpn_fps_upg_ass_ns_battle.stats.recoil = 2
	self.parts.wpn_fps_upg_ass_ns_battle.stats.spread = 2
	self.parts.wpn_fps_upg_ass_ns_battle.stats.damage = -3
	-- Marmon
	self.parts.wpn_fps_upg_ns_ass_smg_v6.stats.concealment = -2
	self.parts.wpn_fps_upg_ns_ass_smg_v6.stats.recoil = 3
	self.parts.wpn_fps_upg_ns_ass_smg_v6.stats.spread = 3
	-- KS12-A Burst Muzzle
	self.parts.wpn_fps_ass_shak12_ns_muzzle.stats.concealment = 0
	self.parts.wpn_fps_ass_shak12_ns_muzzle.stats.suppression = -7
	-- DHL
	self.parts.wpn_fps_upg_ns_duck.stats.recoil = -3
	self.parts.wpn_fps_upg_ns_duck.stats.suppression = -5
	self.parts.wpn_fps_upg_ns_duck.stats.concealment = -4
	-- hailstorm loud ext
	self.parts.wpn_fps_hailstorm_b_extended.stats = { value = 1, concealment = -2, damage = 1, spread = 3, recoil = 2 }

	-- misc
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_autofire")
	table.delete(self.wpn_fps_gre_ms3gl.uses_parts, "wpn_fps_gre_ms3gl_conversion")
	table.insert(self.parts.wpn_fps_smg_fmg9_conversion.forbids, "wpn_fps_lmg_hk51b_ns_jcomp")
	local weapons = {
		"wpn_fps_shot_saiga",
		"wpn_fps_shot_r870",
		"wpn_fps_shot_huntsman",
		"wpn_fps_shot_serbu",
		"wpn_fps_sho_ben",
		"wpn_fps_sho_striker",
		"wpn_fps_sho_ksg",
		"wpn_fps_pis_judge",
		"wpn_fps_sho_spas12",
		"wpn_fps_shot_b682",
		"wpn_fps_sho_aa12",
		"wpn_fps_sho_boot",
		"wpn_fps_shot_m37",
		"wpn_fps_shot_m1897",
		"wpn_fps_sho_m590",
		"wpn_fps_sho_rota",
		"wpn_fps_sho_basset",
		"wpn_fps_sho_x_basset",
		"wpn_fps_pis_x_judge",
		"wpn_fps_sho_x_rota",
		"wpn_fps_sho_coach",
		"wpn_fps_sho_ultima",
		"wpn_fps_sho_sko12",
		"wpn_fps_sho_x_sko12",
	}
	for _, factory_id in ipairs(weapons) do
		if self[factory_id] and self[factory_id].uses_parts then
			table.delete(self[factory_id].uses_parts, "wpn_fps_upg_a_rip") -- fuck tombstone
		end
	end
end)

-- Gun Perks replace stat boosts
function WeaponFactoryTweakData:create_bonuses(tweak_data, weapon_skins)
	self.parts.wpn_fps_upg_perk_template = {
		custom = true,
		exclude_from_challenge = true,
		texture_bundle_folder = "gunperk",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		has_description = true,
		a_obj = "a_body",
		type = "bonus",
		name_id = nil,
		desc_id = nil,
		sub_type = "bonus_stats",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		pcs = {
			10,
			20,
			30,
			40,
		},
		stats = {},
		custom_stats = {},
		perks = {
			"bonus",
		},
	}

	-- speedloader
	self.parts.wpn_fps_upg_perk_speedloader = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_speedloader.name_id = "bm_menu_perk_speedloader"
	self.parts.wpn_fps_upg_perk_speedloader.desc_id = "bm_menu_perk_speedloader_desc"
	self.parts.wpn_fps_upg_perk_speedloader.stats = { reload = 2, total_ammo_mod = -5 }

	-- haste
	self.parts.wpn_fps_upg_perk_haste = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_haste.name_id = "bm_menu_perk_haste"
	self.parts.wpn_fps_upg_perk_haste.desc_id = "bm_menu_perk_haste_desc"
	self.parts.wpn_fps_upg_perk_haste.stats = { total_ammo_mod = -3 }
	self.parts.wpn_fps_upg_perk_haste.custom_stats = { movement_speed = 1.1 }

	-- dead silence
	self.parts.wpn_fps_upg_perk_deadsilence = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_deadsilence.name_id = "bm_menu_perk_deadsilence"
	self.parts.wpn_fps_upg_perk_deadsilence.desc_id = "bm_menu_perk_deadsilence_desc"
	self.parts.wpn_fps_upg_perk_deadsilence.stats = { concealment = 3, total_ammo_mod = -3, recoil = -1, spread = -1 }

	-- jawbreaker
	self.parts.wpn_fps_upg_perk_jawbreaker = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_jawbreaker.name_id = "bm_menu_perk_jawbreaker"
	self.parts.wpn_fps_upg_perk_jawbreaker.desc_id = "bm_menu_perk_jawbreaker_desc"
	self.parts.wpn_fps_upg_perk_jawbreaker.stats = { damage = 15, fire_rate = 0.85 }
	self.parts.wpn_fps_upg_perk_jawbreaker.custom_stats = { ammo_pickup_max_mul = 0.75, ammo_pickup_min_mul = 0.75, fire_rate_multiplier = 0.85 }

	-- whirlwind
	self.parts.wpn_fps_upg_perk_whirlwind = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_whirlwind.name_id = "bm_menu_perk_whirlwind"
	self.parts.wpn_fps_upg_perk_whirlwind.desc_id = "bm_menu_perk_whirlwind_desc"
	self.parts.wpn_fps_upg_perk_whirlwind.stats = { recoil = -3, spread = -1, fire_rate = 1.15 }
	self.parts.wpn_fps_upg_perk_whirlwind.custom_stats = { fire_rate_multiplier = 1.15 }

	-- stockpile
	self.parts.wpn_fps_upg_perk_stockpile = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_stockpile.name_id = "bm_menu_perk_stockpile"
	self.parts.wpn_fps_upg_perk_stockpile.desc_id = "bm_menu_perk_stockpile_desc"
	self.parts.wpn_fps_upg_perk_stockpile.stats = { total_ammo_mod = 5, reload = -3 }

	local uses_parts = {
		wpn_fps_upg_perk_speedloader = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		wpn_fps_upg_perk_haste = { category = { "assault_rifle", "smg", "snp", "shotgun", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		wpn_fps_upg_perk_deadsilence = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg" } },
		wpn_fps_upg_perk_jawbreaker = { category = { "assault_rifle", "smg", "snp", "shotgun", "pistol", "minigun", "akimbo", "lmg" } },
		wpn_fps_upg_perk_whirlwind = { category = { "assault_rifle", "smg", "snp", "shotgun", "pistol", "minigun", "akimbo", "lmg" } },
		wpn_fps_upg_perk_stockpile = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
	}
	local all_pass, weapon_pass, exclude_weapon_pass, category_pass, exclude_category_pass = nil

	for id, data in pairs(tweak_data.upgrades.definitions) do
		local weapon_tweak = tweak_data.weapon[data.weapon_id]
		local primary_category = weapon_tweak and weapon_tweak.categories and weapon_tweak.categories[1]

		if data.weapon_id and weapon_tweak and data.factory_id and self[data.factory_id] then
			for part_id, params in pairs(uses_parts) do
				weapon_pass = not params.weapon or table.contains(params.weapon, data.weapon_id)
				exclude_weapon_pass = not params.exclude_weapon or not table.contains(params.exclude_weapon, data.weapon_id)
				category_pass = not params.category or table.contains(params.category, primary_category)
				exclude_category_pass = not params.exclude_category or not table.contains(params.exclude_category, primary_category)
				all_pass = weapon_pass and exclude_weapon_pass and category_pass and exclude_category_pass

				if all_pass then
					table.insert(self[data.factory_id].uses_parts, part_id)
					table.insert(self[data.factory_id .. "_npc"].uses_parts, part_id)
				end
			end
		end
	end
end
