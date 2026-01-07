local preferred = Eclipse.preferred
local security_enemy = "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex"
local security = { enemy = security_enemy }
local disabled = {
	values = {
		enabled = false,
	},
}
local roof_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	-- Combine some navigation areas
	[101230] = {
		ai_area = {
			{ 9, 208, 209 },
			{ 25, 26 },
			{ 28, 310 },
			{ 44, 311 },
			{ 53, 54, 55 },
			{ 72, 73 },
		},
	},
	--Add new reinforce
	[100109] = {
		reinforce = { -- Police arrived
			{
				name = "patio",
				force = 3,
				position = Vector3(100, 3700, 0),
			},
			{
				name = "stairs",
				force = 3,
				position = Vector3(25, 400, 0),
			},
			{
				name = "fountain",
				force = 4,
				position = Vector3(0, -2130, -200),
			},
		},
		on_executed = { -- preferreds
			{ id = 100830, delay = 30 },
		},
	},
	--Delay sanctum preferreds
	[103217] = {
		reinforce = { -- Enable reinforce
			{
				name = "sanctum_left",
				force = 2,
				position = Vector3(-1700, 5000, -275),
			},
			{
				name = "sanctum_right",
				force = 2,
				position = Vector3(2000, 4400, 0),
			},
		},
		on_executed = {
			{ id = 103216, delay = 0, delay_rand = 20 },
			{ id = 103493, delay = 0, delay_rand = 20 },
		},
	},
	[100955] = {
		reinforce = {
			{ name = "sanctum_left" },
			{ name = "sanctum_right" },
		},
	},
	-- Don't kill off enemies in courtyard/patio
	[102903] = disabled,
	[102904] = disabled,
	-- Disable preferred remove elements responsible for removing spawn groups in front of the mansion.
	[100244] = disabled,
	[102899] = disabled,
	[103218] = disabled,
	-- Spawn group intervals
	-- This heist has notoriously annoying spawns all over the place.
	[100007] = roof_spawn,
	[103098] = roof_spawn,
	[100131] = window_spawn,
	[100132] = window_spawn,
	[100133] = window_spawn,
	[103491] = window_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
	-- Replace Secret Service with the suit thugs
	[100673] = security,
	[100674] = security,
	[100675] = security,
	[100676] = security,
	[100677] = security,
	[100678] = security,
	[100679] = security,
	[101135] = security,
	[101137] = security,
	[101139] = security,
	[101143] = security,
	[101149] = security,
	[101809] = security,
	[101812] = security,
	[101814] = security,
	[101817] = security,
	[101819] = security,
	[101746] = security,
	[101748] = security,
	[101750] = security,
	[101828] = security,
	[101832] = security,
	[101864] = security,
	[101865] = security,
	[103373] = security,
	[101853] = security,
	[101884] = security,
	[101861] = security,
	[101867] = security,
	[101889] = security,
	[101902] = security,
	[101957] = security,
	[101960] = security,
	[101963] = security,
	[101966] = security,
	[101968] = security,
}
