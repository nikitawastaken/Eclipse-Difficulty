local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

local function create_explosive_arrow(base_arrow)
	local explosive_arrow = deep_clone(base_arrow)
	local damage = base_arrow.damage
	explosive_arrow.damage = damage * 1.5
	explosive_arrow.bullet_class = "InstantExplosiveBulletBase"
	explosive_arrow.remove_on_impact = true

	return explosive_arrow
end

local function create_poison_arrow(base_arrow)
	local poison_arrow = deep_clone(base_arrow)
	local damage = base_arrow.damage
	poison_arrow.damage = damage * 0.25
	poison_arrow.bullet_class = "PoisonBulletBase"

	return poison_arrow
end

local function create_incendiary_grenade(base_grenade)
	local incendiary_grenade = deep_clone(base_grenade)
	local damage = base_grenade.damage
	local tier_index = math.floor(damage / 12)
	local tier = tier_index <= 2 and "light" or "heavy"

	incendiary_grenade.damage = damage / 12
	incendiary_grenade.burn_tick_period = 0.5
	incendiary_grenade.burn_duration = math.map_range(damage, 24, 48, 5, 10)
	incendiary_grenade.dot_data_name = "proj_launcher_incendiary_" .. tier
	incendiary_grenade.effect_name = "effects/payday2/particles/explosions/grenade_incendiary_explosion"

	return incendiary_grenade
end

local function create_electric_grenade(base_grenade)
	local electric_grenade = deep_clone(base_grenade)
	local damage = base_grenade.damage
	electric_grenade.damage = damage / 2
	electric_grenade.curve_pow = 1 -- 3
	electric_grenade.range = base_grenade.range + 100
	electric_grenade.sound_event = "gl_electric_explode"
	electric_grenade.projectile_trail = true

	return electric_grenade
end

local function create_poison_grenade(base_grenade)
	local poison_grenade = deep_clone(base_grenade)
	local damage = base_grenade.damage
	local tier_index = math.floor(damage / 12)
	local tier = tier_index <= 2 and "light" or "heavy"

	poison_grenade.damage = damage / 12
	poison_grenade.poison_gas_range = 300
	poison_grenade.poison_gas_tick_time = 0.25
	poison_grenade.poison_gas_duration = math.map_range(damage, 24, 48, 10, 15)
	poison_grenade.poison_gas_fade_time = poison_grenade.poison_gas_duration / 10
	poison_grenade.poison_gas_dot_data_name = "proj_launcher_poison_" .. tier
	poison_grenade.projectile_trail = true

	return poison_grenade
end

-- Increase the distance at which Team AI stop holding their position
-- Add targeting priority multipliers based on enemy tags
tweak_data.team_ai.stop_action.distance = tweak_data.team_ai.stop_action.distance * 2
tweak_data.team_ai.special_enemy_priority_mul = {
	spooc = 2,
	medic = 2,
	taser = 1.75,
	sniper = 1.5,
	tank = 1.5,
	marksman = 1.25,
	shield = 1,
}

-- Security Cameras
tweak_data.security_camera = {
	rotation_enabled = overkill_and_above,
	max_yaw = 60,
	max_pitch = 30,
	stall_time = { 1.5, 2.5 },
	turn_rate = 24, -- degrees/s
}

-- Tear Gas damage is now a percentage of total HP
tweak_data.projectiles.cs_grenade_quick.damage_per_tick = tweak_data.projectiles.cs_grenade_quick.damage_per_tick * 2

-- Arrows
tweak_data.projectiles.west_arrow = {
	damage = 12,
	launch_speed = 2500,
	adjust_z = 0,
	mass_look_up_modifier = 1,
	push_at_body_index = 0,
}

tweak_data.projectiles.long_arrow = deep_clone(tweak_data.projectiles.west_arrow)
tweak_data.projectiles.long_arrow.damage = 24
tweak_data.projectiles.long_arrow.launch_speed = 3500
tweak_data.projectiles.long_arrow.adjust_z = -30

