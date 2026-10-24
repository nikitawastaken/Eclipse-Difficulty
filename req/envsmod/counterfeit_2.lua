return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xgen",
	},
	environment_override = {
		["environments/suburbia_env/suburbia_env"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_evening.custom_xml",
		["environments/pd2_pal_outdoor/pd2_pal_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_evening_outside.custom_xml",
		["environments/pd2_pal_indoor/pd2_pal_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_evening_indoor.custom_xml",
		["environments/pd2_pal_basement/pd2_pal_basement"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_evening_basement.custom_xml",
	},
	sounds_override = { -- File override
		["levels/narratives/classics/pal/world_sounds"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_world_sounds.custom_xml",
	},
}
