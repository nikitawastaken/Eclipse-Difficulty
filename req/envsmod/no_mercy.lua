return {
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_payday",
	},
	environment_override = {
		["environments/pd2_man/pd2_man_corridor_nofog"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nomercy_darkness.custom_xml",
		["units/pd2_dlc_des/environments/des_indoor/des_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nomercy_darkness.custom_xml",
		["units/pd2_dlc_nmh/environments/nmh_environment_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nomercy.custom_xml",
	},
	sounds_override = { -- File override
		["levels/narratives/classics/nmh/world_sounds"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/no_mercy_world_sounds.custom_xml",
	},
}
