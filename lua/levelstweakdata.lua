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

    -- Replace DC beat cops with appropriate ones based on the city
	-- LAPD
	self.rvd1.ai_unit_group_overrides = {
		beat_cop = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"),
			},
		},
	}
	self.rvd2.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides

	-- SFPD
	self.chas.ai_unit_group_overrides = {
		beat_cop = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
			},
		},
	}
	self.sand.ai_unit_group_overrides = self.chas.ai_unit_group_overrides
	self.pent.ai_unit_group_overrides = self.chas.ai_unit_group_overrides

	-- Texas Rangers
	self.ranc.ai_unit_group_overrides = {
		beat_cop = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
			},
		},
	}
	self.corp.ai_unit_group_overrides = self.ranc.ai_unit_group_overrides
end)
