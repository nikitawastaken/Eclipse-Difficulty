return {
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_nice_classic",
		"color_payday_classic",
		"color_force",
	},
	environment_override = { -- File override
		["environments/env_test_dark/env_test_dark"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/vit_dawn_indoor_peoc.custom_xml"
		["units/pd2_dlc_uno/environments/uno_tunnel"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/vit_dawn_indoor_omega.custom_xml"
		["units/pd2_dlc_uno/environments/pd2_env_uno_dark"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/vit_dawn_indoor_omega_dark.custom_xml"
		["units/pd2_dlc_vit/environments/pd2_env_vit_interior"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/vit_dawn_indoor_nosun.custom_xml"
		["units/pd2_dlc_vit/environments/pd2_env_vit_interior_westwing"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/vit_dawn_indoor_sun.custom_xml"
		["units/pd2_dlc_vit/environments/pd2_env_vit_exterior"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/vit_dawn.custom_xml"
	},
}
