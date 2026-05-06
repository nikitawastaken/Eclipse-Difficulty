local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local diff_i = Eclipse.utils.difficulty_index()
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local cop_4 = scripted_enemy.cop_4
local fbi_1 = scripted_enemy.fbi_1
local fbi_2 = scripted_enemy.fbi_2
local fbi_3 = scripted_enemy.fbi_3
local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local sniper = scripted_enemy.sniper
local cops = {
	[cop_1] = 4,
	[cop_3] = 2,
	[cop_2] = 1,
	[cop_4] = 1,
}
local swats = {
	[swat_1] = 6,
	[swat_2] = 2,
	[sniper] = 2,
}
local fbi_list = {
	[fbi_1] = get_difficulty_group_specific_value({ 2, 1, 1 }),
	[fbi_2] = get_difficulty_group_specific_value({ 1, 2, 3 }),
	[fbi_3] = get_difficulty_group_specific_value({ 0, 2, 3 }),
local swat_harasser = {
	enemy = diff_i < 4 and cops or swats,
}
local fbi_agent = {
	enemy = fbi_list,
}
local fbi_agents_chance = math.random() <= 0.5
local street_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local van_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local avalon_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local upper_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- add point of no return
	[100580] = {
		ponr = {
			length = 800,
			length_balance_mul = { 1.5, 1.25, 1, 0.875 },
		},
		paused_difficulty_addends = { -- disable regroup addends
			on_entered_regroup = 1,
		},
	},
	-- Combine some navigation areas
	[102729] = {
		ai_area = {
			{ 17, 18, 91 },
			{ 7, 10, 90, 171 },
			{ 5, 6, 11, 89 },
			{ 12, 13, 88 },
			{ 14, 16, 87 },
			{ 86, 115, 116 },
			{ 1, 19, 20 },
			{ 2, 21, 22 },
			{ 71, 100, 101, 102, 103 },
			{ 70, 96, 97 },
			{ 69, 98, 99 },
			{ 68, 104, 105 },
			{ 29, 30, 84 },
			{ 27, 28, 83 },
			{ 76, 110, 111, 112 },
			{ 150, 151, 170 },
			{ 77, 108, 109 },
			{ 78, 106, 107 },
			{ 79, 117, 118 },
			{ 25, 26, 81 },
			{ 23, 24, 82 },
			{ 33, 72 },
			{ 31, 73 },
			{ 74, 113, 114 },
			{ 8, 94, 214 },
			{ 3, 9, 93 },
			{ 54, 160, 161 },
			{ 162, 163 },
			{ 53, 164, 165 },
			{ 47, 48, 215 },
			{ 52, 55, 166 },
			{ 56, 57 },
			{ 58, 59 },
			{ 60, 61, 216 },
			{ 62, 126, 128 },
			{ 63, 64, 127 },
			{ 66, 167, 168 },
			{ 38, 39, 168 },
			{ 40, 41 },
			{ 34, 35, 36 },
			{ 43, 44 },
			{ 45, 46 },
		},
	},
	-- Add new reinforce
	[102850] = { -- in garage
		reinforce = {
			{
				name = "car",
				force = 3,
				position = Vector3(10600, 5500, -2400),
			},
		},
		on_executed = {
			{ id = 100006, delay = 30 },
		},
	},
	[100006] = { -- extra_preferreds1
		paused_difficulty_addends = {
			on_entered_regroup = false,
		},
	},
	-- Chance for hiding cloakers in the garage
	[102077] = {
		on_executed = {
			{ id = 400012, delay = 0 },
		},
	},
	-- restore unused spawns at the start of the heist and replace security with FBI agents
	[100589] = fbi_agent,
	[100590] = fbi_agent,
	[100585] = fbi_agent,
	[100191] = fbi_agent,
	[100587] = fbi_agent,
	[100586] = fbi_agent,
	[100588] = fbi_agent,
	[100190] = fbi_agent,
	[100584] = fbi_agent,
	[100583] = fbi_agent,
	[100581] = {
		values = {
			enabled = normal_and_above and fbi_agents_chance,
			amount = 2,
			amount_random = 1,
		},
	},
	[100582] = {
		values = {
			enabled = normal_and_above and fbi_agents_chance,
			amount = 2,
			amount_random = 1,
		},
	},
	-- Spawn group intervals
	[101719] = street_spawn,
	[101728] = street_spawn,
	[101731] = street_spawn,
	[100128] = van_spawn,
	[100130] = van_spawn,
	[100131] = van_spawn,
	[100132] = van_spawn,
	[101791] = avalon_spawn,
	[101722] = upper_spawn,
	[101725] = upper_spawn,
	[101737] = upper_spawn,
	[101789] = upper_spawn,
	[101734] = upper_spawn,
	-- Tweak harassers
	[102029] = swat_harasser,
	[102031] = swat_harasser,
	[102033] = swat_harasser,
	[102035] = swat_harasser,
	[102037] = swat_harasser,
	[102039] = swat_harasser,
	[102041] = swat_harasser,
	[102043] = swat_harasser,
}
