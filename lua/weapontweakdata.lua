Hooks:PostHook(WeaponTweakData, "init", "eclipse_init", function(self)
-- Sniper Rifles


-- Contractor
self.tti.stats.concealment = 8
self.tti.stats.damage = 180
self.tti.AMMO_PICKUP = {0.9, 1.8}
self.tti.kick.standing = {3, 3.8, -0.3, 0.3}
self.tti.kick.crouching = self.tti.kick.standing
self.tti.kick.steelsight = self.tti.kick.standing
self.tti.categories = {"snp", "ng"}

-- Grom
self.siltstone.stats.concealment = 20
self.siltstone.stats.damage = 180
self.siltstone.AMMO_PICKUP = {0.9, 1.8}
self.siltstone.kick.standing = {2.6, 3.2, -0.3, 0.3}
self.siltstone.kick.crouching = self.siltstone.kick.standing
self.siltstone.kick.steelsight = self.siltstone.kick.standing
self.siltstone.categories = {"snp", "ng"}

-- Kang Arms
self.qbu88.stats.damage = 180
self.qbu88.CLIP_AMMO_MAX = 10
self.qbu88.AMMO_MAX = 40
self.qbu88.stats.recoil = 7
self.qbu88.AMMO_PICKUP = {0.9, 1.8}
self.qbu88.kick.standing = {3, 3.8, -0.3, 0.3}
self.qbu88.kick.crouching = self.qbu88.kick.standing
self.qbu88.kick.steelsight = self.qbu88.kick.standing
self.qbu88.categories = {"snp", "ng"}

-- Lebensauger
self.wa2000.stats.damage = 195
self.wa2000.CLIP_AMMO_MAX = 10
self.wa2000.AMMO_MAX = 30
self.wa2000.AMMO_PICKUP = {0.9, 1.8}
self.wa2000.fire_mode_data.fire_rate = 60 / 120
self.wa2000.kick.standing = {4, 4.8, -0.3, 0.3}
self.wa2000.kick.crouching = self.wa2000.kick.standing
self.wa2000.kick.steelsight = self.wa2000.kick.standing
self.wa2000.stats.reload = 13
self.wa2000.categories = {"snp", "ng"}

-- Rangehitter 
self.sbl.fire_mode_data.fire_rate = 60 / 100
self.sbl.stats.damage = 220
self.sbl.CLIP_AMMO_MAX = 10
self.sbl.AMMO_MAX = 40
self.sbl.stats_modifiers = {damage = 1}
self.sbl.AMMO_PICKUP = {0.9, 1.8}
self.sbl.stats.reload = 13

-- Repeater
self.winchester1874.stats.damage = 147
self.winchester1874.stats_modifiers = {damage = 2}
self.winchester1874.fire_mode_data.fire_rate = 60 / 85
self.winchester1874.AMMO_PICKUP = {1, 1.5}
self.winchester1874.AMMO_MAX = 30

-- Rattlesnake
self.msr.stats.damage = 147
self.msr.stats_modifiers = {damage = 2}
self.msr.fire_mode_data.fire_rate = 60 / 70
self.msr.AMMO_PICKUP = {1, 1.5}
self.msr.AMMO_MAX = 30

-- R700
self.r700.stats.damage = 147
self.r700.stats_modifiers = {damage = 2}
self.r700.AMMO_PICKUP = {0.9, 1.8}
self.r700.fire_mode_data.fire_rate = 60 / 70
self.r700.AMMO_MAX = 30
self.r700.kick.crouching = self.r700.kick.standing
self.r700.kick.steelsight = self.r700.kick.standing

-- Desert Fox
self.desertfox.fire_mode_data.fire_rate = 60 / 70
self.desertfox.AMMO_PICKUP = {0.9, 1.2}

-- Nagant
self.mosin.fire_mode_data.fire_rate = 60 / 70
self.mosin.AMMO_PICKUP = {0.9, 1.2}

-- R93
self.r93.fire_mode_data.fire_rate = 60 / 70
self.r93.AMMO_PICKUP = {0.9, 1.2}

-- Platypus
self.model70.fire_mode_data.fire_rate = 60 / 70
self.model70.AMMO_PICKUP = {0.9, 1.2}

-- Thanatos
self.m95.stats.damage = 200
self.m95.stats_modifiers = {damage = 40}
self.m95.kick.standing = {5, 6, -1, 1}
self.m95.kick.crouching = self.m95.kick.standing
self.m95.kick.steelsight = self.m95.kick.standing


-- LMGs


-- KSP
self.m249.kick.standing = {0.65, 1.05, -0.8, 0.8}
self.m249.kick.crouching = self.m249.kick.standing
self.m249.kick.steelsight = {0.5, 0.9, -0.6, 0.6}

-- Buzzsaw
self.mg42.kick.standing = {0.65, 1.05, -0.8, 0.8}
self.mg42.kick.crouching = self.mg42.kick.standing
self.mg42.kick.steelsight = {0.5, 0.9, -0.6, 0.6}
self.mg42.stats.reload = 13

-- KSP 58
self.par.kick.standing = {0.65, 1.05, -0.8, 0.8}
self.par.kick.crouching = self.par.kick.standing
self.par.kick.steelsight = {0.5, 0.9, -0.6, 0.6}

-- Brenner 
self.hk21.stats.spread = 12
self.hk21.stats.damage = 110
self.hk21.AMMO_PICKUP = {8, 10}
self.hk21.kick.standing = {0.55, 0.95, -0.8, 0.8}
self.hk21.kick.crouching = self.hk21.kick.standing
self.hk21.kick.steelsight = {0.4, 0.7, -0.6, 0.6}
self.hk21.stats.reload = 12

-- RPK
self.rpk.stats.spread = 10
self.rpk.stats.damage = 110
self.rpk.stats.concealment = 1
self.rpk.AMMO_PICKUP = {8, 10}
self.rpk.kick.standing = {0.55, 0.95, -0.8, 0.8}
self.rpk.kick.crouching = self.rpk.kick.standing
self.rpk.kick.steelsight = {0.4, 0.7, -0.6, 0.6}

-- M60
self.m60.stats.damage = 110
self.m60.AMMO_PICKUP = {8, 10}
self.m60.kick.standing = {0.55, 0.95, -0.8, 0.8}
self.m60.kick.crouching = self.rpk.kick.standing
self.m60.kick.steelsight = {0.4, 0.7, -0.6, 0.6}

-- new hk51b lmg idr the in-game name lol
self.hk51b.stats.damage = 100
self.hk51b.AMMO_PICKUP = {7, 8}
self.hk51b.kick.standing = {0.7, 0.95, -0.8, 0.8}
self.hk51b.kick.crouching = self.rpk.kick.standing
self.hk51b.kick.steelsight = {0.6, 0.75, -0.7, 0.7}

-- Shotguns

-- Izhma
self.saiga.rays = 12
self.saiga.stats.spread = 12
self.saiga.AMMO_PICKUP = {3, 4}
self.saiga.kick.standing = {2.5, 3.2, -0.5, 0.5}
self.saiga.kick.crouching = self.saiga.kick.standing
self.saiga.kick.steelsight = self.saiga.kick.standing
self.saiga.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- Steakout
self.aa12.rays = 12
self.aa12.stats.spread = 12
self.aa12.AMMO_PICKUP = {3, 4}
self.aa12.kick.standing = {2.5, 3.2, -0.5, 0.5}
self.aa12.kick.crouching = self.aa12.kick.standing
self.aa12.kick.steelsight = self.aa12.kick.standing
self.aa12.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- M1014
self.benelli.rays = 12
self.benelli.stats.spread = 12
self.benelli.AMMO_PICKUP = {2, 3}
self.benelli.kick.standing = {2.4, 3, -0.8, 0.8}
self.benelli.kick.crouching = self.benelli.kick.standing
self.benelli.kick.steelsight = self.benelli.kick.standing
self.benelli.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.moving_crouching,
	moving_crouching = self.new_m4.spread.moving_crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- Predator
self.spas12.rays = 12
self.spas12.stats.spread = 12
self.spas12.AMMO_PICKUP = {2, 3}
self.spas12.fire_mode_data.fire_rate = 60 / 429
self.spas12.kick.standing = {2.4, 3, -0.8, 0.8}
self.spas12.kick.crouching = self.spas12.kick.standing
self.spas12.kick.steelsight = self.spas12.kick.standing
self.spas12.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- Raven
self.ksg.rays = 12
self.ksg.stats.damage = 85
self.ksg.fire_mode_data.fire_rate = 0.5
self.ksg.kick.standing = {2, 3, -0.2, 0.2}
self.ksg.kick.crouching = self.ksg.kick.standing
self.ksg.kick.steelsight = self.ksg.kick.standing

-- Reinfeld 880
self.r870.rays = 12
self.r870.stats.damage = 85
self.r870.fire_mode_data.fire_rate = 0.5
self.r870.kick.standing = {2, 3, -0.2, 0.2}
self.r870.kick.crouching = self.r870.kick.standing
self.r870.kick.steelsight = self.r870.kick.standing

-- Reinfeld 88 (Trench Gun)
self.m1897.rays = 12
self.m1897.stats.damage = 85
self.m1897.AMMO_PICKUP = {0.42, 1.47}
self.m1897.kick.standing = {2, 3, -0.2, 0.2}
self.m1897.kick.crouching = self.m1897.kick.standing
self.m1897.kick.steelsight = self.m1897.kick.standing

-- Mosconi Tactical
self.m590.rays = 12
self.m590.stats.damage = 85
self.m590.fire_mode_data.fire_rate = 0.5
self.m590.kick.standing = {2, 3, -0.2, 0.2}
self.m590.kick.crouching = self.m590.kick.standing
self.m590.kick.steelsight = self.m590.kick.standing 

-- Mosconi
self.huntsman.rays = 12
self.huntsman.AMMO_PICKUP = {0.42, 1.47}

-- Joceline
self.b682.rays = 12
self.b682.AMMO_PICKUP = {0.42, 1.47}

-- Breaker
self.boot.rays = 12
self.boot.AMMO_PICKUP = {0.42, 1.2}

-- Grimm (&akimbo)
self.basset.rays = 8
self.basset.AMMO_PICKUP = {2, 3}
self.basset.kick.standing = {2, 3, -0.2, 0.2}
self.basset.kick.crouching = self.basset.kick.standing
self.basset.kick.steelsight = self.basset.kick.standing
self.basset.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}
self.x_basset.rays = 12
self.x_basset.AMMO_PICKUP = {3.5, 4.5}
self.x_basset.kick.standing = {2, 3, -0.2, 0.2}
self.x_basset.kick.crouching = self.x_basset.kick.standing
self.x_basset.kick.steelsight = self.x_basset.kick.standing
self.x_basset.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- Goliath (&akimbo)
self.rota.rays = 6
self.rota.AMMO_PICKUP = {2, 3}
self.rota.kick.standing = {1.8, 2, -0.2, 0.2}
self.rota.kick.crouching = self.rota.kick.standing
self.rota.kick.steelsight = self.rota.kick.standing
self.rota.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}
self.x_rota.rays = 12
self.x_rota.AMMO_PICKUP = {2.5, 3}
self.x_rota.kick.standing = {2, 3, -0.2, 0.2}
self.x_rota.kick.crouching = self.x_rota.kick.standing
self.x_rota.kick.steelsight = self.x_rota.kick.standing
self.x_rota.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- Judge (&akimbo)
self.judge.rays = 12
self.judge.AMMO_PICKUP = {0.275, 0.65}
self.judge.AMMO_MAX = 25
self.x_judge.rays = 12
self.x_judge.stats.damage = 190

