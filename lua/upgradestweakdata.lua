local old_pd2_values_init = UpgradesTweakData._init_pd2_values
function UpgradesTweakData:_init_pd2_values(tweak_data)
	old_pd2_values_init(self, tweak_data)

	self.values.revolver = {} -- init revolver category table
	self.values.grenade_case = {} -- init revolver category table

	-- why is this here?
	self.explosive_bullet = {
		curve_pow = 3,
		player_dmg_mul = 1 / 4,
		range = 300,
	}

	-- 100 skill points
	self.values.rep_upgrades.values = { 0 }

	self.values.player.body_armor = {
		armor = { 0, 2, 4.5, 7, 10, 14, 18 },
		movement = { 1, 0.925, 0.85, 0.775, 0.7, 0.625, 0.55 },
		concealment = { 30, 26, 23, 21, 18, 12, 1 },
		dodge = { 0.1, 0.05, 0, -0.05, -0.2, -0.25, -0.55 },
		damage_shake = { 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4 },
		stamina = { 1, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7 },
		regen_timer = { 3, 3.25, 3.5, 3.75, 4, 4.25, 4.5 },
	}

	-- make sna less cancer
	self.values.player.shield_knock_bullet.chance = 0.7

	-- fak heals 90hp on use
	self.values.first_aid_kit.heal_amount = 9
end

