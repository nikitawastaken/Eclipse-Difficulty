Hooks:PostHook(LevelsTweakData, "init", "eclipse_init", function(self)
	-- add flashlights to heists that take place during night (not to every heist)
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
	self.gallery.flashlights_on = true
	self.hox_3.flashlights_on = true
	self.crojob3_night.flashlights_on = true
	self.dark.flashlights_on = true
	self.short1_stage1.flashlights_on = true
	self.spa.flashlights_on = true
	self.glace.flashlights_on = true -- PDTH vibes
	self.dah.flashlights_on = true -- PDTH vibes
	self.sah.flashlights_on = true

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
		"levels/narratives/dentist/mia/stage2/world_sounds",
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

	-- Replace DC beat cops with appropriate ones based on the city
	-- LAPD
	self.rvd1.ai_unit_group_overrides = {
		CS_cop_1 = {
			america = { Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1") },
		},
		CS_cop_2 = {
			america = { Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2") },
		},
		CS_cop_3 = {
			america = { Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3") },
		},
		CS_cop_4 = {
			america = { Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4") },
		},
		CS_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"),
			},
		},
		CS_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
		CS_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
	}
	self.rvd2.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides

	-- SFPD
	self.chas.ai_unit_group_overrides = {
		CS_cop_1 = {
			america = { Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01") },
		},
		CS_cop_2 = {
			america = { Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01") },
		},
		CS_cop_3 = {
			america = { Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02") },
		},
		CS_cop_4 = {
			america = { Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02") },
		},
		CS_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
			},
		},
		CS_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
			},
		},
		CS_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
			},
		},
	}
	self.sand.ai_unit_group_overrides = self.chas.ai_unit_group_overrides
	self.pent.ai_unit_group_overrides = self.chas.ai_unit_group_overrides

	-- Texas Rangers
	self.ranc.ai_unit_group_overrides = {
		CS_cop_1 = {
			america = { Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01") },
		},
		CS_cop_2 = {
			america = { Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01") },
		},
		CS_cop_3 = {
			america = { Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02") },
		},
		CS_cop_4 = {
			america = { Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02") },
		},
		CS_cop_1_2 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
			},
		},
		CS_cop_1_4 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
			},
		},
		CS_cop_3_4 = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
			},
		},
	}
	self.corp.ai_unit_group_overrides = self.ranc.ai_unit_group_overrides
end)