-- Claire
self.coach.rays = 12
self.coach.AMMO_PICKUP = {0.25, 0.65}

-- GSPS 
self.m37.rays = 12
self.m37.AMMO_PICKUP = {0.42, 1.2}

-- Loco
self.serbu.rays = 12
self.serbu.fire_mode_data.fire_rate = 0.6

-- Sweeper
self.striker.rays = 12
self.striker.AMMO_PICKUP = {1.75, 2.65}
self.striker.kick.standing = {1.8, 2, -0.2, 0.2}
self.striker.kick.crouching = self.striker.kick.standing
self.striker.kick.steelsight = self.striker.kick.standing
self.striker.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- Ultima
self.ultima.rays = 12
self.ultima.stats.damage = 70
self.ultima.kick.standing = {3, 3.5, -0.2, 0.2}
self.ultima.spread = {
	standing = self.new_m4.spread.crouching,
	crouching = self.new_m4.spread.crouching,
	steelsight = self.new_m4.spread.steelsight,
	moving_standing = self.new_m4.spread.crouching,
	moving_crouching = self.new_m4.spread.crouching,
	moving_steelsight = self.new_m4.spread.moving_steelsight
}

-- ARs


-- AMCAR
self.amcar.fire_mode_data = {fire_rate = 60 / 700}
self.amcar.auto = {fire_rate = 60 / 700}
self.amcar.stats.damage = 52
self.amcar.stats.spread = 14
self.amcar.stats.recoil = 16
self.amcar.AMMO_PICKUP = {6, 8}
self.amcar.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.amcar.kick.crouching = self.amcar.kick.standing
self.amcar.kick.steelsight = self.amcar.kick.standing