local old_init = UpgradesTweakData.init
function UpgradesTweakData:init(tweak_data)
	old_init(self, tweak_data)

	-- LEVELING PROGRESION OVERHAUL --

	-- redefine the level unlocks tree, for now only the first 10 levels (early game) are done
	-- TODO: the rest of the level unlocks
	self.level_tree = {
		[0] = {
			upgrades = {
				"frag",
				"frag_com",
				"wpn_dallas_mask",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"b92fs",
				"mac10",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"ak74",
				"new_m4",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"colt_1911",
				"g22c",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"r870",
			}
		},
		{ -- lvl 5
			name_id = "body_armor",
			upgrades = {
				"body_armor1",
				"new_raging_bull",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"g36",
				"s552",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"concussion",
				"new_mp5",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"scar",
			}
		},
		{
			name_id = "weapons",
			upgrades = {
				"serbu",
			}
		},
		{ -- lvl 10
			name_id = "body_armor",
			upgrades = {
				"body_armor2",
				"olympic",
			}
		},
		-- set up the armor unlocks in advance
		[15] = {
			name_id = "body_armor3",
			upgrades = {
				"body_armor3",
			}
		},
		[20] = {
			name_id = "body_armor4",
			upgrades = {
				"body_armor4",
			}
		},
		[25] = {
			name_id = "body_armor5",
			upgrades = {
				"body_armor5",
			}
		},
	}

	-- Weapons
	-------------

	-- LMG / Minigun movement penalties revert
	self.weapon_movement_penalty.lmg = 0.8
	self.weapon_movement_penalty.heavy = 0.8
	self.weapon_movement_penalty.minigun = 0.7
	-- Skills
	-------------

	-- Mastermind --

	-- Company Soul
	self.revive_health_multiplier[1] = 0.05
	self.values.temporary.passive_revive_damage_reduction[1] = { 0.9, 5 }
	self.definitions.player_action_revive_health_regen = {
		category = "feature",
		name_id = "menu_player_action_revive_health_regen",
		upgrade = {
			category = "player",
			upgrade = "action_revive_health_regen",
			value = 1,
		},
	}
	self.values.player.action_revive_health_regen = { 0.2 }
	self.skill_descs.combat_medic.multibasic = "10%"
	self.skill_descs.combat_medic.multibasic2 = "5"
	self.skill_descs.combat_medic.multibasic3 = "5%"
	self.skill_descs.combat_medic.multipro = "20%"

	-- Bandages
	self.definitions.player_revive_health_boost_2 = {
		name_id = "menu_player_revive_health_boost_2",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "revive_health_boost",
			category = "player",
		},
	}
	self.revive_health_multiplier[2] = 0.2 -- actual multiplier
	self.values.player.revive_health_boost[2] = 2 -- second level, not multiplier or a static amount of hp (yes it's stupid that way)
	self.values.player.revived_health_regain[1] = 0.2
	self.skill_descs.fast_learner.multibasic = "15%"
	self.skill_descs.fast_learner.multipro = "20%"

	-- Painkillers
	self.values.temporary.passive_revive_damage_reduction[2] = { 0.5, 5 }
	self.values.temporary.revived_damage_resist[1] = { 0.5, 5 }
	self.skill_descs.tea_time.multibasic = "40%"
	self.skill_descs.tea_time.multipro = "50%"
	self.skill_descs.tea_time.multibasic2 = "5"

	-- Combat Doctor
	self.values.player.revive_damage_reduction[1] = 0.6
	self.values.temporary.revive_damage_reduction[1][1] = 0.6
	self.values.player.revive_interaction_speed_multiplier = { 2 / 3 }
	self.skill_descs.tea_cookies.multibasic = "40%"
	self.skill_descs.tea_cookies.multibasic2 = "5"
	self.skill_descs.tea_cookies.multipro = "33%"
	self.skill_descs.tea_cookies.multipro2 = "25%"
	self.skill_descs.tea_cookies.multipro3 = "10"

	-- Keepers
	self.values.doctor_bag.amount_increase[1] = 1
	self.skill_descs.medic_2x.multibasic = "1"
	self.skill_descs.medic_2x.multipro = "2"

	-- Inspire
	self.morale_boost_speed_bonus = 1.3
	self.morale_boost_reload_speed_bonus = 1.3
	self.morale_boost_suppression_resistance = 0.9
	self.morale_boost_time = 7
	self.values.cooldown.long_dis_revive[1][2] = 120
	self.skill_descs.inspire.multibasic = "7m"
	self.skill_descs.inspire.multibasic2 = "30%"
	self.skill_descs.inspire.multibasic3 = "10%"
	self.skill_descs.inspire.multibasic4 = "7"
	self.skill_descs.inspire.multipro = "120"

	-- Forced Friendship
	self.values.cable_tie.interact_speed_multiplier[1] = 0.75
	self.definitions.player_extra_hostages = {
		category = "feature",
		name_id = "menu_player_extra_hostages",
		upgrade = {
			category = "player",
			upgrade = "extra_hostages",
			value = 1,
		},
	}
	self.values.player.extra_hostages = { 1 }
	self.definitions.cable_tie_pickup_chance = {
		category = "equipment_upgrade",
		name_id = "menu_cable_tie_pickup_chance",
		upgrade = {
			category = "cable_tie",
			upgrade = "pickup_chance",
			value = 1,
		},
	}
	self.values.cable_tie.pickup_chance = { 0.1 }
	self.skill_descs.triathlete.multibasic = "4"
	self.skill_descs.triathlete.multibasic2 = "25%"
	self.skill_descs.triathlete.multipro = "10%"

	-- Control Freak
	self.values.player.intimidation_multiplier[1] = 1.2
	self.values.player.intimidate_range_mul[1] = 1.2
	self.skill_descs.cable_guy.multibasic = "20%"
	self.skill_descs.cable_guy.multipro = "50%"

	-- Joker
	self.values.player.passive_convert_enemies_health_multiplier = { 0.5, 0.2 }
	self.skill_descs.joker.multibasic = "35%"
	self.skill_descs.joker.multibasic2 = "50%"
	self.skill_descs.joker.multipro = "30%"
	self.skill_descs.joker.multipro2 = "65%"

	-- Stockholm Syndrome
	self.values.player.civilians_dont_flee = { true }
	self.definitions.player_civilians_dont_flee = {
		category = "feature",
		name_id = "menu_player_civilians_dont_flee",
		upgrade = {
			category = "player",
			upgrade = "civilians_dont_flee",
			value = 1,
		},
	}
	self.hostage_max_num.resistance = 4
	self.values.player.hostage_damage_reduction_addend = { 0.05 }
	self.definitions.player_hostage_damage_reduction_addend = {
		category = "feature",
		name_id = "menu_player_hostage_damage_reduction_addend",
		upgrade = {
			category = "player",
			upgrade = "hostage_damage_reduction_addend",
			value = 1,
		},
	}
	-- self.values.player.near_hostage_damage_multiplier = { 0.8 }
	-- self.definitions.player_near_hostage_damage_multiplier = {
	-- 	category = "feature",
	-- 	name_id = "menu_player_near_hostage_damage_multiplier",
	-- 	upgrade = {
	-- 		category = "player",
	-- 		upgrade = "near_hostage_damage_multiplier",
	-- 		value = 1,
	-- 	},
	-- }
	self.skill_descs.stockholm_syndrome.multipro = "5%"
	self.skill_descs.stockholm_syndrome.multipro2 = "4"

	-- Parterns in Crime
	self.definitions.player_convert_camouflage_mul = {
		name_id = "menu_player_convert_camouflage_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "convert_camouflage_mul",
			category = "player",
		},
	}
	self.definitions.player_convert_counts_as_hostage = {
		name_id = "menu_player_convert_counts_as_hostage",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "convert_counts_as_hostage",
			category = "player",
		},
	}
	self.values.player.convert_camouflage_mul = { 1.20 }
	self.values.player.convert_counts_as_hostage = { true }
	self.skill_descs.control_freak.multibasic = "20%"

	-- Hostage Taker
	self.values.player.hostage_health_regen_addend[1] = 0.8
	self.hostage_near_player_multiplier = 1.5
	self.hostage_near_player_radius = 700
	self.skill_descs.black_marketeer.multibasic = "8"
	self.skill_descs.black_marketeer.multibasic2 = "5"
	self.skill_descs.black_marketeer.multibasic3 = "1"
	self.skill_descs.black_marketeer.multipro = "50%"
	self.skill_descs.black_marketeer.multipro2 = "7m"

	-- Stable Shot
	self.definitions.weapon_faster_recoil_recentering = {
		name_id = "menu_weapon_faster_recoil_recentering",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "faster_recoil_recentering",
			category = "weapon",
		},
	}
	self.values.player.weapon_accuracy_increase[1] = 1
	self.values.weapon.faster_recoil_recentering = { 2 }
	self.skill_descs.stable_shot.multibasic = "4"
	self.skill_descs.stable_shot.multipro = "50%"

	-- Rifleman
	self.values.player.steelsight_stamina_reduction_multiplier = { 0.85 }
	self.definitions.player_steelsight_stamina_reduction_multiplier = {
		name_id = "menu_player_steelsight_stamina_reduction_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "steelsight_stamina_reduction_multiplier",
			category = "player",
		},
	}
	self.values.weapon.standing_spread_multiplier = { 0.8 }
	self.definitions.weapon_standing_spread_multiplier = {
		name_id = "menu_weapon_standing_spread_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "standing_spread_multiplier",
			category = "weapon",
		},
	}
	self.skill_descs.rifleman.multibasic = "15%"
	self.skill_descs.rifleman.multipro = "20%"

	-- Marksman
	self.values.player.steelsight_aimpunch_multiplier = { 0.85 }
	self.definitions.player_steelsight_aimpunch_multiplier = {
		name_id = "menu_player_steelsight_aimpunch_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "steelsight_aimpunch_multiplier",
			category = "player",
		},
	}
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
	self.skill_descs.sharpshooter.multibasic = "15%"
	self.skill_descs.sharpshooter.multipro = "20%"

	-- Ammo Efficiency
	self.values.player.head_shot_ammo_return = {
		{
			headshots = 2,
			ammo = 1,
			time = 3,
		},
		{
			headshots = 2,
			ammo = 1,
			time = 5,
		},
	}
	self.values.player.head_shot_ammo_return_straight_to_mag = { true }
	self.definitions.head_shot_ammo_return_straight_to_mag = {
		name_id = "menu_player_head_shot_ammo_return_straight_to_mag",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "head_shot_ammo_return_straight_to_mag",
			category = "player",
		},
	}
	self.skill_descs.spotter_teamwork.multibasic = "2"
	self.skill_descs.spotter_teamwork.multibasic2 = "3"
	self.skill_descs.spotter_teamwork.multibasic3 = "1"
	self.skill_descs.spotter_teamwork.multipro = "5"

	-- Kilmer
	self.values.snp.reload_speed_multiplier = { 1.25 }
	self.values.assault_rifle.reload_speed_multiplier = { 1.25 }
	self.values.temporary.single_shot_fast_reload[1][1] = 1.4
	self.values.temporary.single_shot_fast_reload[1][2] = 6
	self.skill_descs.speedy_reload.multibasic = "25%"
	self.skill_descs.speedy_reload.multipro = "40%"
	self.skill_descs.speedy_reload.multipro2 = "6"

	-- Headshot Fury
	self.values.snp.consecutive_headshots = {
		{
			damage_mul_addend = 0.2,
			max_headshots = 5,
		},
	}
	self.definitions.snp_consecutive_headshots = {
		name_id = "menu_snp_consecutive_headshots",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "consecutive_headshots",
			category = "snp",
		},
	}

	self.values.snp.charged_shot = {
		{
			time_to_charge = 2,
			radius = 500,
			times = 4,
			damage_factor = 1,
			chain_multiplier = 0.67,
		},
	}
	self.definitions.snp_charged_shot = {
		name_id = "menu_snp_charged_shot",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "charged_shot",
			category = "snp",
		},
	}

	self.skill_descs.single_shot_ammo_return.multibasic = "20%"
	self.skill_descs.single_shot_ammo_return.multibasic2 = "5"
	self.skill_descs.single_shot_ammo_return.multipro = "2"
	self.skill_descs.single_shot_ammo_return.multipro2 = "100%"
	self.skill_descs.single_shot_ammo_return.multipro3 = "4m"
	self.skill_descs.single_shot_ammo_return.multipro4 = "4"
	self.skill_descs.single_shot_ammo_return.multipro5 = "33%"

	-- Enforcer --

	-- Point Blank
	self.values.player.speed_stack_on_kill = {
		{
			max_stacks = 3,
			max_time = 5,
			speed_bonus = 0.05,
		},
	}
	self.definitions.player_speed_stack_on_kill = {
		name_id = "menu_player_speed_stack_on_kill",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "speed_stack_on_kill",
			category = "player",
		},
	}
	self.values.player.close_damage_multiplier = {
		{
			multiplier = 1.15,
			range = 500,
		},
	}
	self.definitions.player_close_damage_multiplier = {
		name_id = "menu_player_close_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "close_damage_multiplier",
			category = "player",
		},
	}
	self.skill_descs.shotgun_cqb.multibasic = "5%"
	self.skill_descs.shotgun_cqb.multibasic2 = "5"
	self.skill_descs.shotgun_cqb.multibasic3 = "3"
	self.skill_descs.shotgun_cqb.multipro = "15%"
	self.skill_descs.shotgun_cqb.multipro2 = "5m"

	-- Heavy Impact
	self.values.weapon.knock_down[1] = 0.25
	self.values.player.enemy_hurt_damage_multiplier = { 1.15 }
	self.definitions.player_enemy_hurt_damage_multiplier = {
		name_id = "menu_player_enemy_hurt_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "enemy_hurt_damage_multiplier",
			category = "player",
		},
	}
	self.values.shotgun.enemy_push = { true }
	self.definitions.shotgun_enemy_push = {
		name_id = "menu_shotgun_enemy_push",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "enemy_push",
			category = "shotgun",
		},
	}
	self.skill_descs.shotgun_impact.multibasic = "25%"
	self.skill_descs.shotgun_impact.multipro = "15%"

	-- Fast Hands
	self.values.shotgun.pump_reload_speed_mul = { 1.4 }
	self.definitions.shotgun_pump_reload_speed_mul = {
		name_id = "menu_shotgun_pump_reload_speed_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pump_reload_speed_mul",
			category = "shotgun",
		},
	}
	self.values.shotgun.mag_reload_speed_mul = { 1.25 }
	self.definitions.shotgun_mag_reload_speed_mul = {
		name_id = "menu_shotgun_mag_reload_speed_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "mag_reload_speed_mul",
			category = "shotgun",
		},
	}
	self.values.shotgun.hip_rate_of_fire[1] = 1.25
	self.skill_descs.far_away.multibasic = "40%"
	self.skill_descs.far_away.multibasic2 = "25%"
	self.skill_descs.far_away.multipro = "25%"

	-- Far Away
	self.values.shotgun.effective_range_multiplier = { 1.25 }
	self.definitions.shotgun_effective_range_multiplier = {
		name_id = "menu_shotgun_effective_range_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "effective_range_multiplier",
			category = "shotgun",
		},
	}
	self.values.shotgun.steelsight_accuracy_inc[1] = 0.5
	self.skill_descs.close_by.multibasic = "25%"
	self.skill_descs.close_by.multipro = "50%"

	-- OVERKILL
	self.definitions.cooldown_shotgun_panic_on_kill = {
		name_id = "menu_cooldown_shotgun_panic_on_kill",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "shotgun_panic_on_kill",
			category = "cooldown",
		},
	}
	self.values.cooldown.shotgun_panic_on_kill = { { 1, 5 } }
	self.values.shotgun.panic = { { chance = 0.5, area = 800, amount = "panic" } }
	self.values.temporary.overkill_damage_multiplier = {
		{
			1.5,
			5,
		},
	}
	self.skill_descs.overkill.multibasic = "50%"
	self.skill_descs.overkill.multibasic2 = "10"
	self.skill_descs.overkill.multipro = "50%"
	self.skill_descs.overkill.multipro2 = "5"

	-- Impact Padding
	self.values.player.stationary_damage_multiplier = { 0.9 }
	self.definitions.player_stationary_damage_multiplier = {
		name_id = "menu_player_stationary_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "stationary_damage_multiplier",
			category = "player",
		},
	}
	self.definitions.cooldown_damage_multiplier_on_armor_regen = {
		name_id = "menu_cooldown_damage_multiplier_on_armor_regen",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "damage_multiplier_on_armor_regen",
			category = "cooldown",
		},
	}
	self.values.cooldown.damage_multiplier_on_armor_regen = { { 1, 10 } }
	self.values.temporary.armor_regen_damage_multiplier = { { 0.85, 4 } }
	self.definitions.temporary_armor_regen_damage_multiplier = {
		name_id = "menu_temporary_armor_regen_damage_multiplier",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "armor_regen_damage_multiplier",
			category = "temporary",
		},
	}
	self.skill_descs.oppressor.multibasic = "10%"
	self.skill_descs.oppressor.multipro = "15%"
	self.skill_descs.oppressor.multipro2 = "4"
	self.skill_descs.oppressor.multipro3 = "10"

	-- Nerves of Steel
	self.values.player.damage_shake_addend[1] = 0.5
	self.values.player.suppressed_multiplier[1] = 0.8
	self.skill_descs.show_of_force.multibasic = "5"
	self.skill_descs.show_of_force.multipro = "20%"

	-- Protective Mask
	self.values.player.gas_mask = { true }
	self.definitions.player_gas_mask = {
		name_id = "menu_player_gas_mask",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "gas_mask",
			category = "player",
		},
	}
	self.values.player.flashbang_multiplier[1] = 0.65
	self.skill_descs.pack_mule.multipro = "35%"

	-- Pack Mule
	self.values.player.carry_stacker = { true }
	self.definitions.player_carry_stacker = {
		name_id = "menu_player_carry_stacker",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "carry_stacker",
			category = "player",
		},
	}
	self.skill_descs.iron_man.multipro = "2"
	self.skill_descs.iron_man.multipro2 = "10"
	self.skill_descs.iron_man.multipro3 = "1%"

	-- Regen Plating
	self.values.player.armor_regen_time_mul[1] = 0.85
	self.definitions.cooldown_health_regen_on_armor_regen = {
		name_id = "menu_cooldown_health_regen_on_armor_regen",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "health_regen_on_armor_regen",
			category = "cooldown",
		},
	}
	self.values.cooldown.health_regen_on_armor_regen = { { 1, 10 } }
	self.values.player.armor_regen_health_regen = { 0.8 }
	self.skill_descs.prison_wife.multibasic = "15%"
	self.skill_descs.prison_wife.multipro = "8"
	self.skill_descs.prison_wife.multipro2 = "10"

	-- Iron Man
	self.definitions.player_armor_threshold_damage_multiplier = {
		name_id = "menu_player_armor_threshold_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "armor_threshold_damage_multiplier",
			category = "player",
		},
	}
	self.values.player.armor_threshold_damage_multiplier = {
		{
			armor_threshold = 0.8,
			damage_multiplier = 0.75,
		},
	}
	self.skill_descs.juggernaut.multibasic = "80%"
	self.skill_descs.juggernaut.multibasic2 = "25%"

	-- Scavenger
	self.values.player.pick_up_ammo_multiplier[1] = 1.05
	self.values.player.increased_pickup_area[1] = 1.2
	self.skill_descs.scavenging.multibasic = "5%"
	self.skill_descs.scavenging.multipro = "20%"

	-- Fully Loaded
	self.definitions.player_start_out_ammo_multiplier = {
		name_id = "menu_player_start_out_ammo_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "start_out_ammo_multiplier",
			category = "player",
		},
	}
	self.values.player.start_out_ammo_multiplier = { 1.5 }
	self.skill_descs.ammo_reservoir.multibasic = "50%"
	self.skill_descs.ammo_reservoir.multipro = "25%"

	-- Mag Plus
	self.definitions.weapon_consume_no_ammo_chance = {
		name_id = "menu_weapon_consume_no_ammo_chance",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "consume_no_ammo_chance",
			category = "weapon",
		},
	}
	self.values.weapon.consume_no_ammo_chance = { 0.05 }
	self.values.weapon.clip_ammo_increase[1] = 1.2
	self.skill_descs.portable_saw.multibasic = "5%"
	self.skill_descs.portable_saw.multipro = "20%"

	-- Extra Lead
	self.skill_descs.ammo_2x.multibasic = "50%"
	self.skill_descs.ammo_2x.multipro = "2"

	-- Big Game Hunters
	self.values.temporary.double_drop_damage_multiplier = { { 1.5, 5 } }
	self.definitions.temporary_double_drop_damage_multiplier = {
		name_id = "menu_temporary_double_drop_damage_multiplier",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "double_drop_damage_multiplier",
			category = "temporary",
		},
	}
	self.values.player.double_drop_extra_damage = { true }
	self.definitions.player_double_drop_extra_damage = {
		name_id = "menu_player_double_drop_extra_damage",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "double_drop_extra_damage",
			category = "player",
		},
	}
	self.skill_descs.carbon_blade.multibasic = "6th"
	self.skill_descs.carbon_blade.multipro = "50%"
	self.skill_descs.carbon_blade.multipro2 = "5"

	-- Bulletstorm
	self.skill_descs.bandoliers.multibasic = "12"
	self.skill_descs.bandoliers.multipro2 = "30"

	-- Technician --

	-- Daredevil
	self.values.player.interacting_damage_multiplier[1] = 0.9
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
	self.skill_descs.defense_up.multibasic = "10%"
	self.skill_descs.defense_up.multipro = "10%"

	-- Hardware Expert
	self.values.player.drill_fix_interaction_speed_multiplier[1] = 0.5
	self.skill_descs.sentry_targeting_package.multipro = "50%"

	-- Kickstarter
	self.drill_time_to_autorepair = 60
	self.drill_hits_to_restart = 3
	self.skill_descs.jack_of_all_trades.multibasic = "60"
	self.skill_descs.jack_of_all_trades.multipro = "3"

	-- Portable Saw
	self.values.saw.lock_damage_multiplier[2] = 1.6
	self.values.player.saw_speed_multiplier[2] = 0.4
	self.skill_descs.engineering.multibasic = "1"
	self.skill_descs.engineering.multibasic2 = "60%"

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

	-- Blast Shield
	self.values.player.explosive_damage_multiplier = { 0.8 }
	self.definitions.player_explosive_damage_multiplier = {
		name_id = "menu_player_explosive_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "explosive_damage_multiplier",
			category = "player",
		},
	}
	self.values.weapon.explosive_team_damage_multiplier = { 0.7 }
	self.definitions.weapon_explosive_team_damage_multiplier = {
		name_id = "menu_weapon_explosive_team_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "explosive_team_damage_multiplier",
			synced = true,
			category = "weapon",
		},
	}
	self.skill_descs.hardware_expert.multibasic = "20%"
	self.skill_descs.hardware_expert.multipro = "30%"

	-- Combat Engineering
	self.values.trip_mine.explosion_size_multiplier_1 = { 1.5 }
	self.skill_descs.combat_engineering.multibasic = "50%"

	-- Arms Cache
	self.values.grenade_case.amount_increase = { 2 }
	self.definitions.grenade_case_amount_increase = {
		category = "equipment_upgrade",
		name_id = "debug_upgrade_grenade_case_amount_increase",
		upgrade = {
			upgrade = "amount_increase",
			category = "grenade_case",
			value = 1,
		},
	}
	self.values.grenade_crate.amount_increase = { 2 }
	self.definitions.grenade_crate_amount_increase = {
		category = "equipment_upgrade",
		name_id = "debug_upgrade_grenade_crate_amount_increase",
		upgrade = {
			upgrade = "amount_increase",
			category = "grenade_crate",
			value = 1,
		},
	}
	self.values.grenade_case.quantity = { 1 }
	self.definitions.grenade_case_quantity = {
		name_id = "menu_grenade_case_quantity",
		category = "equipment_upgrade",
		upgrade = {
			value = 1,
			upgrade = "quantity",
			category = "grenade_case",
		},
	}
	self.values.grenade_crate.quantity = { 1 }
	self.definitions.grenade_crate_quantity = {
		name_id = "menu_grenade_crate_quantity",
		category = "equipment_upgrade",
		upgrade = {
			value = 1,
			upgrade = "quantity",
			category = "grenade_crate",
		},
	}
	self.skill_descs.drill_expert.multibasic = "50%"
	self.skill_descs.drill_expert.multipro = "2"

	-- Hellwire
	self.values.shape_charge.quantity[1] = 4
	self.values.trip_mine.quantity[1] = 6
	self.values.trip_mine.fire_trap[1] = { 30, 1.5 }
	self.skill_descs.more_fire_power.multibasic = "4"
	self.skill_descs.more_fire_power.multibasic2 = "6"
	self.skill_descs.more_fire_power.multipro = "40"
	self.skill_descs.more_fire_power.multipro2 = "6"

	-- Powder Keg
	self.values.weapon.explosive_range_multiplier = { 1.2 }
	self.definitions.weapon_explosive_range_multiplier = {
		name_id = "menu_player_explosive_range_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "explosive_range_multiplier",
			synced = true,
			category = "weapon",
		},
	}
	self.values.weapon.explosive_curve_multiplier = { 0.34 }
	self.definitions.weapon_explosive_curve_multiplier = {
		name_id = "menu_weapon_explosive_curve_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "explosive_curve_multiplier",
			synced = true,
			category = "weapon",
		},
	}
	self.skill_descs.kick_starter.multibasic = "20%"
	self.skill_descs.kick_starter.multipro = "66%"

	-- Carpet Bombing
	self.cluster_grenade_damage_multiplier = 0.25
	self.values.weapon.explosive_cluster_grenades = { true }
	self.definitions.weapon_explosive_cluster_grenades = {
		name_id = "menu_player_explosive_cluster_grenades",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "explosive_cluster_grenades",
			synced = true,
			category = "weapon",
		},
	}
	self.values.weapon.cluster_incendiary_grenades = { true }
	self.definitions.weapon_cluster_incendiary_grenades = {
		name_id = "menu_player_cluster_incendiary_grenades",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "cluster_incendiary_grenades",
			synced = true,
			category = "weapon",
		},
	}
	self.skill_descs.fire_trap.multibasic = "4"
	self.skill_descs.fire_trap.multibasic2 = "2.5m"
	self.skill_descs.fire_trap.multibasic3 = "25%"
	self.skill_descs.fire_trap.multipro = "30"
	self.skill_descs.fire_trap.multipro2 = "4"

	-- Steady Grip
	self.values.weapon.moving_recoil_penalty_reduction = { 0.8 }
	self.definitions.weapon_moving_recoil_penalty_reduction = {
		name_id = "menu_weapon_moving_recoil_penalty_reduction",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "moving_recoil_penalty_reduction",
			category = "weapon",
		},
	}
	self.values.player.stability_increase_bonus_1[1] = 1
	self.skill_descs.steady_grip.multibasic = "4"
	self.skill_descs.steady_grip.multipro = "20%"

	-- Oppressor
	self.values.player.suppression_multiplier = { 1.2 }
	self.values.player.enemy_panic_damage_multiplier = { 1.15 }
	self.definitions.player_enemy_panic_damage_multiplier = {
		name_id = "menu_player_enemy_panic_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "enemy_panic_damage_multiplier",
			category = "player",
		},
	}
	self.skill_descs.heavy_impact.multibasic = "20%"
	self.skill_descs.heavy_impact.multipro = "15%"

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
		name_id = "menu_weapon_hipfire_spread_penalty_reduction",
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
	self.values.player.stamina_regen_timer_multiplier[1] = 0.85
	self.values.player.stamina_regen_multiplier[1] = 1.15
	self.skill_descs.sprinter.multibasic = "15%"
	self.skill_descs.sprinter.multipro = "10%"

	-- Duck and Cover
	self.values.player.stamina_regen_multiplier_crouched = { 1.33 }
	self.definitions.player_stamina_regen_multiplier_crouched = {
		name_id = "menu_player_stamina_regen_multiplier_crouched",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "stamina_regen_multiplier_crouched",
			category = "player",
		},
	}
	self.values.player.crouch_dodge_chance[1] = 0.1
	self.skill_descs.awareness.multibasic = "33%"
	self.skill_descs.awareness.multipro = "10%"

	-- Sprinter
	self.values.player.can_sprint_swap = { true }
	self.definitions.player_can_sprint_swap = {
		name_id = "menu_player_can_sprint_swap",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "can_sprint_swap",
			category = "player",
		},
	}
	self.values.player.on_zipline_dodge_chance[1] = 0.1
	self.skill_descs.optic_illusions.multibasic = "15%"
	self.skill_descs.optic_illusions.multipro = "10%"

	-- Second Wind
	self.definitions.cooldown_dodge_on_armor_break = {
		name_id = "menu_cooldown_dodge_on_armor_break",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "dodge_on_armor_break",
			category = "cooldown",
		},
	}
	self.values.cooldown.dodge_on_armor_break = { { 1, 10 } }
	self.values.player.armor_break_dodge = { 0.1 }
	self.values.temporary.damage_speed_multiplier = { { 1.2, 5 } }
	self.skill_descs.dire_need.multibasic = "20%"
	self.skill_descs.dire_need.multibasic2 = "5"
	self.skill_descs.dire_need.multipro = "10%"
	self.skill_descs.dire_need.multipro2 = "10"

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
	self.values.cooldown.dodge_replenish_armor = { { 1, 10 } }
	self.definitions.cooldown_dodge_replenish_armor = {
		name_id = "menu_cooldown_dodge_replenish_armor",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "dodge_replenish_armor",
			category = "cooldown",
		},
	}
	self.skill_descs.jail_diet.multibasic2 = "2"
	self.skill_descs.jail_diet.multipro = "10"

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
	self.values.weapon.special_damage_taken_multiplier[1] = 1.15
	self.values.player.marked_distance_mul[1] = 4
	self.skill_descs.thick_skin.multibasic = "15%"
	self.skill_descs.thick_skin.multipro = "4"

	-- The Professional
	self.values.weapon.silencer_enter_steelsight_speed_multiplier[1] = 1.25
	self.skill_descs.silence_expert.multibasic = "25%"
	self.skill_descs.silence_expert.multipro = "1"
	self.skill_descs.silence_expert.multipro2 = "2"

	-- HVT
	self.values.player.marked_inc_dmg_distance[1][2] = 1.2
	self.values.player.marked_enemy_damage_mul = 1.3
	self.skill_descs.hitman.multibasic = "20%"
	self.skill_descs.hitman.multibasic2 = "10"
	self.skill_descs.hitman.multipro = "30%"
	self.skill_descs.hitman.multipro2 = "100%"

	-- Silent Killer
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
	self.values.weapon.silencer_spread_index_addend[1] = 1
	self.values.weapon.silencer_recoil_index_addend[1] = 1
	self.values.weapon.armor_piercing_chance_silencer[1] = 0.3
	self.values.weapon.silencer_damage_multiplier[1] = 1.2
	self.skill_descs.backstab.multibasic = "4"
	self.skill_descs.backstab.multibasic2 = "30%"
	self.skill_descs.backstab.multipro = "20%"

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
	self.definitions.player_critical_hit_chance_2 = {
		incremental = true,
		name_id = "menu_player_critical_hit_chance",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "critical_hit_chance",
			category = "player",
		},
	}
	self.values.player.detection_risk_add_crit_chance = {
		{ 0.01, 2, "below", 35, 0.1 },
		{ 0.03, 1, "below", 35, 0.3 },
	}
	self.values.weapon.extra_crit_damage_mul = { 1 }
	self.values.player.critical_hit_chance[2] = 0.25
	self.skill_descs.unseen_strike.multibasic = "1%"
	self.skill_descs.unseen_strike.multibasic2 = "2"
	self.skill_descs.unseen_strike.multibasic3 = "35"
	self.skill_descs.unseen_strike.multibasic4 = "10%"
	self.skill_descs.unseen_strike.multipro = "20%"
	self.skill_descs.unseen_strike.multipro2 = "100%"

	-- Fugitive --

	-- Gun Drill Savvy
	self.values.weapon.steelsight_move_speed_penalty_multiplier = { 0.8 }
	self.definitions.weapon_steelsight_move_speed_penalty_multiplier = {
		incremental = true,
		name_id = "menu_weapon_steelsight_move_speed_penalty_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "steelsight_move_speed_penalty_multiplier",
			category = "weapon",
		},
	}
	self.values.weapon.enter_steelsight_speed_multiplier[1] = 1.3
	self.skill_descs.equilibrium.multibasic = "20%"
	self.skill_descs.equilibrium.multipro = "30%"

	-- Gunfighter
	self.values.player.sprint_to_fire_multiplier = { 1.25 }
	self.definitions.player_sprint_to_fire_multiplier = {
		name_id = "menu_player_sprint_to_fire_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "sprint_to_fire_multiplier",
			category = "player",
		},
	}
	self.values.weapon.swap_speed_multiplier[1] = 1.25
	self.skill_descs.dance_instructor.multibasic = "25%"
	self.skill_descs.dance_instructor.multipro = "25%"

	-- Sidearm Savvy
	self.values.player.sidearm_move_speed_multiplier = { 1.15 }
	self.definitions.player_sidearm_move_speed_multiplier = {
		name_id = "menu_player_sidearm_move_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "sidearm_move_speed_multiplier",
			category = "player",
		},
	}
	self.values.player.sidearms_reload_primary = {
		{
			kills = 3,
			max_time = 3,
		},
	}
	self.definitions.player_sidearms_reload_primary = {
		name_id = "menu_player_sidearms_reload_primary",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "sidearms_reload_primary",
			category = "player",
		},
	}
	self.skill_descs.akimbo.multibasic = "15%"
	self.skill_descs.akimbo.multipro = "3"
	self.skill_descs.akimbo.multipro2 = "3"

	-- Trigger Overdrive
	self.values.pistol.stacked_reload_bonus = {
		{
			max_stacks = 6,
			reload_bonus = 0.075,
			max_time = 3,
		},
	}
	self.definitions.pistol_stacked_reload_bonus = {
		name_id = "menu_pistol_stacked_reload_bonus",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "stacked_reload_bonus",
			category = "pistol",
		},
	}
	self.values.pistol.stacked_accuracy_bonus = {
		{
			max_stacks = 4,
			accuracy_bonus = 0.12,
			max_time = 6,
		},
	}
	self.skill_descs.gun_fighter.multibasic = "7.5%"
	self.skill_descs.gun_fighter.multibasic2 = "3"
	self.skill_descs.gun_fighter.multibasic3 = "6"
	self.skill_descs.gun_fighter.multipro = "12%"
	self.skill_descs.gun_fighter.multipro2 = "6"
	self.skill_descs.gun_fighter.multipro3 = "4"

	-- Deadeye
	self.values.revolver.headshot_chain_instant_reload = {
		{
			headshots = 4,
		},
	}
	self.definitions.revolver_headshot_chain_instant_reload = {
		name_id = "menu_revolver_headshot_chain_instant_reload",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_chain_instant_reload",
			category = "revolver",
		},
	}
	self.values.revolver.headshot_chain_ammo_restore = {
		{
			headshots = 4,
			max_time = 10,
			ammo_restore_percentage = 0.2,
		},
	}
	self.definitions.revolver_headshot_chain_ammo_restore = {
		name_id = "menu_revolver_headshot_chain_ammo_restore",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_chain_ammo_restore",
			category = "revolver",
		},
	}
	self.skill_descs.expert_handling.multibasic = "4"
	self.skill_descs.expert_handling.multipro = "4"
	self.skill_descs.expert_handling.multipro2 = "10"
	self.skill_descs.expert_handling.multipro3 = "20%"

	-- Peacemaker's Lament
	self.values.temporary.sidearm_pullout_damage_multiplier = { { 1.5, 5 } }
	self.definitions.temporary_sidearm_pullout_damage_multiplier = {
		name_id = "menu_temporary_sidearm_pullout_damage_multiplier",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "sidearm_pullout_damage_multiplier",
			category = "temporary",
		},
	}
	self.values.temporary.sidearm_reload_damage_multiplier = { { 2, 5 } }
	self.definitions.temporary_sidearm_reload_damage_multiplier = {
		name_id = "menu_temporary_sidearm_reload_damage_multiplier",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "sidearm_reload_damage_multiplier",
			category = "temporary",
		},
	}
	self.values.cooldown.sidearm_reload_damage_multiplier = { { 1, 15 } }
	self.definitions.cooldown_sidearm_reload_damage_multiplier = {
		name_id = "menu_cooldown_sidearm_reload_damage_multiplier",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "sidearm_reload_damage_multiplier",
			category = "cooldown",
		},
	}
	self.values.player.sidearm_ricochet_damage = {
		{
			radius = 500,
			times = 1,
			damage_factor = 1,
		},
	}
	self.definitions.player_sidearm_ricochet_damage = {
		name_id = "menu_player_sidearm_ricochet_damage",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "sidearm_ricochet_damage",
			category = "player",
		},
	}
	self.skill_descs.trigger_happy.multibasic = "5"
	self.skill_descs.trigger_happy.multibasic2 = "50%"
	self.skill_descs.trigger_happy.multipro = "5"
	self.skill_descs.trigger_happy.multipro2 = "100%"
	self.skill_descs.trigger_happy.multipro3 = "5m"
	self.skill_descs.trigger_happy.multipro4 = "10"

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

	-- More Blood to Bleed
	self.definitions.player_health_multiplier = {
		name_id = "menu_player_health_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "health_multiplier",
			category = "player",
		},
	}
	self.values.player.health_multiplier = { 1.15 }
	self.skill_descs.up_you_go.multibasic = "50%"
	self.skill_descs.up_you_go.multipro = "15%"

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
	self.values.temporary.first_aid_health_regen = { { 0.8, 60.1 } }
	self.skill_descs.feign_death.multibasic = "8"
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

	-- Bloodthirst
	self.values.player.non_special_melee_multiplier[1] = 1.33
	self.values.player.melee_damage_multiplier[1] = 1.33
	self.values.player.melee_damage_stacking = { { max_multiplier = 5, melee_multiplier = 0.25 } }
	self.skill_descs.bloodthirst.multibasic = "33%"
	self.skill_descs.bloodthirst.multipro = "25%"
	self.skill_descs.bloodthirst.multipro2 = "500%"

	-- Pumping Iron
	self.values.melee.faster_reswing = { 0.5 }
	self.definitions.melee_faster_reswing = {
		name_id = "menu_melee_faster_reswing",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "faster_reswing",
			category = "melee",
		},
	}
	self.values.player.run_and_melee = { true }
	self.definitions.player_run_and_melee = {
		name_id = "menu_player_run_and_melee",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "run_and_melee",
			category = "player",
		},
	}
	self.skill_descs.steroids.multibasic = "100%"

	-- Counterstrike
	self.values.cooldown.melee_dozer_knock = { { 1, 10 } }
	self.definitions.cooldown_melee_dozer_knock = {
		name_id = "menu_cooldown_melee_dozer_knock",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "melee_dozer_knock",
			category = "cooldown",
		},
	}
	self.skill_descs.drop_soap.multipro = "10"

	-- Zerker
	self.values.player.movement_speed_damage_health_ratio_multiplier = { 0.2 }
	self.skill_descs.wolverine.multibasic = "50%"
	self.skill_descs.wolverine.multibasic2 = "20%"
	self.skill_descs.wolverine.multipro = "50%"
	self.skill_descs.wolverine.multipro2 = "250%"

	-- Frenzy
	self.values.player.health_damage_reduction = { 0.85, 0.65 }
	self.values.player.max_health_reduction = { 0.1 }
	self.skill_descs.frenzy.multibasic = "10%"
	self.skill_descs.frenzy.multibasic2 = "15%"
	self.skill_descs.frenzy.multipro = "35%"

	-- Perk Decks
	-------------

	-- Crew Chief
	self.definitions.team_resource_trading_health = {
		category = "team",
		name_id = "resource_trading_health",
		upgrade = {
			category = "player",
			upgrade = "resource_trading_health",
			value = 1,
		},
	}
	self.values.team.player.resource_trading_health = { 0.2 }
	self.definitions.player_extra_hostages_chief = {
		category = "feature",
		name_id = "menu_player_extra_hostages_chief",
		upgrade = {
			category = "player",
			upgrade = "extra_hostages_chief",
			value = 1,
		},
	}
	self.values.player.extra_hostages_chief = { 2 }
	self.values.player.passive_intimidate_range_mul[1] = 1.5
	self.definitions.team_resource_trading_ammo = {
		category = "team",
		name_id = "resource_trading_ammo",
		upgrade = {
			category = "player",
			upgrade = "resource_trading_ammo",
			value = 1,
		},
	}
	self.values.team.player.resource_trading_ammo = { 4 }
	self.values.team.health.hostage_multiplier[1] = 1.05
	self.values.team.stamina.hostage_multiplier[1] = 1.05
	self.definitions.team_resource_trading_assault_delay = {
		category = "team",
		name_id = "resource_trading_assault_delay",
		upgrade = {
			category = "player",
			upgrade = "resource_trading_assault_delay",
			value = 1,
		},
	}
	self.values.team.player.resource_trading_assault_delay = { 10 }
	self.resource_trade_assault_delay_balance_multiplier = { 2, 1, 1, 1 }
	self.values.team.player.resource_trading_no_downs = { true }
	self.definitions.team_resource_trading_no_downs = {
		category = "team",
		name_id = "resource_trading_no_downs",
		upgrade = {
			category = "player",
			upgrade = "resource_trading_no_downs",
			value = 1,
		},
	}
	self.values.team.player.resource_trading_before_first_assault = { true }
	self.definitions.team_resource_trading_before_first_assault = {
		category = "team",
		name_id = "resource_trading_before_first_assault",
		upgrade = {
			category = "player",
			upgrade = "resource_trading_before_first_assault",
			value = 1,
		},
	}
	self.specialization_descs[1][1].multiperk = "20%"
	self.specialization_descs[1][3].multiperk = "2"
	self.specialization_descs[1][3].multiperk2 = "50%"
	self.specialization_descs[1][5].multiperk = "4"
	self.specialization_descs[1][7].multiperk = "5%"
	self.specialization_descs[1][7].multiperk2 = "5%"
	self.specialization_descs[1][7].multiperk3 = "4"
	self.specialization_descs[1][7].multiperk4 = "4"
	self.specialization_descs[1][9].multiperk = "10"
	self.specialization_descs[1][9].multiperk2 = "doubled"

	-- Muscle (uses same extra hp upgrade as grinder)
	self.values.player.uncover_multiplier[1] = 1.25
	self.values.temporary.mrwi_health_invulnerable[1][1] = 0.25
	self.values.temporary.mrwi_health_invulnerable[1][3] = 60
	self.specialization_descs[2][3].multiperk = "30%"
	self.specialization_descs[2][5].multiperk = "25%"
	self.specialization_descs[2][7].multiperk = "25%"
	self.specialization_descs[2][7].multiperk2 = "2"
	self.specialization_descs[2][7].multiperk3 = "60"
	self.specialization_descs[2][9].multiperk = "30%"

	-- Armorer
	self.values.player.armor_regen_timer_multiplier_passive[1] = 0.85
	self.values.player.passive_armor_movement_penalty_multiplier[1] = 0.8
	self.values.player.tier_armor_multiplier[3] = 1.15
	self.values.temporary.armor_break_invulnerable = { { 2, 60 } }
	self.specialization_descs[3][1].multiperk = "15%"
	self.specialization_descs[3][3].multiperk = "20%"
	self.specialization_descs[3][5].multiperk = "15%"
	self.specialization_descs[3][7].multiperk = "25%"
	self.specialization_descs[3][9].multiperk = "2"
	self.specialization_descs[3][9].multiperk2 = "60"

	-- All dodge decks
	self.values.player.passive_dodge_chance = { 0.05, 0.1, 0.15 }
	self.values.player.tier_dodge_chance = { 0.1, 0.15, 0.2 }
	self.specialization_descs[4][1].multiperk = "5%"
	self.specialization_descs[4][5].multiperk = "5%"
	self.specialization_descs[4][7].multiperk = "5%"
	self.specialization_descs[6][1].multiperk = "5%"
	self.specialization_descs[7][1].multiperk = "10%"
	self.specialization_descs[13][5].multiperk3 = "5%"
	self.specialization_descs[18][5].multiperk = "15%"
	self.specialization_descs[21][5].multiperk2 = "5%"

	-- Rogue Specific
	self.values.temporary.unseen_dodge = {
		{
			0.1,
			6,
		},
	}
	self.definitions.player_unseen_temp_increased_dodge_chance = {
		name_id = "menu_player_unseen_increased_dodge_chance",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "unseen_dodge",
			category = "temporary",
		},
	}
	self.specialization_descs[4][3].multiperk = "4"
	self.specialization_descs[4][3].multiperk2 = "10%"
	self.specialization_descs[4][3].multiperk3 = "6"
	self.specialization_descs[4][9].multiperk = "4"
	self.specialization_descs[4][9].multiperk2 = "20%"
	self.specialization_descs[4][9].multiperk3 = "6"
	self.specialization_descs[4][9].multiperk4 = "200%"

	-- Hitman
	self.definitions.player_chain_headshot_kills = {
		name_id = "menu_player_chain_headshot_kills",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "chain_headshot_kills",
			category = "player",
		},
	}
	self.values.player.chain_headshot_kills = {
		{
			headshot_kills = 3,
			max_time = 10,
		},
	}
	self.definitions.temporary_chain_headshot_dodge_1 = {
		name_id = "menu_player_chain_headshot_dodge",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "chain_headshot_dodge",
			category = "temporary",
		},
	}
	self.definitions.temporary_chain_headshot_dodge_2 = {
		name_id = "menu_player_chain_headshot_dodge",
		category = "temporary",
		upgrade = {
			value = 2,
			upgrade = "chain_headshot_dodge",
			category = "temporary",
		},
	}
	self.values.temporary.chain_headshot_dodge = {
		{ 0.1, 5 },
		{ 0.2, 5 },
	}
	self.definitions.temporary_dodge_outnumbered = {
		name_id = "menu_player_dodge_outnumbered",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "dodge_outnumbered",
			category = "temporary",
		},
	}
	self.values.temporary.dodge_outnumbered = { { 0.1, 7 } }
	self.values.player.cheat_death_chance[1] = 0.2
	self.definitions.player_cheat_death_inc = {
		name_id = "menu_player_cheat_death_inc",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "cheat_death_inc",
			category = "player",
		},
	}
	self.values.player.cheat_death_inc = { 0.04 }
	self.specialization_descs[5][1].multiperk = "3"
	self.specialization_descs[5][1].multiperk2 = "10"
	self.specialization_descs[5][1].multiperk3 = "10%"
	self.specialization_descs[5][1].multiperk4 = "5"
	self.specialization_descs[5][3].multiperk = "10%"
	self.specialization_descs[5][5].multiperk = "3"
	self.specialization_descs[5][5].multiperk2 = "10"
	self.specialization_descs[5][5].multiperk3 = "10%"
	self.specialization_descs[5][5].multiperk4 = "5"
	self.specialization_descs[5][7].multiperk = "20%"
	self.specialization_descs[5][9].multiperk = "3"
	self.specialization_descs[5][9].multiperk2 = "10"
	self.specialization_descs[5][9].multiperk3 = "4%"

	-- Crook
	self.values.player.bv_stamina_reduction_multiplier = { 0.7 }
	self.definitions.player_bv_stamina_reduction_multiplier = {
		name_id = "menu_player_bv_stamina_reduction_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bv_stamina_reduction_multiplier",
			category = "player",
		},
	}
	self.values.player.bv_health_damage_reduction = { 0.75 }
	self.definitions.player_bv_health_damage_reduction = {
		name_id = "menu_player_bv_health_damage_reduction",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bv_health_damage_reduction",
			category = "player",
		},
	}
	self.values.player.bv_ap_rnds_protection = { true }
	self.definitions.player_bv_ap_rnds_protection = {
		name_id = "menu_player_bv_ap_rnds_protection",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bv_ap_rnds_protection",
			category = "player",
		},
	}
	self.values.player.level_2_armor_multiplier[1] = 1.25
	self.values.player.level_3_armor_multiplier[1] = 1.25
	self.values.player.level_4_armor_multiplier[1] = 1.25
	self.values.player.bv_no_armor_suppression = { true }
	self.definitions.player_bv_no_armor_suppression = {
		name_id = "menu_player_bv_no_armor_suppression",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bv_no_armor_suppression",
			category = "player",
		},
	}
	self.specialization_descs[6][1].multiperk = "30%"
	self.specialization_descs[6][3].multiperk = "25%"
	self.specialization_descs[6][7].multiperk = "25%"

	-- Tactician (ex-Burglar)
	self.values.player.near_teammate_damage_multiplier = {
		{
			mul = 0.8,
			range = 700,
		},
	}
	self.definitions.player_near_teammate_damage_multiplier = {
		name_id = "menu_player_near_teammate_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "near_teammate_damage_multiplier",
			category = "player",
		},
	}
	self.drill_electrocution_chance = 0.9
	self.values.player.electrocuting_drill = { true }
	self.definitions.player_electrocuting_drill = {
		name_id = "menu_player_electrocuting_drill",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "electrocuting_drill",
			synced = true,
			category = "player",
		},
	}
	self.values.player.no_secondary_deployable_penalty = { true }
	self.definitions.player_no_secondary_deployable_penalty = {
		name_id = "menu_player_no_secondary_deployable_penalty",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "no_secondary_deployable_penalty",
			category = "player",
		},
	}
	self.specialization_descs[7][1].multiperk = "half"
	self.specialization_descs[7][3].multiperk = "30%"
	self.specialization_descs[7][5].multiperk = "20%"
	self.specialization_descs[7][5].multiperk2 = "7m"
	self.specialization_descs[7][7].multiperk = "90%"
	self.specialization_descs[7][9].multiperk = "full"
	self.specialization_descs[7][9].multiperk2 = "100%"

	-- Infiltrator
	self.values.temporary.melee_life_leech[1] = { 1, 5 }
	self.specialization_descs[8][9].multiperk = "10"
	self.specialization_descs[8][9].multiperk2 = "5"

	-- Sociopath
	self.on_killshot_cooldown = 2
	self.values.player.killshot_regen_armor_bonus[1] = 2
	self.values.player.melee_kill_armor_regen = { 2 }
	self.values.cooldown.melee_kill_armor_leech = { { 1, 1 } }
	self.definitions.cooldown_melee_kill_armor_leech = {
		name_id = "menu_cooldown_melee_kill_armor_leech",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "melee_kill_armor_leech",
			category = "cooldown",
		},
	}
	self.values.player.killshot_close_regen_armor_bonus[1] = 2
	self.specialization_descs[9][3].multiperk = "20"
	self.specialization_descs[9][3].multiperk2 = "2"
	self.specialization_descs[9][5].multiperk = "20"
	self.specialization_descs[9][5].multiperk2 = "2"
	self.specialization_descs[9][7].multiperk = "20"
	self.specialization_descs[9][7].multiperk2 = "2"

	-- Infil / Socio shared melee card
	self.max_melee_weapon_dmg_mul_stacks = 4
	self.values.melee.stacking_hit_damage_multiplier = {
		1,
		1,
	}
	self.specialization_descs[8][1].multiperk2 = "1"
	self.specialization_descs[8][1].multiperk3 = "100%"
	self.specialization_descs[8][1].multiperk4 = "4"
	self.specialization_descs[9][1].multiperk2 = "1"
	self.specialization_descs[9][1].multiperk3 = "100%"
	self.specialization_descs[9][1].multiperk4 = "4"

	-- Gambler
	self.values.player.pickup_restore_health = { 0.3, 0.6 }
	self.definitions.player_pickup_restore_health_1 = {
		name_id = "menu_player_pickup_restore_health",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pickup_restore_health",
			category = "player",
		},
	}
	self.loose_ammo_give_team_ratio = 0.25
	self.values.player.pickup_restore_team_ammo = { true }
	self.definitions.player_pickup_restore_team_ammo = {
		name_id = "menu_player_pickup_restore_team_ammo",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pickup_restore_team_ammo",
			category = "player",
		},
	}
	self.loose_health_give_team_ratio = 0.5
	self.values.player.pickup_restore_team_health = { true }
	self.definitions.player_pickup_restore_team_health = {
		name_id = "menu_player_pickup_restore_team_health",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pickup_restore_team_health",
			category = "player",
		},
	}
	self.definitions.player_pickup_restore_health_2 = {
		name_id = "menu_player_pickup_restore_health",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "pickup_restore_health",
			category = "player",
		},
	}
	self.values.player.increased_pickup_area_gambler = { 2 }
	self.definitions.player_increased_pickup_area_gambler = {
		name_id = "menu_player_increased_pickup_area_gambler",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "increased_pickup_area_gambler",
			category = "player",
		},
	}
	self.specialization_descs[10][1].multiperk = "3"
	self.specialization_descs[10][3].multiperk = "25%"
	self.specialization_descs[10][5].multiperk = "50%"
	self.specialization_descs[10][7].multiperk = "100%"
	self.specialization_descs[10][7].multiperk2 = "20%"
	self.specialization_descs[10][9].multiperk = "100%"

	-- Grinder
	self.values.player.extra_health_multiplier = { 1.3, 1.6 }
	self.definitions.player_extra_health_multiplier_1 = {
		name_id = "menu_player_health_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "extra_health_multiplier",
			category = "player",
		},
	}
	self.values.cooldown.headshot_regen_health_bonus = { { 1, 3 } }
	self.values.player.headshot_regen_health_bonus = { 5 }
	self.definitions.cooldown_headshot_regen_health_bonus = {
		name_id = "menu_cooldown_headshot_regen_health_bonus",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_regen_health_bonus",
			category = "cooldown",
		},
	}
	self.definitions.player_extra_health_multiplier_2 = {
		name_id = "menu_player_health_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "extra_health_multiplier",
			category = "player",
		},
	}
	self.damage_to_hot_data.armors_allowed = { "level_1", "level_2", "level_3", "level_4", "level_5", "level_6", "level_7" }
	self.damage_to_hot_data.stacking_cooldown = 1
	self.damage_to_hot_data.add_stack_sources.poison = false
	self.damage_to_hot_data.add_stack_sources.swat_van = false
	self.damage_to_hot_data.add_stack_sources.sentry_gun = false
	self.specialization_descs[11][1].multiperk = "1"
	self.specialization_descs[11][1].multiperk2 = "0.3"
	self.specialization_descs[11][1].multiperk3 = "3"
	self.specialization_descs[11][1].multiperk2 = "1"
	self.specialization_descs[11][3].multiperk = "30%"
	self.specialization_descs[11][5].multiperk = "5"
	self.specialization_descs[11][5].multiperk2 = "3"
	self.specialization_descs[11][7].multiperk = "30%"
	self.specialization_descs[11][9].multiperk = "3"
	self.specialization_descs[11][9].multiperk2 = "0.3"
	self.specialization_descs[11][9].multiperk3 = "3"

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
	self.values.player.armor_grinding = { {
		{ 1, 2 },
		{ 1.5, 2.5 },
		{ 2, 3 },
		{ 2.5, 3.75 },
		{ 3, 4.5 },
		{ 3.5, 6 },
		{ 4, 8 },
	} }
	self.values.player.health_decrease = { 0.25, 0.5 }
	self.definitions.player_health_decrease_2 = {
		name_id = "menu_player_health_decrease",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "health_decrease",
			category = "player",
		},
	}
	self.values.player.level_2_anarchist_armor_multiplier = { 1.1 }
	self.values.player.level_3_anarchist_armor_multiplier = { 1.15 }
	self.values.player.level_4_anarchist_armor_multiplier = { 1.25 }
	self.values.player.level_5_anarchist_armor_multiplier = { 1.4 }
	self.values.player.level_6_anarchist_armor_multiplier = { 1.6 }
	self.values.player.level_7_anarchist_armor_multiplier = { 1.8 }
	self.definitions.player_level_2_anarchist_armor_multiplier = {
		name_id = "menu_player_level_2_anarchist_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_2_anarchist_armor_multiplier",
			category = "player",
		},
	}
	self.definitions.player_level_3_anarchist_armor_multiplier = {
		name_id = "menu_player_level_3_anarchist_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_3_anarchist_armor_multiplier",
			category = "player",
		},
	}
	self.definitions.player_level_4_anarchist_armor_multiplier = {
		name_id = "menu_player_level_4_anarchist_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_4_anarchist_armor_multiplier",
			category = "player",
		},
	}
	self.definitions.player_level_5_anarchist_armor_multiplier = {
		name_id = "menu_player_level_5_anarchist_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_5_anarchist_armor_multiplier",
			category = "player",
		},
	}
	self.definitions.player_level_6_anarchist_armor_multiplier = {
		name_id = "menu_player_level_6_anarchist_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_6_anarchist_armor_multiplier",
			category = "player",
		},
	}
	self.definitions.player_level_7_anarchist_armor_multiplier = {
		name_id = "menu_player_level_7_anarchist_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_7_anarchist_armor_multiplier",
			category = "player",
		},
	}
	self.values.player.headshot_to_armor = { {
		{ 1, 2 },
		{ 1.5, 2.5 },
		{ 2, 3 },
		{ 2.5, 3.75 },
		{ 3, 4.5 },
		{ 3.5, 6 },
		{ 4, 8 },
	} }
	self.definitions.player_headshot_to_armor = {
		name_id = "menu_player_headshot_to_armor",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_to_armor",
			category = "player",
		},
	}
	self.values.player.damage_to_armor = { {
		{ 1, 2 },
		{ 1.5, 2.5 },
		{ 2, 3 },
		{ 2.5, 3.75 },
		{ 3, 4.5 },
		{ 3.5, 6 },
		{ 4, 8 },
	} }
	self.specialization_descs[15][3].multiperk = "75%"
	self.specialization_descs[15][7].multiperk2 = "50%"

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
	self.definitions.player_smoke_grenade_no_armor_suppression = {
		name_id = "menu_smoke_grenade_no_armor_suppression",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "smoke_grenade_no_armor_suppression",
			synced = true,
			category = "player",
		},
	}
	self.values.player.smoke_grenade_no_armor_suppression = { true }
	self.definitions.player_smoke_screen_armor_regen_mul = {
		name_id = "menu_smoke_screen_armor_regen_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "smoke_screen_armor_regen_mul",
			category = "player",
		},
	}
	self.values.player.smoke_screen_armor_regen_mul = { 0.7 }
	self.definitions.player_smoke_grenade_dodge_buff = {
		name_id = "menu_smoke_grenade_dodge_buff",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "smoke_grenade_dodge_buff",
			synced = true,
			category = "player",
		},
	}
	self.values.player.smoke_grenade_dodge_buff = { true }
	self.definitions.player_smoke_screen_dodge_add = {
		name_id = "menu_smoke_screen_dodge_add",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "smoke_screen_dodge_add",
			category = "player",
		},
	}
	self.values.player.smoke_screen_dodge_add = { 0.25 }
	self.definitions.player_smoke_grenade_lingering_effect = {
		name_id = "menu_smoke_grenade_lingering_effect",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "smoke_grenade_lingering_effect",
			synced = true,
			category = "player",
		},
	}
	self.values.player.smoke_grenade_lingering_effect = { 3 }
	self.specialization_descs[18][3].multiperk = "30%"
	self.specialization_descs[18][7].multiperk = "25%"
	self.specialization_descs[18][9].multiperk = "3"

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

	-- Wildcard Perkdeck
	self.values.player.passive_xp_multiplier = { 1.1, 1.25, 1.45 }
	self.definitions.passive_player_xp_multiplier_2 = {
		name_id = "menu_player_xp_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "passive_xp_multiplier",
			category = "player",
		},
	}
	self.definitions.passive_player_xp_multiplier_3 = {
		name_id = "menu_player_xp_multiplier",
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "passive_xp_multiplier",
			category = "player",
		},
	}
	self.values.player.passive_cash_multiplier = { 1.1, 1.25, 1.45 }
	self.definitions.passive_player_cash_multiplier = {
		name_id = "menu_player_cash_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_cash_multiplier",
			category = "player",
		},
	}
	self.definitions.passive_player_cash_multiplier_2 = {
		name_id = "menu_player_cash_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "passive_cash_multiplier",
			category = "player",
		},
	}
	self.definitions.passive_player_cash_multiplier_3 = {
		name_id = "menu_player_cash_multiplier",
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "passive_cash_multiplier",
			category = "player",
		},
	}
	self.specialization_descs[23][1].multiperk = "10%"
	self.specialization_descs[23][3].multiperk = "10%"
	self.specialization_descs[23][5].multiperk = "15%"
	self.specialization_descs[23][7].multiperk = "15%"
	self.specialization_descs[23][9].multiperk = "20%"

	-- Grenade Case
	self.grenade_crate_base = 4
	self.definitions.grenade_case = {
		equipment_id = "grenade_case",
		slot = 1,
		category = "equipment",
		name_id = "menu_equipment_grenade_case",
	}

	-- misc
	self.values.carry.throw_distance_multiplier[1] = 1.25
	self.values.player.crouch_speed_multiplier[1] = 1.1
	self.values.player.run_speed_multiplier[1] = 1.1
	self.values.player.regain_throwable_from_ammo = {
		{
			required_pickups = 50,
		},
	}
	self.values.saw.enemy_slicer[1] = 2
end
