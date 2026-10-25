return {
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_nice_classic",
		"color_payday_classic",
		"color_force",
	},
	environment_override = { -- File override
		["environments/env_test_dark/env_test_dark"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/ -- peoc
		["units/pd2_dlc_uno/environments/uno_tunnel"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/ -- secret puzzle
		["units/pd2_dlc_uno/environments/pd2_env_uno_dark"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/ -- this is probably scripted, just make it darker
		["units/pd2_dlc_vit/environments/pd2_env_vit_interior"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/ -- no sun
		["units/pd2_dlc_vit/environments/pd2_env_vit_interior_westwing"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/ -- sun ok
	},
}
