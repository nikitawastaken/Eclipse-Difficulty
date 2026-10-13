return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_nice",
		"color_xxxgen",
		"color_matrix_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = {
		["environments/pd2_man/pd2_man_rooms"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_rooms.custom_xml",
		["environments/pd2_man/pd2_man_corridor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_corridor.custom_xml",
		["environments/pd2_man/pd2_man_corridor_nofog"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_corridor.custom_xml",
		["environments/pd2_man/pd2_man_main"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover.custom_xml",
	},
}
