return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_glace/glace_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/gridge_rainless.custom_xml",
		["environments/pd2_glace/glace_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/gridge_rainless.custom_xml",
	},
	sounds_override = { -- File override
		["levels/narratives/classics/glace/world_sounds"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/glace_sounds_edit.custom_xml",
	},
}
