Hooks:PostHook(AchievementsTweakData, "init", "eclipse_init", function(self)
	--	self.weapon_part_tracker = {}
	local normal_and_above = {
		"hard",
		"overkill",
		"overkill_145",
		"easy_wish",
	}
	local hard_and_above = {
		"overkill",
		"overkill_145",
		"easy_wish",
	}
	local overkill_and_above = {
		"overkill_145",
		"easy_wish",
	}
	local deathwish_and_above = {
		"easy_wish",
	}

	self.story_level_achievements = {}

	-- story level checks
	self.story_level_achievements.story_lvl25 = {
		story = "story_lvl25",
		level = 25,
	}
	self.story_level_achievements.story_lvl35 = {
		story = "story_lvl35",
		level = 35,
	}
	self.story_level_achievements.story_lvl50 = {
		story = "story_lvl50",
		level = 50,
	}

	-- story heist completion checks in order
	self.complete_heist_achievements.story_four_stores = {
		job = "four_stores",
		story = "story_four_stores",
	}
	self.complete_heist_achievements.story_mallcrasher = {
		job = "mallcrasher",
		story = "story_mallcrasher",
	}
	self.complete_heist_achievements.story_ukrainian_job = {
		job = "ukrainian_job_prof",
		story = "story_ukrainian_job",
		difficulty = normal_and_above,
	}
	self.complete_heist_achievements.story_nightclub = {
		job = "nightclub",
		story = "story_nightclub",
		difficulty = normal_and_above,
	}
	self.complete_heist_achievements.story_bank_heist = {
		job = "branchbank",
		story = "story_bank_heist",
		difficulty = normal_and_above,
	}
	self.complete_heist_achievements.story_diamond_store = {
		job = "family",
		story = "story_diamond_store",
		difficulty = normal_and_above,
	}
	self.complete_heist_achievements.story_transport_mult = {
		story = "story_transport_mult",
		jobs = {
			"arm_cro",
			"arm_hcm",
			"arm_fac",
			"arm_par",
			"arm_und",
			"arm_for",
		},
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_shadow_raid = {
		job = "kosugi",
		story = "story_shadow_raid",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_white_xmas = {
		job = "pines",
		story = "story_white_xmas",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_stealing_xmas = {
		job = "moon",
		story = "story_stealing_xmas",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_generic_mult_1 = {
		story = "story_generic_mult_1",
		jobs = {
			"roberts",
			"gallery",
			"branchbank_gold",
			"jewelry_store",
		},
	}

	self.complete_heist_achievements.story_car_shop = {
		job = "cage",
		story = "story_car_shop",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_watchdogs = {
		story = "story_watchdogs",
		jobs = {
			"watchdogs_wrapper",
			"watchdogs_night",
			"watchdogs",
		},
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_firestarter = {
		job = "firestarter",
		story = "story_firestarter",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_rats = {
		job = "alex",
		story = "story_rats",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_big_oil = {
		story = "story_big_oi",
		jobs = {
			"welcome_to_the_jungle_wrapper_prof",
			"welcome_to_the_jungle_night_prof",
			"welcome_to_the_jungle_prof",
		},
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_framing_frame = {
		job = "framing_frame",
		story = "story_framing_frame",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_election_day = {
		job = "election_day",
		story = "story_election_day",
		difficulty = hard_and_above,
	}

	-- ACT 2 START

	self.complete_heist_achievements.story_big_bank = {
		job = "big",
		story = "story_very_hard_big_bank",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_hotline_miami = {
		job = "mia",
		story = "story_hotline_miami",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_hoxton_breakout = {
		job = "hox",
		story = "story_hoxton_breakout",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_hoxton_revenge = {
		job = "hox_3",
		story = "story_hoxton_revenge",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_diamond = {
		job = "mus",
		story = "story_diamond",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_nmh = {
		job = "nmh",
		story = "story_nmh",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_alesso = {
		job = "arena",
		story = "story_alesso",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_golden_grin = {
		job = "kenaz",
		story = "story_golden_grin",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_generic_mult_1 = {
		story = "story_generic_mult_1",
		difficulty = hard_and_above,
		jobs = {
			"crojob1",
			"crojob_wrapper",
			"crojob2",
			"crojob2_night",
		},
	}

	-- ACT 3 START

	self.complete_heist_achievements.story_aftershock = {
		job = "jolly",
		story = "story_aftershock",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_goat_sim = {
		job = "peta",
		story = "story_goat_sim",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_santas_workshop = {
		job = "cane",
		story = "story_mayhem_santas_workshop",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_meltdown = {
		job = "shoutout_raid",
		story = "story_meltdown",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_slaughterhouse = {
		job = "dinner",
		story = "story_slaughterhouse",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_murky_station = {
		job = "dark",
		story = "story_murky_station",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_boiling_point = {
		job = "mad",
		story = "story_boiling_point",
		difficulty = hard_and_above,
	}

	-- ACT 4 START

	self.complete_heist_achievements.story_beneath_the_mountain = {
		job = "pbr",
		story = "story_beneath_the_mountain",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_birth_of_sky = {
		job = "pbr2",
		story = "story_birth_of_sky",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_heat_street = {
		job = "run",
		story = "story_heat_street",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_biker_heist = {
		job = "born",
		story = "story_biker_heist",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_scarface = {
		job = "friend",
		story = "story_scarface",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_deathsentence_green_bridge = {
		job = "glace",
		story = "story_green_bridge",
		difficulty = hard_and_above,
	}

	-- ACT 5 BEGIN

	self.complete_heist_achievements.story_first_world_bank = {
		job = "red2",
		story = "story_first_world_bank",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_undercover = {
		job = "man",
		story = "story_undercover",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_panic_room = {
		job = "flat",
		story = "story_panic_room",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_counterfeit = {
		job = "pal",
		story = "story_counterfeit",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_brooklyn_10_10 = {
		job = "spa",
		story = "story_brooklyn_10_10",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_yacht = {
		job = "fish",
		story = "story_yacht",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_alaskan_deal = {
		job = "wwh",
		story = "storye_alaskan_deal",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_diamond_heist = {
		job = "dah",
		story = "story_diamond_heist",
		difficulty = overkill_and_above,
	}

	-- ACT 6 BEGIN

	self.complete_heist_achievements.story_reservoir_dogs = {
		job = "rvd",
		story = "story_reservoir_dogs",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_brooklyn_bank = {
		job = "brb",
		story = "story_brooklyn_bank",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_breakin_feds = {
		job = "tag",
		story = "story_breakin_feds",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_henrys_rock = {
		job = "des",
		story = "story_henrys_rock",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_shacklethorne = {
		job = "sah",
		story = "story_shacklethorne",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_hells_island = {
		job = "bph",
		story = "story_hells_island",
		difficulty = overkill_and_above,
	}

	self.complete_heist_achievements.story_white_house = {
		job = "vit",
		story = "story_white_house",
		difficulty = deathwish_and_above,
	}

	-- EXTRA

	self.complete_heist_achievements.story_mex_or_chas = {
		story = "story_mex_or_chas",
		jobs = {
			"mex",
			"chas",
		},
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_bex = {
		story = "story_bex",
		job = "bex",
		difficulty = hard_and_above,
	}

	self.complete_heist_achievements.story_sand = {
		story = "story_sand",
		job = "sand",
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_pex_or_chca = {
		story = "story_pex_or_chca",
		jobs = {
			"pex",
			"chca",
		},
		difficulty = normal_and_above,
	}

	self.complete_heist_achievements.story_fex_or_pent = {
		story = "story_fex_or_pent",
		jobs = {
			"fex",
			"pent",
		},
		difficulty = normal_and_above,
	}
end)