-- Commando 553
self.s552.stats.spread = 14
self.s552.stats.concealment = 18
self.s552.AMMO_PICKUP = {6, 8}
self.s552.kick.standing = {1.1, 1.3, -0.65, 0.65}
self.s552.kick.crouching = self.s552.kick.standing
self.s552.kick.steelsight = self.s552.kick.standing

-- Clarion
self.famas.stats.damage = 43
self.famas.stats.recoil = 13
self.famas.AMMO_PICKUP = {6, 8}
self.famas.kick.standing = {1.1, 1.3, -0.65, 0.65}
self.famas.kick.crouching = self.famas.kick.standing
self.famas.kick.steelsight = self.famas.kick.standing

-- JP36
self.g36.stats.spread = 14
self.g36.AMMO_PICKUP = {6, 8}
self.g36.kick.standing = {1.1, 1.3, -0.65, 0.65}
self.g36.kick.crouching = self.g36.kick.standing
self.g36.kick.steelsight = self.g36.kick.standing

-- AS Val
self.asval.stats.damage = 46
self.asval.AMMO_PICKUP = {6, 8}
self.asval.kick.standing = {1.1, 1.3, -0.65, 0.65}
self.asval.kick.crouching = self.asval.kick.standing
self.asval.kick.steelsight = self.asval.kick.standing

