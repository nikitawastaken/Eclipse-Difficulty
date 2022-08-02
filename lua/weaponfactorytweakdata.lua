Hooks:PostHook(WeaponFactoryTweakData, "init", "eclipse__init", function(self)
    -- Shotgun Ammo Rework
    -- DB
    self.parts.wpn_fps_upg_a_dragons_breath.custom_stats.fire_dot_data = {dot_trigger_chance = "100", dot_damage = "20", dot_length = "1.5", dot_trigger_max_distance = "1500", dot_tick_period = "0.5"}
    -- HE
    self.parts.wpn_fps_upg_a_explosive.stats = {total_ammo_mod = -10, damage = -15, spread = 1}
    self.parts.wpn_fps_upg_a_explosive.custom_stats = {ignore_statistic = true, ammo_pickup_max_mul = 0.9, ammo_pickup_min_mul = 0.9, bullet_class = "InstantExplosiveBulletBase", rays = 1}
	-- 000
    self.parts.wpn_fps_upg_a_custom.custom_stats = {rays = 8, ammo_pickup_max_mul = 1, ammo_pickup_min_mul = 1} -- overwrites walk in closet so technically you still lose pickup
    self.parts.wpn_fps_upg_a_custom_free.custom_stats = {rays = 8, ammo_pickup_max_mul = 1, ammo_pickup_min_mul = 1}
    -- Flechette
    self.parts.wpn_fps_upg_a_piercing.stats.damage = 0
    -- bitchass
    self.wpn_fps_shot_huntsman.override.wpn_fps_upg_a_explosive = nil
    self.wpn_fps_pis_judge.override.wpn_fps_upg_a_explosive = nil
    self.wpn_fps_shot_b682.override.wpn_fps_upg_a_explosive = nil
    self.wpn_fps_pis_x_judge.override.wpn_fps_upg_a_explosive = nil
    self.wpn_fps_sho_coach.override.wpn_fps_upg_a_explosive = nil

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


    -- Minigun half that kit thing
    self.parts.wpn_fps_lmg_m134_body_upper_light.custom_stats = {movement_speed = 1.15}
    -- Union Short Barrel buff
    self.parts.wpn_fps_ass_corgi_b_short.stats.spread = -1

    -- Gadgets
    -- Military Laser module
    self.parts.wpn_fps_upg_fl_ass_peq15.stats.recoil = 0
    self.parts.wpn_fps_upg_fl_ass_peq15.stats.spread = 2
    -- Tactical Laser module
    self.parts.wpn_fps_upg_fl_ass_smg_sho_peqbox.stats.concealment = 0
    -- Assault Light
    self.parts.wpn_fps_upg_fl_ass_smg_sho_surefire.stats.concealment = 0

    -- bipod nerf
    self.parts.wpn_fps_upg_bp_lmg_lionbipod.stats.recoil = -1
    

    -- DMR Kit fixes and concealment nerfs
    -- ak family
    self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats = {ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.9}
    self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.concealment = -6
    self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -8
    self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 75
    self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.custom_stats.ammo_pickup_max_mul = 0.45
    self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.concealment = -7
    self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -11
    self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 95
    -- car family
    self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats.ammo_pickup_min_mul = 0.4
    self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.concealment = -7
    self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -11
    self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 110
    self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = {ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.9}
    self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.concealment = -6
    self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -8
    self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 75
    -- m308 b-stock
    self.parts.wpn_fps_ass_m14_body_ruger.stats.concealment = 8
    -- gewehr
    self.parts.wpn_fps_ass_g3_b_sniper.custom_stats = {ammo_pickup_max_mul = 1.1, ammo_pickup_min_mul = 1.1}
    self.parts.wpn_fps_ass_g3_b_sniper.stats.concealment = -5
    self.parts.wpn_fps_ass_g3_b_sniper.stats.recoil = -11
    self.parts.wpn_fps_ass_g3_b_sniper.stats.damage = 73
    -- broomstick 
    self.parts.wpn_fps_pis_c96_b_long.custom_stats = {ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8}


    -- Commando 553 modifications
    self.parts.wpn_fps_ass_s552_body_standard_black.stats = {spread = 0, recoil = -2, concealment = 2}
    self.parts.wpn_fps_ass_s552_b_long.stats = {spread = 2, concealment = -2}
    self.parts.wpn_fps_ass_s552_fg_standard_green.stats = {concealment = 2, spread = -1, recoil = -1}
    self.parts.wpn_fps_ass_s552_fg_railed.stats = {concealment = -3, recoil = 2, spread = 2}
    self.parts.wpn_fps_ass_s552_g_standard_green.stats = {spread = 1, recoil = 1}

    -- Falcon modifications
    self.parts.wpn_fps_ass_fal_s_01.stats = {recoil = -2, concealment = 2}
    self.parts.wpn_fps_ass_fal_s_wood.stats = {recoil = 3, concealment = -2}
    self.parts.wpn_fps_ass_fal_g_01.stats = {recoil = 1, spread = -2, concealment = 2}

    -- Speedpull nerfs
    self.parts.wpn_fps_m4_upg_m_quick.stats = {recoil = -2, reload = 3}
    self.parts.wpn_fps_upg_ak_m_quick.stats = {recoil = -2, reload = 3}
    self.parts.wpn_fps_ass_g36_m_quick.stats = {recoil = -2, reload = 3}
    self.parts.wpn_fps_ass_aug_m_quick.stats = {recoil = -2, reload = 3}
    self.parts.wpn_fps_smg_sr2_m_quick.stats = {recoil = -2, reload = 3}
    self.parts.wpn_fps_smg_mac10_m_quick.stats = {recoil = -2, reload = 3}
    self.parts.wpn_fps_smg_p90_m_strap.stats = {recoil = -2, reload = 3}

    -- Barrel Extentions

    -- Suppressors

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
    self.parts.wpn_fps_snp_m95_barrel_suppressed.stats.damage = -20
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
end)