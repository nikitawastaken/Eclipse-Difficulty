return {
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_heat_classic",
		"color_payday_classic",
		"color_payday",
	},
	environment_override = { -- File override
		["units/pd2_dlc_nmh/environments/nmh_environment_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nmh_default.custom_xml",
	},
}