-- CAR-4
self.new_m4.fire_mode_data = {fire_rate = 60 / 780}
self.new_m4.auto = {fire_rate = 60 / 780}
self.new_m4.AMMO_PICKUP = {5, 7}
self.new_m4.kick.standing = {1.3, 1.5, -0.5, 0.5}
self.new_m4.kick.crouching = self.new_m4.kick.standing
self.new_m4.kick.steelsight = self.new_m4.kick.standing

-- AK5 
self.ak5.AMMO_PICKUP = {5, 7}
self.ak5.kick.standing = {1.3, 1.5, -0.5, 0.5}
self.ak5.kick.crouching = self.ak5.kick.standing
self.ak5.kick.steelsight = self.ak5.kick.standing

-- Union
self.corgi.stats.damage = 62
self.corgi.AMMO_PICKUP = {5, 7}
self.corgi.kick.standing = {1.3, 1.5, -0.5, 0.5}
self.corgi.kick.crouching = self.corgi.kick.standing
self.corgi.kick.steelsight = self.corgi.kick.standing

-- UAR
self.aug.AMMO_PICKUP = {5, 7}
self.aug.kick.standing = {1.3, 1.5, -0.5, 0.5}
self.aug.kick.crouching = self.aug.kick.standing
self.aug.kick.steelsight = self.aug.kick.standing

-- Queen's Wrath
self.l85a2.AMMO_PICKUP = {5, 7}
self.l85a2.kick.standing = {1.3, 1.5, -0.5, 0.5}
self.l85a2.kick.crouching = self.l85a2.kick.standing
self.l85a2.kick.steelsight = self.l85a2.kick.standing

