local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local office_cop_1 = "units/pd2_dlc_pex/characters/ene_male_office_cop_01/ene_male_office_cop_01"
local office_cop_2 = "units/pd2_dlc_pex/characters/ene_male_office_cop_02/ene_male_office_cop_02"
local office_cop_3 = "units/pd2_dlc_pex/characters/ene_male_office_cop_03/ene_male_office_cop_03"
local office_cop_4 = "units/pd2_dlc_pex/characters/ene_male_office_cop_04/ene_male_office_cop_04"
local cloaker = scripted_enemy.cloaker
local blue_office_cops = {
	Idstring(office_cop_1),
	Idstring(office_cop_2),
}
local blue_office_cop = { enemy = blue_office_cops }
local white_office_cops = {
	Idstring(office_cop_3),
	Idstring(office_cop_4),
}
local white_office_cop = { enemy = white_office_cops }
local random_office_cops = { [office_cop_1] = 3, [office_cop_2] = 3, [office_cop_3] = 2, [office_cop_4] = 2 }
local random_office_cop = { enemy = random_office_cops }
local interrogation_cop = {
	enemy = blue_office_cops,
}
local exclude_shields_dozers = {
	so_access_filter = so_access.no_heavyweight,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local unused_sniper_trigger_times = {
	values = {
		trigger_times = 0,
		enabled = true,
	},
}
local sniper_amount = {
	values = {
		amount = normal and 3 or hard and 4 or 5,
	},
}
local police_roof_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents,
}
local garage_roof_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}

local trigger_times_to_one = {
	values = {
		trigger_times = 1,
	},
}

return {
	[102964] = {
		ponr = {
			length = 270,
			length_balance_mul = { 1.5, 1.25, 1, 0.875 },
		},
		on_executed = {
			{ id = 400049, delay = 0 }, -- enable parking hiding spots when Almor has been found
		},
	},
	-- Add new reinforce
	[100109] = { -- Police arrived
		reinforce = {
			{
				name = "parking_lot01",
				force = 3,
				position = Vector3(1400, -1000, 0),
			},
			{
				name = "parking_lot02",
				force = 3,
				position = Vector3(-1200, -1000, 0),
			},
			{
				name = "entrance",
				force = 3,
				position = Vector3(500, 300, 100),
			},
		},
	},
	-- begin the cloaker hunt at the start of the first assault
	[100842] = {
		values = {
			trigger_times = 1,
		},
		on_executed = {
			{ id = 100800, delay = 0 },
			{ id = 100765, remove = true },
		},
	},
	[100800] = {
		on_executed = {
			{ id = 400050, delay = 0 },
			{ id = 101186, remove = true },
		},
	},
	-- Disable vanilla reinforce
	[104094] = disabled, -- toggle_on_police_points (evidence rooms)
	[104095] = disabled, -- point_area_min_police_force_protect_fire
	[104099] = disabled, -- point_area_min_police_force_armory_large
	[104100] = disabled, -- point_area_min_police_force_armory_large
	[104101] = disabled, -- point_area_min_police_force_armory_medium
	-- Fix two of three Hajrudin look-at triggers poking out of the room
	[102478] = {
		values = {
			position = Vector3(-3375, 4321, 125),
		},
	},
	[103881] = {
		values = {
			position = Vector3(-1725, 3498, 125),
		},
	},
	-- Remove roof spawns from the initial preferred
	[100129] = { -- preferred
		on_executed = {
			{ id = 101574, remove = true }, -- ai_preferred_police_roof
		},
	},
	-- Don't disable preferreds
	[101572] = disabled, -- ai_enemy_prefered_remove_roof
	[102194] = disabled, -- ai_enemy_prefered_remove_cells_back_spawn
	-- tweak the swat van arrivals to not trigger them all at once
	-- 2 swat vans arrive on alarm
	[100948] = {
		on_executed = {
			{ id = 101650, delay = 0, delay_rand = 5 },
			{ id = 101653, delay = 10, delay_rand = 5 },
			{ id = 101662, remove = true },
			{ id = 101663, remove = true },
			{ id = 101594, remove = true },
		},
	},
	-- the rest of swat vans arrive after assault
	[100123] = {
		on_executed = {
			{ id = 101662, delay = 0 },
			{ id = 101574, delay = 0, delay_rand = 0 }, -- ai_preferred_police_roof
			{ id = 101663, delay = 60, delay_rand = 20 },
			{ id = 101594, delay = 100, delay_rand = 20 },
		},
	},
	-- set the trigger times to 1 just in case
	[101592] = trigger_times_to_one,
	[101641] = trigger_times_to_one,
	[101586] = trigger_times_to_one,
	-- Replace the turret with a spawngroup
	[104070] = { -- arrive 1
		on_executed = {
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[104068] = { -- arrive 2
		on_executed = {
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	[104066] = { -- arrive 3
		on_executed = {
			{ id = 400019, delay = 0, delay_rand = 5 },
		},
	},
	[104141] = { -- arrive 4
		on_executed = {
			{ id = 400026, delay = 0, delay_rand = 5 },
		},
	},
	-- Adjust Sniper amount
	[100358] = sniper_amount,
	[100359] = sniper_amount,
	-- Enable unused Snipers and make them respawn
	[100368] = sniper_trigger_times,
	[100374] = sniper_trigger_times,
	[100373] = sniper_trigger_times,
	[100372] = unused_sniper_trigger_times,
	[100371] = unused_sniper_trigger_times,
	[100370] = unused_sniper_trigger_times,
	-- forbid Shields and Dozers from using various SOs near the wall with a breach
	-- e_nl_climb_over_3m
	[102999] = exclude_shields_dozers,
	[103000] = exclude_shields_dozers,
	[103001] = exclude_shields_dozers,
	[103002] = exclude_shields_dozers,
	[103003] = exclude_shields_dozers,
	[103005] = exclude_shields_dozers,
	[103006] = exclude_shields_dozers,
	-- e_nl_over_1m_jump_window
	[101646] = exclude_shields_dozers,
	[101647] = exclude_shields_dozers,
	-- e_nl_under_0_7m
	[101628] = exclude_shields_dozers,
	-- Spawn group intervals
	-- This heist isn't terrible in terms of spawns, but their distribution could be adjusted to make gameplay flow a bit better in some areas.
	[100128] = police_roof_spawn,
	[100692] = police_roof_spawn,
	[104117] = police_roof_spawn,
	[100132] = garage_roof_spawn,
	[104091] = garage_roof_spawn,
	[400020] = scripted_swat_van_spawn,
	[400027] = scripted_swat_van_spawn,
	[400034] = scripted_swat_van_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
	-- Office cops
	[100634] = blue_office_cop, -- Beat Cop Guards
	[100635] = blue_office_cop,
	[100670] = blue_office_cop,
	[100673] = blue_office_cop,
	[100674] = blue_office_cop,
	[100704] = blue_office_cop,
	[102996] = blue_office_cop, -- eepy guard
	[103330] = blue_office_cop,
	[100675] = white_office_cop, -- White Shirt Guards
	[100676] = white_office_cop,
	[100555] = random_office_cop, -- Random Indoor Guards
	[100616] = random_office_cop,
	[100617] = random_office_cop,
	[102023] = interrogation_cop, -- Interrogation Cell Cops
	[102024] = interrogation_cop,
	[102025] = interrogation_cop,
	[102030] = interrogation_cop,
	[102031] = interrogation_cop,
	[102032] = interrogation_cop,
	[102037] = interrogation_cop,
	[102038] = interrogation_cop,
	[102039] = interrogation_cop,
}
