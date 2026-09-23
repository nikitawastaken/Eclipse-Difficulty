return {
	flashlights_on = false, -- Flashlights
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/branchbank_thx_rex.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-4468, -3465, 2556),
				rotation = Rotation(0, 0, -0),
			},
		},
	},
}
