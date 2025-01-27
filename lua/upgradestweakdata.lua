local old_pd2_values_init = UpgradesTweakData._init_pd2_values
function UpgradesTweakData:_init_pd2_values(tweak_data)
	old_pd2_values_init(self, tweak_data)

	-- 100 skill points
	self.values.rep_upgrades.values = { 0 }

	-- Movement speed nerfs
	self.values.player.body_armor.movement = {
		0.85,
		0.825,
		0.8,
		0.75,
		0.7,
		0.6,
		0.5,
	}
	self.values.player.body_armor.stamina = {
		0.85,
		0.825,
		0.8,
		0.75,
		0.7,
		0.6,
		0.5,
	}

	-- steadiness
	self.values.player.body_armor.damage_shake = {
		0.5,
		0.48,
		0.46,
		0.44,
		0.4,
		0.4,
		0.4,
	}

	-- dodge
	self.values.player.body_armor.dodge = {
		0.1,
		0.05,
		0,
		-0.05,
		-0.2,
		-0.25,
		-0.55,
	}

	-- movement tagging
	self.values.player.body_armor.damage_tagged = {
		0.8,
		0.85,
		0.9,
		0.95,
		1,
		1.05,
		1.1,
	}

	-- regen timer
	self.values.player.body_armor.regen_timer = {
		3,
		3.33,
		3.66,
		4,
		4.5,
		5,
		5.5,
	}

	-- ictv nerf
	self.values.player.body_armor.armor[7] = 18

	-- make sna less cancer
	self.values.player.shield_knock_bullet.chance = 0.7

	-- fak heals 90hp on use
	self.values.first_aid_kit.heal_amount = 9
end