-- Tempest
self.komodo.AMMO_PICKUP = {5, 7}
self.komodo.kick.standing = {1.3, 1.5, -0.5, 0.5}
self.komodo.kick.crouching = self.komodo.kick.standing
self.komodo.kick.steelsight = self.komodo.kick.standing

-- AK Rifle
self.ak74.stats.damage = 77
self.ak74.stats.concealment = 15
self.ak74.AMMO_PICKUP = {4.5, 6}
self.ak74.kick.standing = {1.3, 1.5, -0.65, 0.65}
self.ak74.kick.crouching = self.ak74.kick.standing
self.ak74.kick.steelsight = self.ak74.kick.standing

-- Lion's Roar
self.vhs.stats.damage = 72
self.vhs.stats.concealment = 12
self.vhs.AMMO_PICKUP = {4.5, 6}
self.vhs.AMMO_MAX = 150
self.vhs.kick.standing = {1.3, 1.5, -0.65, 0.65}
self.vhs.kick.crouching = self.vhs.kick.standing
self.vhs.kick.steelsight = self.vhs.kick.standing

-- Gecko
self.galil.stats.damage = 72
self.galil.stats.concealment = 12
self.galil.AMMO_PICKUP = {4.5, 6}
self.galil.AMMO_MAX = 140
self.galil.kick.standing = {1.3, 1.5, -0.65, 0.65}
self.galil.kick.crouching = self.galil.kick.standing
self.galil.kick.steelsight = self.galil.kick.standing

-- Bootleg
self.tecci.stats.spread = 11
self.tecci.stats.reload = 11
self.tecci.stats.damage = 60
self.tecci.stats.concealment = 5
self.tecci.AMMO_PICKUP = {5, 7}
self.tecci.kick.standing = {1.3, 1.5, -0.65, 0.65}
self.tecci.kick.crouching = self.tecci.kick.standing
self.tecci.kick.steelsight = self.tecci.kick.standing

-- Groza
self.groza.kick.standing = {1.3, 1.5, -0.65, 0.65}
self.groza.kick.crouching = self.groza.kick.standing
self.groza.kick.steelsight = self.groza.kick.standing

-- AK 7.62
self.akm.fire_mode_data = {fire_rate = 0.1}
self.akm.auto = {fire_rate = 0.1}
self.akm.stats.concealment = 10
self.akm.AMMO_PICKUP = {2.2, 3.5}
self.akm.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.akm.kick.crouching = self.akm.kick.standing
self.akm.kick.steelsight = self.akm.kick.standing

-- Gold AK 7.62
self.akm_gold.fire_mode_data = {fire_rate = 0.1}
self.akm_gold.auto = {fire_rate = 0.1}
self.akm_gold.stats.concealment = 10
self.akm_gold.AMMO_PICKUP = {2.2, 3.5}
self.akm_gold.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.akm_gold.kick.crouching = self.akm_gold.kick.standing
self.akm_gold.kick.steelsight = self.akm_gold.kick.standing

-- AK17
self.flint.stats.concealment = 8
self.flint.AMMO_PICKUP = {2.2, 3.5}
self.flint.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.flint.kick.crouching = self.flint.kick.standing
self.flint.kick.steelsight = self.flint.kick.standing

-- AMR
self.m16.stats.concealment = 8
self.m16.AMMO_PICKUP = {2.2, 3.5}
self.m16.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.m16.kick.crouching = self.m16.kick.standing
self.m16.kick.steelsight = self.m16.kick.standing

-- Eagle Heavy
self.scar.stats.concealment = 10
self.scar.stats.reload = 13
self.scar.AMMO_PICKUP = {2.2, 3.5}
self.scar.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.scar.kick.crouching = self.scar.kick.standing
self.scar.kick.steelsight = self.scar.kick.standing

-- Falcon
self.fal.AMMO_PICKUP = {2.2, 3.5}
self.fal.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.fal.kick.crouching = self.fal.kick.standing
self.fal.kick.steelsight = self.fal.kick.standing

-- Gewehr
self.g3.stats.concealment = 9
self.g3.AMMO_PICKUP = {2.2, 3.5}
self.g3.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.g3.kick.crouching = self.g3.kick.standing
self.g3.kick.steelsight = self.g3.kick.standing

