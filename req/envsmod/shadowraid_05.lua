return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
	},
	environment_override = { -- File override
		["environments/pd2_kosugi/pd2_kosugi"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/shadow_raid_matrix.custom_xml",
	},
}
