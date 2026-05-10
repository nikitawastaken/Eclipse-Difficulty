return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_sin_classic"
	},
	environment_override = { -- File override
		["environments/pd2_red/pd2_red"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_dwpj_bastard.custom_xml",
		["environments/pd2_red_indoor/pd2_red_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_dwpj_bastard.custom_xml",
	},
}