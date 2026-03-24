local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local security_enemy = "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex"
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local heavy_swat_sg = scripted_enemy.heavy_swat_2
local taser = scripted_enemy.taser_1

local bulldozers = is_eclipse_pro and random_elite_dozers or random_dozers
local security = { enemy = security_enemy }

local disabled = {
	values = {
		enabled = false,
	},
}
local roof_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local difficulty_add_20 = {
	difficulty_add = 0.20,
}
local dozer_spawn = {
	enemy = diff_i < 4 and heavy_swat_sg or bulldozers,
	values = {
		participate_to_group_ai = true,
	},
}

local taser_spawn = {
	enemy = taser,
	values = {
		participate_to_group_ai = true,
	},
}

local swat_spawn = {
	enemy = heavy_swat_sg,
	values = {
		participate_to_group_ai = true,
	},
}

return {
	[102919] = { -- enable_safe_interaction_loud
		ponr = {
			length = 400,
			length_balance_mul = { 1.125, 1, 0.875, 0.75 },
		},
	},
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
				name = "kitchen",
				force = 2,
				position = Vector3(1900, 1000, 0),
			},
			{
				name = "piano",
				force = 2,
				position = Vector3(-2000, -100, 0),
			},
			{
				name = "stairs",
				force = 2,
				position = Vector3(75, 600, 0),
			},
			{
				name = "fountain",
				force = 3,
				position = Vector3(0, -1400, -200),
			},
			{
				name = "patio",
				force = 3,
				position = Vector3(0, 3600, 0),
			},
		},
		on_executed = { -- preferreds
			{ id = 100830, delay = 30 },
		},
	},
	[103217] = {
		reinforce = {
			{
				name = "sanctum_entrance01",
				force = 2,
				position = Vector3(-1125, 3350, 0),
			},
			{
				name = "sanctum_entrance02",
				force = 2,
				position = Vector3(2050, 3900, 0),
			},
		},
		on_executed = { -- Delay sanctum preferreds
			{ id = 103216, delay = 0, delay_rand = 20 },
			{ id = 103493, delay = 0, delay_rand = 20 },
		},
	},
	-- change the scripted police heli to be a dozer chopper (with 2 heavy swat shotgunners)
	-- rest of the stuff are handled in instance
	[100708] = {
		values = {
			trigger_times = 1,
			enabled = diff_i >= 5 and true or false,
		},
		on_executed = {
			{ id = 101160, remove = true },
			{ id = 101161, delay = 60 },
		},
	},
	[101162] = {
		on_executed = {
			{ id = 101161, delay = 240, delay_rand = 60 },
		},
	},
	-- change up swat van enemies
	[103275] = dozer_spawn,
	[103276] = taser_spawn,
	[103277] = swat_spawn,
	-- Don't kill off enemies in courtyard/patio
	[102903] = disabled,
	[102904] = disabled,
	-- Add scripted difficulty increases
	[100950] = difficulty_add_20, -- completed_obj_010 (Secret area found)
	[100954] = difficulty_add_20, -- completed_obj_012 (Buluc is dead)
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
