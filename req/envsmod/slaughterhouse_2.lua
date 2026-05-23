return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_dinner_room/pd2_dinner_room"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_start_exterior.custom_xml",
		["environments/pd2_dinner_outdoor/pd2_dinner_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_start_exterior.custom_xml",
		["environments/pd2_dinner_outdoor_middle/pd2_dinner_outdoor_middle"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_start_exterior.custom_xml",
		["environments/pd2_dinner_office/pd2_dinner_office"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_middle_interior.custom_xml",
		["environments/pd2_dinner_slaughterhouse/pd2_dinner_slaughterhouse"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_middle_interior.custom_xml",
		["environments/pd2_dinner_outdoor_ending/pd2_dinner_outdoor_ending"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_ending_exterior_evening.custom_xml",
	}
}