-- KS12
self.shak12.stats.concealment = 10
self.shak12.AMMO_PICKUP = {2.2, 3.5}
self.shak12.kick.standing = {1.3, 1.5, -0.8, 0.8}
self.shak12.kick.crouching = self.shak12.kick.standing
self.shak12.kick.steelsight = self.shak12.kick.standing


-- SMGs

-- Blaster
self.tec9.AMMO_PICKUP = {5, 9}
self.tec9.stats.spread = 11
self.tec9.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.tec9.kick.crouching = self.tec9.kick.standing
self.tec9.kick.steelsight = self.tec9.kick.standing

-- CMP
self.mp9.AMMO_PICKUP = {5, 9}
self.mp9.stats.spread = 11
self.mp9.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.mp9.kick.crouching = self.mp9.kick.standing
self.mp9.kick.steelsight = self.mp9.kick.standing

-- Cobra
self.scorpion.AMMO_PICKUP = {5, 9}
self.scorpion.stats.spread = 11
self.scorpion.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.scorpion.kick.crouching = self.scorpion.kick.standing
self.scorpion.kick.steelsight = self.scorpion.kick.standing

-- Compact-5
self.new_mp5.AMMO_PICKUP = {5, 9}
self.new_mp5.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.new_mp5.kick.crouching = self.new_mp5.kick.standing
self.new_mp5.kick.steelsight = self.new_mp5.kick.standing

-- Micro Uzi
self.baka.AMMO_PICKUP = {5, 9}
self.baka.stats.spread = 11
self.baka.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.baka.kick.crouching = self.baka.kick.standing
self.baka.kick.steelsight = self.baka.kick.standing

-- Uzi
self.uzi.AMMO_PICKUP = {0.9, 3.15}
self.uzi.fire_mode_data.fire_rate = 60 / 850
self.uzi.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.uzi.kick.crouching = self.uzi.kick.standing
self.uzi.kick.steelsight = self.uzi.kick.standing

-- Signature
self.shepheard.AMMO_PICKUP = {5, 9}
self.shepheard.stats.spread = 14
self.shepheard.fire_mode_data.fire_rate = 60 / 850
self.shepheard.kick.standing = {0.9, 1.2, -0.5, 0.5}
self.shepheard.kick.crouching = self.shepheard.kick.standing
self.shepheard.kick.steelsight = self.shepheard.kick.standing

-- Thompson
self.m1928.AMMO_PICKUP = {3, 7}
self.m1928.stats.spread = 15
self.m1928.stats.reload = 13
self.m1928.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.m1928.kick.crouching = self.m1928.kick.standing
self.m1928.kick.steelsight = self.m1928.kick.standing

-- Heather
self.sr2.AMMO_PICKUP = {3, 7}
self.sr2.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.sr2.kick.crouching = self.sr2.kick.standing
self.sr2.kick.steelsight = self.sr2.kick.standing

-- Jacket's Piece
self.cobray.AMMO_PICKUP = {3, 7}
self.cobray.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.cobray.kick.crouching = self.cobray.kick.standing
self.cobray.kick.steelsight = self.cobray.kick.standing

-- Kobus
self.p90.AMMO_PICKUP = {3, 7}
self.p90.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.p90.kick.crouching = self.p90.kick.standing
self.p90.kick.steelsight = self.p90.kick.standing

-- Vertex
self.polymer.AMMO_PICKUP = {3, 7}
self.polymer.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.polymer.kick.crouching = self.polymer.kick.standing
self.polymer.kick.steelsight = self.polymer.kick.standing

-- Mark 10
self.mac10.AMMO_PICKUP = {3, 7}
self.mac10.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.mac10.kick.crouching = self.mac10.kick.standing
self.mac10.kick.steelsight = self.mac10.kick.standing

-- Spec Ops
self.mp7.AMMO_PICKUP = {3, 7}
self.mp7.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.mp7.kick.crouching = self.mp7.kick.standing
self.mp7.kick.steelsight = self.mp7.kick.standing

