return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_payday",
	},
	environment_override = { -- morning
		["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_und_morning.custom_xml",
	}, -- daytime fog white bright
}
