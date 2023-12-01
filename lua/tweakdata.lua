-- lock dw / ds
tweak_data.difficulty_level_locks = {
	0,
	0,
	0,
	0,
	0,
	80,
	69420,
	69420,
}

-- lower difficulty xp muls
tweak_data.experience_manager.difficulty_multiplier = {
	1.5,
	3,
	6,
	12,
	12,
	12,
}

-- remove alive player multipliers
tweak_data.experience_manager.alive_humans_multiplier = {
	[0] = 1,
	1,
	1,
	1,
	1,
}

-- medics don't heal cloakers and other medics
tweak_data.medic.disabled_units = { "spooc", "medic" }

-- Arrows
tweak_data.projectiles.frankish_arrow.damage = 50
tweak_data.projectiles.frankish_arrow_exp.damage = 50
tweak_data.projectiles.crossbow_arrow_exp.damage = 35
tweak_data.projectiles.ecp_arrow.damage = 25
tweak_data.projectiles.ecp_arrow_exp.damage = 25
tweak_data.projectiles.west_arrow.damage = 80
tweak_data.projectiles.west_arrow_exp.damage = 80
tweak_data.projectiles.bow_poison_arrow.damage = 10
tweak_data.projectiles.arblast_arrow.damage = 100
tweak_data.projectiles.arblast_arrow_exp.damage = 100
tweak_data.projectiles.arblast_poison_arrow.damage = 25

-- grenade launchers and rocket launchers

-- 101
tweak_data.projectiles.rocket_ray_frag.damage = 128
tweak_data.projectiles.rocket_ray_frag.player_damage = 16
tweak_data.projectiles.rocket_ray_frag.range = 700

-- rpg
tweak_data.projectiles.launcher_rocket.damage = 24000 -- the extra 0 isn't a typo :trolline:
tweak_data.projectiles.launcher_rocket.player_damage = 24
tweak_data.projectiles.launcher_rocket.range = 700
-- piglet
tweak_data.projectiles.launcher_frag_m32.damage = 82
tweak_data.projectiles.launcher_frag_m32.player_damage = 16
-- china
tweak_data.weapon_disable_crit_for_damage.launcher_frag_china = { explosion = false, fire = false } -- why is china puff allowed to crit lmao
tweak_data.projectiles.launcher_frag_china.damage = 82
tweak_data.projectiles.launcher_frag_china.player_damage = 16
-- arbiter
tweak_data.projectiles.launcher_frag_arbiter.damage = 70
tweak_data.projectiles.launcher_frag_arbiter.player_damage = 16
-- basilisk
tweak_data.projectiles.launcher_frag_ms3gl.damage = 56
tweak_data.projectiles.launcher_frag_ms3gl.player_damage = 16
-- gl40
tweak_data.projectiles.launcher_frag.damage = 82
tweak_data.projectiles.launcher_frag.player_damage = 16
-- compact 40
tweak_data.projectiles.launcher_frag_slap.damage = 82
tweak_data.projectiles.launcher_frag_slap.player_damage = 16
-- underbarrel lf
tweak_data.projectiles.launcher_m203.damage = 60
tweak_data.projectiles.launcher_m203.player_damage = 16
-- underbarrel groza
tweak_data.projectiles.underbarrel_m203_groza.damage = 60
tweak_data.projectiles.underbarrel_m203_groza.player_damage = 16

-- electric
tweak_data.projectiles.launcher_electric.damage = 10
tweak_data.projectiles.launcher_electric_m32.damage = 10
tweak_data.projectiles.launcher_electric_china.damage = 10
tweak_data.projectiles.launcher_electric_slap.damage = 10
tweak_data.projectiles.launcher_electric_arbiter.damage = 10
tweak_data.projectiles.underbarrel_electric.damage = 10
tweak_data.projectiles.underbarrel_electric_groza.damage = 10
tweak_data.projectiles.launcher_electric_ms3gl.damage = 10

-- incendiary buff
-- tweak_data.projectiles.fir_com.damage = 10
tweak_data.projectiles.fir_com.fire_dot_data.dot_damage = 30
tweak_data.projectiles.fir_com.range = 800
-- frags buff
tweak_data.projectiles.frag.damage = 200
tweak_data.projectiles.frag_com.damage = 200
tweak_data.projectiles.dada_com.damage = 200
tweak_data.projectiles.dynamite.damage = 200

-- poison nerf
-- tweak_data.projectiles.poison_gas_grenade.poison_gas_dot_data.hurt_animation_chance = 1
-- tweak_data.projectiles.poison_gas_grenade.poison_gas_dot_data.dot_damage = 8
-- tweak_data.projectiles.poison_gas_grenade.poison_gas_dot_data.dot_tick_period = 2
-- tweak_data.projectiles.poison_gas_grenade.poison_gas_dot_data.dot_length = 10
tweak_data.projectiles.poison_gas_grenade.poison_gas_range = 400
tweak_data.projectiles.poison_gas_grenade.poison_gas_duration = 10

tweak_data.projectiles.launcher_poison.damage = 9
tweak_data.projectiles.launcher_poison.poison_gas_range = 300
tweak_data.projectiles.launcher_poison.poison_gas_duration = 10
tweak_data.projectiles.launcher_poison.poison_gas_dot_data = { hurt_animation_chance = 0.3, dot_damage = 4, dot_length = 10, dot_tick_period = 2 }
tweak_data.projectiles.launcher_poison_gre_m79 = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_gre_m79.damage = 9
tweak_data.projectiles.launcher_poison_gre_m79.poison_gas_range = 300
tweak_data.projectiles.launcher_poison_m32 = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_m32.damage = 9
tweak_data.projectiles.launcher_poison_m32.poison_gas_duration = 6
tweak_data.projectiles.launcher_poison_m32.poison_gas_range = 300
tweak_data.projectiles.launcher_poison_groza = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_groza.damage = 9
tweak_data.projectiles.launcher_poison_groza.poison_gas_duration = 3
tweak_data.projectiles.launcher_poison_groza.poison_gas_range = 300
tweak_data.projectiles.launcher_poison_china = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_china.damage = 8
tweak_data.projectiles.launcher_poison_china.poison_gas_duration = 4
tweak_data.projectiles.launcher_poison_china.poison_gas_range = 250
tweak_data.projectiles.launcher_poison_arbiter = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_arbiter.damage = 7
tweak_data.projectiles.launcher_poison_arbiter.poison_gas_duration = 3
tweak_data.projectiles.launcher_poison_arbiter.poison_gas_range = 250
tweak_data.projectiles.launcher_poison_slap = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_slap.damage = 9
tweak_data.projectiles.launcher_poison_slap.poison_gas_duration = 6
tweak_data.projectiles.launcher_poison_slap.poison_gas_range = 300
tweak_data.projectiles.launcher_poison_contraband = deep_clone(tweak_data.projectiles.launcher_poison)
tweak_data.projectiles.launcher_poison_contraband.damage = 9
tweak_data.projectiles.launcher_poison_contraband.poison_gas_duration = 3
tweak_data.projectiles.launcher_poison_contraband.poison_gas_range = 300

-- cop tear gas
tweak_data.projectiles.cs_grenade_quick.damage_per_tick = 1.5