-- Miyaka
self.pm9.AMMO_PICKUP = {3, 7}
self.pm9.kick.standing = {1.2, 1.4, -0.5, 0.5}
self.pm9.kick.crouching = self.pm9.kick.standing
self.pm9.kick.steelsight = self.pm9.kick.standing

-- Para
self.olympic.AMMO_MAX = 90
self.olympic.AMMO_PICKUP = {0.9, 3.15}
self.olympic.stats.damage = 80
self.olympic.kick.standing = {1.2, 1.4, -0.75, 0.75}
self.olympic.kick.crouching = self.olympic.kick.standing
self.olympic.kick.steelsight = self.olympic.kick.standing

-- AKGEN
self.vityaz.AMMO_MAX = 90
self.vityaz.AMMO_PICKUP = {0.9, 3.15}
self.vityaz.stats.damage = 100
self.vityaz.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.vityaz.kick.crouching = self.vityaz.kick.standing
self.vityaz.kick.steelsight = self.vityaz.kick.standing

-- CR805
self.hajk.stats.damage = 80
self.hajk.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.hajk.kick.crouching = self.hajk.kick.standing
self.hajk.kick.steelsight = self.hajk.kick.standing

-- Krinkov
self.akmsu.stats.damage = 80
self.akmsu.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.akmsu.kick.crouching = self.akmsu.kick.standing
self.akmsu.kick.steelsight = self.akmsu.kick.standing

-- MP40
self.erma.stats.reload = 13
self.erma.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.erma.kick.crouching = self.erma.kick.standing
self.erma.kick.steelsight = self.erma.kick.standing

-- Pattchet
self.sterling.AMMO_PICKUP = {0.9, 3.15}
self.sterling.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.sterling.kick.crouching = self.sterling.kick.standing
self.sterling.kick.steelsight = self.sterling.kick.standing

-- Swedish K
self.m45.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.m45.kick.crouching = self.m45.kick.standing
self.m45.kick.steelsight = self.m45.kick.standing

-- Jackal
self.schakal.kick.standing = {1.4, 1.6, -0.6, 0.6}
self.schakal.kick.crouching = self.schakal.kick.standing
self.schakal.kick.steelsight = self.schakal.kick.standing

-- Wasp
self.fmg9.stats.damage = 58
self.fmg9.stats.spread = 14
self.fmg9.AMMO_MAX = 150
self.fmg9.AMMO_PICKUP = {3, 7}
self.fmg9.kick.standing = {1, 1.1, -0.75, 0.75}
self.fmg9.kick.crouching = self.fmg9.kick.standing
self.fmg9.kick.steelsight = self.fmg9.kick.standing
self.fmg9.timers.unequip = 1.2


-- DMRs

-- Cavity
self.sub2000.AMMO_PICKUP = {1.5, 2.5}
self.sub2000.stats.damage = 180
self.sub2000.stats.concealment = 18
self.sub2000.kick.standing = {2, 3, -0.3, 0.3}
self.sub2000.kick.crouching = self.sub2000.kick.standing
self.sub2000.kick.steelsight = self.sub2000.kick.standing
-- M308
self.new_m14.AMMO_PICKUP = {1.5, 2.5}
self.new_m14.stats.damage = 180
self.new_m14.stats.concealment = 5
self.new_m14.kick.standing = {3, 3.8, -0.6, 0.6}
self.new_m14.kick.crouching = self.new_m14.kick.standing
self.new_m14.kick.steelsight = self.new_m14.kick.standing
-- Galant
self.ching.AMMO_PICKUP = {1.5, 2.5}
self.ching.stats.damage = 180
self.ching.stats.concealment = 10
self.ching.kick.standing = {2.6, 3.4, -0.45, 0.45}
self.ching.kick.crouching = self.ching.kick.standing
self.ching.kick.steelsight = self.ching.kick.standing


-- Pistols

-- 5/7
self.lemming.stats.damage = 70

--Peacemaker
self.peacemaker.AMMO_MAX = 24
self.peacemaker.stats.damage = 105
self.peacemaker.stats.reload = 17
self.peacemaker.AMMO_PICKUP = {0.26, 0.67}
self.peacemaker.can_shoot_through_enemy = true
self.peacemaker.can_shoot_through_shield = true
self.peacemaker.can_shoot_through_wall = true
self.peacemaker.armor_piercing_chance = 1

