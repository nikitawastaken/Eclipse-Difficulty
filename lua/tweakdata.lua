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

local function create_explosive_arrow(base_arrow, explosive_arrow)
	explosive_arrow = deep_clone(base_arrow)
	explosive_arrow.bullet_class = "InstantExplosiveBulletBase"
	explosive_arrow.damage = base_arrow.damage * 1.5
	explosive_arrow.remove_on_impact = true
end

local function create_poison_arrow(base_arrow, poison_arrow)
	poison_arrow = deep_clone(base_arrow)
	poison_arrow.bullet_class = "PoisonBulletBase"
	poison_arrow.damage = base_arrow.damage * 0.5
end

local function create_incendiary_grenade(base_grenade, incendiary_grenade, id)
	incendiary_grenade = deep_clone(base_grenade)
	incendiary_grenade.dot_data_name = "launcher_incendiary_" .. id
	incendiary_grenade.damage = base_grenade.damage * 0.25
	incendiary_grenade.burn_duration = math.max(1, base_grenade.damage / 120)
	incendiary_grenade.burn_tick_period = 0.25
	incendiary_grenade.effect_name = "effects/payday2/particles/explosions/grenade_incendiary_explosion"
end

local function create_electric_grenade(base_grenade, electric_grenade)
	electric_grenade = deep_clone(base_grenade)
	electric_grenade.damage = base_grenade.damage * 0.5
	electric_grenade.range = 4 * (base_grenade.range / 3)
	electric_grenade.projectile_trail = true
	electric_grenade.sound_event = "gl_electric_explode"
end

local function create_poison_grenade(base_grenade, poison_grenade)
	poison_grenade = deep_clone(base_grenade)
	poison_grenade.damage = base_grenade.damage * 0.25
	poison_grenade.poison_gas_range = (base_grenade.damage / 240) * 150
	poison_grenade.poison_gas_duration = base_grenade.damage / 120
	poison_grenade.poison_gas_fade_time = poison_grenade.poison_gas_duration * 0.25
	poison_grenade.poison_gas_tick_time = 0.5
	poison_grenade.projectile_trail = true
end

-- Arrows
tweak_data.projectiles.bow_arrow = {
	damage = 48,
	launch_speed = 2500,
	adjust_z = 0,
	mass_look_up_modifier = 1,
	push_at_body_index = 0,
}

tweak_data.projectiles.west_arrow = deep_clone(tweak_data.projectiles.bow_arrow)
tweak_data.projectiles.west_arrow.damage = 48
tweak_data.projectiles.west_arrow.name_id = "bm_west_arrow"

tweak_data.projectiles.long_arrow = deep_clone(tweak_data.projectiles.bow_arrow)
tweak_data.projectiles.long_arrow.damage = 72
tweak_data.projectiles.long_arrow.launch_speed = 3500
tweak_data.projectiles.long_arrow.adjust_z = -30

tweak_data.projectiles.elastic_arrow = deep_clone(tweak_data.projectiles.bow_arrow)
tweak_data.projectiles.elastic_arrow.damage = 72
tweak_data.projectiles.elastic_arrow.launch_speed = 3500
tweak_data.projectiles.elastic_arrow.adjust_z = -130

create_explosive_arrow(tweak_data.projectiles.bow_arrow, tweak_data.projectiles.bow_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.west_arrow, tweak_data.projectiles.west_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.long_arrow, tweak_data.projectiles.long_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.elastic_arrow, tweak_data.projectiles.elastic_arrow_exp)

create_poison_arrow(tweak_data.projectiles.bow_arrow, tweak_data.projectiles.bow_arrow_poison)
create_poison_arrow(tweak_data.projectiles.west_arrow, tweak_data.projectiles.west_arrow_poison)
create_poison_arrow(tweak_data.projectiles.long_arrow, tweak_data.projectiles.long_arrow_poison)
create_poison_arrow(tweak_data.projectiles.elastic_arrow, tweak_data.projectiles.elastic_arrow_poison)

tweak_data.projectiles.crossbow_arrow = {
	damage = 36,
	launch_speed = 2500,
	adjust_z = 0,
	mass_look_up_modifier = 1,
	push_at_body_index = 0,
}

