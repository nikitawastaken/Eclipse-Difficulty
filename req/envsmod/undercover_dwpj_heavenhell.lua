return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen"
	},
	environment_override = { -- File override
		["environments/pd2_man/pd2_man_rooms"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_dwpj_hell.custom_xml",
		["environments/pd2_man/pd2_man_corridor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_dwpj_hell.custom_xml",
		["environments/pd2_man/pd2_man_corridor_nofog"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_dwpj_hell.custom_xml",
		["environments/pd2_man/pd2_man_main"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/undercover_dwpj_heaven.custom_xml"
	}
}