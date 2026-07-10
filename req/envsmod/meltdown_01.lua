return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_nice_classic",
	},
	environment_override = { -- File override
		["environments/pd2_shoutoutraid_indoor/pd2_shoutoutraid_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/meltdown_01.custom_xml",
	},
}