tweak_data.projectiles.hunter_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.hunter_arrow.damage = 24
tweak_data.projectiles.hunter_arrow.launch_speed = 2000

tweak_data.projectiles.ecp_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.ecp_arrow.damage = 24

tweak_data.projectiles.frankish_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.frankish_arrow.damage = 36

tweak_data.projectiles.arblast_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.arblast_arrow.damage = 72
tweak_data.projectiles.arblast_arrow.launch_speed = 3500

create_explosive_arrow(tweak_data.projectiles.crossbow_arrow, tweak_data.projectiles.crossbow_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.hunter_arrow, tweak_data.projectiles.hunter_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.ecp_arrow, tweak_data.projectiles.ecp_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.frankish_arrow, tweak_data.projectiles.frankish_arrow_exp)
create_explosive_arrow(tweak_data.projectiles.arblast_arrow, tweak_data.projectiles.arblast_arrow_exp)

create_poison_arrow(tweak_data.projectiles.crossbow_arrow, tweak_data.projectiles.crossbow_arrow_poison)
create_poison_arrow(tweak_data.projectiles.hunter_arrow, tweak_data.projectiles.hunter_arrow_poison)
create_poison_arrow(tweak_data.projectiles.ecp_arrow, tweak_data.projectiles.ecp_arrow_poison)
create_poison_arrow(tweak_data.projectiles.frankish_arrow, tweak_data.projectiles.frankish_arrow_poison)
create_poison_arrow(tweak_data.projectiles.arblast_arrow, tweak_data.projectiles.arblast_arrow_poison)

tweak_data.projectiles.frag = {
	damage = 96,
	curve_pow = 2,
	player_damage = 1,
	range = 450,
	name_id = "bm_grenade_frag",
}

tweak_data.projectiles.frag_com = deep_clone(tweak_data.projectiles.frag)
tweak_data.projectiles.frag_com.name_id = "bm_grenade_frag_com"

tweak_data.projectiles.dada_com = deep_clone(tweak_data.projectiles.frag)
tweak_data.projectiles.dada_com.name_id = "bm_grenade_dada_com"
tweak_data.projectiles.dada_com.sound_event = "mtl_explosion"

tweak_data.projectiles.dynamite = deep_clone(tweak_data.projectiles.frag)
tweak_data.projectiles.dynamite.name_id = "bm_grenade_frag"
tweak_data.projectiles.dynamite.effect_name = "effects/payday2/particles/explosions/dynamite_explosion"

tweak_data.projectiles.launcher_frag = {
	damage = 72,
	launch_speed = 1500,
	curve_pow = 2,
	player_damage = 1,
	player_dmg_mul = 1 / 4,
	range = 450,
	init_timer = 2.5,
	mass_look_up_modifier = 1,
	sound_event = "gl_explode",
	name_id = "bm_launcher_frag",
}

-- GL40
tweak_data.projectiles.launcher_frag_m79 = deep_clone(tweak_data.projectiles.launcher_frag)

create_incendiary_grenade(tweak_data.projectiles.launcher_frag_m79, tweak_data.projectiles.launcher_incendiary_m79, "m79")
create_electric_grenade(tweak_data.projectiles.launcher_frag_m79, tweak_data.projectiles.launcher_electric_m79)
create_poison_grenade(tweak_data.projectiles.launcher_frag_m79, tweak_data.projectiles.launcher_poison_m79)

-- Compact-40
tweak_data.projectiles.launcher_frag_slap = deep_clone(tweak_data.projectiles.launcher_frag)

create_incendiary_grenade(tweak_data.projectiles.launcher_frag_slap, tweak_data.projectiles.launcher_incendiary_slap, "slap")
create_electric_grenade(tweak_data.projectiles.launcher_frag_slap, tweak_data.projectiles.launcher_electric_slap)
create_poison_grenade(tweak_data.projectiles.launcher_frag_slap, tweak_data.projectiles.launcher_poison_slap)

-- Little Friend Underbarrel
tweak_data.projectiles.launcher_m203 = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_m203.projectile_trail = true

-- Groza Underbarrel
tweak_data.projectiles.underbarrel_m203_groza = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.underbarrel_m203_groza.projectile_trail = true

