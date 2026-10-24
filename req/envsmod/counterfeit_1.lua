return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday",
		"color_payday_classic",
	},
	environment_override = {
		["environments/suburbia_env/suburbia_env"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit.custom_xml",
		["environments/pd2_pal_outdoor/pd2_pal_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_outside.custom_xml",
		["environments/pd2_pal_indoor/pd2_pal_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_indoor.custom_xml",
		["environments/pd2_pal_basement/pd2_pal_basement"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_basement_tempfix.custom_xml",
	},
	sounds_override = { -- File override
		["levels/narratives/classics/pal/world_sounds"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_world_sounds.custom_xml",
	},
}
