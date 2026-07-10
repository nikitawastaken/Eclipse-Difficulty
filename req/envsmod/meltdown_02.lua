return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_shoutoutraid_indoor/pd2_shoutoutraid_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/meltdown_02.custom_xml",
	},
}
