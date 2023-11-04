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
		digest(3),
		digest(16),
	}

	-- MASTERMIND --

	-- Bandage
	self.skills.combat_medic[1].upgrades = { "player_revive_damage_reduction_level_1" }
	self.skills.combat_medic.name_id = "menu_bandage"
	self.skills.combat_medic.desc_id = "menu_bandage_desc"

	-- Painkillers
	self.skills.tea_time[1].upgrades = { "player_revive_damage_reduction_level_2" }
	self.skills.tea_time[2].upgrades = { "player_revived_damage_resist_1" }
	self.skills.tea_time.name_id = "menu_fast_learner_beta"
	self.skills.tea_time.desc_id = "menu_field_surgery_desc"
	self.skills.tea_time.icon_xy = { 0, 10 }

	-- Company Soul
	self.skills.fast_learner[1].upgrades = { "team_weapon_recoil_index_addend", "team_weapon_suppression_recoil_index_addend" }
	self.skills.fast_learner[2].upgrades = { "team_stamina_multiplier" }
	self.skills.fast_learner.name_id = "menu_company_soul"
	self.skills.fast_learner.desc_id = "menu_company_soul_desc"
	self.skills.fast_learner.icon_xy = { 5, 2 }

	-- Combat Doctor
	self.skills.tea_cookies[1].upgrades = { "temporary_revive_damage_reduction_1", "player_revive_damage_reduction_1" }
	self.skills.tea_cookies[2].upgrades = { "player_revive_interaction_speed_multiplier", "temporary_combat_medic_damage_multiplier1" }
	self.skills.tea_cookies.name_id = "menu_medic_2x_beta"
	self.skills.tea_cookies.desc_id = "menu_combat_doctor_desc"
	self.skills.tea_cookies.icon_xy = { 4, 9 }

	-- Keepers
	self.skills.medic_2x.name_id = "menu_keepers"

	-- Inspire
	self.skills.inspire[1].upgrades = { "player_morale_boost" }
	self.skills.inspire[2].upgrades = { "cooldown_long_dis_revive" }
	self.skills.inspire.icon_xy = { 11, 5 }

	-- Forced Friendship
	self.skills.triathlete[1].upgrades = { "cable_tie_quantity" }
	self.skills.triathlete[2].upgrades = { "cable_tie_interact_speed_multiplier", "player_extra_hostages" }

	-- Stockholm Syndrome
	self.skills.cable_guy[1].upgrades = { "player_intimidate_range_mul", "player_intimidate_aura", "player_intimidation_multiplier" }
	self.skills.cable_guy[2].upgrades = { "player_civ_intimidation_mul", "player_civ_calming_alerts", "player_civilian_reviver" }
	self.skills.cable_guy.icon_xy = { 3, 8 }

	-- Hostage Situation
	self.skills.stockholm_syndrome[1].upgrades = { "team_damage_hostage_absorption" }
	self.skills.stockholm_syndrome[2].upgrades = { "team_hostage_situation" }
	self.skills.stockholm_syndrome.icon_xy = { 6, 7 }

	-- Partners in Crime
	self.skills.control_freak[1].upgrades = { "player_passive_convert_enemies_health_multiplier_1" }
	self.skills.control_freak[2].upgrades = { "player_passive_convert_enemies_health_multiplier_2" }

	-- Hostage Taker
	self.skills.black_marketeer[1].upgrades = { "player_hostage_health_regen_addend_1", "player_hostage_min_sum_taker_1" }
	self.skills.black_marketeer[2].upgrades = { "player_hostage_health_regen_addend_2", "player_hostage_min_sum_taker_2", "player_joker_counts_for_hostage_boost" }

	-- Marksman
	self.skills.sharpshooter[1].upgrades = { "weapon_single_spread_index_addend" }
	self.skills.sharpshooter[2].upgrades = { "single_shot_accuracy_inc_1" }

	-- Lock N' Load
	self.skills.rifleman[1].upgrades = { "weapon_swap_speed_multiplier", "weapon_enter_steelsight_speed_multiplier" }
	self.skills.rifleman[2].upgrades = { "player_run_and_shoot_1" }
	self.skills.rifleman.icon_xy = { 7, 10 }
	self.skills.rifleman.name_id = "menu_rifleman"
	self.skills.rifleman.desc_id = "menu_rifleman_desc"

	-- Kilmer
	table.delete(self.skills.speedy_reload[1].upgrades, "smg_reload_speed_multiplier")
	self.skills.speedy_reload.name_id = "menu_kilmer"
	self.skills.speedy_reload.icon_xy = { 1, 9 }

	-- ENFORCER --

	-- Hard Boiled
	self.skills.underdog[1].upgrades = { "shotgun_damage_multiplier_1" }
	self.skills.underdog[2].upgrades = { "shotgun_swap_speed_multiplier" }
	self.skills.underdog.name_id = "menu_from_the_hip"
	self.skills.underdog.desc_id = "menu_from_the_hip_desc"
	self.skills.underdog.icon_xy = { 5, 0 }

	-- Fast Hands
	self.skills.shotgun_cqb[1].upgrades = { "shotgun_pump_reload_speed_1" }
	self.skills.shotgun_cqb[2].upgrades = { "shotgun_pump_reload_speed_2", "enter_steelsight_speed_multiplier" }
	self.skills.shotgun_cqb.icon_xy = { 5, 1 }

	-- Point Blank
	self.skills.shotgun_impact[1].upgrades = { "shotgun_extra_pellets" }
	self.skills.shotgun_impact[2].upgrades = { "shotgun_hip_fire_spread_multiplier" }

	-- Shotgun CQB
	self.skills.far_away[1].upgrades = { "shotgun_hip_rate_of_fire_1" }
	self.skills.far_away[2].upgrades = { "shotgun_speed_stack_on_kill" }
	self.skills.far_away.icon_xy = { 8, 6 }

	-- Mag-Fed Specialist
	self.skills.close_by[1].upgrades = { "shotgun_mag_reload_speed" }
	self.skills.close_by[2].upgrades = { "shotgun_magazine_capacity_inc_1" }
	self.skills.close_by.icon_xy = { 8, 7 }

	-- Shotgun Hell
	self.skills.overkill[1].upgrades = { "shotgun_consume_no_ammo_chance_1" }
	self.skills.overkill[2].upgrades = { "cooldown_shotgun_panic_on_kill" }

	-- Resilience
	self.skills.oppressor.icon_xy = { 6, 1 }

	-- Thick skin
	self.skills.show_of_force[1].upgrades = { "player_damage_shake_addend" }
	self.skills.show_of_force.icon_xy = { 2, 12 }

	-- Underdog
	self.skills.pack_mule[1].upgrades = { "player_damage_multiplier_outnumbered" }
	self.skills.pack_mule[2].upgrades = { "player_damage_dampener_outnumbered" }
	self.skills.pack_mule.icon_xy = { 2, 1 }
	self.skills.pack_mule.name_id = "menu_underdog_beta"
	self.skills.pack_mule.desc_id = "menu_underdog_beta_desc"

	-- Iron Man
	self.skills.juggernaut[1].upgrades = { "body_armor6" }
	self.skills.juggernaut[2].upgrades = { "player_armor_multiplier" }

	-- Fully Loaded
	self.skills.ammo_reservoir[1].upgrades = { "player_add_armor_stat_skill_ammo_mul" }
	self.skills.ammo_reservoir[2].upgrades = { "extra_ammo_multiplier1" }
	self.skills.ammo_reservoir.name_id = "menu_bandoliers_beta"
	self.skills.ammo_reservoir.desc_id = "menu_bandoliers_beta_desc"
	self.skills.ammo_reservoir.icon_xy = { 3, 0 }

	-- Bulletstorm
	self.skills.bandoliers[1].upgrades = { "temporary_no_ammo_cost_1" }
	self.skills.bandoliers[2].upgrades = { "temporary_no_ammo_cost_2" }
	self.skills.bandoliers.name_id = "menu_ammo_reservoir_beta"
	self.skills.bandoliers.desc_id = "menu_ammo_reservoir_beta_desc"
	self.skills.bandoliers.icon_xy = { 4, 5 }

	-- TECHNICIAN --

	-- Transporter
	self.skills.defense_up[1].upgrades = { "carry_movement_speed_multiplier" }
	self.skills.defense_up[2].upgrades = { "carry_throw_distance_multiplier" }
	self.skills.defense_up.icon_xy = { 6, 0 }

	-- Daredevil
	self.skills.sentry_targeting_package[1].upgrades = { "player_interacting_damage_multiplier" }
	self.skills.sentry_targeting_package[2].upgrades = { "player_run_and_reload" }
	self.skills.sentry_targeting_package.icon_xy = { 10, 6 }

	-- Defense Package
	self.skills.engineering[1].upgrades = { "sentry_gun_armor_multiplier" }
	self.skills.engineering[2].upgrades = { "sentry_gun_shield" }
	self.skills.engineering.icon_xy = { 7, 5 }

	-- Sentry Nest
	self.skills.tower_defense[2].upgrades = { "sentry_gun_cost_reduction_1", "sentry_gun_cost_reduction_2", "sentry_gun_extra_ammo_multiplier_1" }
	self.skills.tower_defense.icon_xy = { 7, 6 }

	-- PhD in Engineering
	self.skills.eco_sentry[1].upgrades = { "sentry_gun_standstill_omniscience", "sentry_gun_spread_multiplier" }
	self.skills.eco_sentry[2].upgrades = { "sentry_gun_ap_bullets", "sentry_gun_fire_rate_reduction_1" }
	self.skills.eco_sentry.icon_xy = { 7, 8 }

	-- Oppressor
	self.skills.heavy_impact[1].upgrades = { "player_suppression_bonus" }
	self.skills.heavy_impact[2].upgrades = { "player_suppression_bonus_2" }
	self.skills.heavy_impact.name_id = "menu_oppressor"
	self.skills.heavy_impact.desc_id = "menu_oppressor_desc"
	self.skills.heavy_impact.icon_xy = { 7, 0 }

	-- Fire Control
	self.skills.fire_control[2].upgrades = { "player_ap_bullets_1" }

	-- Sleight of Hand
	self.skills.shock_and_awe[1].upgrades = { "smg_reload_speed_multiplier", "lmg_reload_speed_multiplier" }
	self.skills.shock_and_awe.icon_xy = { 3, 3 }
	self.skills.shock_and_awe.name_id = "menu_fast_hands"
	self.skills.shock_and_awe.desc_id = "menu_fast_hands_desc"

	-- Mag Plus
	self.skills.fast_fire[1].upgrades = { "player_automatic_mag_increase_1" }
	self.skills.fast_fire[2].upgrades = { "player_automatic_mag_increase_2" }
	self.skills.fast_fire.icon_xy = { 2, 0 }

	-- Body Expertise
	self.skills.body_expertise[1].upgrades = { "player_no_movement_penalty" }
	self.skills.body_expertise[2].upgrades = { "weapon_automatic_head_shot_add_1" }

	-- GHOST --

	-- Inner Pockets
	self.skills.cleaner[1].upgrades = { "player_melee_concealment_modifier" }
	self.skills.cleaner[2].upgrades = { "player_ballistic_vest_concealment_1" }
	self.skills.cleaner.icon_xy = { 10, 7 }
	self.skills.cleaner.name_id = "menu_thick_skin_beta"
	self.skills.cleaner.desc_id = "menu_thick_skin_beta_desc"

	-- Logistician
	self.skills.second_chances[1].upgrades = { "carry_interact_speed_multiplier_2" }
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
	self.skills.sprinter[1].upgrades = { "player_walk_speed_multiplier", "player_movement_speed_multiplier" }
	self.skills.sprinter[2].upgrades = { "player_stamina_regen_timer_multiplier", "player_stamina_regen_multiplier" }
	self.skills.sprinter.icon_xy = { 1, 8 }
	self.skills.sprinter.name_id = "menu_sprinter"
	self.skills.sprinter.desc_id = "menu_sprinter_desc"

	-- Duck and Cover
	self.skills.awareness[1].upgrades = { "player_crouch_speed_multiplier" }
	self.skills.awareness[2].upgrades = { "player_crouch_dodge_chance_1" }
	self.skills.awareness.icon_xy = { 0, 11 }
	self.skills.awareness.name_id = "menu_awareness"
	self.skills.awareness.desc_id = "menu_awareness_desc"

	-- Sprinter
	self.skills.optic_illusions[1].upgrades = { "player_can_strafe_run", "player_run_speed_multiplier" }
	self.skills.optic_illusions[2].upgrades = { "player_run_dodge_chance", "player_on_zipline_dodge_chance" }
	self.skills.optic_illusions.icon_xy = { 7, 3 }

	-- Second Wind
	self.skills.dire_need[1].upgrades = { "temporary_damage_speed_multiplier" }
	self.skills.dire_need[2].upgrades = { "cooldown_panic_on_armor_break" }
	self.skills.dire_need.icon_xy = { 10, 9 }

	-- Shockproof
	self.skills.insulation[1].upgrades = { "player_resist_firing_tased", "player_weaker_tase_effect" }

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
	self.skills.silence_expert[1].upgrades = { "weapon_silencer_recoil_index_addend" }
	self.skills.silence_expert[2].upgrades = { "weapon_silencer_enter_steelsight_speed_multiplier", "weapon_silencer_spread_index_addend" }

	-- HVT
	self.skills.hitman[1].upgrades = { "player_marked_inc_dmg_distance_1" }
	self.skills.hitman[2].upgrades = { "player_marked_enemy_extra_damage", "player_mark_enemy_time_multiplier" }

	-- Silencer Expert
	self.skills.backstab[1].upgrades = { "player_silencer_concealment_penalty_decrease_1", "player_silencer_concealment_increase_1" }
	self.skills.backstab[2].upgrades = { "weapon_silencer_damage_multiplier", "weapon_armor_piercing_chance_silencer" }
	self.skills.backstab.icon_xy = { 5, 9 }
	self.skills.backstab.name_id = "menu_silenced_damage"
	self.skills.backstab.desc_id = "menu_silenced_damage_desc"

	-- Low Blow
	self.skills.unseen_strike[1].upgrades = { "player_detection_risk_add_crit_chance_1" }
	self.skills.unseen_strike[2].upgrades = { "player_detection_risk_add_crit_chance_2", "weapon_extra_crit_damage_mul" }
	self.skills.unseen_strike.icon_xy = { 0, 12 }
	self.skills.unseen_strike.name_id = "menu_backstab_beta"
	self.skills.unseen_strike.desc_id = "menu_backstab_beta_desc"

	-- FUGITIVE --

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

	-- Running from Death
	self.skills.up_you_go[1].upgrades = { "player_temp_swap_weapon_faster_1", "player_temp_reload_weapon_faster_1" }
	self.skills.up_you_go[2].upgrades = { "player_temp_increased_movement_speed_1" }
	self.skills.up_you_go.name_id = "menu_running_from_death_beta"
	self.skills.up_you_go.desc_id = "menu_running_from_death_beta_desc"
	self.skills.up_you_go.icon_xy = { 11, 3 }

	-- Uppers
	self.skills.feign_death[1].upgrades = { "first_aid_kit_quantity_increase_1" }
	self.skills.feign_death[2].upgrades = { "first_aid_kit_quantity_increase_2", "first_aid_kit_auto_recovery_1" }
	self.skills.feign_death.icon_xy = { 2, 11 }
	self.skills.feign_death.name_id = "menu_tea_cookies_beta"
	self.skills.feign_death.desc_id = "menu_tea_cookies_beta_desc"

	-- Swan Song
	table.delete(self.skills.perseverance[2].upgrades, "player_berserker_no_ammo_cost")

	-- Messiah
	self.skills.messiah[1].upgrades = { "player_messiah_revive_from_bleed_out_1", "player_increased_bleedout_timer" }
	self.skills.messiah[2].upgrades = { "player_messiah_revive_from_bleed_out_2", "player_super_syndrome_1" }

	-- Berserker
	self.skills.wolverine[1].upgrades = { "player_movement_speed_damage_health_ratio_multiplier", "player_movement_speed_damage_health_ratio_threshold_multiplier" }
	self.skills.wolverine[2].upgrades = { "player_melee_damage_health_ratio_multiplier" }

	-- Counter Strike
	self.skills.drop_soap[1].upgrades = { "player_run_and_melee_eclipse" }
	self.skills.drop_soap[2].upgrades = { "cooldown_counter_strike_eclipse" }

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
			name_id = "menu_st_category_favorites",
			category = "favorites",
		},
	}

	-- ccf
	self.specializations[1].category = { "health", "support" }
	-- mus
	self.specializations[2].category = { "health", "healing" }
	-- arm
	self.specializations[3].category = "armor"
	-- rog
	self.specializations[4].category = "dodge"
	-- hit
	self.specializations[5].category = "armor_gating"
	-- crk
	self.specializations[6].category = { "armor", "dodge" }
	-- brg
	self.specializations[7].category = "dodge"
	-- inf
	self.specializations[8].category = "resistance"
	-- soc
	self.specializations[9].category = { "healing", "armor_gating" }
	-- gmb
	self.specializations[10].category = { "healing", "support" }
	-- grd
	self.specializations[11].category = "healing"
	-- yak
	self.specializations[12].category = "dodge"
	-- exp
	self.specializations[13].category = "healing"
	-- man
	self.specializations[14].category = { "support", "resistance" }
	-- anr
	self.specializations[15].category = { "armor", "armor_gating" }
	-- bik
	self.specializations[16].category = { "healing", "armor_gating" }
	-- kpn
	self.specializations[17].category = { "health", "resistance" }
	-- sic
	self.specializations[18].category = { "dodge", "armor_gating" }
	-- stc
	self.specializations[19].category = { "health", "resistance" }
	-- tgt
	self.specializations[20].category = { "healing", "support" }
	-- hck
	self.specializations[21].category = { "support", "healing" }
	-- lch
	self.specializations[22].category = { "health", "resistance" }

	-- crew chief
	table.delete(self.specializations[1][3].upgrades, "player_damage_dampener_close_contact_1")
	table.delete(self.specializations[1][9].upgrades, "team_hostage_damage_dampener_multiplier")

	-- muscle
	table.delete(self.specializations[2][9].upgrades, "player_passive_health_multiplier_5")
	self.specializations[2][7].upgrades = { "temporary_mrwi_health_invulnerable_1" }
	self.specializations[2][7].texture_bundle_folder = "mrwi"
	self.specializations[2][7].icon_xy = { 3, 0 }

	-- armorer
	table.delete(self.specializations[3][1].upgrades, "player_tier_armor_multiplier_2")
	table.delete(self.specializations[3][9].upgrades, "player_tier_armor_multiplier_6")
	self.specializations[3][3].upgrades = { "player_tier_armor_multiplier_2" }
	self.specializations[3][5].upgrades = { "player_tier_armor_multiplier_3", "player_tier_armor_multiplier_4", "player_tier_armor_multiplier_5" }

	-- hitman
	self.specializations[5][1].upgrades = { "player_primary_reload_secondary_1", "player_secondary_reload_primary_1" }
	self.specializations[5][1].texture_bundle_folder = "mrwi"
	self.specializations[5][1].icon_xy = { 0, 0 }
	self.specializations[5][3].upgrades = { "weapon_passive_swap_speed_multiplier_1" }
	self.specializations[5][5].upgrades = { "player_unseen_temp_increased_crit_chance_1", "player_unseen_increased_crit_chance_1" }
	self.specializations[5][5].icon_xy = { 2, 8 }
	self.specializations[5][7].upgrades = { "cooldown_hitman_ammo_refund" }
	self.specializations[5][7].icon_xy = { 3, 3 }
	self.specializations[5][9].upgrades = { "player_killshot_regen_armor_bonus", "player_passive_loot_drop_multiplier" }
	self.specializations[5][9].icon_xy = { 0, 5 }

	-- burglar
	table.delete(self.specializations[7][7].upgrades, "player_tier_dodge_chance_3")
	self.specializations[7][9].upgrades = { "player_dodge_ricochet_bullets", "player_passive_loot_drop_multiplier" }
	self.specializations[7][9].texture_bundle_folder = "mrwi"
	self.specializations[7][9].icon_xy = { 2, 0 }

	-- socio
	table.delete(self.specializations[9][7].upgrades, "player_tier_armor_multiplier_3")

	-- Gambler
	table.insert(self.specializations[10][9].upgrades, "player_increased_pickup_area_1")
	table.insert(self.specializations[10][9].upgrades, "player_increased_pickup_area_2")
	table.insert(self.specializations[10][3].upgrades, "player_pick_up_ammo_multiplier")
	table.delete(self.specializations[10][3].upgrades, "temporary_loose_ammo_give_team")

	-- yakuza
	self.specializations[12][1].upgrades = { "player_armor_regen_damage_health_ratio_multiplier_1", "player_armor_regen_damage_health_ratio_threshold_multiplier" }
	self.specializations[12][3].upgrades = { "weapon_passive_swap_speed_multiplier_1" }
	self.specializations[12][3].icon_xy = { 7, 2 }
	self.specializations[12][5].upgrades = { "player_camouflage_multiplier" }
	self.specializations[12][5].name_id = "menu_deck4_3"
	self.specializations[12][5].icon_xy = { 4, 2 }
	self.specializations[12][7].upgrades = { "player_dodge_health_ratio_multiplier" }
	self.specializations[12][7].icon_xy = { 1, 8 }
	self.specializations[12][9].upgrades = { "player_damage_health_ratio_multiplier", "player_damage_damage_health_ratio_threshold_multiplier" }

	-- Grinder and Ex-President
	table.delete(self.specializations[11][3].upgrades, "player_passive_health_multiplier_1")
	table.delete(self.specializations[11][3].upgrades, "player_passive_health_multiplier_2")
	table.delete(self.specializations[11][7].upgrades, "player_passive_health_multiplier_3")
	table.delete(self.specializations[13][3].upgrades, "player_passive_health_multiplier_1")
	table.delete(self.specializations[13][5].upgrades, "player_passive_health_multiplier_2")
	table.delete(self.specializations[13][7].upgrades, "player_passive_health_multiplier_3")

	-- Maniac
	table.insert(self.specializations[14][3].upgrades, "player_panic_suppression")

	-- anarchist
	self.specializations[15][5].upgrades = { "player_chico_armor_multiplier_1", "player_armor_increase_2" }
	self.specializations[15][7].upgrades = { "player_passive_dodge_chance_1", "player_armor_increase_3" }
	table.delete(self.specializations[15][1].upgrades, "temporary_armor_break_invulnerable_1")

	-- kingpin
	table.delete(self.specializations[17][9].upgrades, "player_passive_health_multiplier_4")

	-- hacker
	table.delete(self.specializations[21][3].upgrades, "player_passive_health_multiplier_2")
	table.insert(self.specializations[21][7].upgrades, "player_passive_health_multiplier_2")
	table.delete(self.specializations[21][7].upgrades, "player_pocket_ecm_kill_dodge_1")
	table.delete(self.specializations[21][9].upgrades, "player_passive_dodge_chance_2")

	-- leech
	table.delete(self.specializations[22][9].upgrades, "player_activate_ability_downed")
	table.delete(self.specializations[22][9].upgrades, "player_passive_health_multiplier_4")

	-- wild cards
	for _, perkdeck in pairs(self.specializations) do
		perkdeck[2].upgrades = { "player_regain_throwable_from_ammo_1" }
		perkdeck[2].icon_xy = { 0, 8 }
		perkdeck[4].upgrades = { "player_passive_suspicion_bonus", "player_buy_bodybags_asset", "player_additional_assets", "player_buy_spotter_asset" }
		perkdeck[6].upgrades = { "armor_kit", "player_passive_armor_movement_penalty_multiplier" }
	end

	-- Buncha default upgrade fuckery
	table.insert(self.default_upgrades, "player_bleed_out_health_multiplier")
	table.insert(self.default_upgrades, "sentry_gun_rot_speed_multiplier")
	table.insert(self.default_upgrades, "passive_player_xp_multiplier")
	table.delete(self.default_upgrades, "player_steelsight_when_downed")
	table.delete(self.default_upgrades, "carry_movement_speed_multiplier")
	table.delete(self.default_upgrades, "carry_interact_speed_multiplier_2")
	table.delete(self.default_upgrades, "ecm_jammer_can_activate_feedback")
	table.delete(self.default_upgrades, "ecm_jammer_can_retrigger")
	table.delete(self.default_upgrades, "player_walk_speed_multiplier")
	table.delete(self.default_upgrades, "player_crouch_speed_multiplier")
end
