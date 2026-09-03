local vanilla_outfits = Eclipse.settings.player_styles == 1
local vanilla_outfits = Eclipse.settings.player_styles == 1
local expanded_outfits = Eclipse.settings.player_styles == 2
local no_outfits = Eclipse.settings.player_styles == 3
local disable_christmas = Eclipse.settings.disable_christmas

Hooks:PostHook(LevelsTweakData, "init", "eclipse_init", function(self)
	for _, level in pairs(self) do
		if level.world_name then
			level.player_style = nil

			if not level.env_params then
				level.env_params = {}
			end

			-- Add an option to disable year-round Christmas decorations
			if disable_christmas and level.is_christmas_heist then
				level.is_christmas_heist = false
			end
		end
	end

	-- Add flashlights to more heists
	self.welcome_to_the_jungle_1_night.flashlights_on = true
	self.framing_frame_1.flashlights_on = true
	self.election_day_2.flashlights_on = true
	self.watchdogs_1_night.flashlights_on = true
	self.watchdogs_2.flashlights_on = true
	self.firestarter_1.flashlights_on = true
	self.firestarter_2.flashlights_on = true
	self.alex_1.flashlights_on = true
	self.alex_2.flashlights_on = true
	self.alex_3.flashlights_on = true
	self.rat.flashlights_on = true
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
	self.short1_stage1.flashlights_on = true
	self.spa.flashlights_on = true
	self.glace.flashlights_on = true -- PDTH vibes
	self.dah.flashlights_on = true -- PDTH vibes
	self.sah.flashlights_on = true
	self.deep.flashlights_on = true

	--  Enable megaphone cop announcemens on specific levels
	self.branchbank.has_megaphone_cop = true
	self.four_stores.has_megaphone_cop = true
	self.mallcrasher.has_megaphone_cop = true
	self.family.has_megaphone_cop = true
	self.firestarter_3.has_megaphone_cop = true
	self.election_day_3.has_megaphone_cop = true
	self.election_day_3_skip1.has_megaphone_cop = true
	self.election_day_3_skip2.has_megaphone_cop = true
	self.roberts.has_megaphone_cop = true
	self.big.has_megaphone_cop = true
	self.red2.has_megaphone_cop = true
	self.man.has_megaphone_cop = true
	self.moon.has_megaphone_cop = true
	self.brb.has_megaphone_cop = true
	self.chas.has_megaphone_cop = true

	-- Set AI group types (factions)
	self.kosugi.ai_group_type = "murkywater"
	self.dark.ai_group_type = "murkywater"
	self.shoutout_raid.ai_group_type = "murkywater"
	self.wwh.ai_group_type = "murkywater"
	self.pines.ai_group_type = "russia"
	self.vit.ai_group_type = "america"
	self.haunted.ai_group_type = "zombie"
	self.nail.ai_group_type = "zombie"
	self.help.ai_group_type = "zombie"

	-- Set Group AI presets that determine spawngroup composition and distribution
	self.jewelry_store.group_ai_preset = "small_urban"
	self.ukrainian_job.group_ai_preset = "small_urban"
	self.branchbank.group_ai_preset = "small_urban"
	self.four_stores.group_ai_preset = "small_urban"
	self.mallcrasher.group_ai_preset = "small_urban"
	self.nightclub.group_ai_preset = "small_urban"
	self.family.group_ai_preset = "small_urban"
	self.gallery.group_ai_preset = "small_urban"
	self.arm_for.group_ai_preset = "heavy_response"
	self.watchdogs_2.group_ai_preset = "heavy_response"
	self.watchdogs_2_day.group_ai_preset = "heavy_response"
	self.firestarter_2.group_ai_preset = "heavy_response"
	self.firestarter_3.group_ai_preset = "heavy_response"
	self.man.group_ai_preset = "heavy_response"
	self.crojob2.group_ai_preset = "heavy_response"
	self.crojob3.group_ai_preset = "heavy_response"
	self.crojob3_night.group_ai_preset = "heavy_response"
	self.rvd2.group_ai_preset = "heavy_response"
	self.vit.group_ai_preset = "heavy_response"
	self.trai.group_ai_preset = "heavy_response"
	self.welcome_to_the_jungle_2.group_ai_preset = "remote"
	self.peta2.group_ai_preset = "remote"
	self.chew.group_ai_preset = "remote"
	self.wwh.group_ai_preset = "remote"
	self.mex.group_ai_preset = "remote"
	self.mex_cooking.group_ai_preset = "remote"
	self.chca.group_ai_preset = "remote"
	self.deep.group_ai_preset = "remote"

	-- Set force presets
	self.mia_2.force_size_preset = "reduced_t3"
	self.haunted.force_size_preset = "reduced_t3"
	self.chew.force_size_preset = "reduced_t3"
	self.hvh.force_size_preset = "reduced_t3"

	self.framing_frame_3.force_size_preset = "reduced_t2"
	self.chill_combat.force_size_preset = "reduced_t2"
	self.nmh.force_size_preset = "reduced_t2"
	self.bph.force_size_preset = "reduced_t2"
	self.vit.force_size_preset = "reduced_t2"

	self.roberts.force_size_preset = "reduced_t1"
	self.pbr2.force_size_preset = "reduced_t1"
	self.flat.force_size_preset = "reduced_t1"
	self.nail.force_size_preset = "reduced_t1"
	self.moon.force_size_preset = "reduced_t1"
	self.wwh.force_size_preset = "reduced_t1"
	self.des.force_size_preset = "reduced_t1"
	self.fex.force_size_preset = "reduced_t1"
	self.chca.force_size_preset = "reduced_t1"

	self.watchdogs_2.force_size_preset = "increased_t1"
	self.watchdogs_2_day.force_size_preset = "increased_t1"
	self.shoutout_raid.force_size_preset = "increased_t1"
	self.kenaz.force_size_preset = "increased_t1"
	self.friend.force_size_preset = "increased_t1"
	self.bex.force_size_preset = "increased_t1"
	self.trai.force_size_preset = "increased_t1"

	self.corp.force_size_preset = "increased_t2"

	-- Set difficulty scaling presets
	self.escape_park.difficulty_scaling_preset = "timed"
	self.escape_cafe_day.difficulty_scaling_preset = "timed"
	self.escape_park_day.difficulty_scaling_preset = "timed"
	self.escape_cafe.difficulty_scaling_preset = "timed"
	self.escape_street.difficulty_scaling_preset = "timed"
	self.escape_overpass.difficulty_scaling_preset = "timed"
	self.escape_overpass_night.difficulty_scaling_preset = "timed"

	self.escape_garage.difficulty_scaling_preset = "timed_fast"
	self.framing_frame_2.difficulty_scaling_preset = "timed_fast"

	self.alex_3.difficulty_scaling_preset = "timed_slow"

	self.watchdogs_1.difficulty_scaling_preset = "regroup_aggressive"
	self.watchdogs_1_night.difficulty_scaling_preset = "regroup_aggressive"
	self.watchdogs_2.difficulty_scaling_preset = "regroup_aggressive"
	self.watchdogs_2_day.difficulty_scaling_preset = "regroup_aggressive"
	self.firestarter_1.difficulty_scaling_preset = "regroup_aggressive"
	self.firestarter_2.difficulty_scaling_preset = "regroup_aggressive"
	self.firestarter_3.difficulty_scaling_preset = "regroup_aggressive"
	self.rvd1.difficulty_scaling_preset = "regroup_aggressive"

	self.arm_for.difficulty_scaling_preset = "regroup_slow"
	self.hox_2.difficulty_scaling_preset = "regroup_slow"
	self.arena.difficulty_scaling_preset = "regroup_slow"
	--	self.red2.difficulty_scaling_preset = "regroup_slow"
	self.dinner.difficulty_scaling_preset = "regroup_slow"
	self.kenaz.difficulty_scaling_preset = "regroup_slow"
	self.pbr.difficulty_scaling_preset = "regroup_slow"
	self.peta.difficulty_scaling_preset = "regroup_slow"
	self.peta2.difficulty_scaling_preset = "regroup_slow"
	self.pal.difficulty_scaling_preset = "regroup_slow"
	self.mad.difficulty_scaling_preset = "regroup_slow"
	self.flat.difficulty_scaling_preset = "regroup_slow"
	self.friend.difficulty_scaling_preset = "regroup_slow"
	self.des.difficulty_scaling_preset = "regroup_slow"
	self.bex.difficulty_scaling_preset = "regroup_slow"
	self.deep.difficulty_scaling_preset = "regroup_slow"

	self.pex.difficulty_scaling_preset = "sustain_aggressive"

	self.man.difficulty_scaling_preset = "sustain_slow"
	self.vit.difficulty_scaling_preset = "sustain_slow"

	-- stealth bonus changes
	-- reduce the max possible stealth bonus from 25% to 15% to match with the heat xp bonus (with the exception of The White House)
	-- the stealth bonus is tweaked based on the heist, how many days it has and how risky the job/day is
	-- low risk heists
	self.gallery.ghost_bonus = 0.05 -- to be consistent with Framing Frame Day 1
	self.mallcrasher.ghost_bonus = 0.05 -- it's possible to stealth mallcrasher, i'm serious
	self.nightclub.ghost_bonus = 0.05 -- it's a basic heist (from 10%)
	self.branchbank.ghost_bonus = 0.05 -- same as here (from 10%)
	-- normal risks heists
	self.kosugi.ghost_bonus = 0.1 -- increase the bonus to 10% (from 5%)
	self.dark.ghost_bonus = 0.1 -- decrease the bonus to 10% (from 15%)
	self.hox_3.ghost_bonus = 0.15 -- increase the bonus to 15% (from 10%)
	self.bex.ghost_bonus = 0.1 -- Slik Road, City of Gold and Texas Heat heists all have bonus decreased to 10% (except final heists, Border Crossing and Lost In Transit)
	self.pex.ghost_bonus = 0.1
	self.chas.ghost_bonus = 0.1
	self.sand.ghost_bonus = 0.1
	self.chca.ghost_bonus = 0.1
	self.ranc.ghost_bonus = 0.1
	self.corp.ghost_bonus = 0.1
	-- high risk heists
	self.mex.ghost_bonus = 0.15 -- tedious heist
	self.arm_for.ghost_bonus = 0.15 -- high risk job involing US Army
	self.arena.ghost_bonus = 0.15 -- Alesso Heist is pretty long even on stealth
	self.kenaz.ghost_bonus = 0.15 -- same as GGC
	self.dah.ghost_bonus = 0.15 -- increase to 15% (from 10%)
	self.vit.ghost_bonus = 0.2 -- The Greatest Heist of All
	self.trai.ghost_bonus = 0.15 -- high risk job involing US Army

	-- multi day heists
	-- Big Oil (5% for Big Oil day 1 from fucking 15%)
	self.welcome_to_the_jungle_1.ghost_bonus = 0.05
	self.welcome_to_the_jungle_1_night.ghost_bonus = 0.05
	-- Framing Frame (5% in day 1, 3% in day 2 and 7% on day 3 to reach the max 15% stealth bonus)
	self.framing_frame_1.ghost_bonus = 0.05
	self.framing_frame_2.ghost_bonus = 0.03
	self.framing_frame_3.ghost_bonus = 0.07
	-- Election Day (3% in day 1 and 7% on day 2 if it's not Plan C)
	self.election_day_1.ghost_bonus = 0.03
	self.election_day_2.ghost_bonus = 0.07
	-- Firestarter (5% for all days, resulting in 15% stealth bonus max)
	self.firestarter_1.ghost_bonus = 0.05
	self.firestarter_2.ghost_bonus = 0.05
	self.firestarter_3.ghost_bonus = 0.05

	-- heists that shouldn't have stealth bonus (they're not possible to beat)
	self.nmh.ghost_bonus = nil

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
		cs_cop_2_3 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
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
		cs_cop_2_3 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"),
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
		cs_cop_2_3 = {
			america = {
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_2/ene_coast_guard_2"),
				Idstring("units/pd2_dlc_chca/characters/ene_coast_guard_3/ene_coast_guard_3"),
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

	self.deep.ai_unit_group_overrides = deep_clone(self.chca.ai_unit_group_overrides)

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
		cs_cop_2_3 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"),
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
	self.dinner.ai_unit_group_overrides = self.ranc.ai_unit_group_overrides
	self.trai.ai_unit_group_overrides = self.ranc.ai_unit_group_overrides
	self.corp.ai_unit_group_overrides = self.ranc.ai_unit_group_overrides

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
		"levels/narratives/classics/dah/world_sounds",
	}
	self.jolly.package = {
		"packages/jolly",
		"levels/narratives/dentist/mia/stage2/world_sounds",
	}
	self.cane.package = {
		"packages/cane",
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
		"levels/narratives/dentist/mia/stage2/world_sounds",
	}

	if not no_outfits then
		if expanded_outfits or vanilla_outfits then -- Vanilla setting, the same as vanilla, also on for the Expanded setting
			self.glace.player_style = "raincoat"
			self.dah.player_style = "sneak_suit"
			self.wwh.player_style = "winter_suit"
			self.sah.player_style = "tux"
			self.bph.player_style = "sneak_suit"
			self.vit.player_style = "murky_suit"
			self.pal.player_style = "poolrepair"
			self.dinner.player_style = "slaughterhouse"
		end

		if expanded_outfits then -- Expanded setting, fitting default outfits for more heists
			-- Tactical BDU
			self.firestarter_1.player_style = "sneak_suit"
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
			self.corp.player_style = "sneak_suit"
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
			self.pbr2.player_style = "murky_suit"
			self.vit.player_style = "murky_suit"

			-- Legacy Tactical
			self.arm_for.player_style = "slaughterhouse"
			self.alex_1.player_style = "slaughterhouse"
			self.alex_2.player_style = "slaughterhouse"
			self.alex_3.player_style = "slaughterhouse"
			self.rat.player_style = "slaughterhouse"
			self.welcome_to_the_jungle_1.player_style = "slaughterhouse"
			self.welcome_to_the_jungle_1_night.player_style = "slaughterhouse"
			self.welcome_to_the_jungle_2.player_style = "slaughterhouse"
			self.watchdogs_1.player_style = "slaughterhouse"
			self.watchdogs_1_night.player_style = "slaughterhouse"
			self.watchdogs_2.player_style = "slaughterhouse"
			self.watchdogs_2_day.player_style = "slaughterhouse"
			self.mia_1.player_style = "slaughterhouse"
			self.mia_2.player_style = "slaughterhouse"
			self.crojob2.player_style = "slaughterhouse"
			self.crojob3.player_style = "slaughterhouse"
			self.crojob3_night.player_style = "slaughterhouse"
			self.shoutout_raid.player_style = "slaughterhouse"
			self.man.player_style = "slaughterhouse"
			self.spa.player_style = "slaughterhouse"
			self.pbr.player_style = "slaughterhouse"
			self.des.player_style = "slaughterhouse"
			self.mex.player_style = "slaughterhouse"
			self.mex_cooking.player_style = "slaughterhouse"
			self.ranc.player_style = "slaughterhouse"
			self.trai.player_style = "slaughterhouse"
			self.deep.player_style = "slaughterhouse"
			self.skm_watchdogs_stage2.player_style = "slaughterhouse"
		end
	end

	local ready_team_package = { "packages/ready_teams" }
	self.watchdogs_1.custom_package = ready_team_package
	self.watchdogs_1_night.custom_package = ready_team_package
	self.watchdogs_2.custom_package = ready_team_package
	self.watchdogs_2_day.custom_package = ready_team_package
	self.firestarter_1.custom_package = ready_team_package
	self.firestarter_2.custom_package = ready_team_package
	self.firestarter_3.custom_package = ready_team_package
	self.alex_1.custom_package = ready_team_package
	self.alex_2.custom_package = ready_team_package
	self.alex_3.custom_package = ready_team_package
	self.hox_2.custom_package = ready_team_package
	self.man.custom_package = ready_team_package

	self.welcome_to_the_jungle_1.custom_package = {}
	self.welcome_to_the_jungle_1_night.custom_package = {}
	self.cane.custom_package = {}
	self.mex.custom_package = {}
	self.dinner.custom_package = {}
	self.trai.custom_package = {}

	--[[
	table.insert(self.welcome_to_the_jungle_1.custom_package, "packages/female_bikers")
	table.insert(self.welcome_to_the_jungle_1_night.custom_package, "packages/female_bikers")
	table.insert(self.cane.custom_package, "packages/female_bikers")
	table.insert(self.mex.custom_package, "packages/female_bikers")
	]]
	--

	local us_army_package = { "packages/us_army" }
	self.arm_for.custom_package = us_army_package
	self.roberts.custom_package = us_army_package
	self.crojob2.custom_package = us_army_package
	self.crojob3.custom_package = us_army_package
	self.jolly.custom_package = us_army_package
	self.peta2.custom_package = us_army_package
	self.vit.custom_package = us_army_package
	table.insert(self.trai.custom_package, "packages/us_army")

	local gensec_tactical_security_package = { "packages/gensec_tactical_security" }
	self.dah.custom_package = gensec_tactical_security_package
	self.arena.custom_package = gensec_tactical_security_package

	local russian_mercs_package = { "packages/akan_mercs" }
	self.pines.custom_package = russian_mercs_package

	local murky_dozers_package = { "packages/murky_bulldozers" }
	self.pbr2.custom_package = murky_dozers_package
	table.insert(self.dinner.custom_package, "packages/murky_bulldozers")

	local murky_mercs_package = { "packages/murky_mercs" }
	self.kosugi.custom_package = murky_mercs_package
	self.shoutout_raid.custom_package = murky_mercs_package
	self.dark.custom_package = murky_mercs_package
	self.wwh.custom_package = murky_mercs_package

	local murky_mercs_scripted_package = { "packages/murky_mercs_scripted" }
	--	self.brb.custom_package = murky_mercs_scripted_package

	local zombie_faction_package = { "packages/zombie_cops" }
	self.haunted.custom_package = zombie_faction_package
	self.nail.custom_package = zombie_faction_package
	self.help.custom_package = zombie_faction_package

	local lapd_package = { "packages/lapd" }
	self.kenaz.custom_package = lapd_package
	self.pal.custom_package = lapd_package
	self.friend.custom_package = lapd_package
	table.insert(self.jolly.custom_package, "packages/lapd")

	local coast_guard_package = { "packages/coast_guard" }
	self.chca.custom_package = coast_guard_package
	self.deep.custom_package = coast_guard_package

	local texas_rangers_package = { "packages/texas_rangers" }
	table.insert(self.dinner.custom_package, "packages/texas_rangers")
	table.insert(self.trai.custom_package, "packages/texas_rangers")

	local bellmead_security_package = { "packages/bellmead_security" }
	self.ranc.custom_package = bellmead_security_package
	self.corp.custom_package = bellmead_security_package

	local additive_weight_value = 1
	local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
	local is_jason = os.date("%A %d") == "Friday 13"
	local is_halloween = os.date("%B %d") == "October 31"
	if is_jason or is_halloween or is_eclipse_pro then
		additive_weight_value = math.huge
	else
		additive_weight_value = 0
	end

	self.branchbank.random_environments = {
		["branchbank01"] = 3,
		["branchbank02"] = 3,
		["branchbank03"] = 3,
		["branchbank04"] = 3,
		["branchbank05"] = 3,
		["branchbank_old"] = 2,
		["branchbank01_night"] = 1,
	}
	self.four_stores.random_environments = {
		["fourstores_01"] = 3,
		["fourstores_02"] = 3,
		["fourstores_03"] = 3,
		["default"] = 2,
		["fourstores_01_night"] = 1,
		["fourstores_02_night"] = 1,
	}
	self.jewelry_store.random_environments = {
		["jewelry_01"] = 2,
		["jewelry_02"] = 2,
		["jewelry_03"] = 2,
		["jewelry_04"] = 2,
		["jewelry_05"] = 2,
		["default"] = 1,
	}
	self.nightclub.random_environments = {
		["nightclub_01"] = 2,
		["nightclub_02"] = 3,
		["nightclub_03"] = 2,
		["default"] = 1,
	}
	self.mallcrasher.random_environments = {
		["mallcrasher_01"] = 2,
		["mallcrasher_02"] = 2,
		["default"] = 1,
	}
	self.gallery.random_environments = {
		["framingframe1_01"] = 2,
		["framingframe1_02"] = 3,
		["default"] = 1,
	}
	self.framing_frame_1.random_environments = {
		["framingframe1_01"] = 2,
		["framingframe1_02"] = 3,
		["default"] = 1,
	}
	self.framing_frame_2.random_environments = {
		["framingframe2_01"] = 3,
		["framingframe2_02"] = 3,
		["framingframe2_03"] = 2,
		["default"] = 1,
	}
	self.framing_frame_3.random_environments = {
		["framingframe3_01"] = 3,
		["framingframe3_02"] = 2,
		["framingframe3_03"] = 2,
		["default"] = 1,
	}
	self.rat.random_environments = {
		["rats1_01"] = 1,
		["rats1_02"] = 1,
		["rats1_03"] = 1,
		["rats1_04"] = 1,
		["default"] = 1,
		["rats1_dwpj"] = additive_weight_value,
		["rats1_dwpj_2"] = additive_weight_value,
	}
	self.alex_1.random_environments = {
		["rats1_01"] = 3,
		["rats1_02"] = 3,
		["rats1_03"] = 3,
		["rats1_04"] = 2,
		["default"] = 1,
		["rats1_dwpj"] = additive_weight_value,
		["rats1_dwpj_2"] = additive_weight_value,
	}
	self.alex_2.random_environments = {
		["rats2_01"] = 2,
		["rats2_02"] = 2,
		["rats2_03"] = 2,
		["default"] = 1,
	}
	self.alex_3.random_environments = {
		["rats3_01"] = 69,
	}
	self.ukrainian_job.random_environments = {
		["jewelry_01"] = 2,
		["jewelry_02"] = 2,
		["jewelry_03"] = 2,
		["jewelry_04"] = 2,
		["jewelry_05"] = 2,
		["default"] = 1,
	}
	self.watchdogs_1.random_environments = {
		["watchdogs1_01_day"] = 3,
		["watchdogs1_02_day"] = 3,
		["watchdogs1_03_day"] = 3,
		["watchdogs1_04_evening"] = 2,
		["watchdogs1_05_evening"] = 2,
		["default"] = 1,
	}
	self.watchdogs_1_night.env_params.environment = nil
	self.watchdogs_1_night.random_environments = {
		["watchdogs1_01_night"] = 2,
		["watchdogs1_02_night"] = 2,
		["watchdogs1_03_night"] = 2,
		["default"] = 1,
	}
	self.watchdogs_2.random_environments = {
		["watchdogs2_02_night"] = 2,
	}
	-- self.watchdogs_2_day.env_params.environment = nil
	self.watchdogs_2_day.random_environments = {
		["watchdogs2_01_day"] = 3,
		["watchdogs2_02_day"] = 3,
	}
	self.run.random_environments = {
		["heat_street_1"] = 3,
		["heat_street_3"] = 3,
		["heat_street_4"] = 3,
	}
	--	self.nmh.random_environments = {
	--		["no_mercy"] = 69,
	--	}
	self.dah.random_environments = {
		["diamond_heist"] = 69,
	}
	self.red2.random_environments = {
		["first_world_bank_1"] = 3,
		["first_world_bank_1_night"] = 1,
		["first_world_bank_dwpj_bastard"] = additive_weight_value,
		["first_world_bank_dwpj_matrix"] = additive_weight_value,
	}
	self.man.random_environments = {
		["undercover"] = 3,
		["undercover_dwpj_heavenhell"] = additive_weight_value,
	}
	self.mia_1.random_environments = {
		["hotlinemiami_1"] = 3,
		["hotlinemiami_2"] = 2,
		["hotlinemiami_3"] = 2,
		["hotlinemiami_4"] = 2,
		["hotlinemiami_5_dwpj"] = additive_weight_value,
		["default"] = 1,
	}
	self.mia_2.random_environments = {
		["commissar"] = 69,
	}
	self.born.random_environments = {
		["bikerheist_1_01"] = 3,
		["bikerheist_1_02"] = 2,
		["default"] = 1,
	}
	self.chew.random_environments = {
		["bikerheist_2_01"] = 2,
		["bikerheist_2_02"] = 3,
		["default"] = 1,
	}
	self.big.random_environments = {
		["bigbank_01"] = 3,
		["bigbank_02"] = 3,
		["default"] = 1,
	}
	self.mad.random_environments = {
		["mad"] = 3,
		["mad_night"] = 2,
		["default"] = 1,
	}
	self.pex.random_environments = {
		["tijuana_01"] = 1,
		["default"] = 3,
	}
	self.mex.random_environments = {
		["crossing_01"] = 1,
		["default"] = 3,
	}
	self.bex.random_environments = {
		["sanmartin_02"] = 2,
		["default"] = 3,
	}
	self.pal.random_environments = {
		["counterfeit_1"] = 3,
		["counterfeit_2"] = 2,
		["counterfeit_3"] = 1,
	}
	self.moon.random_environments = {
		["stealingxmas_1"] = 3,
		["stealingxmas_2"] = 2,
		["default"] = 1,
	}
	self.pines.random_environments = {
		["whitexmas_4"] = 3,
		["whitexmas_2"] = 2,
		["whitexmas_3"] = 2,
		["whitexmas_1"] = 2,
		["default"] = 1,
	}
	self.crojob3.random_environments = {
		["croatian_forest_1"] = 2,
		["default"] = 1,
		["croatian_forest_2"] = 1,
		["croatian_forest_3"] = 3,
		["croatian_forest_4"] = 2,
	}
	self.crojob2.random_environments = {
		["croatian_dockyard_1"] = 3,
		["croatian_dockyard_2"] = 2,
		["croatian_dockyard_3"] = 2,
		["default"] = 1,
	}
	self.arm_cro.random_environments = {
		["arm_cro_1"] = 3,
		["arm_cro_2"] = 3,
		["default"] = 2,
		["arm_cro_1_night"] = 1,
		["arm_cro_2_night"] = 1,
	}
	self.arm_par.random_environments = {
		["arm_par_1"] = 3,
		["arm_par_2"] = 3,
		["default"] = 1,
	}
	self.arm_fac.random_environments = {
		["arm_fac_3"] = 3,
		["arm_fac_2"] = 2,
		["arm_fac_1"] = 2,
		["default"] = 1,
	}
	self.arm_hcm.random_environments = {
		["arm_hcm_1"] = 2,
		["arm_hcm_2"] = 2,
		["arm_hcm_3"] = 2,
		["default"] = 1,
	}
	self.arm_und.random_environments = {
		["arm_und_1"] = 4,
		["arm_und_2"] = 3,
		["arm_und_3"] = 4,
		["arm_und_4"] = 3,
		["arm_und_5"] = 2,
		["default"] = 1,
	}
	self.arm_for.random_environments = {
		["arm_for_1"] = 2,
		["arm_for_2"] = 2,
		["arm_for_3"] = 3,
		["arm_for_4"] = 3,
		["default"] = 1,
	}
	self.firestarter_1.random_environments = {
		["firestarter1_1"] = 2,
		["firestarter1_2"] = 3,
		["firestarter1_3"] = 2,
		["firestarter1_4"] = 3,
	}
	self.firestarter_2.random_environments = {
		["firestarter2_1"] = 2,
		["firestarter2_2"] = 2,
	}
	self.firestarter_3.random_environments = {
		["firestarter3_1"] = 3,
		["firestarter3_2"] = 2,
		["firestarter3_3"] = 2,
	}
	self.brb.random_environments = {
		["brb_1"] = 3,
		["brb_2"] = 3,
	}
	self.hox_1.random_environments = {
		["hox_1_1"] = 3,
		["hox_1_2"] = 2,
		["default"] = 1,
	}
	self.flat.random_environments = {
		["flat_1"] = 4,
		["flat_2"] = 3,
		["default"] = 1,
	}
	self.dinner.random_environments = {
		["slaughterhouse_1"] = 4,
		["slaughterhouse_2"] = 3,
		["default"] = 1,
	}
	self.friend.random_environments = {
		["scarface_1"] = 4,
		["default"] = 2,
		["scarface_2"] = 2,
	}
	self.nail.random_environments = {
		["lab_rats_01"] = 3,
		["lab_rats_02"] = 2,
		["lab_rats_03"] = 1,
	}
	self.help.random_environments = {
		["prison_01"] = 3,
		["prison_02"] = 2,
		["prison_03"] = 1,
	}
	self.haunted.random_environments = {
		["horrorhouse_01"] = 4,
		["horrorhouse_02"] = 1,
		["horrorhouse_03"] = 3,
		["horrorhouse_04"] = 2,
		["horrorhouse_05"] = 2,
	}
	self.pbr2.random_environments = {
		["birth_of_sky"] = 69,
	}
	self.roberts.random_environments = {
		["roberts_1"] = 2,
		["roberts_2"] = 2,
		["roberts_3"] = 2,
	}
	self.arena.random_environments = {
		["arena_cg"] = 69,
	}
	self.glace.random_environments = {
		["glace_1"] = 69,
	}
	self.mus.random_environments = {
		["dadiamond_cg"] = 69,
	}
	self.chas.random_environments = {
		["chas_blue"] = 1,
		["chas_cg"] = 2,
	}
	self.spa.random_environments = {
		["spa_01"] = 69,
	}
	self.election_day_3.random_environments = {
		["breakingballot_01"] = 2,
		["breakingballot_02"] = 1,
		["breakingballot_03"] = 1,
	}
	self.election_day_3_skip1.random_environments = self.election_day_3.random_environments
	self.election_day_3_skip2.random_environments = self.election_day_3.random_environments
	self.jolly.random_environments = {
		["aftershock_01"] = 2,
		["aftershock_02"] = 1,
	}
	self.peta.random_environments = {
		["peta_01"] = 2,
	}
	self.kosugi.random_environments = {
		["shadowraid_01"] = 3,
		["shadowraid_02"] = 2,
		["shadowraid_03"] = 1,
	}
	self.welcome_to_the_jungle_1.random_environments = {
		["big_oil_1_2"] = 3,
		["big_oil_1_3"] = 2,
		["big_oil_1_4"] = 2,
		["big_oil_1_5"] = 1,
	}
	self.welcome_to_the_jungle_1_night.random_environments = {
		["big_oil_1_1"] = 3,
		["big_oil_1_6"] = 2,
		["big_oil_1_7"] = 1,
		["big_oil_1_8"] = 2,
	}
	self.welcome_to_the_jungle_2.random_environments = {
		["big_oil_2_cg"] = 1,
	}
	self.shoutout_raid.random_environments = {
		["meltdown_01"] = 3,
		["meltdown_02"] = 2,
		["meltdown_03"] = 1,
	}
	self.rvd1.random_environments = {
		["reservoir_1_1"] = 1,
		["reservoir_1_2"] = 2,
	}
	self.rvd2.random_environments = {
		["reservoir_2_1"] = 1,
		["reservoir_2_2"] = 2,
	}
	self.pbr.random_environments = {
		["pbr_cg"] = 1,
	}
	self.wwh.random_environments = {
		["wwh_cg"] = 1,
	}
	self.escape_park.random_environments = {
		["escape_park_1"] = 3,
		["escape_park_2"] = 1,
		["escape_park_3"] = 1,
		["escape_park_4"] = 2,
	}
	self.escape_park_day.random_environments = {
		["escape_park_day_1"] = 2,
		["escape_park_day_2"] = 1,
		["escape_park_day_3"] = 1,
		["escape_park_day_4"] = 3,
	}
	self.escape_overpass.random_environments = {
		["escape_overpass_1"] = 4,
		["escape_overpass_2"] = 3,
		["escape_overpass_day"] = 2,
	}
	self.escape_overpass_night.random_environments = self.escape_overpass.random_environments
	self.escape_cafe_day.random_environments = {
		["escape_cafe_day_1"] = 1,
		["escape_cafe_day_2"] = 1,
	}
	self.escape_garage.random_environments = {
		["escape_garage_01"] = 1,
		["escape_garage_02"] = 1,
	}
	self.escape_street.random_environments = {
		["escape_street_1"] = 1,
		["escape_street_2"] = 1,
	}
	self.family.random_environments = {
		["family_1"] = 1,
		["family_2"] = 1,
	}
	self.safehouse.random_environments = {
		["safehouse_old_01"] = 1,
		["safehouse_old_02"] = 1,
		["safehouse_old_03"] = 1,
	}
	self.chill.random_environments = {
		["safehouse_new_01"] = 1,
		["safehouse_new_02"] = 1,
		["safehouse_new_03"] = 1,
	}
	self.chill_combat.random_environments = self.chill.random_environments
	self.dark.random_environments = {
		["dark_02"] = 1,
		["dark_01"] = 2,
	}
	self.sah.random_environments = {
		["sah_cg"] = 69,
	}
	self.bph.random_environments = {
		["bph_01"] = 3,
		["bph_dwpj"] = additive_weight_value,
	}
end)
