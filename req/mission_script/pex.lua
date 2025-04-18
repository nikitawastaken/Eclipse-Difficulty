local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local office_cop_1 = "units/pd2_dlc_pex/characters/ene_male_office_cop_01/ene_male_office_cop_01"
local office_cop_2 = "units/pd2_dlc_pex/characters/ene_male_office_cop_02/ene_male_office_cop_02"
local office_cop_3 = "units/pd2_dlc_pex/characters/ene_male_office_cop_03/ene_male_office_cop_03"
local office_cop_4 = "units/pd2_dlc_pex/characters/ene_male_office_cop_04/ene_male_office_cop_04"
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
local flank_spawn = {
	values = {
		interval = 20,
	},
}
local roof_spawn1 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields,
}
local roof_spawn2 = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	[101829] = {
		ponr = {
			length = 300,
			player_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	--Add new reinforce
	[100109] = { -- Police arrived
		reinforce = {
			{
				name = "parking_lot1",
				force = 3,
				position = Vector3(-1100, -400, 0)
			},
			{
				name = "parking_lot2",
				force = 3,
				position = Vector3(1800, -400, 0)
			},
		}
	},
	-- Add new preferreds and adjust existing ones
	[100129] = { -- initial preferreds
		on_executed = {
			{ id = 400013, delay = 0 },
			{ id = 101574, remove = true }, -- remove roof preferreds
			{ id = 102203, remove = true }, -- remove back alley preferreds
		},
	},
	[101571] = { -- fire started, enable roof preferreds
		on_executed = {
			{ id = 101574, delay = 0 },
		},
	},
	[100006] = { -- fire done, enable back alley preferreds
		on_executed = {
			{ id = 102203, delay = 0 },
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
	-- Spawn group delays
	-- This heist isn't terrible in terms of spawns, but their distribution could be adjusted to make gameplay flow a bit better in some areas.
	[100019] = flank_spawn,
	[100131] = flank_spawn,
	[104123] = flank_spawn,
	[100132] = roof_spawn1,
	[104091] = roof_spawn1,
	[100128] = roof_spawn2,
	[100692] = roof_spawn2,
	[104117] = roof_spawn2,
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
	[102023] = blue_office_cop,
	[102024] = blue_office_cop,
	[102025] = blue_office_cop,
	[102030] = blue_office_cop,
	[102031] = blue_office_cop,
	[102032] = blue_office_cop,	
	[102037] = blue_office_cop,
	[102038] = blue_office_cop,
	[102039] = blue_office_cop,
	[100675] = white_office_cop, -- White Shirt Guards
	[100676] = white_office_cop,
	[100555] = random_office_cop, -- Random Indoor Guards
	[100616] = random_office_cop, 
	[100617] = random_office_cop,
}
