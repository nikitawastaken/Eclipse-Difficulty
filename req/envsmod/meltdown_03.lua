return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat_classic",
	},
	environment_override = { -- File override
		["environments/pd2_shoutoutraid_indoor/pd2_shoutoutraid_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/meltdown_03_night.custom_xml",
	},
}
