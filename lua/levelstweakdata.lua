local vanilla_outfits = Eclipse.settings.player_styles == 1
local expanded_outfits = Eclipse.settings.player_styles == 2
local no_outfits = Eclipse.settings.player_styles == 3

Hooks:PostHook(LevelsTweakData, "init", "eclipse_init", function(self)
	for _, level in pairs(self) do
		if level.world_name then
			level.player_style = nil
			level.group_ai_settings = {
				difficulty_curve_points = { 0.5 },
				spawn_kill_distance = 1500,
				spawn_kill_cooldown = 10,
				first_responders_trade_delay = 45,
				recurring_cloaker_spawn_interval_mul = 1,
				hostage_hesitation_delay_mul = 1,
				sustain_duration_mul = 1,
				assault_delay_mul = 1,
				assault_force_mul = 1,
				spawnrate_mul = 1,
				min_reenforce_interval_mul = 1,
				reenforce_interval_mul = 1,
				recon_interval_variation_mul = 1,
				recon_force_mul = 1,
				push_delay_mul = 1,
				min_grenade_timeout_mul = 1,
				cs_grenade_chance_times_mul = 1,
				difficulty_scaling = {},
				grenade_timeout_mul = {
					flash_grenade = 1,
					smoke_grenade = 1,
					cs_grenade = 1,
				},
				special_limit_add = {
					shield = 0,
					medic = 0,
					taser = 0,
					tank = 0,
					spooc = 0,
					marksman = 0,
					marshal = 0,
				},
				force_tactics = {},
			}
		end
	end

	-- add flashlights to more heists
	self.welcome_to_the_jungle_1_night.flashlights_on = true
	self.framing_frame_1.flashlights_on = true
	self.election_day_2.flashlights_on = true
	self.watchdogs_1_night.flashlights_on = true
	self.watchdogs_2.flashlights_on = true
	self.firestarter_1.flashlights_on = true
	self.firestarter_2.flashlights_on = true
	self.alex_2.flashlights_on = true
	self.alex_3.flashlights_on = true
	self.nightclub.flashlights_on = true
	self.escape_cafe.flashlights_on = true
	self.escape_park.flashlights_on = true
	self.escape_overpass.flashlights_on = true -- it's actually night time
	self.escape_overpass_night.flashlights_on = true
	self.arm_und.flashlights_on = true
	self.kosugi.flashlights_on = true
	self.dark.flashlights_on = true
	self.gallery.flashlights_on = true
	self.hox_3.flashlights_on = true
	self.crojob3_night.flashlights_on = true
	self.dark.flashlights_on = true
	self.short1_stage1.flashlights_on = true
	self.spa.flashlights_on = true
	self.glace.flashlights_on = true -- PDTH vibes
	self.dah.flashlights_on = true -- PDTH vibes
	self.sah.flashlights_on = true
	self.deep.flashlights_on = true

	-- add Group AI settings
	self.jewelry_store.group_ai_settings = {
		assault_force_mul = 0.7,
		recon_interval_variation_mul = 0.75,
		push_delay_mul = 1.25,
		difficulty_scaling = {
			diff_init = 0.2,
		},
		force_tactics = {
			swat_init = {
				flank = true,
			},
		},
	}
	self.jewelry_store.group_ai_preset = "small_urban"

	self.ukrainian_job.group_ai_settings = deep_clone(self.jewelry_store.group_ai_settings)
	self.ukrainian_job.group_ai_preset = "small_urban"

	self.mallcrasher.group_ai_settings = deep_clone(self.jewelry_store.group_ai_settings)
	self.mallcrasher.group_ai_settings.difficulty_scaling = {
		diff_init = 0.2,
		assault_delay = 75,
	}
	self.mallcrasher.group_ai_preset = "small_urban"

	self.four_stores.group_ai_settings = deep_clone(self.jewelry_store.group_ai_settings)
	self.four_stores.group_ai_settings.assault_force_mul = 0.6
	self.four_stores.group_ai_preset = "small_urban"

	self.nightclub.group_ai_settings = deep_clone(self.four_stores.group_ai_settings)
	self.nightclub.group_ai_settings.special_limit_add = { shield = -1, marksman = -1 }
	self.nightclub.group_ai_preset = "small_urban"

	self.arm_par.group_ai_settings = {
		sustain_duration_mul = 0.75,
		assault_force_mul = 0.7,
		difficulty_scaling = {
			assault_add = 0.3,
		},
	}

	self.arm_cro.group_ai_settings = deep_clone(self.arm_par.group_ai_settings)
	self.arm_fac.group_ai_settings = deep_clone(self.arm_par.group_ai_settings)
	self.arm_hcm.group_ai_settings = deep_clone(self.arm_par.group_ai_settings)
	self.arm_und.group_ai_settings = deep_clone(self.arm_par.group_ai_settings)

	self.arm_for.group_ai_settings = {
		special_limit_add = {
			shield = -1,
		},
	}
	self.arm_for.group_ai_preset = "heavy_response"

	self.escape_park.group_ai_settings = deep_clone(self.arm_par.group_ai_settings)
	self.escape_park.group_ai_settings.difficulty_scaling = { diff_init = 0.5, assault_add = 0.25 }

	self.escape_cafe_day.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)
	self.escape_park_day.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)
	self.escape_cafe.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)
	self.escape_street.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)
	self.escape_overpass.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)
	self.escape_overpass_night.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)
	self.escape_garage.group_ai_settings = deep_clone(self.escape_park.group_ai_settings)

	self.watchdogs_1.group_ai_settings = {
		difficulty_scaling = {
			diff_init = 0.5,
			assault_add = 0.25,
			assault_delay = 60,
		},
	}

	self.watchdogs_2.group_ai_settings = {
		sustain_duration_mul = 1.25,
		assault_force_mul = 1.2,
		difficulty_scaling = {
			diff_init = 0.5,
			assault_add = 0.25,
		},
		special_limit_add = {
			shield = 1,
		},
	}
	self.watchdogs_2.group_ai_preset = "heavy_response"

	self.watchdogs_2_day.group_ai_settings = deep_clone(self.watchdogs_2.group_ai_settings)

	self.framing_frame_2.group_ai_settings = {
		recon_force_mul = 0,
		difficulty_scaling = {
			diff_init = 0.5,
			assault_add = 0.5,
		},
	}
	self.framing_frame_2.group_ai_preset = "heavy_response"

	self.framing_frame_3.group_ai_settings = {
		assault_force_mul = 0.6,
		grenade_timeout_mul = {
			flash_grenade = 0.75,
		},
		special_limit_add = {
			shield = -1,
			marksman = -2,
		},
	}
	self.framing_frame_3.group_ai_preset = "skyscraper"

	self.roberts.group_ai_settings = {
		assault_force_mul = 0.8,
		force_tactics = {
			shield_def = {
				ranged_fire = false,
			},
		},
	}

	self.mia_2.group_ai_settings = deep_clone(self.framing_frame_3.group_ai_settings)
	self.mia_2.group_ai_settings.assault_force_mul = 0.5

	self.hox_1.group_ai_settings = {
		sustain_duration_mul = 0.75,
		assault_delay_mul = 1.25,
		assault_force_mul = 0.6,
		min_reenforce_interval_mul = 0,
		push_delay_mul = 1.25,
		min_grenade_timeout_mul = 1.5,
		force_tactics = {
			swat_init = {
				no_push = true,
			},
			swat_agg = {
				charge = false,
			},
			shield_agg = {
				charge = false,
			},
			taser_agg = {
				charge = false,
			},
		},
	}

	self.mus.group_ai_settings = {
		assault_force_mul = 0.7,
		difficulty_scaling = {
			assault_delay = 90,
		},
	}

	self.arena.group_ai_settings = {
		spawn_kill_cooldown = 15,
		hostage_hesitation_delay_mul = 1.5,
		assault_force_mul = 0.8,
	}

	self.crojob3.group_ai_settings = {
		assault_delay_mul = 1.25,
		assault_force_mul = 0.8,
		difficulty_scaling = {
			assault_delay = 75,
		},
	}
	self.crojob3.group_ai_preset = "remote"

	self.crojob3_night.group_ai_settings = deep_clone(self.crojob3.group_ai_settings)
	self.crojob3_night.group_ai_preset = "remote"

	self.kenaz.group_ai_settings = {
		hostage_hesitation_delay_mul = 1.5,
		assault_force_mul = 1.2,
		force_tactics = {
			shield_def = {
				ranged_fire = false,
			},
		},
	}

	self.pbr2.group_ai_settings = {
		spawn_kill_cooldown = 20,
		assault_force_mul = 0.6,
		special_limit_add = {
			shield = -1,
		},
	}

	self.peta.group_ai_settings = {
		assault_force_mul = 1.2,
		assault_delay_mul = 1.25,
		force_tactics = {
			swat_init = {
				flank = true,
			},
			shield_def = {
				ranged_fire = false,
			},
		},
	}

	self.peta2.group_ai_settings = {
		assault_force_mul = 0.7,
		recon_force_mul = 0.5,
	}
	self.peta2.group_ai_preset = "remote"

	self.mad.group_ai_settings = {
		assault_force_mul = 0.8,
		difficulty_scaling = {
			diff_init = 0.25,
			assault_add = 0.25,
		},
	}

	self.man.group_ai_settings = {
		recurring_cloaker_spawn_interval_mul = 0.75,
		sustain_duration_mul = 1.25,
		assault_force_mul = 0.7,
		cs_grenade_chance_times_mul = 0.75,
		special_limit_add = {
			shield = -1,
			tank = 1,
			cloaker = 1,
		},
	}
	self.man.group_ai_preset = "heavy_response"

	self.born.group_ai_settings = {
		assault_force_mul = 0.8,
		grenade_timeout_mul = {
			smoke_grenade = 0.75,
		},
		force_tactics = {
			shield_def = {
				ranged_fire = false,
			},
		},
	}

	self.chew.group_ai_settings = {
		assault_force_mul = 0.3,
		recon_force_mul = 0,
		cs_grenade_chance_times_mul = 1.5,
		special_limit_add = {
			shield = -2,
			cloaker = -1,
			marksman = -2,
		},
		force_tactics = {
			cop_def = {
				ranged_fire = false,
			},
			swat_init = {
				ranged_fire = false,
			},
			swat_def = {
				ranged_fire = false,
			},
			shield_def = {
				ranged_fire = false,
			},
			bulldozer_def = {
				door_ambush = false,
			},
		},
	}

	self.flat.group_ai_settings = {
		assault_force_mul = 0.8,
		force_tactics = {
			cop_snk = {
				smoke_grenade = true,
				flash_grenade = true,
			},
			swat_init = {
				flank = true,
			},
		},
	}

	self.chill_combat.group_ai_settings = {
		sustain_duration_mul = 0.75,
		assault_force_mul = 0.5,
		cs_grenade_chance_times_mul = 0.5,
		difficulty_scaling = {
			diff_init = 0.33,
			assault_add = 0.33,
		},
		grenade_timeout_mul = {
			cs_grenade = 0.5,
		},
		force_tactics = {
			hrt_def = {
				smoke_grenade = true,
				flash_grenade = true,
			},
			hrt_snk = {
				smoke_grenade = true,
				flash_grenade = true,
			},
			swat_def = {
				rescue = true,
			},
			swat_agg = {
				rescue = true,
			},
		},
	}
	self.chill_combat.group_ai_preset = "small_urban"

	self.help.group_ai_settings = deep_clone(self.flat.group_ai_settings)
	self.help.group_ai_settings.force_tactics = nil

	self.friend.group_ai_settings = deep_clone(self.kenaz.group_ai_settings)

	self.moon.group_ai_settings = deep_clone(self.help.group_ai_settings)

	self.spa.group_ai_settings = {
		assault_force_mul = 0.7,
		special_limit_add = {
			shield = -1,
		},
	}

	self.run.group_ai_settings = deep_clone(self.hox_1.group_ai_settings)
	self.run.group_ai_settings.special_limit_add = {
		taser = 1,
		medic = 1,
	}

	self.glace.group_ai_settings = deep_clone(self.run.group_ai_settings)
	self.glace.group_ai_settings.difficulty_scaling = { assault_delay = 120 }

	self.wwh.group_ai_settings = {
		assault_force_mul = 0.8,
		difficulty_scaling = {
			diff_init = 0.5,
			assault_add = 0.25,
		},
		special_limit_add = {
			taser = 1,
		},
	}
	self.wwh.group_ai_preset = "remote"

	self.dah.group_ai_preset = "skyscraper"

	self.hvh.group_ai_settings = {
		spawn_kill_distance_mul = 1000,
		assault_force_mul = 0.5,
		recon_force_mul = 0.6,
		grenade_timeout_mul = {
			smoke_grenade = 1.25,
		},
		special_limit_add = {
			shield = -1,
			marksman = -1,
		},
	}

	self.rvd1.group_ai_settings = {
		recon_interval_variation_mul = 0.5,
		difficulty_scaling = {
			diff_init = 0.5,
			assault_add = 0.25,
		},
		special_limit_add = {
			shield = 1,
		},
	}

	self.rvd2.group_ai_settings = {
		assault_force_mul = 0.6,
	}
	self.rvd2.group_ai_preset = "heavy_response"

	self.des.group_ai_settings = deep_clone(self.help.group_ai_settings)
	self.des.group_ai_settings.assault_force_mul = 0.6

	self.sah.group_ai_settings = {
		assault_force_mul = 0.7,
		difficulty_scaling = {
			assault_delay = 60,
		},
	}

	self.nmh.group_ai_settings = {
		spawn_kill_cooldown = 15,
		assault_force_mul = 0.6,
		difficulty_scaling = {
			assault_delay = 60,
		},
		special_limit_add = {
			shield = -1,
			tank = 1,
			marksman = -1,
		},
	}

	self.bph.group_ai_settings = deep_clone(self.nmh.group_ai_settings)

	self.vit.group_ai_settings = { -- Greatest heist of all
		sustain_duration_mul = 1.35,
		assault_force_mul = 0.6,
		cs_grenade_chance_times_mul = 1.25,
		special_limit_add = {
			tank = 1,
			medic = 1,
		},
	}
	self.vit.group_ai_preset = "heavy_response"

	self.mex.group_ai_settings = deep_clone(self.born.group_ai_settings)

	self.mex_cooking.group_ai_settings = deep_clone(self.mex.group_ai_settings)

	self.bex.group_ai_settings = {
		assault_force_mul = 1.2,
		special_limit_add = {
			shield = 1,
			taser = 1,
		},
	}

	self.pex.group_ai_settings = {
		sustain_duration_mul = 1.25, -- Bird flu
	}

	self.fex.group_ai_settings = deep_clone(self.nmh.group_ai_settings)

	self.sand.group_ai_settings = deep_clone(self.run.group_ai_settings)

	self.chca.group_ai_settings = {
		first_responders_trade_delay = 60,
		spawn_kill_cooldown = 15,
		assault_force_mul = 0.7,
		assault_delay_mul = 1.25,
		difficulty_scaling = {
			assault_delay = 75,
		},
		special_limit_add = {
			marksman = -1,
		},
	}
	self.chca.group_ai_preset = "remote"

	self.pent.group_ai_settings = deep_clone(self.framing_frame_3.group_ai_settings)
	self.pent.group_ai_settings.special_limit_add = nil
	self.pent.group_ai_settings.assault_force_mul = 0.8
	self.pent.group_ai_preset = "skyscraper"

	self.ranc.group_ai_settings = {
		first_responders_trade_delay = 60,
		difficulty_scaling = {
			assault_delay = 75,
		},
	}

	self.trai.group_ai_settings = {
		sustain_duration_mul = 1.25,
		assault_force_mul = 1.2,
		special_limit_add = {
			tank = 1,
		},
	}

	self.corp.group_ai_settings = { -- Fuckhuge (tm)
		sustain_duration_mul = 1.35,
		assault_force_mul = 1.4,
		recon_interval_variation_mul = 0.5,
		min_reenforce_interval_mul = 0.5,
		difficulty_scaling = {
			diff_init = 0.5,
			assault_add = 0.25,
		},
		grenade_timeout_mul = {
			smoke_grenade = 0.75,
		},
		special_limit_add = {
			taser = 1,
			tank = 1,
			marksman = 1,
		},
	}
	self.corp.group_ai_preset = "heavy_response"

	self.deep.group_ai_preset = "remote"

	-- Replace DC beat cops with appropriate ones based on the city
	-- LAPD
	self.rvd1.ai_unit_group_overrides = {
		cs_cop_1 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
			},
		},
		cs_cop_2 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"),
			},
		},
		cs_cop_3 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
			},
		},
		cs_cop_4 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
		cs_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"),
			},
		},
		cs_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
		cs_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
		cs_cop = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
	}
	self.rvd2.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides
	self.kenaz.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides
	self.jolly.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides
	self.pal.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides
	self.friend.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides

	-- SFPD
	self.chas.ai_unit_group_overrides = {
		cs_cop_1 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
			},
		},
		cs_cop_2 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
			},
		},
		cs_cop_3 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"),
			},
		},
		cs_cop_4 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"),
			},
		},
		cs_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
			},
		},
		cs_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"),
			},
		},
		cs_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"),
			},
		},
		cs_cop = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"),
			},
		},
	}
	self.sand.ai_unit_group_overrides = self.chas.ai_unit_group_overrides
	self.pent.ai_unit_group_overrides = self.chas.ai_unit_group_overrides

	-- Coast Guard
	self.chca.ai_unit_group_overrides = {
		cs_cop_1 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_1/ene_coast_guard_1"),
			},
		},
		cs_cop_2 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_2/ene_coast_guard_2"),
			},
		},
		cs_cop_3 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_3/ene_coast_guard_3"),
			},
		},
		cs_cop_4 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_4/ene_coast_guard_4"),
			},
		},
		cs_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_1/ene_coast_guard_1"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_2/ene_coast_guard_2"),
			},
		},
		cs_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_1/ene_coast_guard_1"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_4/ene_coast_guard_4"),
			},
		},
		cs_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_3/ene_coast_guard_3"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_4/ene_coast_guard_4"),
			},
		},
		cs_cop = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_1/ene_coast_guard_1"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_2/ene_coast_guard_2"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_3/ene_coast_guard_3"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_4/ene_coast_guard_4"),
			},
		},
	}

	-- Texas Rangers
	self.ranc.ai_unit_group_overrides = {
		cs_cop_1 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
			},
		},
		cs_cop_2 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
			},
		},
		cs_cop_3 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"),
			},
		},
		cs_cop_4 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"),
			},
		},
		cs_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
			},
		},
		cs_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"),
			},
		},
		cs_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"),
			},
		},
		cs_cop = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"),
			},
		},
	}
	self.trai.ai_unit_group_overrides = self.ranc.ai_unit_group_overrides

	self.corp.ai_unit_group_overrides = deep_clone(self.ranc.ai_unit_group_overrides)
	self.corp.ai_unit_group_overrides.Marshal_gunner_1 = {
		america = {
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_hcar_2/ene_male_marshal_gunner_hcar_2"),
		},
	}
	self.corp.ai_unit_group_overrides.Marshal_gunner_2 = {
		america = {
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_sko12_2/ene_male_marshal_gunner_sko12_2"),
		},
	}
	self.corp.ai_unit_group_overrides.Marshal_gunner = {
		america = {
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_hcar_2/ene_male_marshal_gunner_hcar_2"),
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_sko12_2/ene_male_marshal_gunner_sko12_2"),
		},
	}

	self.deep.ai_unit_group_overrides = deep_clone(self.chca.ai_unit_group_overrides)
	self.deep.ai_unit_group_overrides.Marshal_gunner_1 = {
		america = {
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_hcar_2/ene_male_marshal_gunner_hcar_2"),
		},
	}
	self.deep.ai_unit_group_overrides.Marshal_gunner_2 = {
		america = {
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_sko12_2/ene_male_marshal_gunner_sko12_2"),
		},
	}
	self.deep.ai_unit_group_overrides.Marshal_gunner = {
		america = {
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_hcar_2/ene_male_marshal_gunner_hcar_2"),
			Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_sko12_2/ene_male_marshal_gunner_sko12_2"),
		},
	}

	-- load the missing boat driver lines to Watchdogs day 2
	self.watchdogs_2.package = {
		"packages/narr_watchdogs2",
		"levels/narratives/vlad/cane/world_sounds",
	}
	self.watchdogs_2_day.package = {
		"packages/narr_watchdogs2_day",
		"levels/narratives/vlad/cane/world_sounds",
	}

	-- load required gangster vo to heists where it actually needs
	-- for reference: Rats day 1 has regular latin vo,
	-- Rats day 2 has cobra vo,
	-- big oil day 1 has biker vo
	-- and hotline miami day 2 (or 1, doesn't matter) has russian mobster vo
	self.welcome_to_the_jungle_1.package = {
		"packages/narr_jungle1",
		"levels/narratives/h_alex_must_die/stage_2/world_sounds",
	}
	self.welcome_to_the_jungle_1_night.package = {
		"packages/narr_jungle1_night",
		"levels/narratives/h_alex_must_die/stage_2/world_sounds",
	}
	self.alex_3.package = {
		"packages/narr_alex3",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.nightclub.package = {
		"packages/vlad_nightclub",
		"levels/narratives/dentist/mia/stage2/world_sounds",
	}
	self.jolly.package = {
		"packages/jolly",
		"levels/narratives/dentist/mia/stage2/world_sounds",
	}
	self.cane.package = {
		"packages/cane",
		"levels/narratives/e_welcome_to_the_jungle/stage_1/world_sounds",
	}
	self.peta.package = {
		"packages/narr_peta",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.peta2.package = {
		"packages/narr_peta2",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.born.package = {
		"packages/narr_born_1",
		"levels/narratives/e_welcome_to_the_jungle/stage_1/world_sounds",
	}
	self.chew.package = {
		"packages/lvl_chew",
		"levels/narratives/e_welcome_to_the_jungle/stage_1/world_sounds",
	}
	self.short2_stage1.package = {
		"packages/job_short2_stage1",
		"levels/narratives/dentist/mia/stage2/world_sounds",
	}
	self.flat.package = {
		"packages/narr_flat",
		"levels/narratives/h_alex_must_die/stage_2/world_sounds",
	}
	self.friend.package = {
		"packages/lvl_friend",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.spa.package = {
		"packages/job_spa",
		"levels/narratives/dentist/mia/stage2/world_sounds",
	}
	self.mex.package = {
		"packages/job_mex",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
		"levels/narratives/e_welcome_to_the_jungle/stage_1/world_sounds",
	}
	self.mex_cooking.package = {
		"packages/job_mex2",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.fex.package = {
		"packages/job_fex",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.chas.package = {
		"packages/job_chas",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.sand.package = {
		"packages/job_sand",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.chca.package = {
		"packages/job_chca",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}
	self.pent.package = {
		"packages/job_pent",
		"levels/narratives/h_alex_must_die/stage_1/world_sounds",
	}

	if not no_outfits then
		if expanded_outfits or vanilla_outfits then -- Vanilla setting, the same as vanilla, also on for the Expanded setting
			self.pal.player_style = "raincoat"
			self.dah.player_style = "sneak_suit"
			self.wwh.player_style = "winter_suit"
			self.sah.player_style = "tux"
			self.bph.player_style = "sneak_suit"
			self.vit.player_style = "murky_suit"
			self.pal.player_style = "poolrepair"
		end

		if expanded_outfits then -- Expanded setting, fitting default outfits for more heists
			-- Tactical BDU
			self.firestarter_2.player_style = "sneak_suit"
			self.framing_frame_1.player_style = "sneak_suit"
			self.framing_frame_2.player_style = "sneak_suit"
			self.framing_frame_3.player_style = "sneak_suit"
			self.election_day_1.player_style = "sneak_suit"
			self.election_day_2.player_style = "sneak_suit"
			self.gallery.player_style = "sneak_suit"
			self.kosugi.player_style = "sneak_suit"
			self.tag.player_style = "sneak_suit"
			self.dark.player_style = "sneak_suit"
			self.mus.player_style = "sneak_suit"
			self.hox_3.player_style = "sneak_suit"
			self.bph.player_style = "sneak_suit"
			self.pex.player_style = "sneak_suit"
			self.sand.player_style = "sneak_suit"
			self.skm_mus.player_style = "sneak_suit"

			-- Winter Camo Parka
			self.mad.player_style = "winter_suit"

			-- Tuxedo
			self.kenaz.player_style = "tux"
			self.fish.player_style = "tux"
			self.sah.player_style = "tux"
			self.chca.player_style = "tux"
			self.fex.player_style = "tux"
			self.skm_cas.player_style = "tux"

			-- Murkywater Uniform
			self.pbr.player_style = "murky_suit"
			self.pbr2.player_style = "murky_suit"
			self.des.player_style = "murky_suit"
			self.vit.player_style = "murky_suit"

			-- Legacy Tactical
			self.alex_1.player_style = "slaughterhouse"
			self.alex_3.player_style = "slaughterhouse"
			self.welcome_to_the_jungle_1.player_style = "slaughterhouse"
			self.welcome_to_the_jungle_1_night.player_style = "slaughterhouse"
			self.welcome_to_the_jungle_2.player_style = "slaughterhouse"
			self.watchdogs_1.player_style = "slaughterhouse"
			self.watchdogs_1_night.player_style = "slaughterhouse"
			self.watchdogs_2.player_style = "slaughterhouse"
			self.watchdogs_2_day.player_style = "slaughterhouse"
			self.firestarter_1.player_style = "slaughterhouse"
			self.mia_1.player_style = "slaughterhouse"
			self.mia_2.player_style = "slaughterhouse"
			self.crojob2.player_style = "slaughterhouse"
			self.crojob3.player_style = "slaughterhouse"
			self.crojob3_night.player_style = "slaughterhouse"
			self.shoutout_raid.player_style = "slaughterhouse"
			self.dinner.player_style = "slaughterhouse"
			self.man.player_style = "slaughterhouse"
			self.spa.player_style = "slaughterhouse"
			self.mex.player_style = "slaughterhouse"
			self.mex_cooking.player_style = "slaughterhouse"
			self.ranc.player_style = "slaughterhouse"
			self.trai.player_style = "slaughterhouse"
			self.deep.player_style = "slaughterhouse"
			self.skm_watchdogs_stage2.player_style = "slaughterhouse"
		end
	end
end)
