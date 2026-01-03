local data = SkillTreeTweakData.init
function SkillTreeTweakData:init(tweak_data)
	data(self, tweak_data)

	local function digest(value)
		return Application:digest_value(value, true)
	end

	-- reduce t4 cost
	self.tier_unlocks = {
		digest(0),
		digest(1),
		digest(4),
		digest(16),
	}

	-- MASTERMIND --

	-- Aftercare
	self.skills.combat_medic[1].upgrades = { "player_revive_damage_reduction_level_1", "player_revive_health_boost" }
	self.skills.combat_medic[2].upgrades = { "player_action_revive_health_regen" }
	self.skills.combat_medic.icon_xy = { 7, 12 }

	-- Bandages
	self.skills.fast_learner[1].upgrades = { "player_revive_health_boost_2" }
	self.skills.fast_learner[2].upgrades = { "player_revived_health_regain_1" }
	self.skills.fast_learner.name_id = "menu_bandages"
	self.skills.fast_learner.desc_id = "menu_bandages_desc"
	self.skills.fast_learner.icon_xy = { 5, 7 }

	-- Painkillers
	self.skills.tea_time[1].upgrades = { "player_revive_damage_reduction_level_2" }
	self.skills.tea_time[2].upgrades = { "player_revived_damage_resist_1" }
	self.skills.tea_time.name_id = "menu_fast_learner_beta"
	self.skills.tea_time.desc_id = "menu_fast_learner_beta_desc"
	self.skills.tea_time.icon_xy = { 0, 10 }

	-- Combat Doctor
	self.skills.tea_cookies[1].upgrades = { "temporary_revive_damage_reduction_1", "player_revive_damage_reduction_1" }
	self.skills.tea_cookies[2].upgrades = { "player_revive_interaction_speed_multiplier", "temporary_combat_medic_damage_multiplier1" }
	self.skills.tea_cookies.name_id = "menu_medic_2x_beta"
	self.skills.tea_cookies.desc_id = "menu_combat_doctor_desc"
	self.skills.tea_cookies.icon_xy = { 4, 9 }

	-- Keepers
	self.skills.medic_2x[1].upgrades = { "doctor_bag_amount_increase1" }
	self.skills.medic_2x[2].upgrades = { "doctor_bag_quantity" }
	self.skills.medic_2x.name_id = "menu_keepers"
	self.skills.medic_2x.desc_id = "menu_keepers_desc"

	-- Inspire
	self.skills.inspire[1].upgrades = { "player_morale_boost" }
	self.skills.inspire[2].upgrades = { "cooldown_long_dis_revive" }
	self.skills.inspire.icon_xy = { 11, 5 }

	-- Forced Friendship
	self.skills.triathlete[1].upgrades = { "cable_tie_quantity", "cable_tie_interact_speed_multiplier" }
	self.skills.triathlete[2].upgrades = { "player_extra_hostages", "cable_tie_pickup_chance" }

	-- Control Freak
	self.skills.cable_guy[1].upgrades = { "player_intimidate_range_mul", "player_intimidate_aura", "player_intimidation_multiplier" }
	self.skills.cable_guy[2].upgrades = { "player_civ_intimidation_mul", "player_civ_calming_alerts" }
	self.skills.cable_guy.icon_xy = { 6, 7 }

	-- Joker
	self.skills.joker[1].upgrades =
		{ "player_convert_enemies_damage_multiplier_1", "player_convert_enemies", "player_convert_enemies_max_minions_1", "player_passive_convert_enemies_health_multiplier_1" }
	self.skills.joker[2].upgrades = { "player_convert_enemies_damage_multiplier_2", "player_convert_enemies_interaction_speed_multiplier", "player_passive_convert_enemies_health_multiplier_2" }

	-- Stockholm Syndrome
	self.skills.stockholm_syndrome[1].upgrades = { "player_civilians_dont_flee", "player_civilian_reviver" }
	self.skills.stockholm_syndrome[2].upgrades = { "player_hostage_damage_reduction_addend" }
	self.skills.stockholm_syndrome.icon_xy = { 3, 8 }

	-- Partners in Crime
	self.skills.control_freak[1].upgrades = { "player_convert_camouflage_mul" }
	self.skills.control_freak[2].upgrades = { "player_convert_counts_as_hostage" }

	-- Hostage Taker
	self.skills.black_marketeer[1].upgrades = { "player_hostage_health_regen_addend_1" }
	self.skills.black_marketeer[2].upgrades = { "player_close_to_hostage_boost" }

	-- Stable Shot
	self.skills.stable_shot[1].upgrades = { "player_weapon_accuracy_increase_1" }
	self.skills.stable_shot[2].upgrades = { "weapon_faster_recoil_recentering" }
	self.skills.stable_shot.icon_xy = { 9, 11 }

	-- Rifleman
	self.skills.rifleman[1].upgrades = { "player_steelsight_stamina_reduction_multiplier" }
	self.skills.rifleman[2].upgrades = { "weapon_standing_spread_multiplier" }
	self.skills.rifleman.icon_xy = { 0, 5 }

	-- Marksman
	self.skills.sharpshooter[1].upgrades = { "player_steelsight_aimpunch_multiplier" }
	self.skills.sharpshooter[2].upgrades = { "weapon_steelsight_recoil_multiplier" }
	self.skills.sharpshooter.icon_xy = { 6, 5 }

	-- Ammo Efficiency
	self.skills.spotter_teamwork[1].upgrades = { "head_shot_ammo_return_1" }
	self.skills.spotter_teamwork[2].upgrades = { "head_shot_ammo_return_2", "head_shot_ammo_return_straight_to_mag" }
	self.skills.spotter_teamwork.icon_xy = { 8, 4 }
	self.skills.spotter_teamwork.name_id = "menu_ammo_efficiency"
	self.skills.spotter_teamwork.desc_id = "menu_ammo_efficiency_desc"

	-- Kilmer
	table.delete(self.skills.speedy_reload[1].upgrades, "smg_reload_speed_multiplier")
	self.skills.speedy_reload.name_id = "menu_kilmer"
	self.skills.speedy_reload.icon_xy = { 1, 9 }

	-- Headshot Fury
	self.skills.single_shot_ammo_return[1].upgrades = { "snp_consecutive_headshots" }
	self.skills.single_shot_ammo_return[2].upgrades = { "snp_charged_shot" }
	self.skills.single_shot_ammo_return.icon_xy = { 11, 9 }
	self.skills.single_shot_ammo_return.name_id = "menu_headshot_fury"
	self.skills.single_shot_ammo_return.desc_id = "menu_headshot_fury_desc"

	-- ENFORCER --

	-- Point Blank
	self.skills.shotgun_cqb[1].upgrades = { "player_speed_stack_on_kill" }
	self.skills.shotgun_cqb[2].upgrades = { "player_close_damage_multiplier" }
	self.skills.shotgun_cqb.icon_xy = { 8, 6 }
	self.skills.shotgun_cqb.name_id = "menu_point_blank"
	self.skills.shotgun_cqb.desc_id = "menu_point_blank_desc"

	-- Heavy Impact
	self.skills.shotgun_impact[1].upgrades = { "weapon_knock_down_1" }
	self.skills.shotgun_impact[2].upgrades = { "player_enemy_hurt_damage_multiplier", "shotgun_enemy_push" }
	self.skills.shotgun_impact.icon_xy = { 5, 0 }
	self.skills.shotgun_impact.name_id = "menu_heavy_impact"
	self.skills.shotgun_impact.desc_id = "menu_heavy_impact_desc"

	-- Fast Hands
	self.skills.far_away[1].upgrades = { "shotgun_pump_reload_speed_mul", "shotgun_mag_reload_speed_mul" }
	self.skills.far_away[2].upgrades = { "shotgun_hip_rate_of_fire_1" }
	self.skills.far_away.name_id = "menu_fast_hands"
	self.skills.far_away.desc_id = "menu_fast_hands_desc"
	self.skills.far_away.icon_xy = { 5, 1 }

	-- Far Away
	self.skills.close_by[1].upgrades = { "shotgun_effective_range_multiplier" }
	self.skills.close_by[2].upgrades = { "shotgun_steelsight_accuracy_inc_1" }
	self.skills.close_by.name_id = "menu_far_away"
	self.skills.close_by.desc_id = "menu_far_away_desc"
	self.skills.close_by.icon_xy = { 8, 5 }

	-- OVERKILL
	self.skills.overkill[1].upgrades = { "cooldown_shotgun_panic_on_kill" }
	self.skills.overkill[2].upgrades = { "player_overkill_damage_multiplier", "player_overkill_all_weapons" }
	self.skills.overkill.name_id = "menu_overkill"
	self.skills.overkill.desc_id = "menu_overkill_desc"
	self.skills.overkill.icon_xy = { 3, 2 }

	-- Impact Padding
	self.skills.oppressor[1].upgrades = { "player_stationary_damage_multiplier" }
	self.skills.oppressor[2].upgrades = { "cooldown_damage_multiplier_on_armor_regen", "temporary_armor_regen_damage_multiplier" }
	self.skills.oppressor.name_id = "menu_impact_padding"
	self.skills.oppressor.desc_id = "menu_impact_padding_desc"
	self.skills.oppressor.icon_xy = { 6, 4 }

	-- Nerves of Steel
	self.skills.show_of_force[1].upgrades = { "player_damage_shake_addend" }
	self.skills.show_of_force[2].upgrades = { "player_suppressed_bonus" }
	self.skills.show_of_force.name_id = "menu_nerves_of_steel"
	self.skills.show_of_force.desc_id = "menu_nerves_of_steel_desc"
	self.skills.show_of_force.icon_xy = { 6, 6 }

	-- Protective Mask
	self.skills.pack_mule[1].upgrades = { "player_gas_mask" }
	self.skills.pack_mule[2].upgrades = { "player_flashbang_multiplier_1" }
	self.skills.pack_mule.name_id = "menu_protective_mask"
	self.skills.pack_mule.desc_id = "menu_protective_mask_desc"
	self.skills.pack_mule.icon_xy = { 6, 12 }

	-- Pack Mule
	self.skills.iron_man[1].upgrades = { "carry_movement_penalty_nullifier" }
	self.skills.iron_man[2].upgrades = { "player_carry_stacker", "player_armor_carry_bonus_1" }
	self.skills.iron_man.name_id = "menu_pack_mule"
	self.skills.iron_man.desc_id = "menu_pack_mule_desc"
	self.skills.iron_man.icon_xy = { 6, 0 }

	-- Regen Plating
	self.skills.prison_wife[1].upgrades = { "player_armor_regen_time_mul_1" }
	self.skills.prison_wife[2].upgrades = { "cooldown_health_regen_on_armor_regen" }
	self.skills.prison_wife.name_id = "menu_regen_plating"
	self.skills.prison_wife.desc_id = "menu_regen_plating_desc"
	self.skills.prison_wife.icon_xy = { 11, 10 }

	-- Iron Man
	self.skills.juggernaut[1].upgrades = { "player_armor_threshold_damage_multiplier" }
	self.skills.juggernaut[2].upgrades = { "body_armor6" }
	self.skills.juggernaut.name_id = "menu_iron_man"
	self.skills.juggernaut.desc_id = "menu_iron_man_desc"
	self.skills.juggernaut.icon_xy = { 3, 1 }

	-- Scavenger
	self.skills.scavenging[1].upgrades = { "player_pick_up_ammo_multiplier" }
	self.skills.scavenging[2].upgrades = { "player_increased_pickup_area_1" }

	-- Fully Loaded
	self.skills.ammo_reservoir[1].upgrades = { "player_start_out_ammo_multiplier" }
	self.skills.ammo_reservoir[2].upgrades = { "extra_ammo_multiplier1" }
	self.skills.ammo_reservoir.name_id = "menu_fully_loaded"
	self.skills.ammo_reservoir.desc_id = "menu_fully_loaded_desc"
	self.skills.ammo_reservoir.icon_xy = { 3, 0 }

	-- Mag Plus
	self.skills.portable_saw[1].upgrades = { "weapon_consume_no_ammo_chance" }
	self.skills.portable_saw[2].upgrades = { "weapon_clip_ammo_increase_1" }
	self.skills.portable_saw.name_id = "menu_mag_plus_beta"
	self.skills.portable_saw.desc_id = "menu_mag_plus_beta_desc"
	self.skills.portable_saw.icon_xy = { 2, 0 }

	-- Extra Lead
	self.skills.ammo_2x[1].upgrades = { "ammo_bag_ammo_increase1" }
	self.skills.ammo_2x[2].upgrades = { "ammo_bag_quantity" }

	-- Big Game Hunters
	self.skills.carbon_blade[1].upgrades = { "player_double_drop_1" }
	self.skills.carbon_blade[2].upgrades = { "player_double_drop_extra_damage" }
	self.skills.carbon_blade.name_id = "menu_big_game_hunters"
	self.skills.carbon_blade.desc_id = "menu_big_game_hunters_desc"
	self.skills.carbon_blade.icon_xy = { 10, 2 }

	-- Bulletstorm
	self.skills.bandoliers[1].upgrades = { "temporary_no_ammo_cost_1" }
	self.skills.bandoliers[2].upgrades = { "temporary_no_ammo_cost_2" }
	self.skills.bandoliers.name_id = "menu_ammo_reservoir_beta"
	self.skills.bandoliers.desc_id = "menu_ammo_reservoir_beta_desc"
	self.skills.bandoliers.icon_xy = { 4, 5 }

	-- TECHNICIAN --

	-- Daredevil
	self.skills.defense_up[1].upgrades = { "player_interacting_damage_multiplier" }
	self.skills.defense_up[2].upgrades = { "player_total_interaction_timer_multiplier" }
	self.skills.defense_up.icon_xy = { 8, 9 }

	-- Hardware Expert
	self.skills.sentry_targeting_package[1].upgrades = { "player_drill_alert", "player_silent_drill" }
	self.skills.sentry_targeting_package[2].upgrades = { "player_drill_fix_interaction_speed_multiplier" }
	self.skills.sentry_targeting_package.icon_xy = { 9, 6 }

	-- Kickstarter
	self.skills.jack_of_all_trades[1].upgrades = { "player_drill_autorepair_1", "player_drill_autorepair_2" }
	self.skills.jack_of_all_trades[2].upgrades = { "player_drill_melee_hit_restart_chance_1" }
	self.skills.jack_of_all_trades.icon_xy = { 9, 8 }

	-- Portable Saw
	self.skills.engineering[1].upgrades =
		{ "saw_extra_ammo_multiplier", "player_saw_speed_multiplier_1", "player_saw_speed_multiplier_2", "saw_lock_damage_multiplier_1", "saw_lock_damage_multiplier_2" }
	self.skills.engineering[2].upgrades = { "saw_secondary" }
	self.skills.engineering.icon_xy = { 0, 1 }
	self.skills.engineering.name_id = "menu_portable_saw"
	self.skills.engineering.desc_id = "menu_portable_saw_desc"

	-- Sentry Nest
	self.skills.tower_defense[2].upgrades = { "sentry_gun_cost_reduction_1", "sentry_gun_cost_reduction_2", "sentry_gun_extra_ammo_multiplier_1" }
	self.skills.tower_defense.icon_xy = { 7, 6 }

	-- PhD in Engineering
	self.skills.eco_sentry[1].upgrades = { "sentry_gun_standstill_omniscience", "sentry_gun_spread_multiplier" }
	self.skills.eco_sentry[2].upgrades = { "sentry_gun_ap_bullets", "sentry_gun_fire_rate_reduction_1" }
	self.skills.eco_sentry.icon_xy = { 7, 8 }

	-- Blast Shield
	self.skills.hardware_expert[1].upgrades = { "player_explosive_damage_multiplier" }
	self.skills.hardware_expert[2].upgrades = { "weapon_explosive_team_damage_multiplier" }
	self.skills.hardware_expert.name_id = "menu_blast_shield"
	self.skills.hardware_expert.desc_id = "menu_blast_shield_desc"
	self.skills.hardware_expert.icon_xy = { 7, 9 }

	-- Arms Cache
	self.skills.drill_expert[1].upgrades = { "grenade_case_amount_increase", "grenade_crate_amount_increase" }
	self.skills.drill_expert[2].upgrades = { "grenade_case_quantity", "grenade_crate_quantity" }
	self.skills.drill_expert.name_id = "menu_arms_cache"
	self.skills.drill_expert.desc_id = "menu_arms_cache_desc"
	self.skills.drill_expert.icon_xy = { 0, 7 }

	-- Hellwire
	self.skills.more_fire_power[1].upgrades = { "shape_charge_quantity_increase_1", "trip_mine_quantity_increase_1" }
	self.skills.more_fire_power[2].upgrades = { "trip_mine_fire_trap_1" }
	self.skills.more_fire_power.name_id = "menu_hellwire"
	self.skills.more_fire_power.desc_id = "menu_hellwire_desc"
	self.skills.more_fire_power.icon_xy = { 9, 9 }

	-- Powder Keg
	self.skills.kick_starter[1].upgrades = { "weapon_explosive_range_multiplier" }
	self.skills.kick_starter[2].upgrades = { "weapon_explosive_curve_multiplier" }
	self.skills.kick_starter.name_id = "menu_powder_keg"
	self.skills.kick_starter.desc_id = "menu_powder_keg_desc"
	self.skills.kick_starter.icon_xy = { 9, 7 }

	-- Carpet Bombing
	self.skills.fire_trap[1].upgrades = { "weapon_explosive_cluster_grenades" }
	self.skills.fire_trap[2].upgrades = { "weapon_cluster_incendiary_grenades" }
	self.skills.fire_trap.name_id = "menu_carpet_bombing"
	self.skills.fire_trap.desc_id = "menu_carpet_bombing_desc"
	self.skills.fire_trap.icon_xy = { 6, 9 }

	-- Steady Grip
	self.skills.steady_grip[1].upgrades = { "player_stability_increase_bonus_1" }
	self.skills.steady_grip[2].upgrades = { "weapon_moving_recoil_penalty_reduction" }
	self.skills.steady_grip.icon_xy = { 7, 7 }

	-- Oppressor
	self.skills.heavy_impact[1].upgrades = { "player_suppression_bonus" }
	self.skills.heavy_impact[2].upgrades = { "player_enemy_panic_damage_multiplier" }
	self.skills.heavy_impact.name_id = "menu_oppressor"
	self.skills.heavy_impact.desc_id = "menu_oppressor_desc"
	self.skills.heavy_impact.icon_xy = { 7, 0 }

	-- Fire Control
	self.skills.fire_control[1].upgrades = { "weapon_hipfire_spread_penalty_reduction" }
	self.skills.fire_control[2].upgrades = { "smg_spray_recoil_multiplier", "lmg_spray_recoil_multiplier", "minigun_spray_recoil_multiplier" }

	-- Sleight of Hand
	self.skills.shock_and_awe[1].upgrades = { "smg_reload_speed_multiplier", "lmg_reload_speed_multiplier" }
	self.skills.shock_and_awe.icon_xy = { 3, 3 }
	self.skills.shock_and_awe.name_id = "menu_sleight_of_hand"
	self.skills.shock_and_awe.desc_id = "menu_sleight_of_hand_desc"

	-- Lock N' Load
	self.skills.fast_fire[1].upgrades = { "player_run_and_shoot_1" }
	self.skills.fast_fire[2].upgrades = { "player_no_movement_penalty" }
	self.skills.fast_fire.icon_xy = { 7, 10 }

	-- Body Expertise
	self.skills.body_expertise[1].upgrades = { "player_ap_bullets_1" }
	self.skills.body_expertise[2].upgrades = { "weapon_automatic_head_shot_add_1" }

	-- GHOST --

	-- Inner Pockets
	self.skills.cleaner[1].upgrades = { "player_melee_concealment_modifier" }
	self.skills.cleaner[2].upgrades = { "player_ballistic_vest_concealment_1" }
	self.skills.cleaner.icon_xy = { 10, 7 }
	self.skills.cleaner.name_id = "menu_thick_skin_beta"
	self.skills.cleaner.desc_id = "menu_thick_skin_beta_desc"

	-- Winstone Wolfe
	self.skills.second_chances[1].upgrades = { "player_corpse_dispose_amount_2", "player_extra_corpse_dispose_amount" }
	self.skills.second_chances[2].upgrades = { "player_pick_lock_easy_speed_multiplier", "player_pick_lock_hard" }
	self.skills.second_chances.icon_xy = { 5, 4 }

	-- ECM feedback
	self.skills.ecm_booster[1].upgrades = { "ecm_jammer_can_activate_feedback" }
	self.skills.ecm_booster[2].upgrades = { "ecm_jammer_can_retrigger" }
	self.skills.ecm_booster.icon_xy = { 6, 2 }

	-- Chameleon
	self.skills.jail_workout[1].upgrades = { "player_suspicion_bonus", "player_camouflage_bonus_1", "player_camouflage_bonus_2" }
	self.skills.jail_workout[2].upgrades = { "player_concealment_bonus_1" }

	-- ECM Specialist
	self.skills.ecm_2x[2].upgrades = { "ecm_jammer_duration_multiplier_1", "ecm_jammer_duration_multiplier_2", "ecm_jammer_feedback_duration_boost_2" }

	-- Blackout
	self.skills.chameleon[1].upgrades = { "player_tape_loop_duration_1", "player_tape_loop_duration_2" }
	self.skills.chameleon[2].upgrades = { "ecm_jammer_affects_pagers", "ecm_jammer_can_open_sec_doors" }
	self.skills.chameleon.icon_xy = { 6, 3 }

	-- Athlete
	self.skills.sprinter[1].upgrades = { "player_stamina_regen_timer_multiplier", "player_stamina_regen_multiplier" }
	self.skills.sprinter[2].upgrades = { "player_movement_speed_multiplier" }
	self.skills.sprinter.icon_xy = { 1, 8 }
	self.skills.sprinter.name_id = "menu_sprinter"
	self.skills.sprinter.desc_id = "menu_sprinter_desc"

	-- Duck and Cover
	self.skills.awareness[1].upgrades = { "player_stamina_regen_multiplier_crouched" }
	self.skills.awareness[2].upgrades = { "player_crouch_dodge_chance_1" }
	self.skills.awareness.icon_xy = { 0, 11 }
	self.skills.awareness.name_id = "menu_awareness"
	self.skills.awareness.desc_id = "menu_awareness_desc"

	-- Sprinter
	self.skills.optic_illusions[1].upgrades = { "player_can_strafe_run", "player_can_sprint_swap" }
	self.skills.optic_illusions[2].upgrades = { "player_run_dodge_chance", "player_on_zipline_dodge_chance" }
	self.skills.optic_illusions.icon_xy = { 7, 3 }

	-- Second Wind
	self.skills.dire_need[1].upgrades = { "temporary_damage_speed_multiplier" }
	self.skills.dire_need[2].upgrades = { "cooldown_dodge_on_armor_break" }
	self.skills.dire_need.icon_xy = { 10, 9 }

	-- Shockproof
	self.skills.insulation[1].upgrades = { "player_resist_firing_tased", "player_weaker_tase_effect" }

	-- Sneaky Bastard
	self.skills.jail_diet[2].upgrades = { "cooldown_dodge_replenish_armor" }

	-- Resilient Assault
	self.skills.scavenger[1].upgrades = { "player_critical_hit_chance_1" }
	self.skills.scavenger[2].upgrades = { "player_armor_depleted_stagger_shot_1", "player_armor_depleted_stagger_shot_2" }
	self.skills.scavenger.icon_xy = { 10, 8 }

	-- Eagle Eye
	self.skills.thick_skin[1].upgrades = { "weapon_special_damage_taken_multiplier" }
	self.skills.thick_skin[2].upgrades = { "weapon_steelsight_highlight_specials", "player_marked_distance_mul" }
	self.skills.thick_skin.icon_xy = { 3, 7 }
	self.skills.thick_skin.name_id = "menu_cleaner_beta"
	self.skills.thick_skin.desc_id = "menu_cleaner_beta_desc"

	-- The Professional
	self.skills.silence_expert[1].upgrades = { "weapon_silencer_enter_steelsight_speed_multiplier" }
	self.skills.silence_expert[2].upgrades = { "player_silencer_concealment_penalty_decrease_1", "player_silencer_concealment_increase_1" }

	-- HVT
	self.skills.hitman[1].upgrades = { "player_marked_inc_dmg_distance_1" }
	self.skills.hitman[2].upgrades = { "player_marked_enemy_extra_damage", "player_mark_enemy_time_multiplier" }

	-- Silent Killer
	self.skills.backstab[1].upgrades = { "weapon_silencer_recoil_index_addend", "weapon_silencer_spread_index_addend", "weapon_armor_piercing_chance_silencer" }
	self.skills.backstab[2].upgrades = { "weapon_silencer_damage_multiplier" }
	self.skills.backstab.icon_xy = { 5, 9 }
	self.skills.backstab.name_id = "menu_silenced_damage"
	self.skills.backstab.desc_id = "menu_silenced_damage_desc"

	-- Low Blow
	self.skills.unseen_strike[1].upgrades = { "player_detection_risk_add_crit_chance_1" }
	self.skills.unseen_strike[2].upgrades = { "player_critical_hit_chance_2", "weapon_extra_crit_damage_mul" }
	self.skills.unseen_strike.icon_xy = { 0, 12 }
	self.skills.unseen_strike.name_id = "menu_backstab_beta"
	self.skills.unseen_strike.desc_id = "menu_backstab_beta_desc"

	-- FUGITIVE --

	-- Equilibrium
	self.skills.equilibrium[1].upgrades = { "weapon_steelsight_move_speed_penalty_multiplier" }
	self.skills.equilibrium[2].upgrades = { "weapon_enter_steelsight_speed_multiplier" }
	self.skills.equilibrium.icon_xy = { 0, 9 }

	-- Field Operator
	self.skills.dance_instructor[1].upgrades = { "player_sprint_to_fire_multiplier" }
	self.skills.dance_instructor[2].upgrades = { "weapon_swap_speed_multiplier" }
	self.skills.dance_instructor.icon_xy = { 4, 10 }

	-- Sidearm Savvy
	self.skills.akimbo[1].upgrades = { "player_sidearm_move_speed_multiplier" }
	self.skills.akimbo[2].upgrades = { "player_sidearms_reload_primary" }
	self.skills.akimbo.icon_xy = { 5, 10 }

	-- Triggery Overdrive
	self.skills.gun_fighter[1].upgrades = { "pistol_stacked_reload_bonus" }
	self.skills.gun_fighter[2].upgrades = { "pistol_stacked_accuracy_bonus_1" }
	self.skills.gun_fighter.icon_xy = { 0, 8 }

	-- Deadeye
	self.skills.expert_handling[1].upgrades = { "revolver_headshot_chain_instant_reload" }
	self.skills.expert_handling[2].upgrades = { "revolver_headshot_chain_ammo_restore" }
	self.skills.expert_handling.icon_xy = { 8, 12 }

	-- Peacemaker's Lament
	self.skills.trigger_happy[1].upgrades = { "temporary_sidearm_pullout_damage_multiplier" }
	self.skills.trigger_happy[2].upgrades = { "temporary_sidearm_reload_damage_multiplier", "cooldown_sidearm_reload_damage_multiplier", "player_sidearm_ricochet_damage" }
	self.skills.trigger_happy.icon_xy = { 11, 11 }

	-- Tough Guy
	self.skills.nine_lives[1].upgrades = { "player_steelsight_when_downed" }
	self.skills.nine_lives[2].upgrades = { "player_swap_weapon_when_downed" }
	self.skills.nine_lives.icon_xy = { 1, 2 }

	-- Quick Fix
	self.skills.running_from_death[1].upgrades = { "first_aid_kit_deploy_time_multiplier" }
	self.skills.running_from_death[2].upgrades = { "first_aid_kit_damage_reduction_upgrade" }
	self.skills.running_from_death.icon_xy = { 1, 11 }
	self.skills.running_from_death.name_id = "menu_tea_time_beta"
	self.skills.running_from_death.desc_id = "menu_tea_time_beta_desc"

	-- More Blood to Bleed
	self.skills.up_you_go[1].upgrades = { "player_bleed_out_health_multiplier" }
	self.skills.up_you_go[2].upgrades = { "player_health_multiplier" }
	self.skills.up_you_go.icon_xy = { 1, 1 }
	self.skills.up_you_go.name_id = "menu_more_blood_to_bleed"
	self.skills.up_you_go.desc_id = "menu_more_blood_to_bleed_desc"

	-- Uppers
	self.skills.feign_death[1].upgrades = { "first_aid_kit_hot_regen_1" }
	self.skills.feign_death[2].upgrades = { "first_aid_kit_auto_recovery_1" }
	self.skills.feign_death.icon_xy = { 2, 11 }
	self.skills.feign_death.name_id = "menu_tea_cookies_beta"
	self.skills.feign_death.desc_id = "menu_tea_cookies_beta_desc"

	-- Swan Song
	table.delete(self.skills.perseverance[2].upgrades, "player_berserker_no_ammo_cost")

	-- Messiah
	self.skills.messiah[1].upgrades = { "player_messiah_revive_from_bleed_out_1", "player_increased_bleedout_timer" }
	self.skills.messiah[2].upgrades = { "player_messiah_revive_from_bleed_out_2", "player_super_syndrome_1" }

	-- Bloodthirst
	self.skills.bloodthirst[1].upgrades = { "player_melee_damage_stacking_1" }
	self.skills.bloodthirst[2].upgrades = { "player_non_special_melee_multiplier", "player_melee_damage_multiplier" }
	self.skills.bloodthirst.name_id = "menu_bloodthirst"
	self.skills.bloodthirst.desc_id = "menu_bloodthirst_desc"

	-- Pumping Iron
	self.skills.steroids[1].upgrades = { "melee_faster_reswing" }
	self.skills.steroids[2].upgrades = { "player_run_and_melee" }
	self.skills.steroids.icon_xy = { 4, 12 }
	self.skills.steroids.name_id = "menu_pumping_iron"
	self.skills.steroids.desc_id = "menu_pumping_iron_desc"

	-- Counter Strike
	self.skills.drop_soap[1].upgrades = { "player_shield_knock" }
	self.skills.drop_soap[2].upgrades = { "cooldown_melee_dozer_knock" }
	self.skills.drop_soap.icon_xy = { 4, 8 }
	self.skills.drop_soap.name_id = "menu_counter_strike"
	self.skills.drop_soap.desc_id = "menu_counter_strike_desc"

	-- Berserker
	self.skills.wolverine[1].upgrades = { "player_movement_speed_damage_health_ratio_multiplier", "player_movement_speed_damage_health_ratio_threshold_multiplier" }
	self.skills.wolverine[2].upgrades = { "player_melee_damage_health_ratio_multiplier" }

	-- MISC STUFF --
	-- Medic Tree
	self.trees[1].tiers[2][1] = "fast_learner"
	self.trees[1].tiers[2][2] = "tea_time"
	-- Sentry tree
	self.trees[7].tiers[2][2] = "engineering"
	self.trees[7].tiers[3][2] = "tower_defense"
	self.trees[7].tiers[3][1] = "jack_of_all_trades"
	self.trees[7].tiers[4][1] = "eco_sentry"
	-- ECM tree
	self.trees[10].tiers[1][1] = "cleaner"
	self.trees[10].tiers[2][1] = "second_chances"
	self.trees[10].tiers[2][2] = "ecm_booster"
	self.trees[10].tiers[3][1] = "jail_workout"
	self.trees[10].tiers[3][2] = "ecm_2x"
	self.trees[10].tiers[4][1] = "chameleon"
	-- Swap Silencer Expert and HVT
	self.trees[12].tiers[3][1] = "hitman"
	self.trees[12].tiers[3][2] = "backstab"
	-- Swap Inner Pockets and Deft Hands
	self.trees[11].tiers[2][2] = "optic_illusions"
	self.trees[12].tiers[2][1] = "thick_skin"
	-- Swap Uppers and Swan Song
	self.trees[14].tiers[3][1] = "feign_death"
	self.trees[14].tiers[3][2] = "perseverance"

	-- PERK DECKS --

	-- categories
	self.specialization_category = {
		{
			name_id = "menu_st_category_all",
			category = "all",
		},
		{
			name_id = "menu_st_category_health",
			category = "health",
		},
		{
			name_id = "menu_st_category_healing",
			category = "healing",
		},
		{
			name_id = "menu_st_category_armor",
			category = "armor",
		},
		{
			name_id = "menu_st_category_armor_gating",
			category = "armor_gating",
		},
		{
			name_id = "menu_st_category_resistance",
			category = "resistance",
		},
		{
			name_id = "menu_st_category_support",
			category = "support",
		},
		{
			name_id = "menu_st_category_dodge",
			category = "dodge",
		},
		{
			name_id = "menu_st_category_special",
			category = "special",
		},
	}

	-- ccf
	self.specializations[1].category = { "support", "health" }
	-- mus
	self.specializations[2].category = { "health" }
	-- arm
	self.specializations[3].category = "armor"
	-- rog
	self.specializations[4].category = "dodge"
	-- hit
	self.specializations[5].category = "dodge"
	-- crk
	self.specializations[6].category = { "armor", "resistance" }
	-- tct
	self.specializations[7].category = { "support", "resistance" }
	-- inf
	self.specializations[8].category = { "resistance", "healing" }
	-- soc
	self.specializations[9].category = { "armor", "armor_gating" }
	-- gmb
	self.specializations[10].category = { "healing", "support" }
	-- grd
	self.specializations[11].category = { "health", "healing" }
	-- yak
	self.specializations[12].category = "dodge"
	-- exp
	self.specializations[13].category = "healing"
	-- man
	self.specializations[14].category = { "resistance", "support" }
	-- anr
	self.specializations[15].category = { "armor_gating", "armor" }
	-- bik
	self.specializations[16].category = { "healing", "armor_gating" }
	-- kpn
	self.specializations[17].category = { "health", "resistance" }
	-- sic
	self.specializations[18].category = { "dodge", "support" }
	-- stc
	self.specializations[19].category = { "health", "resistance" }
	-- tgt
	self.specializations[20].category = { "support", "healing" }
	-- hck
	self.specializations[21].category = { "healing", "health" }
	-- lch
	self.specializations[22].category = { "health", "resistance" }

	-- This is for applying custom atlas without typing texture_bundle_folder for every single deck
	-- P.S. 2, 4 ,6 and 8 cards for custom perk decks still will use vanilla atlas
	local generic_perk_deck_cards = { 2, 4, 6, 8 } -- For 2, 4, 6 and 8 cards that every deck have

	local unique_perk_deck_cards = { 1, 3, 5, 7, 9 } -- For unique perk deck cards
	local perk_decks_eclipse_atlas = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 } -- CC -> Ex-pres use default atlas so need reapply to use new one

	-- Applying atlas changes for 2, 4, 6 and 8 cards
	for i, _ in ipairs(self.specializations) do
		for _, k in ipairs(generic_perk_deck_cards) do
			self.specializations[i][k].texture_bundle_folder = "eclipse"
		end
	end

	-- Applying atlas changes for 1, 3, 5, 7 and 9 cards for Crew Chief, Muscle , ... Ex-Pres
	for _, i in ipairs(perk_decks_eclipse_atlas) do
		for _, k in ipairs(unique_perk_deck_cards) do
			self.specializations[i][k].texture_bundle_folder = "eclipse"
		end
	end

	-- crew chief
	self.specializations[1][1].upgrades = { "team_resource_trading_health", "team_resource_trading_no_downs" }
	self.specializations[1][3].upgrades = { "player_extra_hostages_chief", "player_passive_intimidate_range_mul" }
	self.specializations[1][5].upgrades = { "team_resource_trading_ammo" }
	self.specializations[1][7].upgrades = { "team_hostage_health_multiplier", "team_hostage_stamina_multiplier", "cable_tie_quantity_2" }
	self.specializations[1][7].icon_xy = { 0, 1 }
	self.specializations[1][9].upgrades = { "team_resource_trading_assault_delay", "team_resource_trading_before_first_assault", "player_passive_loot_drop_multiplier" }
	self.specializations[1][9].icon_xy = { 7, 8 }

	-- muscle
	self.specializations[2][1].upgrades = { "player_panic_suppression" }
	self.specializations[2][1].icon_xy = { 3, 1 }
	self.specializations[2][3].upgrades = { "player_extra_health_multiplier_1" }
	self.specializations[2][3].icon_xy = { 2, 1 }
	self.specializations[2][5].upgrades = { "player_uncover_multiplier" }
	self.specializations[2][5].icon_xy = { 1, 1 }
	self.specializations[2][7].upgrades = { "temporary_mrwi_health_invulnerable_1" }
	self.specializations[2][7].texture_bundle_folder = "mrwi"
	self.specializations[2][7].icon_xy = { 3, 0 }
	self.specializations[2][9].upgrades = { "player_extra_health_multiplier_2" }

	-- armorer
	self.specializations[3][1].upgrades = { "player_armor_regen_timer_multiplier_passive" }
	self.specializations[3][3].upgrades = { "player_passive_armor_movement_penalty_multiplier" }
	self.specializations[3][5].upgrades = { "player_tier_armor_multiplier_1", "player_tier_armor_multiplier_2", "player_tier_armor_multiplier_3" }
	self.specializations[3][7].upgrades = { "" }
	self.specializations[3][9].upgrades = { "temporary_armor_break_invulnerable_1", "player_passive_loot_drop_multiplier" }

	-- rogue
	self.specializations[4][3].upgrades = { "player_unseen_increased_crit_chance_1", "player_unseen_temp_increased_dodge_chance" }
	self.specializations[4][9].upgrades = { "player_unseen_temp_increased_crit_chance_1", "player_passive_loot_drop_multiplier" }

	-- hitman
	self.specializations[5][1].upgrades = { "player_chain_headshot_kills", "temporary_chain_headshot_dodge_1" }
	self.specializations[5][1].icon_xy = { 7, 2 }
	self.specializations[5][3].upgrades = { "temporary_dodge_outnumbered" }
	self.specializations[5][3].icon_xy = { 0, 3 }
	self.specializations[5][5].upgrades = { "temporary_chain_headshot_dodge_2" }
	self.specializations[5][5].icon_xy = { 1, 3 }
	self.specializations[5][7].upgrades = { "player_cheat_death_chance_1" }
	self.specializations[5][7].icon_xy = { 2, 3 }
	self.specializations[5][9].upgrades = { "player_cheat_death_inc", "player_passive_loot_drop_multiplier" }
	self.specializations[5][9].icon_xy = { 3, 3 }

	-- crook
	self.specializations[6][1].upgrades = { "player_bv_stamina_reduction_multiplier" }
	self.specializations[6][1].icon_xy = { 1, 9 }
	self.specializations[6][3].upgrades = { "player_bv_health_damage_reduction" }
	self.specializations[6][3].icon_xy = { 3, 9 }
	self.specializations[6][5].upgrades = { "player_bv_ap_rnds_protection" }
	self.specializations[6][5].icon_xy = { 2, 9 }
	self.specializations[6][7].upgrades = { "player_level_2_armor_multiplier_1", "player_level_3_armor_multiplier_1", "player_level_4_armor_multiplier_1" }
	self.specializations[6][9].upgrades = { "player_bv_no_armor_suppression", "player_passive_loot_drop_multiplier" }
	self.specializations[6][9].icon_xy = { 0, 9 }

	-- tactician (ex-burglar)
	self.specializations[7][1].upgrades = { "second_deployable_1" }
	self.specializations[7][1].icon_xy = { 5, 8 }
	self.specializations[7][3].upgrades = { "player_drill_speed_multiplier1", "player_drill_speed_multiplier2" }
	self.specializations[7][3].icon_xy = { 3, 8 }
	self.specializations[7][5].upgrades = { "player_near_teammate_damage_multiplier" }
	self.specializations[7][5].icon_xy = { 2, 8 }
	self.specializations[7][7].upgrades = { "player_electrocuting_drill" }
	self.specializations[7][7].icon_xy = { 4, 8 }
	self.specializations[7][9].upgrades = { "player_no_secondary_deployable_penalty", "deploy_interact_faster_1", "player_passive_loot_drop_multiplier" }
	self.specializations[7][9].icon_xy = { 6, 8 }

	-- socio
	table.delete(self.specializations[9][7].upgrades, "player_tier_armor_multiplier_3")
	self.specializations[9][5].upgrades = { "cooldown_melee_kill_armor_leech", "player_damage_dampener_close_contact_1" }

	-- Gambler
	self.specializations[10][1].upgrades = { "player_pickup_restore_health_1" }
	self.specializations[10][3].upgrades = { "player_pickup_restore_team_ammo" }
	self.specializations[10][5].upgrades = { "player_pickup_restore_team_health" }
	self.specializations[10][7].upgrades = { "player_pickup_restore_health_2", "player_passive_health_multiplier_1", "player_passive_health_multiplier_2" }
	self.specializations[10][9].upgrades = { "player_increased_pickup_area_gambler", "player_passive_loot_drop_multiplier" }

	-- Grinder
	self.specializations[11][1].upgrades = { "player_damage_to_hot_1" }
	self.specializations[11][3].upgrades = { "player_extra_health_multiplier_1", "player_armor_to_health_conversion", "player_fall_damage_multiplier" }
	self.specializations[11][3].icon_xy = { 2, 1 }
	self.specializations[11][5].upgrades = { "cooldown_headshot_regen_health_bonus" }
	self.specializations[11][5].texture_bundle_folder = "mrwi"
	self.specializations[11][5].icon_xy = { 1, 0 }
	self.specializations[11][7].upgrades = { "player_extra_health_multiplier_2" }
	self.specializations[11][9].upgrades = { "player_damage_to_hot_3" }
	self.specializations[11][7].icon_xy = { 4, 1 }

	-- Ex-President
	table.delete(self.specializations[13][3].upgrades, "player_passive_health_multiplier_1")
	table.delete(self.specializations[13][5].upgrades, "player_passive_health_multiplier_2")
	table.delete(self.specializations[13][7].upgrades, "player_passive_health_multiplier_3")

	-- yakuza
	self.specializations[12][1].upgrades = { "player_armor_regen_damage_health_ratio_multiplier_1", "player_armor_regen_damage_health_ratio_threshold_multiplier" }
	self.specializations[12][3].upgrades = { "weapon_passive_swap_speed_multiplier_1" }
	self.specializations[12][3].icon_xy = { 0, 7 }
	self.specializations[12][5].upgrades = { "player_camouflage_multiplier" }
	self.specializations[12][5].name_id = "menu_deck4_3"
	self.specializations[12][5].icon_xy = { 4, 2 }
	self.specializations[12][7].upgrades = { "player_dodge_health_ratio_multiplier" }
	self.specializations[12][7].icon_xy = { 1, 8 }
	self.specializations[12][9].upgrades = { "player_damage_health_ratio_multiplier", "player_damage_damage_health_ratio_threshold_multiplier", "player_passive_loot_drop_multiplier" }

	-- Maniac
	table.insert(self.specializations[14][3].upgrades, "player_panic_suppression")

	-- Anarchist
	self.specializations[15][3].upgrades = {
		"player_health_decrease_1",
		"player_level_2_anarchist_armor_multiplier",
		"player_level_3_anarchist_armor_multiplier",
		"player_level_4_anarchist_armor_multiplier",
		"player_level_5_anarchist_armor_multiplier",
		"player_level_6_anarchist_armor_multiplier",
		"player_level_7_anarchist_armor_multiplier",
	}
	self.specializations[15][5].upgrades = { "player_headshot_to_armor" }
	self.specializations[15][5].icon_xy = { 1, 0 }
	self.specializations[15][5].texture_bundle_folder = nil
	self.specializations[15][7].upgrades = { "player_health_decrease_2" }
	table.delete(self.specializations[15][1].upgrades, "temporary_armor_break_invulnerable_1")

	-- kingpin
	table.delete(self.specializations[17][9].upgrades, "player_passive_health_multiplier_4")

	-- sicario
	self.specializations[18][3].upgrades = { "player_smoke_grenade_no_armor_suppression" }
	self.specializations[18][3].icon_xy = { 1, 1 }
	self.specializations[18][5].upgrades = { "player_passive_dodge_chance_1", "player_passive_dodge_chance_2", "player_passive_dodge_chance_3" }
	self.specializations[18][5].texture_bundle_folder = nil
	self.specializations[18][5].icon_xy = { 3, 2 }
	self.specializations[18][7].upgrades = { "player_smoke_grenade_dodge_buff" }
	self.specializations[18][7].icon_xy = { 2, 1 }
	self.specializations[18][9].upgrades = { "player_smoke_grenade_lingering_effect", "player_passive_loot_drop_multiplier" }

	-- stoic
	self.specializations[19][3].upgrades = { "player_armor_to_health_conversion", "player_fall_damage_multiplier" }

	-- hacker
	table.delete(self.specializations[21][3].upgrades, "player_passive_health_multiplier_2")
	self.specializations[21][3].texture_bundle_folder = nil
	self.specializations[21][3].icon_xy = { 1, 6 }
	table.insert(self.specializations[21][7].upgrades, "player_passive_health_multiplier_2")
	table.delete(self.specializations[21][7].upgrades, "player_pocket_ecm_kill_dodge_1")
	self.specializations[21][7].texture_bundle_folder = nil
	self.specializations[21][7].icon_xy = { 2, 6 }
	table.delete(self.specializations[21][9].upgrades, "player_passive_dodge_chance_2")

	-- leech
	table.delete(self.specializations[22][9].upgrades, "player_activate_ability_downed")
	table.delete(self.specializations[22][9].upgrades, "player_passive_health_multiplier_4")

	local wildcard_perkdeck = {
		{
			cost = 200,
			desc_id = "menu_deck_wildcard_1_desc",
			short_id = "menu_deck_wildcard_1_short",
			name_id = "menu_deck_wildcard_1",
			upgrades = {
				"passive_player_xp_multiplier",
			},
			icon_xy = {
				7,
				3,
			},
		},
		{
			cost = 300,
			desc_id = "menu_deckall_2_desc",
			name_id = "menu_deckall_2",
			upgrades = {
				"player_regain_throwable_from_ammo_1",
			},
			icon_xy = {
				0,
				8,
			},
		},
		{
			cost = 400,
			desc_id = "menu_deck_wildcard_3_desc",
			short_id = "menu_deck_wildcard_3_short",
			name_id = "menu_deck_wildcard_3",
			upgrades = {
				"passive_player_cash_multiplier",
			},
			icon_xy = {
				7,
				3,
			},
		},
		{
			cost = 600,
			desc_id = "menu_deckall_4_desc",
			name_id = "menu_deckall_4",
			upgrades = {
				"player_passive_suspicion_bonus",
				"player_buy_bodybags_asset",
				"player_additional_assets",
				"player_buy_spotter_asset",
			},
			icon_xy = {
				3,
				0,
			},
		},
		{
			cost = 1000,
			desc_id = "menu_deck_wildcard_5_desc",
			short_id = "menu_deck_wildcard_5_short",
			name_id = "menu_deck_wildcard_5",
			upgrades = {
				"passive_player_xp_multiplier_2",
			},
			icon_xy = {
				7,
				3,
			},
		},
		{
			cost = 1600,
			desc_id = "menu_deckall_6_desc",
			name_id = "menu_deckall_6",
			upgrades = {
				"armor_kit",
			},
			icon_xy = {
				5,
				0,
			},
		},
		{
			cost = 2400,
			desc_id = "menu_deck_wildcard_7_desc",
			short_id = "menu_deck_wildcard_7_short",
			name_id = "menu_deck_wildcard_7",
			upgrades = {
				"passive_player_cash_multiplier_2",
			},
			icon_xy = {
				7,
				3,
			},
		},
		{
			cost = 3200,
			desc_id = "menu_deckall_8_desc",
			name_id = "menu_deckall_8",
			upgrades = {
				"passive_doctor_bag_interaction_speed_multiplier",
			},
			icon_xy = {
				7,
				0,
			},
		},
		{
			cost = 4000,
			desc_id = "menu_deck_wildcard_9_desc",
			short_id = "menu_deck_wildcard_9_short",
			name_id = "menu_deck_wildcard_9",
			upgrades = {
				"player_passive_loot_drop_multiplier",
				"passive_player_xp_multiplier_3",
				"passive_player_cash_multiplier_3",
			},
			icon_xy = {
				7,
				3,
			},
		},
		name_id = "menu_st_spec_23",
		desc_id = "menu_st_spec_23_desc",
		category = "special",
	}

	self.specializations[23] = wildcard_perkdeck

	-- wild cards
	for _, perkdeck in pairs(self.specializations) do
		perkdeck[2].upgrades = { "player_regain_throwable_from_ammo_1" }
		perkdeck[2].icon_xy = { 0, 8 }
		perkdeck[4].upgrades = { "player_passive_suspicion_bonus", "player_buy_bodybags_asset", "player_additional_assets", "player_buy_spotter_asset" }
		perkdeck[6].upgrades = { "armor_kit" }
		perkdeck[8].upgrades = { "passive_doctor_bag_interaction_speed_multiplier" } -- get rid of the 5% damage buff it's stupid anyways
	end

	-- Buncha default upgrade fuckery
	table.insert(self.default_upgrades, "temporary_double_drop_damage_multiplier")
	table.insert(self.default_upgrades, "sentry_gun_rot_speed_multiplier")
	table.insert(self.default_upgrades, "passive_player_xp_multiplier")
	table.insert(self.default_upgrades, "player_first_aid_health_regen")
	table.insert(self.default_upgrades, "bodybags_bag_quantity")
	table.insert(self.default_upgrades, "grenade_case")
	table.insert(self.default_upgrades, "player_smoke_screen_armor_regen_mul")
	table.insert(self.default_upgrades, "player_smoke_screen_dodge_add")
	table.insert(self.default_upgrades, "player_trip_mine_deploy_time_multiplier_2")
	table.insert(self.default_upgrades, "sentry_gun_armor_multiplier") -- prev defense package
	table.insert(self.default_upgrades, "sentry_gun_shield") -- prev defense package
	table.insert(self.default_upgrades, "saw_enemy_slicer") -- prev saw massacre
	table.insert(self.default_upgrades, "saw_ignore_shields_1") -- prev saw massacre
	table.insert(self.default_upgrades, "saw_panic_when_kill_1") -- prev saw massacre
	table.delete(self.default_upgrades, "player_fall_damage_multiplier")
	table.delete(self.default_upgrades, "player_fall_health_damage_multiplier")
	table.delete(self.default_upgrades, "player_steelsight_when_downed")
	table.delete(self.default_upgrades, "carry_interact_speed_multiplier_2")
	table.delete(self.default_upgrades, "ecm_jammer_can_activate_feedback")
	table.delete(self.default_upgrades, "ecm_jammer_can_retrigger")
	table.delete(self.default_upgrades, "carry_movement_speed_multiplier")
	table.delete(self.default_upgrades, "player_walk_speed_multiplier")
	table.delete(self.default_upgrades, "striker_reload_speed_default") -- why did they do it like this?
end
