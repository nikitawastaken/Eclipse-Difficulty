return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_madplanet"
	},
	environment_override = { -- File override
		["units/pd2_dlc_des/environments/des_indoor/des_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/no_mercy_madworld_darkness.custom_xml",
		["units/pd2_dlc_nmh/environments/nmh_environment_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/no_mercy_madworld.custom_xml",
		["environments/pd2_man/pd2_man_corridor_nofog"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/no_mercy_madworld_darkness.custom_xml",
	}
}