-- Angry Tiger
self.rsh12.stats.damage = 210
self.rsh12.stats.reload = 13
self.rsh12.AMMO_PICKUP = {0.26, 0.67}
self.rsh12.stats_modifiers = {damage = 1}
self.rsh12.kick.standing = {2.9, 3, -0.5, 0.5}
self.rsh12.kick.crouching = self.rsh12.kick.standing
self.rsh12.kick.steelsight = self.rsh12.kick.standing

-- Bronco
self.new_raging_bull.stats.reload = 13

-- Castigo
self.chinchilla.stats.reload = 13

-- Frenchman
self.model3.stats.damage = 175
self.model3.AMMO_PICKUP = self.new_raging_bull.AMMO_PICKUP
self.x_model3.stats.damage = 175
self.x_model3.AMMO_PICKUP = self.x_rage.AMMO_PICKUP

-- Baby Deagle
self.sparrow.stats.damage = 140
self.x_sparrow.stats.damage = 140

-- Deagle
self.deagle.stats.damage = 140
self.x_deagle.stats.damage = 140

-- Chunky Crosskil
self.m1911.stats.damage = 135
self.x_m1911.stats.damage = 135

-- White Streak
self.pl14.stats.damage = 140
self.x_pl14.stats.damage = 140


-- Grenade / Rocket launchers

-- GL40
self.gre_m79.stats.damage = 48
self.gre_m79.AMMO_MAX = 3
self.gre_m79.AMMO_PICKUP = {0.05, 0.575}

-- Piglet
self.m32.stats.damage = 48
self.m32.AMMO_PICKUP = {0.05, 0.575}
self.m32.stats.reload = 12

-- Commando 101
self.ray.stats.damage = 6
self.ray.stats.reload = 8
self.ray.AMMO_PICKUP = {0.05, 0.4}

-- RPG
self.rpg7.stats.damage = 60
self.rpg7.AMMO_PICKUP = {0.05, 0.38}
self.rpg7.stats.reload = 15

-- China Puff
self.china.stats.damage = 36
self.china.AMMO_PICKUP = {0.05, 0.5}

-- Arbiter
self.arbiter.stats.damage = 28
self.arbiter.AMMO_PICKUP = {0.05, 0.55}

-- Compact 40
self.slap.stats.damage = 48
self.slap.AMMO_MAX = 3
self.slap.AMMO_PICKUP = {0.05, 0.5}

end)

Hooks:PostHook(WeaponTweakData, "_set_sm_wish", "eclipse__set_sm_wish", function(self)
	-- NPC weapon edits
	self.m4_npc.DAMAGE = 1
	self.m4_npc.auto.fire_rate = 0.225
	self.m4_yellow_npc.DAMAGE = 1
	self.m4_yellow_npc.auto.fire_rate = 0.3
	self.m249_npc.auto.fire_rate = 0.2
	self.ump_npc.auto.fire_rate = 0.25
	self.g36_npc.DAMAGE = 1
	self.g36_npc.auto.fire_rate = 0.25
	self.mp9_npc.auto.fire_rate = 0.275
	self.mp5_npc.auto.fire_rate = 0.25
	self.saiga_npc.auto.fire_rate = 0.2
	self.raging_bull_npc.DAMAGE = 1
	self.ak47_ass_npc.DAMAGE = 1
	self.ak47_npc.DAMAGE = 1
	self.scar_npc.DAMAGE = 1
	-- Misc
	self.m249_npc.usage = "is_lmg"
	self.r870_npc.CLIP_AMMO_MAX = 8
	self.saiga_npc.CLIP_AMMO_MAX = 20
	self.benelli_npc.CLIP_AMMO_MAX = 8
	self.flamethrower_npc.flame_max_range = 800 -- wow 15m is retarded lmao
	self.benelli_npc.sounds.prefix = "benelli_m4_npc" -- Give it a proper sound
	self.beretta92_npc.has_suppressor = "suppressed_b" -- suppressed
	self.m14_sniper_npc.trail = "effects/particles/weapons/sniper_trail"
end)