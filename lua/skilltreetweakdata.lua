local data = SkillTreeTweakData.init
function SkillTreeTweakData:init(tweak_data)
    data(self, tweak_data)

	-- Overkill
	self.skills.overkill = {
		{
			upgrades = {"player_overkill_damage_multiplier"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"player_overkill_damage_multiplier_2", "player_overkill_all_weapons", "weapon_swap_speed_multiplier"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_overkill_beta",
		desc_id = "menu_overkill_beta_desc",
		icon_xy = {
			3,
			2
		}
	}

	-- Mag Plus
	self.skills.fast_fire = {
		{
			upgrades = {"player_automatic_mag_increase_1"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"player_automatic_mag_increase_2"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_fast_fire_beta",
		desc_id = "menu_fast_fire_beta_desc",
		icon_xy = {
			2,
			0
		}
	}

	-- Body Expertise
	self.skills.body_expertise = {
		{
			upgrades = {"player_ap_bullets_1"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"weapon_automatic_head_shot_add_1"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_body_expertise_beta",
		desc_id = "menu_body_expertise_beta_desc",
		icon_xy = {
			10,
			3
		}
	}

	-- Bulletstorm
	self.skills.bandoliers = {
		{
			upgrades = {"temporary_no_ammo_cost_1"},
			cost = self.costs.default
		},
		{
			upgrades = {"temporary_no_ammo_cost_2"},
			cost = self.costs.pro
		},
		name_id = "menu_ammo_reservoir_beta",
		desc_id = "menu_ammo_reservoir_beta_desc",
		icon_xy = {
			4,
			5
		}
	}

	-- Fully Loaded
	self.skills.carbon_blade = {
		{
			upgrades = {"player_regain_throwable_from_ammo_1"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"extra_ammo_multiplier1", "player_pick_up_ammo_multiplier", "player_pick_up_ammo_multiplier_2"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_bandoliers_beta",
		desc_id = "menu_bandoliers_beta_desc",
		icon_xy = {
			3,
			0
		}
	}

	-- Saw Massacre
	self.skills.ammo_reservoir = {
		{
			upgrades = {"saw_enemy_slicer"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"saw_ignore_shields_1", "saw_panic_when_kill_1"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_carbon_blade_beta",
		desc_id = "menu_carbon_blade_beta_desc",
		icon_xy = {
			0,
			2
		}
	}

	-- Marksman
	self.skills.sharpshooter = {
		{
			upgrades = {"weapon_enter_steelsight_speed_multiplier", "weapon_single_spread_index_addend"},
			cost = self.costs.default
		},
		{
			upgrades = {"single_shot_accuracy_inc_1"},
			cost = self.costs.pro
		},
		name_id = "menu_sharpshooter_beta",
		desc_id = "menu_sharpshooter_beta_desc",
		icon_xy = {
			8,
			1
		}
	}

	-- Confident
	self.skills.cable_guy = {
		{
			upgrades = {"player_intimidate_range_mul", "player_intimidate_aura", "player_civ_intimidation_mul"},
			cost = self.costs.default
		},
		{
			upgrades = {"team_damage_hostage_absorption"},
			cost = self.costs.pro
		},
		name_id = "menu_cable_guy_beta",
		desc_id = "menu_cable_guy_beta_desc",
		icon_xy = {
			2,
			8
		}
	}

	-- Forced Friendship
	self.skills.triathlete = {
		{
			upgrades = {"cable_tie_interact_speed_multiplier"},
			cost = self.costs.default
		},
		{
			upgrades = {"cable_tie_quantity"},
			cost = self.costs.pro
		},
		name_id = "menu_triathlete_beta",
		desc_id = "menu_triathlete_beta_desc",
		icon_xy = {
			4,
			7
		}
	}

	-- Berserker
	self.skills.wolverine = {
		{
			upgrades = {"player_melee_damage_health_ratio_multiplier"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"player_movement_speed_damage_health_ratio_multiplier", "player_movement_speed_damage_health_ratio_threshold_multiplier"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_wolverine_beta",
		desc_id = "menu_wolverine_beta_desc",
		icon_xy = {
			2,
			2
		}
	}

	-- Nine Lives (Tough Guy)
	self.skills.nine_lives = {
		{
			upgrades = {"player_bleed_out_health_multiplier"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"player_primary_weapon_when_downed"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_nine_lives_beta",
		desc_id = "menu_nine_lives_beta_desc",
		icon_xy = {
			1,
			2
		}
	}

	-- Combat Doctor
	self.skills.medic_2x = {
		{
			upgrades = {"doctor_bag_amount_increase1"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"doctor_bag_quantity"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_medic_2x_beta",
		desc_id = "menu_medic_2x_beta_desc",
		icon_xy = {
			5,
			8
		}
	}

	-- Iron Man
	self.skills.juggernaut = {
		{
			upgrades = {"body_armor6"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"player_armor_multiplier"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_juggernaut_beta",
		desc_id = "menu_juggernaut_beta_desc",
		icon_xy = {
			3,
			1
		}
	}

	-- Inspire (istg i will get to cleaning this to not look awful later)
	self.skills.inspire = {
		{
			upgrades = {"player_morale_boost"},
			cost = self.costs.hightier
		},
		{
			upgrades = {"player_revive_interaction_speed_multiplier"},
			cost = self.costs.hightierpro
		},
		name_id = "menu_inspire_beta",
		desc_id = "menu_inspire_beta_desc",
		icon_xy = {
			4,
			9
		}
	}

	-- Lock N' Load
	self.skills.rifleman[1].upgrades = {"weapon_swap_speed_multiplier_2", "weapon_enter_steelsight_speed_multiplier"}
	self.skills.rifleman[2].upgrades = {"player_run_and_shoot_1"}
	self.skills.rifleman.icon_xy = {7, 10}
	self.skills.rifleman.name_id = "menu_rifleman"
	self.skills.rifleman.desc_id = "menu_rifleman_desc"

	-- Kilmer
	table.delete(self.skills.speedy_reload[1].upgrades, "smg_reload_speed_multiplier")
	self.skills.speedy_reload.icon_xy = {1, 9}
	self.skills.speedy_reload.name_id = "menu_kilmer"

	-- Resilience
	self.skills.oppressor.icon_xy = {6, 1}

	-- Die Hard
	self.skills.show_of_force[1].upgrades = {"player_damage_shake_addend"}
	self.skills.show_of_force.icon_xy = {2, 12}
	
	-- Fast Hands
	self.skills.shock_and_awe[1].upgrades = {"player_run_and_reload", "smg_reload_speed_multiplier", "lmg_reload_speed_multiplier"}
	self.skills.shock_and_awe.icon_xy = {10, 6}
	self.skills.shock_and_awe.name_id = "menu_fast_hands"
	self.skills.shock_and_awe.desc_id = "menu_fast_hands_desc"

	-- Athlete
	self.skills.sprinter[1].upgrades = {"player_walk_speed_multiplier", "player_movement_speed_multiplier"}
	self.skills.sprinter[2].upgrades = {"player_stamina_regen_timer_multiplier", "player_stamina_regen_multiplier"}
	self.skills.sprinter.icon_xy = {1, 8}
	self.skills.sprinter.name_id = "menu_sprinter"
	self.skills.sprinter.desc_id = "menu_sprinter_desc"

	-- Duck and Cover
	self.skills.awareness[1].upgrades = {"player_crouch_speed_multiplier"}
	self.skills.awareness[2].upgrades = {"player_crouch_dodge_chance_1"}
	self.skills.awareness.icon_xy = {0, 11}
	self.skills.awareness.name_id = "menu_awareness"
	self.skills.awareness.desc_id = "menu_awareness_desc"

	-- Sprinter
	self.skills.optic_illusions[1].upgrades = {"player_can_strafe_run", "player_run_speed_multiplier"}
	self.skills.optic_illusions[2].upgrades = {"player_run_dodge_chance", "player_on_zipline_dodge_chance"}
	self.skills.optic_illusions.icon_xy = {7, 3}

	-- Low Blow
	self.skills.unseen_strike[1].upgrades = {"player_detection_risk_add_crit_chance_1"}
	self.skills.unseen_strike[2].upgrades = {"player_detection_risk_add_crit_chance_2"}
	self.skills.unseen_strike.icon_xy = {0, 12}
	self.skills.unseen_strike.name_id = "menu_backstab_beta"
	self.skills.unseen_strike.desc_id = "menu_backstab_beta_desc"

	-- Silencer Expert
	self.skills.backstab[1].upgrades = {"player_silencer_concealment_penalty_decrease_1", "player_silencer_concealment_increase_1"}
	self.skills.backstab[2].upgrades = {"weapon_silencer_damage_multiplier", "weapon_armor_piercing_chance_silencer"}
	self.skills.backstab.icon_xy = {5, 9}
	self.skills.backstab.name_id = "menu_silenced_damage"
	self.skills.backstab.desc_id = "menu_silenced_damage_desc"

	-- Swap Silencer Expert and HVT
	self.trees[12].tiers[3][2] = "backstab"
	self.trees[12].tiers[3][1] = "hitman"
	-- Swap Inner Pockets and Deft Hands
	self.trees[11].tiers[2][2] = "optic_illusions"
	self.trees[12].tiers[2][1] = "thick_skin"

	-- Old Swan Song
	table.delete(self.skills.perseverance[2].upgrades, "player_berserker_no_ammo_cost")

	-- Remove 15% dodge boost from Hackers botnet card
	table.delete(self.specializations[21][9].upgrades, "player_passive_dodge_chance_2")
	
	-- Remove 20% armor from Armorer
	table.delete(self.specializations[3][1].upgrades, "player_tier_armor_multiplier_2")
	table.delete(self.specializations[3][3].upgrades, "player_tier_armor_multiplier_3")
	table.delete(self.specializations[3][9].upgrades, "player_tier_armor_multiplier_6")
	table.insert(self.specializations[3][3].upgrades, "player_tier_armor_multiplier_2")
	table.insert(self.specializations[3][5].upgrades, "player_tier_armor_multiplier_3")
	table.insert(self.specializations[3][5].upgrades, "player_tier_armor_multiplier_5")

	-- Remove armor boost from overdose card on socio
	table.delete(self.specializations[9][7].upgrades, "player_tier_armor_multiplier_3")
	
	-- Give faster swap speed and zerker to Yakuza and get rid of speed boost
	table.delete(self.specializations[12][3].upgrades, "player_movement_speed_damage_health_ratio_multiplier")
	table.insert(self.specializations[12][3].upgrades, "weapon_passive_swap_speed_multiplier_1")
	table.insert(self.specializations[12][9].upgrades, "player_damage_health_ratio_multiplier")
	table.delete(self.specializations[12][9].upgrades, "player_movement_speed_damage_health_ratio_threshold_multiplier")
	
	-- Remove self revive and self-healing on leech
	table.delete(self.specializations[22][1].upgrades, "player_copr_kill_life_leech_1")
	table.delete(self.specializations[22][9].upgrades, "player_activate_ability_downed")

	-- No 2s godmode for anar
	table.delete(self.specializations[15][1].upgrades, "temporary_armor_break_invulnerable_1")

	-- Lower the kingpin health
	table.delete(self.specializations[17][9].upgrades, "player_passive_health_multiplier_4")

	-- Crew Chief nerfs
	table.delete(self.specializations[1][3].upgrades, "player_damage_dampener_close_contact_1")
	table.delete(self.specializations[1][9].upgrades, "team_hostage_damage_dampener_multiplier")

	-- Get rid of burglars crouch move speed boost to avoid bugging upgrades out (no one plays the deck anyway so who cares)
	table.delete(self.specializations[7][9].upgrades, "player_crouch_speed_multiplier_2")

	-- Remove some default upgrades
	table.delete(self.default_upgrades, "player_primary_weapon_when_downed")
	table.delete(self.default_upgrades, "player_walk_speed_multiplier")
	table.delete(self.default_upgrades, "player_crouch_speed_multiplier")
end