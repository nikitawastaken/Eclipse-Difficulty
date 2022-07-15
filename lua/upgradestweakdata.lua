local old_pd2_values_init = UpgradesTweakData._init_pd2_values
function UpgradesTweakData:_init_pd2_values(tweak_data)
	old_pd2_values_init(self, tweak_data)
	
	-- 100 skill points
	self.values.rep_upgrades.values = {0}

	-- Movement speed nerfs
	self.values.player.body_armor.movement = {
		0.925,
		0.9,
		0.85,
		0.8,
		0.775,
		0.625,
		0.525
	}
	
	self.values.player.body_armor.armor[7] = 13
end

local old_init = UpgradesTweakData.init
function UpgradesTweakData:init(tweak_data)
	old_init(self, tweak_data)

	-- Weapons
	-------------
	
	-- LMG / Minigun movement penalties revert
	self.weapon_movement_penalty.lmg = 0.8
	self.weapon_movement_penalty.minigun = 0.8


	-- Skills
	-------------

	-- Mastermind --

	-- Uppers 60s description
	self.skill_descs.tea_cookies.multipro4 = "60"

	-- 60s inspire cooldown
	self.morale_boost_speed_bonus = 1.3
	self.morale_boost_reload_speed_bonus = 1.3
	self.morale_boost_time = 6
	self.values.player.revive_interaction_speed_multiplier = {1 / 3}
	self.skill_descs.inspire.multibasic = "30%"
	self.skill_descs.inspire.multibasic2 = "6"
	self.skill_descs.inspire.multipro = "200%"

	-- FFriendship description stuff
	self.skill_descs.triathlete.multibasic = "75%"
	self.skill_descs.triathlete.multipro = "4"

	-- Confident ace now has buffed damage absorption from FF
	self.values.team.damage = {
		hostage_absorption = {
			0.25
		},
		hostage_absorption_limit = 3
	}
	self.skill_descs.cable_guy.multipro = "2.5"
	self.skill_descs.cable_guy.multipro2 = "3"

	-- PiC nerf
	self.values.player.passive_convert_enemies_health_multiplier = {0.54, 0.02}
	self.values.player.minion_master_health_multiplier = {1.1}
	self.skill_descs.control_freak.multipro3 = "10%"
	self.skill_descs.control_freak.multipro4 = "53%"

	-- Hostage taker
	self.values.player.hostage_health_regen_addend = {0.4, 1}
	self.skill_descs.black_marketeer.multibasic = "4"
	self.skill_descs.black_marketeer.multipro = "10"

	-- Lock N' Load
	self.definitions.weapon_swap_speed_multiplier = {
		name_id = "menu_weapon_swap_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "swap_speed_multiplier",
			category = "weapon"
		}
	}
	self.values.weapon.swap_speed_multiplier = {1.25, 1.8} -- make overkill use second value
	self.skill_descs.rifleman.multibasic2 = "25%"

	-- Ammo Efficiency
	self.skill_descs.spotter_teamwork.multibasic = "2"
	self.skill_descs.spotter_teamwork.multibasic2 = "3"
	self.skill_descs.spotter_teamwork.multipro = "1"
	self.values.player.head_shot_ammo_return = {
		{
			headshots = 2,
			ammo = 1,
			time = 3
		},
		{
			headshots = 0,
			ammo = 1,
			time = 6
		}
	}

	-- Kilmer
	self.values.snp.reload_speed_multiplier = {1.25}
	self.values.assault_rifle.reload_speed_multiplier = {1.25}
	self.values.smg.reload_speed_multiplier = {1.25}
	self.values.temporary.single_shot_fast_reload[1][1] = 1.6
	self.values.temporary.single_shot_fast_reload[1][2] = 3
	self.skill_descs.speedy_reload.multibasic = "25%"
	self.skill_descs.speedy_reload.multipro = "60%"
	self.skill_descs.speedy_reload.multipro2 = "3"

	-- Mind Blown
	self.values.snp.graze_damage = {
		{
			radius = 500,
			times = 1,
			damage_factor = 0.35,
			damage_factor_kill = 0.35
		},
		{
			radius = 500,
			times = 1,
			damage_factor = 0.35,
			damage_factor_kill = 1
		}
	}
	self.skill_descs.single_shot_ammo_return.multibasic = "35%"
	self.skill_descs.single_shot_ammo_return.multibasic2 = "5m"
	self.skill_descs.single_shot_ammo_return.multipro = "100%"

	-- Enforcer --

	-- Underdog nerf as it actually hits a lot of breakpoints
	-- with new health and hs dmg mul values
	self.values.temporary.dmg_multiplier_outnumbered = {{1.1, 3}}
	self.skill_descs.underdog.multibasic2 = "10%"
	self.skill_descs.underdog.multibasic3 = "3"

	-- Overkill nerf
	self.definitions.player_overkill_damage_multiplier_2 = {
		name_id = "menu_player_overkill_damage_multiplier",
		category = "temporary",
		upgrade = {
			value = 2,
			upgrade = "overkill_damage_multiplier",
			category = "temporary"
		}
	}
	
	self.values.temporary.overkill_damage_multiplier = {
		{
			1.3,
			5
		},
		{
			1.45,
			12
		}
	}
	
	self.skill_descs.overkill.multibasic = "30%"
	self.skill_descs.overkill.multibasic2 = "5"
	self.skill_descs.overkill.multipro = "45%"
	self.skill_descs.overkill.multipro2 = "12"
	self.skill_descs.overkill.multipro3 = "80%"

	-- Close By aced nerf (15 shells down to 5 shells)
	self.values.shotgun.magazine_capacity_inc[1] = 5
	self.skill_descs.close_by.multipro2 = "5"

	-- Resilience aced nerf
	self.values.player.flashbang_multiplier = {0.75, 0.75}
	self.skill_descs.oppressor.multipro2 = "25%"

	-- Die Hard gives steadiness instead
	self.values.player.damage_shake_addend = {0.6}
	self.skill_descs.show_of_force.multibasic = "6"

	-- Correct Bulletstorm Description
	self.skill_descs.bandoliers.multibasic = "5"
	self.skill_descs.bandoliers.multipro = "20"

	-- Saw Massacre desc
	self.skill_descs.ammo_reservoir.multibasic2 = "50%"
	self.skill_descs.ammo_reservoir.multipro = "50%"
	self.skill_descs.ammo_reservoir.multipro3 = "10"

	-- Slight Fully Loaded nerf as it's a T3 skill instead
	self.values.player.regain_throwable_from_ammo[1].chance = 0
	self.values.player.regain_throwable_from_ammo[1].chance_inc = 0.003
	self.values.player.extra_ammo_multiplier[1] = 1.25
	self.values.player.pick_up_ammo_multiplier = {1.35, 1.45}
	self.skill_descs.carbon_blade.multibasic = "0%"
	self.skill_descs.carbon_blade.multibasic2 = "0.3%"
	self.skill_descs.carbon_blade.multipro2 = "25%"
	self.skill_descs.carbon_blade.multipro3 = "45%"

	-- Technician --

	-- Fast Hands
	self.values.lmg.reload_speed_multiplier = {1.2}
	self.values.smg.reload_speed_multiplier = {1.2}
	self.skill_descs.shock_and_awe.multibasic = "20%"

	-- Mag plus is divided into +5 bullets for basic and +10 bullets for aced 
	self.definitions.player_automatic_mag_increase_2 = {
		name_id = "menu_automatic_mag_increase",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "automatic_mag_increase",
			category = "player"
		}
	}
	self.values.player.automatic_mag_increase = {
		5,
		15
	}
	self.skill_descs.fast_fire.multibasic = "5"
	self.skill_descs.fast_fire.multipro = "10"

	-- Body Expertise basic gives armor piercing and aced applies 60% of the headshot damage to the body
	self.values.weapon.automatic_head_shot_add = {0.6, 0.9}
	self.skill_descs.body_expertise.multipro = "60%"
	
	-- Ghost --

	-- Athlete
	self.skill_descs.sprinter.multibasic2 = "10%"
	self.skill_descs.sprinter.multipro = "25%"

	-- Duck and Cover
	self.values.player.crouch_speed_multiplier[1] = 0.15
	self.values.player.crouch_dodge_chance[1] = 0.1
	self.skill_descs.awareness.multibasic = "15%"
	self.skill_descs.awareness.multipro = "10%"

	-- Sprinter
	self.values.player.run_speed_multiplier[1] = 1.2
	self.values.player.on_zipline_dodge_chance[1] = 0.1
	self.skill_descs.optic_illusions.multibasic = "20%"
	self.skill_descs.optic_illusions.multipro = "10%"

	-- The Professional nerf
	self.values.weapon.silencer_spread_index_addend[1] = 2 -- 8 accuracy
	self.values.weapon.silencer_recoil_index_addend[1] = 2 -- 8 stability
	self.skill_descs.silence_expert.multibasic = "8"
	self.skill_descs.silence_expert.multipro3 = "8"

	-- Silencer Expert
	self.definitions.weapon_silencer_damage_multiplier = {
	    category = "feature",
		name_id = "silencer_damage_multiplier",
		upgrade = {
		    category = "weapon",
			upgrade = "silencer_damage_multiplier",
			value = 1
		}	
	}
	self.definitions.weapon_armor_piercing_chance_silencer = {
	    category = "feature",
		name_id = "armor_piercing_chance_silencer",
		upgrade = {
		    category = "weapon",
			upgrade = "armor_piercing_chance_silencer",
			value = 1
		}	
	}
	self.values.weapon.armor_piercing_chance_silencer[1] = 0.5
	self.skill_descs.backstab.multibasic = "1"
	self.skill_descs.backstab.multibasic2 = "2"
	self.skill_descs.backstab.multipro = "15%"
	self.skill_descs.backstab.multipro2 = "50%"

	-- Low Blow
	self.values.player.detection_risk_add_crit_chance = {
		{
			0.04,
			2,
			"below",
			35,
			0.4
		},
		{
			0.06,
			1,
			"below",
			35,
			0.6
		}
	}
	self.skill_descs.unseen_strike.multibasic = "4%"
	self.skill_descs.unseen_strike.multibasic2 = "2"
	self.skill_descs.unseen_strike.multibasic3 = "35"
	self.skill_descs.unseen_strike.multibasic4 = "40%"
	self.skill_descs.unseen_strike.multipro = "6%"
	self.skill_descs.unseen_strike.multipro2 = "1"
	self.skill_descs.unseen_strike.multipro3 = "35"
	self.skill_descs.unseen_strike.multipro4 = "60%"

	-- HVT basic buff and aced nerf
	self.values.player.marked_enemy_damage_mul = 1.25
	self.values.player.marked_inc_dmg_distance[1][2] = 1.25
	self.skill_descs.hitman.multibasic = "25%"
	self.skill_descs.hitman.multipro = "25%"
	self.skill_descs.hitman.multipro2 = "10"
	self.skill_descs.hitman.multipro3 = "100%"

	-- Fugitive --

	-- Equilbrium nerf
	self.values.pistol.swap_speed_multiplier = {1.25} -- funny how this is actually 50% in vanilla and not 30%
	self.skill_descs.equilibrium.multibasic3 = "25%"

	-- Trigger Happy rework
	self.values.pistol.stacking_hit_damage_multiplier = {
		{
			max_stacks = 5,
			max_time = 3,
			damage_bonus = 1.15
		},
		{
			max_stacks = 5,
			max_time = 6,
			damage_bonus = 1.15
		}
	}
	-- what the fuck are these description values
	self.skill_descs.trigger_happy.multibasic4 = "15%"
	self.skill_descs.trigger_happy.multibasic2 = "3"
	self.skill_descs.trigger_happy.multibasic3 = "5"
	self.skill_descs.trigger_happy.multipro2 = "6"

	self.values.temporary.berserker_damage_multiplier[2] = {1, 9}
	self.skill_descs.perseverance.multipro = "6"

	-- Pumping Iron buff
	self.values.player.non_special_melee_multiplier[1] = 3
	self.skill_descs.steroids.multibasic = "200%"

	-- Bloodthirst nerf
	self.values.player.melee_damage_stacking.max_multiplier = 6
	self.skill_descs.bloodthirst.multibasic2 = "600%"

	-- Zerker
	self.values.player.melee_damage_health_ratio_multiplier = {1.5}
	self.values.player.movement_speed_damage_health_ratio_multiplier = {0.25}
	self.skill_descs.wolverine.multibasic = "50%"
	self.skill_descs.wolverine.multibasic2 = "150%"
	self.skill_descs.wolverine.multipro = "50%"
	self.skill_descs.wolverine.multipro2 = "25%"

	-- Frenzy
	self.values.player.health_damage_reduction = {0.85, 0.7}
	self.values.player.max_health_reduction = {0.1}
	self.skill_descs.frenzy.multibasic = "10%"
	self.skill_descs.frenzy.multibasic2 = "15%"
	self.skill_descs.frenzy.multipro = "30%"

	-- Perk Decks
	-------------

	-- Crew Chief health / hostage nerf
	self.values.team.health.hostage_multiplier = {1.04}
	self.specialization_descs[1][9].multiperk = "4%"

	-- Muscle lower health regen
	self.values.player.passive_health_regen = {1}
	self.specialization_descs[2][9].multiperk2 = "10"

	-- Hitman faster armor recovery rate
	self.values.player.perk_armor_regen_timer_multiplier[5] = 0.4
	self.specialization_descs[5][9].multiperk = "25%"

	-- Armorer godmode nerf
	self.values.temporary.armor_break_invulnerable = {{2, 24}}
	self.specialization_descs[3][7].multiperk3 = "24"
	self.specialization_descs[3][1].multiperk = "5%"
	self.specialization_descs[3][3].multiperk = "5%"
	self.specialization_descs[3][5].multiperk = "5%"

	-- Subtle card gives lower dodge
	self.values.player.passive_dodge_chance = {0.05, 0.2, 0.3}
	self.specialization_descs[4][1].multiperk = "5%"
	self.specialization_descs[4][7].multiperk = "10%"
	self.specialization_descs[6][1].multiperk = "5%"
	self.specialization_descs[13][5].multiperk3 = "5%"
	self.specialization_descs[18][5].multiperk = "5%"
	self.specialization_descs[21][5].multiperk2 = "5%"

	-- Anarchist additional armor on conversion decrease
	self.values.player.armor_grinding = {{
			{1, 1.5},
			{1.5, 2.25},
			{2, 3},
			{2.5, 3.75},
			{3.5, 4.5},
			{5, 5.25},
			{8, 6}
		}}
	self.values.player.damage_to_armor = {{
			{1, 1.5},
			{1, 1.5},
			{1, 1.5},
			{1, 1.5},
			{1, 1.5},
			{1, 1.5},
			{1, 1.5}
		}}
	self.values.player.armor_increase = {0.8, 0.9, 1}
	self.specialization_descs[15][3].multiperk2 = "80%"
	self.specialization_descs[15][5].multiperk2 = "90%"
	self.specialization_descs[15][7].multiperk2 = "100%"

	-- Crook dodge nerf and make lower armor get higher armor boost
	self.values.player.level_2_armor_multiplier[3] = 1.8
	self.values.player.level_3_armor_multiplier[3] = 1.7
	self.values.player.level_4_armor_multiplier[3] = 1.65
	self.values.player.level_2_dodge_addend[3] = 0.2
	self.values.player.level_3_dodge_addend[3] = 0.2
	self.values.player.level_4_dodge_addend[3] = 0.2
	self.specialization_descs[6][5].multiperk = "5%"

	-- Gambler cooldowns decrease
	for _, v in pairs(self.values.temporary.loose_ammo_restore_health) do
		v[2] = 2
	end
	self.specialization_descs[10][1].multiperk3 = "2"
	self.values.temporary.loose_ammo_give_team[1][2] = 3
	self.specialization_descs[10][3].multiperk2 = "3"

	-- Nerf grinders healing intensity
	self.damage_to_hot_data.tick_time = 0.5
	self.specialization_descs[11][1].multiperk2 = "0.5"
	self.specialization_descs[11][3].multiperk2 = "0.5"
	self.specialization_descs[11][5].multiperk2 = "0.5"
	self.specialization_descs[11][7].multiperk2 = "0.5"
	self.specialization_descs[11][9].multiperk2 = "0.5"

	-- Ex-president max health store amount nerf
	self.values.player.body_armor.skill_max_health_store = {8, 7, 5, 5, 4.5, 4, 3.5}
	
	-- Give yakuza damage zerker and swap speed
	self.values.player.damage_health_ratio_multiplier = {0.35}
	self.specialization_descs[12][3].multiperk = "80%"
	self.specialization_descs[12][9].multiperk = "25%"
	self.specialization_descs[12][9].multiperk2 = "35%"
	self.specialization_descs[12][9].multiperk3 = "50%"
	self.specialization_descs[12][9].multiperk4 = "25%"

	-- Maniac absorption nerf
	self.cocaine_stacks_convert_levels = {600 / 8, 60}
	self.values.player.cocaine_stack_absorption_multiplier = {1.5}
	self.specialization_descs[14][1].multiperk6 = "75"
	self.specialization_descs[14][7].multiperk2 = "60"
	self.specialization_descs[14][9].multiperk = "50%"

	-- KP 45s inj description
	self.specialization_descs[17][1].multiperk3 = "45"
	self.specialization_descs[17][9].multiperk3 = "5 points"
	self.specialization_descs[17][9].multiperk3 = "1"

	-- Sicario twitch 3s cooldown
	self.values.player.dodge_shot_gain = {
		{
			0.2,
			3
		}
	}
	self.specialization_descs[18][3].multiperk2 = "3"

	-- Stoic flask cooldown increase
	self.specialization_descs[19][1].multiperk3 = "16"

	-- Tag Team max 8 absorption
	self.values.player.tag_team_damage_absorption.max = 0.8
	self.specialization_descs[20][5].multiperk2 = "8"

	-- Hacker nerf
	self.values.temporary.pocket_ecm_kill_dodge[1] = {0.15, 25, 4}
	self.values.player.pocket_ecm_heal_on_kill = {1}
	self.specialization_descs[21][5].multiperk = "10"
	self.specialization_descs[21][7].multiperk = "4%"
	self.specialization_descs[21][7].multiperk2 = "15%"
	self.specialization_descs[21][7].multiperk3 = "25"

	-- Leech nerf all around, without much thought cause idc about the deck and honestly just fuck it
	self.copr_ability_cooldown = 60
	self.values.temporary.copr_ability[1][2] = 4
	self.values.temporary.copr_ability[2][2] = 8
	self.values.player.copr_static_damage_ratio[2] = 0.125
	self.values.player.copr_teammate_heal = {
		0.015,
		0.03
	}
	self.specialization_descs[22][1].multiperk4 = "1.5%"
	self.specialization_descs[22][1].multiperk5 = "4"
	self.specialization_descs[22][1].multiperk6 = "60"
	self.specialization_descs[22][5].multiperk = "8"
	self.specialization_descs[22][5].multiperk3 = "3%"
	self.specialization_descs[22][9].multiperk = "12.5%"
end
