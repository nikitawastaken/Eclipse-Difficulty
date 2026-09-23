return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_man/pd2_man_rooms"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_thunder.custom_xml",
		["environments/pd2_man/pd2_man_corridor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_thunder.custom_xml",
		["environments/pd2_man/pd2_man_corridor_nofog"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_thunder.custom_xml",
		["environments/pd2_man/pd2_man_main"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_thunder.custom_xml",
	},
}