tweak_data.projectiles.elastic_arrow = deep_clone(tweak_data.projectiles.west_arrow)
tweak_data.projectiles.elastic_arrow.damage = 24
tweak_data.projectiles.elastic_arrow.launch_speed = 3500
tweak_data.projectiles.elastic_arrow.adjust_z = -130

tweak_data.projectiles.bow_arrow_exp = create_explosive_arrow(tweak_data.projectiles.west_arrow)
tweak_data.projectiles.west_arrow_exp = create_explosive_arrow(tweak_data.projectiles.west_arrow)
tweak_data.projectiles.long_arrow_exp = create_explosive_arrow(tweak_data.projectiles.long_arrow)
tweak_data.projectiles.elastic_arrow_exp = create_explosive_arrow(tweak_data.projectiles.elastic_arrow)

tweak_data.projectiles.bow_arrow_poison = create_poison_arrow(tweak_data.projectiles.west_arrow)
tweak_data.projectiles.bow_poison_arrow = create_poison_arrow(tweak_data.projectiles.west_arrow)
tweak_data.projectiles.long_poison_arrow = create_poison_arrow(tweak_data.projectiles.long_arrow)
tweak_data.projectiles.elastic_arrow_poison = create_poison_arrow(tweak_data.projectiles.elastic_arrow)

tweak_data.projectiles.crossbow_arrow = {
	damage = 8,
	launch_speed = 2500,
	adjust_z = 0,
	mass_look_up_modifier = 1,
	push_at_body_index = 0,
}

tweak_data.projectiles.frankish_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.frankish_arrow.damage = 12

tweak_data.projectiles.arblast_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.arblast_arrow.damage = 24
tweak_data.projectiles.arblast_arrow.launch_speed = 3500

