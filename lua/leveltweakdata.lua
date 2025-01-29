--add packages that include missing SF/Texas beat cops
Hooks:PostHook(LevelsTweakData, "init", "eclipse_init", function(self)
	--LAPD
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

	--SFPD
	self.chas.ai_unit_group_overrides = {
		beat_cop = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_chas_police_01/ene_male_chas_police_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_chas_police_02/ene_male_chas_police_02"),
			},
		},
	}
	self.pent.ai_unit_group_overrides = self.chas.ai_unit_group_overrides

	--Texas Rangers
	self.ranc.ai_unit_group_overrides = {
		beat_cop = {
			america = {
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"),
				Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"),
			},
		},
	}
end)