-- Piglet
tweak_data.projectiles.launcher_frag_m32 = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_m32.damage = 60

create_incendiary_grenade(tweak_data.projectiles.launcher_frag_m32, tweak_data.projectiles.launcher_incendiary_m32, "m32")
create_electric_grenade(tweak_data.projectiles.launcher_frag_m32, tweak_data.projectiles.launcher_electric_m32)
create_poison_grenade(tweak_data.projectiles.launcher_frag_m32, tweak_data.projectiles.launcher_poison_m32)

-- China Puff
tweak_data.projectiles.launcher_frag_china = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_china.damage = 60
tweak_data.weapon_disable_crit_for_damage.launcher_frag_china = { explosion = false, fire = false } -- why is china puff allowed to crit lmao

create_incendiary_grenade(tweak_data.projectiles.launcher_frag_china, tweak_data.projectiles.launcher_incendiary_china, "china")
create_electric_grenade(tweak_data.projectiles.launcher_frag_china, tweak_data.projectiles.launcher_electric_china)
create_poison_grenade(tweak_data.projectiles.launcher_frag_china, tweak_data.projectiles.launcher_poison_china)

-- Arbiter
tweak_data.projectiles.launcher_frag_arbiter = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_arbiter.damage = 48
tweak_data.projectiles.launcher_frag_arbiter.range = 300
tweak_data.projectiles.launcher_frag_arbiter.launch_speed = 6000

create_incendiary_grenade(tweak_data.projectiles.launcher_frag_arbiter, tweak_data.projectiles.launcher_incendiary_arbiter, "arbiter")
create_electric_grenade(tweak_data.projectiles.launcher_frag_arbiter, tweak_data.projectiles.launcher_electric_arbiter)
create_poison_grenade(tweak_data.projectiles.launcher_frag_arbiter, tweak_data.projectiles.launcher_poison_arbiter)

-- Basilisk
tweak_data.projectiles.launcher_frag_ms3gl = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_ms3gl.damage = 48

create_incendiary_grenade(tweak_data.projectiles.launcher_frag_ms3gl, tweak_data.projectiles.launcher_incendiary_ms3gl, "ms3gl")
create_electric_grenade(tweak_data.projectiles.launcher_frag_ms3gl, tweak_data.projectiles.launcher_electric_ms3gl)
create_poison_grenade(tweak_data.projectiles.launcher_frag_ms3gl, tweak_data.projectiles.launcher_poison_ms3gl)

tweak_data.projectiles.launcher_rocket = {
	damage = 1600,
	launch_speed = 3000,
	curve_pow = 2,
	player_damage = 1,
	player_dmg_mul = 1 / 20,
	range = 600,
	init_timer = 2.5,
	mass_look_up_modifier = 1,
	sound_event = "rpg_explode",
	name_id = "bm_launcher_rocket",
}

-- Commando 101
tweak_data.projectiles.rocket_ray_frag = deep_clone(tweak_data.projectiles.launcher_rocket)
tweak_data.projectiles.rocket_ray_frag.damage = 180
tweak_data.projectiles.rocket_ray_frag.player_dmg_mul = 1 / 4

-- cop tear gas
tweak_data.projectiles.cs_grenade_quick.damage_per_tick = 1.5

-- FFO ponr
tweak_data.point_of_no_returns.ffo = {
	texture = "guis/textures/pd2/hud_icon_noreturnbox",
	texture_rect = {
		0,
		0,
		32,
		32,
	},
	color = Color(1, 1, 0, 0),
	timer_flash_color = Color(1, 1, 0.8, 0.2),
	attention_color = Color(1, 1, 1, 1),
	scale_box = true,
}

if _G.IS_VR then
	tweak_data.point_of_no_returns.ffo.text_id = "hud_assault_full_force_onslaught"
else
	tweak_data.point_of_no_returns.ffo.text_id = "hud_assault_full_force_onslaught_in"
end

for _, projectile in pairs(tweak_data.projectiles) do
	-- More noticeable explosive damage dropoff to encourage accurate shooting
	if projectile.curve_pow then
		projectile.curve_pow = 2
	end

	if projectile.player_damage and projectile.damage then
		projectile.player_damage = projectile.damage * (projectile.player_dmg_mul or 0.25)
	end
end