tweak_data.projectiles.ecp_arrow = deep_clone(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.ecp_arrow.damage = 8
tweak_data.projectiles.ecp_arrow.launch_speed = 3500

tweak_data.projectiles.crossbow_arrow_exp = create_explosive_arrow(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.ecp_arrow_exp = create_explosive_arrow(tweak_data.projectiles.ecp_arrow)
tweak_data.projectiles.frankish_arrow_exp = create_explosive_arrow(tweak_data.projectiles.frankish_arrow)
tweak_data.projectiles.arblast_arrow_exp = create_explosive_arrow(tweak_data.projectiles.arblast_arrow)

tweak_data.projectiles.crossbow_poison_arrow = create_poison_arrow(tweak_data.projectiles.crossbow_arrow)
tweak_data.projectiles.ecp_arrow_poison = create_poison_arrow(tweak_data.projectiles.ecp_arrow)
tweak_data.projectiles.frankish_poison_arrow = create_poison_arrow(tweak_data.projectiles.frankish_arrow)
tweak_data.projectiles.arblast_poison_arrow = create_poison_arrow(tweak_data.projectiles.arblast_arrow)

tweak_data.projectiles.dart_arrow = {
	mass_look_up_modifier = 1.25,
	push_at_body_index = 0,
	damage = 12,
	projectile_trail = true,
	adjust_z = -100,
	launch_speed = 2500,
}

tweak_data.projectiles.dart_daze.damage = 0

-- Throwing Knives/Axes/Stars etc.

-- Shuriken
tweak_data.projectiles.wpn_prj_four.damage = 4

-- Ace of Spades
tweak_data.projectiles.wpn_prj_ace.damage = 1

-- Javelin
tweak_data.projectiles.wpn_prj_jav.damage = 24

--Throwing Knife
tweak_data.projectiles.wpn_prj_hur.damage = 12

-- Throwing Axe
tweak_data.projectiles.wpn_prj_target.damage = 12

-- Increase the Laser Chronometer's fire rate but decrease the damage (higher ammo consumption)
tweak_data.projectiles.laser_watch.damage = tweak_data.projectiles.laser_watch.damage / 2

-- Throwable Grenades

-- Frag Grenade
tweak_data.projectiles.frag.damage = 48
tweak_data.projectiles.frag.curve_pow = 1
tweak_data.projectiles.frag.range = 500

-- HEF Grenade
tweak_data.projectiles.frag_com = deep_clone(tweak_data.projectiles.frag)
tweak_data.projectiles.frag_com.name_id = "bm_grenade_frag_com"

-- Molotov Cocktail
tweak_data.projectiles.molotov.damage = 4
tweak_data.projectiles.molotov.curve_pow = 1

-- Incendiary Grenade
tweak_data.projectiles.fir_com.damage = 0.4
tweak_data.projectiles.fir_com.curve_pow = 1

-- Dynamite
tweak_data.projectiles.dynamite = deep_clone(tweak_data.projectiles.frag)
tweak_data.projectiles.dynamite.name_id = "bm_grenade_frag"
tweak_data.projectiles.dynamite.effect_name = "effects/payday2/particles/explosions/dynamite_explosion"

-- Flashbang (formerly Concussion Grenade)
tweak_data.projectiles.concussion.damage = 1
tweak_data.projectiles.concussion.curve_pow = 1
tweak_data.projectiles.concussion.range = 800

-- X1-ZAPper
tweak_data.projectiles.wpn_gre_electric.damage = 24
tweak_data.projectiles.wpn_gre_electric.curve_pow = 1 -- 3
tweak_data.projectiles.wpn_gre_electric.range = 600

-- Matryoshka Grenade (now an alternative to the X1-ZAPper)
tweak_data.projectiles.dada_com.damage = 24
tweak_data.projectiles.dada_com.player_damage = 225
tweak_data.projectiles.dada_com.curve_pow = 1 -- 3
tweak_data.projectiles.dada_com.range = 600

-- The Snowball
tweak_data.projectiles.xmas_snowball.damage = 4
tweak_data.projectiles.xmas_snowball.curve_pow = 1

-- Viper Grenade
tweak_data.projectiles.poison_gas_grenade.damage = 1
tweak_data.projectiles.poison_gas_grenade.curve_pow = 1
tweak_data.projectiles.poison_gas_grenade.poison_gas_range = 400
tweak_data.projectiles.poison_gas_grenade.poison_gas_duration = 20
tweak_data.projectiles.poison_gas_grenade.poison_gas_fade_time = tweak_data.projectiles.poison_gas_grenade.poison_gas_duration / 5
tweak_data.projectiles.poison_gas_grenade.poison_gas_tick_time = 0.5

-- FF related flags
tweak_data.projectiles.poison_gas_grenade.gas_player_damage = tweak_data.projectiles.cs_grenade_quick.damage_per_tick * 0.5 -- Tear gas dmg when player inside viper grenade
tweak_data.projectiles.poison_gas_grenade.damage_tick_period = tweak_data.projectiles.cs_grenade_quick.damage_tick_period -- dmg tick period for player FF
tweak_data.projectiles.poison_gas_grenade.radius_blurzone_multiplier = tweak_data.projectiles.cs_grenade_quick.radius_blurzone_multiplier -- Blurzone modifier

-- Impact Grenade (formerly the Adhesive Grenade)
tweak_data.projectiles.sticky_grenade.damage = 36
tweak_data.projectiles.sticky_grenade.curve_pow = 1
tweak_data.projectiles.sticky_grenade.range = 200
tweak_data.projectiles.sticky_grenade.detonate_timer = 0 -- Instant detonation on impact

-- Launcher Grenades
tweak_data.projectiles.launcher_frag.damage = 36
tweak_data.projectiles.launcher_frag.curve_pow = 1
tweak_data.projectiles.launcher_frag.range = 350

tweak_data.projectiles.launcher_incendiary = create_incendiary_grenade(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_electric = create_electric_grenade(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_poison = create_poison_grenade(tweak_data.projectiles.launcher_frag)

-- GL40
tweak_data.projectiles.launcher_incendiary_m79 = create_incendiary_grenade(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_electric_m79 = create_electric_grenade(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_poison_m79 = create_poison_grenade(tweak_data.projectiles.launcher_frag)

-- Compact-40
tweak_data.projectiles.launcher_frag_slap = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_incendiary_slap = create_incendiary_grenade(tweak_data.projectiles.launcher_frag_slap)
tweak_data.projectiles.launcher_electric_slap = create_electric_grenade(tweak_data.projectiles.launcher_frag_slap)
tweak_data.projectiles.launcher_poison_slap = create_poison_grenade(tweak_data.projectiles.launcher_frag_slap)

-- China Puff
--tweak_data.projectiles.launcher_frag_china = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_china.damage = 30

tweak_data.projectiles.launcher_incendiary_china = create_incendiary_grenade(tweak_data.projectiles.launcher_frag_china)
tweak_data.projectiles.launcher_electric_china = create_electric_grenade(tweak_data.projectiles.launcher_frag_china)
tweak_data.projectiles.launcher_poison_china = create_poison_grenade(tweak_data.projectiles.launcher_frag_china)

-- Little Friend Underbarrel
--tweak_data.projectiles.launcher_m203 = deep_clone(tweak_data.projectiles.launcher_frag)
--tweak_data.projectiles.launcher_m203.projectile_trail = true

-- Groza Underbarrel
--tweak_data.projectiles.underbarrel_m203_groza = deep_clone(tweak_data.projectiles.launcher_frag)
--tweak_data.projectiles.underbarrel_m203_groza.projectile_trail = true

-- Piglet
--tweak_data.projectiles.launcher_frag_m32 = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_m32.damage = 24

tweak_data.projectiles.launcher_incendiary_m32 = create_incendiary_grenade(tweak_data.projectiles.launcher_frag_m32)
tweak_data.projectiles.launcher_electric_m32 = create_electric_grenade(tweak_data.projectiles.launcher_frag_m32)
tweak_data.projectiles.launcher_poison_m32 = create_poison_grenade(tweak_data.projectiles.launcher_frag_m32)

-- Arbiter
--tweak_data.projectiles.launcher_frag_arbiter = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_arbiter.damage = 24
tweak_data.projectiles.launcher_frag_arbiter.launch_speed = 7000
tweak_data.projectiles.launcher_frag_arbiter.range = 200

--tweak_data.projectiles.launcher_incendiary_arbiter = create_incendiary_grenade(tweak_data.projectiles.launcher_frag_arbiter)
tweak_data.projectiles.launcher_electric_arbiter = create_electric_grenade(tweak_data.projectiles.launcher_frag_arbiter)
tweak_data.projectiles.launcher_poison_arbiter = create_poison_grenade(tweak_data.projectiles.launcher_frag_arbiter)

-- Basilisk
--tweak_data.projectiles.launcher_frag_ms3gl = deep_clone(tweak_data.projectiles.launcher_frag)
tweak_data.projectiles.launcher_frag_ms3gl.damage = 24

tweak_data.projectiles.launcher_incendiary_ms3gl = create_incendiary_grenade(tweak_data.projectiles.launcher_frag_ms3gl)
tweak_data.projectiles.launcher_electric_ms3gl = create_electric_grenade(tweak_data.projectiles.launcher_frag_ms3gl)
tweak_data.projectiles.launcher_poison_ms3gl = create_poison_grenade(tweak_data.projectiles.launcher_frag_ms3gl)

-- RPG
tweak_data.projectiles.launcher_rocket.damage = 480
tweak_data.projectiles.launcher_rocket.curve_pow = 1
tweak_data.projectiles.launcher_rocket.player_dmg_mul = 1 / 8
tweak_data.projectiles.launcher_rocket.range = 500
tweak_data.projectiles.launcher_rocket.projectile_trail = true

-- Commando 101
tweak_data.projectiles.rocket_ray_frag.damage = 240
tweak_data.projectiles.rocket_ray_frag.curve_pow = 1
tweak_data.projectiles.rocket_ray_frag.player_dmg_mul = 1 / 4
tweak_data.projectiles.rocket_ray_frag.range = 500

-- the c101 exclusive anim breaks for some reason when it's changed to primary with no fix
tweak_data.scene_poses.weapon.ray = { "husk_generic1", "husk_generic2", "husk_generic3", "husk_generic4", required_pose = false }

-- Cluster Grenade
tweak_data.weapon_disable_crit_for_damage.cluster = { explosion = false, fire = false }
tweak_data.projectiles.cluster = deep_clone(tweak_data.projectiles.frag)
tweak_data.projectiles.cluster.name_id = "bm_grenade_cluster"
tweak_data.projectiles.cluster.effect_name = "effects/payday2/particles/impacts/shotgun_explosive_round"
tweak_data.projectiles.cluster.init_timer = 2.5
tweak_data.projectiles.cluster.range = 300

-- Incendiary Cluster Grenade
tweak_data.weapon_disable_crit_for_damage.cluster_incendiary = { explosion = false, fire = false }
tweak_data.projectiles.cluster_incendiary = deep_clone(tweak_data.projectiles.cluster)
tweak_data.projectiles.cluster_incendiary.name_id = "bm_grenade_cluster_incendiary"
tweak_data.projectiles.cluster_incendiary.effect_name = "effects/payday2/particles/explosions/cluster_incendiary_explosion"
tweak_data.projectiles.cluster_incendiary.sound_event = "white_explosion"
tweak_data.projectiles.cluster_incendiary.dot_data_name = "cluster_incendiary"

-- Flare Gun
tweak_data.projectiles.flun_flare.damage = 0.4
tweak_data.projectiles.flun_flare.airdrop_unit = nil

-- Set Friendly Fire damage
for k, v in pairs(tweak_data.projectiles) do
	if v.player_damage and v.damage then
		v.player_damage = v.damage * (v.player_dmg_mul or 1 / 2)
	end
end

-- Fix the Death Wish soundtrack being unavailable
tweak_data.music.track_list[12].lock = nil

-- Grenade Case HUD icon
tweak_data.hud_icons.equipment_grenade_case = {
	texture = "guis/textures/pd2/blackmarket/icons/deployables/outline/grenade_case",
	texture_rect = {
		0,
		0,
		32,
		32,
	},
}

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

-- LEVELING PROGRESION OVERHAUL --

-- Clear out the vanilla level table (including hardcoded lvls 1-9)
tweak_data.experience_manager.levels = {}

-- Flatten the curve of experience per level distribution, the exponent is reduced from 3 to 1.5
-- Reduce the total amount of experience required to go through lvl 0-100 from 23.3 mil to 20.2 mil
local multiplier = 1
local exp_step_start = 1
local exp_step_end = 100
local exp_step = 1 / (exp_step_end - exp_step_start)
local exp_step_last_points = 5000
local exp_step_curve = 1.5

for i = exp_step_start, exp_step_end do
	tweak_data.experience_manager.levels[i] = {
		points = math.round((500000 - exp_step_last_points) * math.pow(exp_step * (i - exp_step_start), exp_step_curve) + exp_step_last_points) * multiplier,
	}
end

-- Hide ovk290 / sm_wish, lock ov145 behind lvl 40+
tweak_data.difficulty_level_locks = {
	0,
	0,
	0,
	0,
	30,
	60,
	69420,
	69420,
}

-- Rework difficulty exp muls
tweak_data.experience_manager.difficulty_multiplier = {
	2,
	4,
	7,
	12,
	69420,
	69420,
}

-- Make the heist fail multiplier on exp less harsh
tweak_data.experience_manager.stage_failed_multiplier = 0.05

-- Make exp card drops give more exp in pick-a-card
tweak_data.experience_manager.loot_drop_value = {
	xp10 = 8000,
	xp15 = 16000,
	xp20 = 32000,
	xp30 = 64000,
	xp40 = 96000,
	xp50 = 128000,
	xp60 = 192000,
	xp70 = 256000,
	xp80 = 320000,
	xp90 = 384000,
	xp100 = 512000,
	xp_pda9_1 = 250000,
	xp_pda9_2 = 3000000,
}

-- Remove alive player multipliers, there's already a strong penalty for the player in custody
tweak_data.experience_manager.alive_humans_multiplier = {
	[0] = 1,
	1,
	1,
	1,
	1,
}

-- No stupid extra multipliers
tweak_data.experience_manager.limited_xmas_bonus_multiplier = 1
tweak_data.experience_manager.limited_bonus_multiplier = 1
-- these two in particular are to block any day any heist users from cheesing progression with 7 day long heists (and it shouldn't affect any vanilla heists)
tweak_data.experience_manager.day_multiplier = { 1, 1, 1, 1, 1, 1, 1 }
tweak_data.experience_manager.pro_day_multiplier = { 1, 1, 1, 1, 1, 1, 1 }

tweak_data:digest_recursive(tweak_data.experience_manager)

-- Offshore casino rework
if tweak_data.blackmarket.xp.xp_pda9_1 then
	tweak_data.blackmarket.xp.xp_pda9_1.weight = 0.1
	tweak_data.blackmarket.xp.xp_pda9_2.weight = 0.1
	tweak_data.blackmarket.xp.xp_pda9_1.infamous = true
	tweak_data.blackmarket.xp.xp_pda9_2.infamous = true
	tweak_data.blackmarket.xp.xp_pda9_1.pcs = {
		90,
		100,
	}
	tweak_data.blackmarket.xp.xp_pda9_2.pcs = {
		90,
		100,
	}
end

tweak_data.casino = {
	unlock_level = 10,
	entrance_level = {
		10,
		20,
		30,
		40,
		50,
		60,
		70,
	},
	entrance_fee = {
		45000,
		55000,
		60000,
		75000,
		120000,
		135000,
		150000,
	},
	prefer_cost = 80000,
	prefer_chance = 0.12,
	secure_card_cost = {
		35000,
		60000,
		95000,
	},
	secure_card_level = {
		1,
		1,
		1,
	},
	infamous_cost = 200000,
	infamous_chance = 3,
}

-- Safehouse Unlock Level
tweak_data.safehouse_unlock_level = 35
-- Tweak "Earned from raid" text value since Safehouse Raid don't give coins anymore
tweak_data.safehouse.rewards.raid = 0

-- Color Gradings
table.insert(tweak_data.color_grading, { value = "color_bhd_classic", text_id = "menu_color_bhd_classic" })
table.insert(tweak_data.color_grading, { value = "color_heat_classic", text_id = "menu_color_heat_classic" })
table.insert(tweak_data.color_grading, { value = "color_nice_classic", text_id = "menu_color_nice_classic" })
table.insert(tweak_data.color_grading, { value = "color_payday_classic", text_id = "menu_color_payday_classic" })
table.insert(tweak_data.color_grading, { value = "color_xgen_classic", text_id = "menu_color_xgen_classic" })
table.insert(tweak_data.color_grading, { value = "color_xxxgen_classic", text_id = "menu_color_xxxgen_classic" })
table.insert(tweak_data.color_grading, { value = "color_plus", text_id = "menu_color_plus" })
table.insert(tweak_data.color_grading, { value = "color_force", text_id = "menu_color_force" })
table.insert(tweak_data.color_grading, { value = "color_e3nice", text_id = "menu_color_e3nice" })
table.insert(tweak_data.color_grading, { value = "color_subzero", text_id = "menu_color_subzero" })
table.insert(tweak_data.color_grading, { value = "color_cgreyscale", text_id = "menu_color_cgreyscale" })

-- Remove some of the special contracts from crime.net
local function btn(tbl, name, class, index)
	for id, btn in pairs(tbl) do
		if btn[class or "name_id"] == name and id > (index or 0) then
			return id
		end
	end
end

local special = tweak_data.gui.crime_net.special_contracts
table.remove(special, btn(special, "menu_cn_short"))
table.remove(special, btn(special, "menu_mutators"))
table.remove(special, btn(special, "cn_crime_spree"))
table.remove(special, btn(special, "cn_crime_spree"))
table.remove(special, btn(special, "menu_cn_challenge"))

special[btn(special, "menu_cn_casino")].x = 347
special[btn(special, "menu_cn_casino")].y = 716
special[btn(special, "menu_cn_premium_buy")].menu_node = "contract_broker"

-- Main Menu Color Grading
tweak_data.scene_environments.standard.color_grading = "color_bhd_classic"

-- misc
-- Python code for matplotlibing experience graphs
--[[

import math
import matplotlib.pyplot as plt

# ====================================================
# VANILLA PAYDAY 2 SETTINGS
# ====================================================
exp_step_start_vanilla = 10
exp_step_end_vanilla = 100
exp_step_vanilla = 1 / (exp_step_end_vanilla - exp_step_start_vanilla)
exp_step_last_points_vanilla = 4600
exp_step_curve_vanilla = 3
multiplier_vanilla = 1

# Base levels 1–9 (vanilla hardcoded)
base_points_vanilla = [900, 1250, 1550, 1850, 2200, 2600, 3000, 3500, 4000]

levels_vanilla = []
xp_points_vanilla = []

# Add early fixed levels
for i, p in enumerate(base_points_vanilla, start=1):
    levels_vanilla.append(i)
    xp_points_vanilla.append(p)

# Procedural XP (10–100)
for i in range(exp_step_start_vanilla, exp_step_end_vanilla + 1):
    points = round(
        (1000000 - exp_step_last_points_vanilla)
        * math.pow(exp_step_vanilla * (i - exp_step_start_vanilla), exp_step_curve_vanilla)
        + exp_step_last_points_vanilla
    ) * multiplier_vanilla
    levels_vanilla.append(i)
    xp_points_vanilla.append(points)

# Calculate cumulative XP
cumulative_vanilla = []
running_total = 0
for xp in xp_points_vanilla:
    running_total += xp
    cumulative_vanilla.append(running_total)


# ====================================================
# CUSTOM (ECLIPSE PROGRESSION DEV BRANCH)
# ====================================================
exp_step_start_mod = 1
exp_step_end_mod = 100
exp_step_mod = 1 / (exp_step_end_mod - exp_step_start_mod)
exp_step_last_points_mod = 3000
exp_step_curve_mod = 1.5
multiplier_mod = 1

levels_mod = []
xp_points_mod = []

for i in range(exp_step_start_mod, exp_step_end_mod + 1):
    points = round(
        (500000 - exp_step_last_points_mod)
        * math.pow(exp_step_mod * (i - exp_step_start_mod), exp_step_curve_mod)
        + exp_step_last_points_mod
    ) * multiplier_mod
    levels_mod.append(i)
    xp_points_mod.append(points)

# Calculate cumulative XP
cumulative_mod = []
running_total = 0
for xp in xp_points_mod:
    running_total += xp
    cumulative_mod.append(running_total)


# ====================================================
# REPORT
# ====================================================
target_level = 80

total_xp_vanilla_target = cumulative_vanilla[target_level - 1]
total_xp_vanilla_100 = cumulative_vanilla[-1]
total_xp_mod_target = cumulative_mod[target_level - 1]
total_xp_mod_100 = cumulative_mod[-1]

print(f"[VANILLA] Total XP to reach level {target_level}: {total_xp_vanilla_target:,} XP")
print(f"[VANILLA] Total XP to reach level 100: {total_xp_vanilla_100:,} XP")
print()
print(f"[CUSTOM]  Total XP to reach level {target_level}: {total_xp_mod_target:,} XP")
print(f"[CUSTOM]  Total XP to reach level 100: {total_xp_mod_100:,} XP")


# ====================================================
# PLOT 1 — XP PER LEVEL (BOTH CURVES)
# ====================================================
plt.figure(figsize=(10, 6))
plt.plot(levels_vanilla, xp_points_vanilla, marker="o", color="tab:blue", label="Vanilla PAYDAY 2")
plt.plot(levels_mod, xp_points_mod, marker="o", color="tab:orange", label="Custom Curve (Eclipse Progression-Dev)")
plt.title("XP Required per Level — Vanilla vs. Eclipse Progression-Dev")
plt.xlabel("Level")
plt.ylabel("XP Required for Next Level")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()

# ====================================================
# PLOT 2 — CUMULATIVE XP COMPARISON
# ====================================================
plt.figure(figsize=(10, 6))
plt.plot(levels_vanilla, cumulative_vanilla, color="tab:blue", label="Vanilla PAYDAY 2")
plt.plot(levels_mod, cumulative_mod, color="tab:orange", label="Custom Curve (Eclipse Progression-Dev)")
plt.title("Total Cumulative XP — Vanilla vs. Eclipse Progression-Dev")
plt.xlabel("Level")
plt.ylabel("Total XP Required")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()



]]