local old_init = UpgradesTweakData.init
function UpgradesTweakData:init(tweak_data)
	old_init(self, tweak_data)

	-- Weapons
	-------------

	-- LMG / Minigun movement penalties revert
	self.weapon_movement_penalty.lmg = 0.8
	self.weapon_movement_penalty.minigun = 0.75
	self.weapon_movement_penalty.heavy = 0.75

	-- Skills
	-------------

	-- Mastermind --

	-- Bandage
	self.values.temporary.passive_revive_damage_reduction[1] = { 0.9, 5 }
	self.skill_descs.combat_medic.multibasic = "10%"
	self.skill_descs.combat_medic.multibasic2 = "5"

	-- Painkillers
	self.values.temporary.passive_revive_damage_reduction[2] = { 0.5, 5 }
	self.values.temporary.revived_damage_resist[1] = { 0.5, 5 }
	self.skill_descs.tea_time.multibasic = "40%"
	self.skill_descs.tea_time.multipro = "50%"
	self.skill_descs.tea_time.multibasic2 = "5"

	-- Company Soul
	self.skill_descs.fast_learner.multibasic = "8"
	self.skill_descs.fast_learner.multipro = "50%"

	-- Combat Medic
	self.values.player.revive_damage_reduction[1] = 0.6
	self.values.temporary.revive_damage_reduction[1][1] = 0.6
	self.values.player.revive_interaction_speed_multiplier = { 2 / 3 }
	self.skill_descs.tea_cookies.multibasic = "40%"
	self.skill_descs.tea_cookies.multibasic2 = "5"
	self.skill_descs.tea_cookies.multipro = "33%"
	self.skill_descs.tea_cookies.multipro2 = "25%"
	self.skill_descs.tea_cookies.multipro3 = "10"

	-- Inspire
	self.morale_boost_speed_bonus = 1.3
	self.morale_boost_reload_speed_bonus = 1.3
	self.morale_boost_time = 7
	self.values.cooldown.long_dis_revive[1][2] = 120
	self.skill_descs.inspire.multibasic = "7m"
	self.skill_descs.inspire.multibasic2 = "30%"
	self.skill_descs.inspire.multibasic3 = "7"
	self.skill_descs.inspire.multipro = "120"

	-- FFriendship
	self.definitions.player_extra_hostages = {
		category = "feature",
		name_id = "menu_shotgun_extra_hostages",
		upgrade = {
			category = "player",
			upgrade = "extra_hostages",
			value = 1,
		},
	}
	self.values.player.extra_hostages = { 2 }
	self.skill_descs.triathlete.multibasic = "4"
	self.skill_descs.triathlete.multipro = "2"
	self.skill_descs.triathlete.multipro2 = "75%"

	-- Confident
	self.skill_descs.cable_guy.multipro = "50%"

	-- PiC
	self.values.player.passive_convert_enemies_health_multiplier = { 0.10, 0.01 }
	self.skill_descs.control_freak.multibasic3 = "90%"
	self.skill_descs.control_freak.multipro4 = "9%"

	-- Hostage Situation
	self.definitions.team_hostage_situation = {
		category = "feature",
		name_id = "hostage_situation",
		upgrade = {
			category = "team",
			upgrade = "hostage_situation",
			value = 1,
		},
	}
	self.values.team.hostage_situation = { 4 }
	self.values.team.damage = {
		hostage_absorption = { 0.2 },
		hostage_absorption_limit = 4,
	}
	self.skill_descs.stockholm_syndrome.multibasic = "2"
	self.skill_descs.stockholm_syndrome.multipro = "4"
	self.skill_descs.stockholm_syndrome.multipro2 = "4"

	-- Hostage Taker
	self.values.player.hostage_min_sum_taker = { 1, 1 }
	self.values.player.joker_counts_for_hostage_boost = { true }
	self.values.player.hostage_health_regen_addend = { 1, 1.2 }
	self.definitions.player_hostage_min_sum_taker_1 = {
		category = "feature",
		name_id = "hostage_min_sum_taker",
		upgrade = {
			category = "player",
			upgrade = "hostage_min_sum_taker",
			value = 1,
		},
	}
	self.definitions.player_hostage_min_sum_taker_2 = {
		category = "feature",
		name_id = "hostage_min_sum_taker",
		upgrade = {
			category = "player",
			upgrade = "hostage_min_sum_taker",
			value = 2,
		},
	}
	self.definitions.player_joker_counts_for_hostage_boost = {
		category = "feature",
		name_id = "joker_counts_for_hostage_boost",
		upgrade = {
			category = "player",
			upgrade = "joker_counts_for_hostage_boost",
			value = 1,
		},
	}
	self.skill_descs.black_marketeer.multibasic = "1"
	self.skill_descs.black_marketeer.multibasic2 = "10"
	self.skill_descs.black_marketeer.multibasic3 = "5"
	self.skill_descs.black_marketeer.multipro = "12"

	-- Stable Shot
	self.definitions.assault_rifle_spread_index_addend = {
		name_id = "menu_assault_rifle_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "assault_rifle",
		},
	}
	self.values.assault_rifle.spread_index_addend = { 1 }

	self.definitions.snp_spread_index_addend = {
		name_id = "menu_snp_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "snp",
		},
	}
	self.values.snp.spread_index_addend = { 1 }

	self.definitions.team_weapon_spread_index_addend = {
		name_id = "menu_team_weapon_spread_index_addend",
		category = "team",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "weapon",
		},
	}
	self.values.team.weapon.spread_index_addend = { 1 }
	self.skill_descs.stable_shot.multibasic = "4"
	self.skill_descs.stable_shot.multipro = "4"

	-- Rifleman
	self.values.weapon.enter_steelsight_speed_multiplier[1] = 1.5
	self.values.weapon.swap_speed_multiplier = { 1.33 }
	self.skill_descs.rifleman.multibasic = "50%"
	self.skill_descs.rifleman.multipro = "33%"

	-- Marksman
	self.values.player.not_moving_accuracy_increase[1] = 3
	self.values.weapon.steelsight_recoil_multiplier = { 0.8 }
	self.definitions.weapon_steelsight_recoil_multiplier = {
		name_id = "menu_weapon_steelsight_recoil_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "steelsight_recoil_multiplier",
			category = "weapon",
		},
	}
	self.skill_descs.sharpshooter.multibasic = "20%"
	self.skill_descs.sharpshooter.multipro = "12"

	-- Kilmer
	self.values.snp.reload_speed_multiplier = { 1.25 }
	self.values.assault_rifle.reload_speed_multiplier = { 1.25 }
	self.values.temporary.single_shot_fast_reload[1][1] = 1.4
	self.values.temporary.single_shot_fast_reload[1][2] = 6
	self.skill_descs.speedy_reload.multibasic = "25%"
	self.skill_descs.speedy_reload.multipro = "40%"
	self.skill_descs.speedy_reload.multipro2 = "6"

	-- Bullseye
	self.values.weapon.magnetizing_bullets = { true } -- unused
	self.definitions.weapon_magnetizing_bullets = {
		name_id = "menu_weapon_magnetizing_bullets",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "magnetizing_bullets",
			category = "weapon",
		},
	}

	-- unused
	self.values.weapon.no_pen_damage_penalty = { true } -- unused
	self.definitions.weapon_no_pen_damage_penalty = {
		name_id = "menu_weapon_no_pen_damage_penalty",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "no_pen_damage_penalty",
			category = "weapon",
		},
	}

	self.values.snp.graze_damage = {
		{
			radius = 300,
			damage_factor = 0.5,
		},
		{ -- unused
			radius = 500,
			damage_factor = 0.5,
		},
	}
	self.values.player.headshot_regen_armor_bonus[1] = 5
	self.on_headshot_dealt_cooldown = 3
	self.skill_descs.single_shot_ammo_return.multibasic = "50%"
	self.skill_descs.single_shot_ammo_return.multibasic2 = "3m"
	self.skill_descs.single_shot_ammo_return.multipro = "50"
	self.skill_descs.single_shot_ammo_return.multipro2 = "3"

	-- Enforcer --

	-- Hard Boiled
	self.values.shotgun.swap_speed_multiplier = { 1.2 }
	self.definitions.shotgun_swap_speed_multiplier = {
		name_id = "menu_shotgun_swap_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "swap_speed_multiplier",
			category = "shotgun",
		},
	}
	self.skill_descs.underdog.multibasic = "5%"
	self.skill_descs.underdog.multipro = "20%"

	-- Fast Hands
	self.values.shotgun.pump_reload_speed = { 1.25, 1.5 }
	self.definitions.shotgun_pump_reload_speed_1 = {
		name_id = "menu_shotgun_pump_reload_speed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pump_reload_speed",
			category = "shotgun",
		},
	}
	self.definitions.shotgun_pump_reload_speed_2 = {
		name_id = "menu_shotgun_pump_reload_speed",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "pump_reload_speed",
			category = "shotgun",
		},
	}
	self.skill_descs.shotgun_cqb.multibasic = "25%"
	self.skill_descs.shotgun_cqb.multipro = "25%"

	-- Point Blank
	self.values.shotgun.extra_pellets = { 2 }
	self.values.shotgun.spread_index_addend = { 1 }
	self.values.shotgun.recoil_index_addend[1] = 1
	self.definitions.shotgun_extra_pellets = {
		name_id = "menu_shotgun_extra_pellets",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "extra_pellets",
			category = "shotgun",
		},
	}
	self.definitions.shotgun_spread_index_addend = {
		name_id = "menu_shotgun_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "shotgun",
		},
	}
	self.skill_descs.shotgun_impact.multibasic = "4"
	self.skill_descs.shotgun_impact.multipro = "2"

	-- Shotgun CQB
	self.definitions.shotgun_speed_stack_on_kill = {
		name_id = "menu_shotgun_speed_stack_on_kill",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "speed_stack_on_kill",
			category = "shotgun",
		},
	}
	self.values.shotgun.hip_rate_of_fire[1] = 1.15
	self.values.shotgun.speed_stack_on_kill = { {
		max_stacks = 5,
		max_time = 12,
		speed_bonus = 1.08,
	} }
	self.skill_descs.far_away.multibasic = "15%"
	self.skill_descs.far_away.multipro = "8%"
	self.skill_descs.far_away.multipro2 = "12"
	self.skill_descs.far_away.multipro3 = "5"

	-- Mag-fed Specialist
	self.values.shotgun.mag_reload_speed = { 1.25 }
	self.values.shotgun.magazine_capacity_inc[1] = 5
	self.definitions.shotgun_mag_reload_speed = {
		name_id = "menu_shotgun_mag_reload_speed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "mag_reload_speed",
			category = "shotgun",
		},
	}
	self.skill_descs.close_by.multibasic = "25%"
	self.skill_descs.close_by.multipro = "5"

	-- Shotgun Hell
	self.definitions.cooldown_shotgun_panic_on_kill = {
		name_id = "menu_cooldown_shotgun_panic_on_kill",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "shotgun_panic_on_kill",
			category = "cooldown",
		},
	}
	self.values.shotgun.consume_no_ammo_chance[1] = 0.125
	self.values.cooldown.shotgun_panic_on_kill = { { 1, 5 } }
	self.values.shotgun.panic = { { chance = 0.75, area = 800, amount = "panic" } }
	self.skill_descs.overkill.multibasic = "12.5%"
	self.skill_descs.overkill.multipro = "75%"
	self.skill_descs.overkill.multipro2 = "5"

	-- Resilience
	self.values.player.armor_regen_timer_multiplier[1] = 0.95
	self.values.player.flashbang_multiplier = { 0.5, 0.5 }
	self.skill_descs.oppressor.multibasic2 = "5%"
	self.skill_descs.oppressor.multipro2 = "50%"

	-- Underdog
	self.skill_descs.pack_mule.multibasic = "10"
	self.skill_descs.pack_mule.multibasic2 = "15%"
	self.skill_descs.pack_mule.multibasic3 = "7"
	self.skill_descs.pack_mule.multipro = "18"
	self.skill_descs.pack_mule.multipro2 = "10%"
	self.skill_descs.pack_mule.multipro3 = "7"

	-- Thick Skin
	self.values.player.damage_shake_addend[1] = 1.5
	self.skill_descs.show_of_force.multibasic = "15"

	-- Shock and Awe
	self.values.player.tagged_speed_mul = { 0.5 }
	self.definitions.player_tagged_speed_mul = {
		name_id = "menu_player_tagged_speed_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "tagged_speed_mul",
			category = "player",
		},
	}
	self.skill_descs.iron_man.multibasic = "50%"
	self.skill_descs.iron_man.multipro = "50%"

	-- Nerves of Steel
	self.definitions.player_health_multiplier_1 = {
		name_id = "menu_player_health_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "health_multiplier",
			category = "player",
		},
	}
	self.definitions.player_health_multiplier_2 = {
		name_id = "menu_player_health_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "health_multiplier",
			category = "player",
		},
	}
	self.values.player.health_multiplier = { 1.1, 1.3 }
	self.skill_descs.prison_wife.multibasic = "10%"
	self.skill_descs.prison_wife.multipro = "20%"

	-- Scavenger
	self.values.player.increased_pickup_area[1] = 1.3
	self.skill_descs.scavenging.multibasic = "30%"

	-- Bulletstorm
	self.skill_descs.bandoliers.multibasic = "12"
	self.skill_descs.bandoliers.multipro2 = "30"

	-- Fully Loaded
	self.values.player.body_armor.skill_ammo_mul = {
		1.04,
		1.05,
		1.06,
		1.07,
		1.08,
		1.1,
		1.12,
	}
	self.skill_descs.ammo_reservoir.multibasic = "12%"
	self.skill_descs.ammo_reservoir.multipro = "25%"

	-- Technician --

	-- Transporter
	self.values.carry.interact_speed_multiplier[1] = 0.75
	self.skill_descs.defense_up.multibasic = "25%"

	-- Rifleman
	self.skill_descs.defense_up.multibasic = "50%"
	self.skill_descs.defense_up.multipro = "50%"

	-- Daredevil
	self.values.player.total_interaction_timer_multiplier = { 0.9 }
	self.definitions.player_total_interaction_timer_multiplier = {
		name_id = "menu_player_total_interaction_timer_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "total_interaction_timer_multiplier",
			category = "player",
		},
	}
	self.values.player.interacting_damage_multiplier[1] = 0.65
	self.skill_descs.sentry_targeting_package.multibasic = "10%"
	self.skill_descs.sentry_targeting_package.multipro = "35%"

	-- Defense Package
	self.skill_descs.engineering.multibasic = "150%"

	-- Sentry Nest
	self.skill_descs.tower_defense.multipro = "25%"
	self.skill_descs.tower_defense.multipro2 = "50%"

	-- PhD in Engineering
	self.values.sentry_gun.standstill_omniscience = { true }
	self.definitions.sentry_gun_standstill_omniscience = {
		name_id = "menu_sentry_gun_standstill_omniscience",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "standstill_omniscience",
			synced = true,
			category = "sentry_gun",
		},
	}
	self.skill_descs.eco_sentry.multibasic = "100%"
	self.skill_descs.eco_sentry.multipro = "75%"
	self.skill_descs.eco_sentry.multipro2 = "250%"

	-- Hardware Expert
	self.values.player.drill_autorepair_1[1] = 0.2
	self.skill_descs.hardware_expert.multipro3 = "20%"

	-- Kickstarter
	self.values.player.drill_autorepair_2[1] = 0.3
	self.skill_descs.kick_starter.multibasic = "30%"

	-- Combat Engineering
	self.values.trip_mine.explosion_size_multiplier_1 = { 1.5 }
	self.skill_descs.combat_engineering.multibasic = "50%"

	-- More Firepower
	self.values.shape_charge.quantity = { 2, 5 }
	self.values.trip_mine.quantity = { 5, 15 }
	self.skill_descs.more_fire_power.multibasic = "2"
	self.skill_descs.more_fire_power.multibasic2 = "5"
	self.skill_descs.more_fire_power.multipro = "3"
	self.skill_descs.more_fire_power.multipro2 = "10"

	-- Fire Trap
	self.values.trip_mine.fire_trap[1][1] = 10
	self.values.trip_mine.fire_trap[2][1] = 30
	self.skill_descs.fire_trap.multibasic = "20"
	self.skill_descs.fire_trap.multipro = "20"

	-- Steady Grip
	self.definitions.smg_recoil_index_addend = {
		name_id = "menu_smg_recoil_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "recoil_index_addend",
			category = "smg",
		},
	}
	self.values.smg.recoil_index_addend = { 1 }

	self.definitions.minigun_recoil_index_addend = {
		name_id = "menu_smg_recoil_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "recoil_index_addend",
			category = "minigun",
		},
	}
	self.values.minigun.recoil_index_addend = { 1 }
	self.values.team.weapon.recoil_index_addend[1] = 1
	self.values.team.weapon.suppression_recoil_index_addend[1] = 1
	self.skill_descs.steady_grip.multibasic = "4"
	self.skill_descs.steady_grip.multipro = "4"

	-- Oppressor
	self.definitions.player_suppression_bonus_2 = {
		name_id = "menu_player_suppression_bonus",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "suppression_multiplier",
			category = "player",
		},
	}
	self.values.player.suppression_multiplier = { 1.15, 1.45 }
	self.skill_descs.heavy_impact.multibasic = "15%"
	self.skill_descs.heavy_impact.multipro = "30%"

	-- Fire Control
	self.definitions.minigun_spray_recoil_multiplier = {
		name_id = "menu_minigun_spray_recoil_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spray_recoil_multiplier",
			category = "minigun",
		},
	}
	self.values.minigun.spray_recoil_multiplier = {
		0.005,
	}
	self.definitions.lmg_spray_recoil_multiplier = {
		name_id = "menu_lmg_spray_recoil_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spray_recoil_multiplier",
			category = "lmg",
		},
	}
	self.values.lmg.spray_recoil_multiplier = {
		0.01,
	}
	self.definitions.smg_spray_recoil_multiplier = {
		name_id = "menu_smg_spray_recoil_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spray_recoil_multiplier",
			category = "smg",
		},
	}
	self.values.smg.spray_recoil_multiplier = {
		0.015,
	}

	self.values.weapon.hipfire_spread_penalty_reduction = { 0.8 }
	self.definitions.weapon_hipfire_spread_penalty_reduction = {
		name_id = "menu_hipfire_spread_penalty_reduction",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hipfire_spread_penalty_reduction",
			category = "weapon",
		},
	}

	self.values.player.weapon_movement_stability[1] = 0.9
	self.max_spray_recoil_reduction = 0.5
	self.skill_descs.fire_control.multibasic = "20%"
	self.skill_descs.fire_control.multipro = "50%"

	-- Sleight of Hand
	self.values.lmg.reload_speed_multiplier = { 1.2 }
	self.values.smg.reload_speed_multiplier = { 1.2 }
	self.skill_descs.shock_and_awe.multibasic = "20%"

	-- Mag Plus
	self.definitions.player_automatic_mag_increase_2 = {
		name_id = "menu_automatic_mag_increase",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "automatic_mag_increase",
			category = "player",
		},
	}
	self.values.player.automatic_mag_increase = { 5, 15 }
	self.skill_descs.carbon_blade.multibasic = "5"
	self.skill_descs.carbon_blade.multipro = "10"

	-- Heavy Gun Expert
	self.values.player.no_movement_penalty = { true }
	self.definitions.player_no_movement_penalty = {
		name_id = "menu_player_no_movement_penalty",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "no_movement_penalty",
			category = "player",
		},
	}
	self.values.weapon.automatic_head_shot_add[1] = 0.8
	self.skill_descs.body_expertise.multipro = "80%"

	-- Ghost --

	-- Inner Pockets
	self.values.player.melee_concealment_modifier[1] = 1
	self.values.player.ballistic_vest_concealment[1] = 3
	self.skill_descs.cleaner.multibasic2 = "1"
	self.skill_descs.cleaner.multipro2 = "3"

	-- Winstone Wolfe
	self.values.player.pick_lock_easy_speed_multiplier[1] = 0.5
	self.skill_descs.second_chances.multibasic = "1"
	self.skill_descs.second_chances.multibasic2 = "3"
	self.skill_descs.second_chances.multipro = "50%"
	self.skill_descs.second_chances.multipro2 = "50%"

	-- ECM Feedback
	self.ecm_feedback_retrigger_interval = 120
	self.skill_descs.ecm_booster.multibasic = "25m"
	self.skill_descs.ecm_booster.multipro = "2"

	-- Chameleon
	self.values.player.suspicion_multiplier[1] = 0.65
	self.skill_descs.jail_workout.multibasic = "35%"
	self.skill_descs.jail_workout.multipro = "5"

	-- ECM Specialist
	self.values.ecm_jammer.feedback_duration_boost = {
		1.5,
	}
	self.values.ecm_jammer.feedback_duration_boost_2 = {
		1.5,
	}
	self.skill_descs.ecm_2x.multipro = "30"

	-- Sixth Sense
	self.skill_descs.chameleon.multibasic = "10"
	self.skill_descs.chameleon.multibasic2 = "3"

	-- Athlete
	self.skill_descs.sprinter.multibasic = "25%"
	self.skill_descs.sprinter.multipro = "25%"
	self.skill_descs.sprinter.multipro2 = "10%"

	-- Duck and Cover
	self.values.player.crouch_speed_multiplier[1] = 1.15
	self.values.player.crouch_dodge_chance[1] = 0.1
	self.skill_descs.awareness.multibasic = "15%"
	self.skill_descs.awareness.multipro = "10%"

	-- Sprinter
	self.values.player.run_speed_multiplier[1] = 1.15
	self.values.player.on_zipline_dodge_chance[1] = 0.1
	self.skill_descs.optic_illusions.multibasic = "15%"
	self.skill_descs.optic_illusions.multipro = "10%"

	-- Second Wind
	self.definitions.cooldown_panic_on_armor_break = {
		name_id = "menu_cooldown_panic_on_armor_break",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "panic_on_armor_break",
			category = "cooldown",
		},
	}
	self.values.cooldown.panic_on_armor_break = { { 1, 12 } }
	self.values.player.armor_panic = { { chance = 0.75, area = 500, amount = "panic" } }
	self.values.temporary.damage_speed_multiplier = { { 1.25, 5 } }
	self.skill_descs.dire_need.multibasic = "25%"
	self.skill_descs.dire_need.multibasic2 = "5"
	self.skill_descs.dire_need.multipro = "75%"
	self.skill_descs.dire_need.multipro2 = "12"

	-- Shockproof
	self.values.player.weaker_tase_effect = { 0.33 }
	self.definitions.player_weaker_tase_effect = {
		name_id = "menu_weaker_tase_effect",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "weaker_tase_effect",
			category = "player",
		},
	}
	self.skill_descs.insulation.multibasic = "33%"

	-- Sneaky Bastard
	self.values.player.detection_risk_add_dodge_chance = {
		{ 0.01, 2, "below", 35, 0.1 },
		{ 0.015, 1, "below", 35, 0.15 },
	}
	self.skill_descs.jail_diet.multibasic2 = "2"
	self.skill_descs.jail_diet.multipro = "1.5%"
	self.skill_descs.jail_diet.multipro4 = "15%"

	-- Resilient Assault
	self.values.player.critical_hit_chance[1] = 0.05
	self.values.player.armor_depleted_stagger_shot = {
		0,
		3,
	}
	self.skill_descs.scavenger.multibasic = "5%"
	self.skill_descs.scavenger.multibasic2 = "200%"
	self.skill_descs.scavenger.multipro = "3"

	-- Eagle Eye
	self.values.weapon.special_damage_taken_multiplier[1] = 1.1
	self.values.player.marked_distance_mul[1] = 4
	self.skill_descs.thick_skin.multibasic = "10%"
	self.skill_descs.thick_skin.multipro = "4"

	-- The Professional
	self.values.weapon.silencer_enter_steelsight_speed_multiplier[1] = 1.5
	self.skill_descs.silence_expert.multibasic = "50%"
	self.skill_descs.silence_expert.multipro = "1"
	self.skill_descs.silence_expert.multipro2 = "2"

	-- HVT
	self.values.player.marked_inc_dmg_distance[1][2] = 1.2
	self.values.player.marked_enemy_damage_mul = 1.3
	self.skill_descs.hitman.multibasic = "20%"
	self.skill_descs.hitman.multibasic2 = "10"
	self.skill_descs.hitman.multipro = "30%"
	self.skill_descs.hitman.multipro2 = "100%"

	-- Silencer Expert
	self.definitions.weapon_silencer_damage_multiplier = {
		category = "feature",
		name_id = "silencer_damage_multiplier",
		upgrade = {
			category = "weapon",
			upgrade = "silencer_damage_multiplier",
			value = 1,
		},
	}
	self.definitions.weapon_armor_piercing_chance_silencer = {
		category = "feature",
		name_id = "armor_piercing_chance_silencer",
		upgrade = {
			category = "weapon",
			upgrade = "armor_piercing_chance_silencer",
			value = 1,
		},
	}
	self.definitions.weapon_silencer_fire_rate_multiplier = {
		category = "feature",
		name_id = "silencer_fire_rate_multiplier",
		upgrade = {
			category = "weapon",
			upgrade = "silencer_fire_rate_multiplier",
			value = 1,
		},
	}
	self.values.weapon.silencer_fire_rate_multiplier = { 1.15 }
	self.values.weapon.armor_piercing_chance_silencer[1] = 0.5
	self.skill_descs.backstab.multibasic = "15%"
	self.skill_descs.backstab.multipro = "15%"
	self.skill_descs.backstab.multipro2 = "50%"

	-- Low Blow
	self.definitions.weapon_extra_crit_damage_mul = {
		category = "feature",
		name_id = "extra_crit_damage_mul",
		upgrade = {
			category = "weapon",
			upgrade = "extra_crit_damage_mul",
			value = 1,
		},
	}
	self.values.player.detection_risk_add_crit_chance = {
		{ 0.03, 2, "below", 35, 0.3 },
		{ 0.03, 1, "below", 35, 0.3 },
	}
	self.values.weapon.extra_crit_damage_mul = { 1 }
	self.skill_descs.unseen_strike.multibasic = "3%"
	self.skill_descs.unseen_strike.multibasic2 = "2"
	self.skill_descs.unseen_strike.multibasic3 = "35"
	self.skill_descs.unseen_strike.multibasic4 = "30%"
	self.skill_descs.unseen_strike.multipro = "3%"
	self.skill_descs.unseen_strike.multipro2 = "1"
	self.skill_descs.unseen_strike.multipro3 = "100%"

	-- Fugitive --

	-- Equilbrium nerf
	self.values.pistol.swap_speed_multiplier = { 1.10 } -- funny how this is actually 50% in vanilla and not 30%
	self.skill_descs.equilibrium.multibasic3 = "10%"

	-- Trigger Happy
	self.values.pistol.stacking_hit_damage_multiplier = {
		{ max_stacks = 5, max_time = 3, damage_bonus = 1.15 },
		{ max_stacks = 2, max_time = 6, damage_bonus = 1.375 },
	}
	self.skill_descs.trigger_happy.multibasic = "15%"
	self.skill_descs.trigger_happy.multibasic2 = "3"
	self.skill_descs.trigger_happy.multibasic3 = "5"
	self.skill_descs.trigger_happy.multipro = "37.5%"
	self.skill_descs.trigger_happy.multipro2 = "6"
	self.skill_descs.trigger_happy.multipro3 = "2"

	-- Tough Guy
	self.definitions.player_swap_weapon_when_downed = {
		name_id = "menu_player_swap_weapon_when_downed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "swap_weapon_when_downed",
			category = "player",
		},
	}
	self.values.player.swap_weapon_when_downed = { true }

	-- Quick Fix
	self.skill_descs.running_from_death.multipro = "10%"
	self.skill_descs.running_from_death.multipro2 = "120"

	-- Running from Death
	self.skill_descs.up_you_go.multibasic = "100%"
	self.skill_descs.up_you_go.multipro = "30%"
	self.skill_descs.up_you_go.multipro2 = "10"

	-- Uppers
	self.definitions.first_aid_kit_hot_regen_1 = {
		name_id = "menu_first_aid_kit_hot_regen_1",
		category = "equipment_upgrade",
		upgrade = {
			value = 1,
			upgrade = "first_aid_kit_hot_regen",
			category = "first_aid_kit",
		},
	}
	self.definitions.player_first_aid_health_regen = {
		name_id = "menu_temporary_first_aid_health_regen",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "first_aid_health_regen",
			category = "temporary",
		},
	}
	self.values.first_aid_kit.first_aid_kit_hot_regen = { true }
	self.values.temporary.first_aid_health_regen = { { 1, 60.1 } }
	self.skill_descs.feign_death.multibasic = "10"
	self.skill_descs.feign_death.multibasic2 = "5"
	self.skill_descs.feign_death.multibasic3 = "60"
	self.skill_descs.feign_death.multipro = "5"
	self.skill_descs.feign_death.multipro2 = "120"

	-- Swan Song
	self.values.temporary.berserker_damage_multiplier[2] = { 1, 9 }
	self.skill_descs.perseverance.multipro = "6"

	-- Messiah
	self.values.player.messiah_revive_from_bleed_out = { 1, 3 }
	self.values.player.increased_bleedout_timer = { 10 }
	self.definitions.player_messiah_revive_from_bleed_out_2 = {
		name_id = "menu_player_pistol_revive_from_bleed_out",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "messiah_revive_from_bleed_out",
			category = "player",
		},
	}
	self.definitions.player_increased_bleedout_timer = {
		name_id = "menu_player_increased_bleedout_timer",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "increased_bleedout_timer",
			category = "player",
		},
	}
	self.skill_descs.messiah.multibasic = "1"
	self.skill_descs.messiah.multibasic2 = "10"
	self.skill_descs.messiah.multipro = "2"

	-- Pumping Iron
	self.values.player.non_special_melee_multiplier[1] = 3
	self.skill_descs.steroids.multibasic = "200%"

	-- Bloodthirst
	self.values.player.melee_damage_stacking = { { max_multiplier = 5, melee_multiplier = 0.5 } }
	self.skill_descs.bloodthirst.multibasic2 = "500%"

	-- Zerker
	self.values.player.movement_speed_damage_health_ratio_multiplier = { 0.2 }
	self.skill_descs.wolverine.multibasic = "50%"
	self.skill_descs.wolverine.multibasic2 = "20%"
	self.skill_descs.wolverine.multipro = "50%"
	self.skill_descs.wolverine.multipro2 = "250%"

	-- Counterstrike
	self.values.player.run_and_melee_eclipse = { true }
	self.values.cooldown.counter_strike_eclipse = { { 1, 10 } }
	self.definitions.player_run_and_melee_eclipse = {
		name_id = "menu_player_run_and_melee_eclipse",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "run_and_melee_eclipse",
			category = "player",
		},
	}
	self.definitions.player_counter_strike_eclipse_2 = {
		name_id = "menu_player_counter_strike_eclipse",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "counter_strike_eclipse",
			category = "player",
		},
	}
	self.definitions.cooldown_counter_strike_eclipse = {
		name_id = "menu_cooldown_counter_strike_eclipse",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "counter_strike_eclipse",
			category = "cooldown",
		},
	}
	self.skill_descs.drop_soap.multipro = "10"

	-- Frenzy
	self.values.player.health_damage_reduction = { 0.85, 0.65 }
	self.values.player.max_health_reduction = { 0.1 }
	self.skill_descs.frenzy.multibasic = "10%"
	self.skill_descs.frenzy.multibasic2 = "15%"
	self.skill_descs.frenzy.multipro = "35%"

	-- Perk Decks
	-------------

	-- Crew Chief
	self.values.team.health.hostage_multiplier = { 1.04 }
	self.specialization_descs[1][9].multiperk = "4%"

	-- Muscle
	self.values.player.passive_health_regen = { 0.8 }
	self.values.temporary.mrwi_health_invulnerable[1][3] = 60
	self.specialization_descs[2][9].multiperk = "40%"
	self.specialization_descs[2][9].multiperk2 = "8"
	self.specialization_descs[2][7].multiperk = "50%"
	self.specialization_descs[2][7].multiperk2 = "2"
	self.specialization_descs[2][7].multiperk3 = "60"

	-- Armorer
	self.values.temporary.armor_break_invulnerable = { { 2, 45 } }
	self.specialization_descs[3][7].multiperk3 = "45"
	self.specialization_descs[3][1].multiperk = "5%"
	self.specialization_descs[3][3].multiperk = "5%"
	self.specialization_descs[3][5].multiperk = "5%"

	-- Rogue (and other dodge decks)
	self.values.player.passive_dodge_chance = { 0.05, 0.15, 0.25 }
	self.values.player.tier_dodge_chance = { 0.1, 0.15, 0.2 }
	self.specialization_descs[4][1].multiperk = "5%"
	self.specialization_descs[4][5].multiperk = "10%"
	self.specialization_descs[4][7].multiperk = "10%"
	self.specialization_descs[6][1].multiperk = "5%"
	self.specialization_descs[7][1].multiperk = "10%"
	self.specialization_descs[13][5].multiperk3 = "5%"
	self.specialization_descs[18][5].multiperk = "5%"
	self.specialization_descs[21][5].multiperk2 = "5%"

	-- Hitman
	self.values.player.primary_reload_secondary[1] = 5
	self.values.player.secondary_reload_primary[1] = 5
	self.values.temporary.unseen_strike[1] = { 1.2, 5 }
	self.values.cooldown.hitman_ammo_refund = { { 1, 2 } }
	self.specialization_descs[5][1].multiperk = "5"
	self.specialization_descs[5][3].multiperk = "80%"
	self.specialization_descs[5][5].multiperk = "20%"
	self.specialization_descs[5][5].multiperk2 = "5"
	self.specialization_descs[5][5].multiperk3 = "4"
	self.specialization_descs[5][7].multiperk = "1"
	self.specialization_descs[5][7].multiperk2 = "3"
	self.specialization_descs[5][9].multiperk = "30"
	self.specialization_descs[5][9].multiperk2 = "1"
	self.definitions.cooldown_hitman_ammo_refund = {
		name_id = "menu_cooldown_hitman_ammo_refund",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "hitman_ammo_refund",
			category = "cooldown",
		},
	}

	-- Crook
	self.values.player.level_2_dodge_addend = {
		0.05,
		0.15,
		0.20,
	}
	self.values.player.level_3_dodge_addend = {
		0.05,
		0.15,
		0.225,
	}
	self.values.player.level_2_armor_multiplier = {
		1.1,
		1.2,
		1.35,
	}
	self.values.player.level_3_armor_multiplier = {
		1.2,
		1.3,
		1.5,
	}

	-- Infiltrator / Socio healing
	self.values.player.melee_kill_life_leech = { 1.5 }
	self.specialization_descs[9][5].multiperk = "15"
	self.values.temporary.melee_life_leech[1][1] = 4
	self.specialization_descs[8][9].multiperk = "40"

	-- Gambler
	self.values.player.pick_up_ammo_multiplier[1] = 1.15
	for _, v in pairs(self.values.temporary.loose_ammo_restore_health) do
		v[2] = 10
	end
	self.values.temporary.loose_ammo_give_team[1][2] = 5
	self.values.player.increased_pickup_area[2] = 2.25
	self.definitions.player_increased_pickup_area_2 = {
		name_id = "menu_player_increased_pickup_area",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "increased_pickup_area",
			category = "player",
		},
	}
	self.specialization_descs[10][1].multiperk3 = "10"
	self.specialization_descs[10][3].multiperk = "15%"
	self.specialization_descs[10][9].multiperk4 = "125%"

	-- Grinder
	self.damage_to_hot_data.tick_time = 0.5
	self.damage_to_hot_data.total_ticks = 3
	self.damage_to_hot_data.stacking_cooldown = 1.25
	self.values.player.damage_to_hot_extra_ticks[1] = 2
	self.damage_to_hot_data.armors_allowed = { "level_1" }
	self.specialization_descs[11][1].multiperk2 = "0.5"
	self.specialization_descs[11][3].multiperk2 = "0.5"
	self.specialization_descs[11][5].multiperk2 = "0.5"
	self.specialization_descs[11][7].multiperk2 = "0.5"
	self.specialization_descs[11][9].multiperk2 = "0.5"
	self.specialization_descs[11][1].multiperk3 = "1.5"
	self.specialization_descs[11][3].multiperk3 = "1.5"
	self.specialization_descs[11][5].multiperk3 = "1.5"
	self.specialization_descs[11][7].multiperk3 = "1.5"
	self.specialization_descs[11][9].multiperk3 = "2.5"
	self.specialization_descs[11][1].multiperk4 = "1.25"

	-- Yakuza
	self.values.player.damage_health_ratio_multiplier = { 0.30 }
	self.values.player.armor_regen_damage_health_ratio_multiplier[1] = 0.3
	self.values.player.armor_regen_damage_health_ratio_threshold_multiplier[1] = 4
	self.values.player.damage_damage_health_ratio_threshold_multiplier = { 2 }
	self.values.player.dodge_health_ratio_multiplier = { 0.4 }
	self.definitions.player_dodge_health_ratio_multiplier = {
		name_id = "menu_player_dodge_health_ratio_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "dodge_health_ratio_multiplier",
			category = "player",
		},
	}
	self.definitions.player_damage_damage_health_ratio_threshold_multiplier = {
		name_id = "menu_player_damage_damage_health_ratio_threshold_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "damage_damage_health_ratio_threshold_multiplier",
			category = "player",
		},
	}
	self.specialization_descs[12][1].multiperk = "30%"
	self.specialization_descs[12][3].multiperk = "80%"
	self.specialization_descs[12][5].multiperk = "15%"
	self.specialization_descs[12][7].multiperk = "40%"
	self.specialization_descs[12][9].multiperk = "30%"

	-- Ex-President
	self.values.player.body_armor.skill_max_health_store = { 6, 5, 4, 3, 2.5, 2, 1 }
	self.values.player.armor_health_store_amount = { 0.1, 0.3, 0.5 }
	self.specialization_descs[13][1].multiperk = "1"
	self.specialization_descs[13][3].multiperk = "2"
	self.specialization_descs[13][7].multiperk = "2"

	-- Maniac
	self.cocaine_stacks_convert_levels = { 600 / 8, 60 }
	self.values.player.cocaine_stack_absorption_multiplier = { 1.5 }
	self.specialization_descs[14][1].multiperk6 = "75"
	self.specialization_descs[14][7].multiperk2 = "60"
	self.specialization_descs[14][9].multiperk = "50%"

	-- Anarchist
	self.values.player.chico_armor_multiplier[1] = 1.3
	self.values.player.armor_grinding = { {
		{ 1, 1.5 },
		{ 1.5, 2.25 },
		{ 2, 3 },
		{ 2.5, 3.75 },
		{ 3.5, 4.5 },
		{ 5, 6 },
		{ 7, 9 },
	} }
	self.values.player.damage_to_armor = { {
		{ 1, 1.5 },
		{ 1, 1.5 },
		{ 1, 1.5 },
		{ 1, 1.5 },
		{ 1, 1.5 },
		{ 1, 1.5 },
		{ 1, 1.5 },
	} }
	self.values.player.armor_increase = { 0.1, 0.15, 0.2 }
	self.specialization_descs[15][3].multiperk2 = "10%"
	self.specialization_descs[15][5].multiperk2 = "15%"
	self.specialization_descs[15][7].multiperk2 = "20%"
	self.specialization_descs[15][7].multiperk3 = "5%"
	self.specialization_descs[15][9].multiperk3 = "30%"

	-- Biker
	self.wild_trigger_time = 16
	self.wild_max_triggers_per_time = 2
	self.values.player.wild_health_amount = { 0.75 }
	self.values.player.less_health_wild_cooldown = {
		{
			1 / 6,
			1,
		},
	}
	self.values.player.less_armor_wild_cooldown = {
		{
			1 / 6,
			1,
		},
	}
	self.specialization_descs[16][1].multiperk = "7.5"
	self.specialization_descs[16][1].multiperk3 = "2"
	self.specialization_descs[16][1].multiperk4 = "16"
	self.specialization_descs[16][5].multiperk = "1/6"
	self.specialization_descs[16][5].multiperk2 = "16"
	self.specialization_descs[16][5].multiperk3 = "1"
	self.specialization_descs[16][9].multiperk = "1/6"
	self.specialization_descs[16][9].multiperk2 = "16"
	self.specialization_descs[16][9].multiperk3 = "1"

	-- Kingpin
	self.specialization_descs[17][1].multiperk3 = "45"
	self.specialization_descs[17][9].multiperk3 = "5 points"
	self.specialization_descs[17][9].multiperk3 = "1"

	-- Sicario
	self.values.player.dodge_shot_gain = { { 0.1, 1 } }
	self.specialization_descs[18][3].multiperk = "10%"
	self.specialization_descs[18][3].multiperk2 = "1"

	-- Stoic
	self.specialization_descs[19][1].multiperk3 = "16"

	-- Tag Team
	self.values.player.tag_team_base.kill_health_gain = 0.5
	self.values.player.tag_team_base.tagged_health_gain_ratio = 1
	self.values.player.tag_team_damage_absorption = { { kill_gain = 0.15, max = 0.6 } }
	self.specialization_descs[20][1].multiperk2 = "5"
	self.specialization_descs[20][1].multiperk3 = "5"
	self.specialization_descs[20][5].multiperk = "1.5"
	self.specialization_descs[20][5].multiperk2 = "6"

	-- Hacker
	self.values.player.pocket_ecm_heal_on_kill = {
		1.5,
	}
	self.values.team.pocket_ecm_heal_on_kill = {
		0.5,
	}
	self.specialization_descs[21][3].multiperk = "10%"
	self.specialization_descs[21][5].multiperk = "15"
	self.specialization_descs[21][7].multiperk = "10%"
	self.specialization_descs[21][9].multiperk = "5"

	-- Leech
	self.values.player.copr_kill_life_leech[2] = 1
	self.copr_ability_cooldown = 60
	self.values.temporary.copr_ability[1][2] = 4
	self.values.temporary.copr_ability[2][2] = 8
	self.values.player.copr_static_damage_ratio[2] = 0.0625
	self.values.player.copr_teammate_heal = { 0.15, 0.3 }
	self.values.player.copr_activate_bonus_health_ratio[1] = 50
	self.specialization_descs[22][1].multiperk3 = "0.45"
	self.specialization_descs[22][1].multiperk4 = "1.5"
	self.specialization_descs[22][1].multiperk5 = "4"
	self.specialization_descs[22][1].multiperk6 = "60"
	self.specialization_descs[22][5].multiperk = "8"
	self.specialization_descs[22][5].multiperk3 = "3"
	self.specialization_descs[22][9].multiperk = "6.25%"
	self.specialization_descs[22][9].multiperk2 = "40%"

	-- misc
	self.values.player.passive_xp_multiplier[1] = 1.2
	self.values.player.regain_throwable_from_ammo[1].chance = 0.02
	self.values.player.regain_throwable_from_ammo[1].chance_inc = 0.001
end
