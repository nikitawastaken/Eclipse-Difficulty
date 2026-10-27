local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local mobster_team = {
	values = {
		team = "mobster1",
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local wall_spawn_action = {
	values = {
		so_action = "e_sp_over_3_35m",
	},
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
local interior_medium_navlink = {
	values = {
		interval = 7,
	},
	so_access_filter = so_access.no_heavyweight,
}

local interior_fast_navlink = deep_clone(interior_medium_navlink)
interior_fast_navlink.values.interval = 5

local interior_slow_navlink = deep_clone(interior_medium_navlink)
interior_slow_navlink.values.interval = 9

return {
	-- Combine some navigation areas
	[141003] = {
		ai_area = {
			{ 2, 66 },
			{ 16, 72 },
			{ 29, 88 },
			{ 31, 95, 96 },
			{ 34, 81 },
			{ 36, 47, 179 },
			{ 38, 89 },
			{ 39, 86 },
			{ 53, 80 },
			{ 55, 105 },
			{ 71, 78 },
			{ 79, 82 },
			{ 87, 90, 91, 92, 93, 94 },
		},
	},
	-- add custom alert trigger
	[100107] = {
		on_executed = {
			{ id = 400023, delay = 0 },
		},
	},
	-- alert Sosa's men when there are gunshots or explosions
	[400024] = {
		func = function()
			for _, u_data in pairs(managers.enemy:all_enemies()) do
				u_data.unit:movement():set_cool(false)
			end
		end,
	},
	-- FFO
	[101103] = {
		ponr = {
			length = 360,
			length_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	-- Disable bad navlink
	[101057] = disabled,
	-- Add some reinforce around the house
	[100129] = { -- Preferred
		reinforce = {
			{
				name = "mansion_left",
				force = 2,
				position = Vector3(-1500, -5250, -50),
			},
			{
				name = "mansion_back",
				force = 2,
				position = Vector3(-3500, -1900, -50),
			},
			{
				name = "mansion_front",
				force = 2,
				position = Vector3(4100, -3175, -150),
			},
			{
				name = "mansion_right",
				force = 2,
				position = Vector3(1400, 2650, -175),
			},
		},
	},
	-- Enter main hall
	[103594] = {
		add_drama = {
			amount = 1,
			balance_mul = { 1, 1, 1, 1 },
			team_ai_balance_mul_weight = 1,
			ignore_gain_mul = true,
		},
		forced_difficulty = {
			amount = 0.1,
			time = { 30, 45 },
			delay = 0,
		},
	},
	-- Boss dead, safe objective
	[101169] = {
		reinforce = {
			{
				name = "main_hall",
				force = 3,
				position = Vector3(-1700, -1075, 50),
			},
		},
		on_executed = {
			{ id = 400026, delay = 0 },
		},
		forced_difficulty = false, -- disable forced difficulty
	},
	-- Disable Sosa retreat on low health during boss fight
	[101596] = disabled,
	-- Fallback to make Sosa retreat when house is accessible
	[102653] = {
		on_executed = {
			{ id = 102692, delay = 0 },
		},
	},
	-- Change Sosa's line to more appropriate one (having a chance to say the famous Scarface quote)
	[101485] = {
		values = {
			sound_event = "Play_bos_fri_04",
		},
	},
	-- Disable vanilla bag instance requirments
	[100165] = disabled,
	-- Disable vanilla reinforce
	-- Timed objective/escape zone reinforce BORING
	[100007] = disabled,
	[100207] = disabled,
	[100208] = disabled,
	[100210] = disabled,
	-- Only boat escape
	[100213] = disabled,
	[100214] = disabled,
	[103446] = disabled,
	-- Tweak navlink access and intervals
	[101062] = interior_slow_navlink,
	[100168] = interior_slow_navlink,
	[100169] = interior_slow_navlink,
	[100173] = interior_slow_navlink,
	[100176] = interior_slow_navlink,
	[100179] = interior_slow_navlink,
	[101025] = interior_medium_navlink,
	[101026] = interior_medium_navlink,
	[101085] = interior_medium_navlink,
	[101086] = interior_medium_navlink,
	[102454] = interior_fast_navlink,
	[102529] = interior_fast_navlink,
	-- Tweak spawn actions to look less bizarre
	[102379] = wall_spawn_action,
	[102377] = wall_spawn_action,
	[101039] = wall_spawn_action,
	[101038] = wall_spawn_action,
	[101036] = wall_spawn_action,
	-- Replace Vanilla's singular Cloaker group with custom groups
	[100845] = { -- ai_enemy_prefered_add_001
		values = {
			spawn_groups = {
				400035,
				400036,
				400037,
				400038,
				400039,
				400040,
				400041,
				400042,
			},
		},
	},
	-- Scripted difficulty scaling
	[102074] = { -- complete_objective017 (Mansion opened)
		on_executed = {
			{ id = 400025, delay = 0 },
		},
	},
	--You're Sosa's men, not undercover cops
	[100852] = mobster_team,
	[100854] = mobster_team,
	[100855] = mobster_team,
	[100856] = mobster_team,
	[100857] = mobster_team,
	[100858] = mobster_team,
	[100858] = mobster_team,
	[100859] = mobster_team,
	[100860] = mobster_team,
	[100861] = mobster_team,
	[100862] = mobster_team,
	[100863] = mobster_team,
	[101185] = mobster_team,
	[101185] = mobster_team,
	[101189] = mobster_team,
	[101771] = mobster_team,
	[102301] = mobster_team,
	[102395] = mobster_team,
	[102399] = mobster_team,
	[102404] = mobster_team,
	[102408] = mobster_team,
	[102419] = mobster_team,
	[102421] = mobster_team,
	[102532] = mobster_team,
	[102535] = mobster_team,
	[102538] = mobster_team,
	[102540] = mobster_team,
	[102542] = mobster_team,
	[102544] = mobster_team,
	[102546] = mobster_team,
	[102548] = mobster_team,
	[102550] = mobster_team,
	[102553] = mobster_team,
	[102557] = mobster_team,
	[102559] = mobster_team,
	[102562] = mobster_team,
	[102565] = mobster_team,
	[102569] = mobster_team,
	[102572] = mobster_team,
	[102576] = mobster_team,
	[102578] = mobster_team,
	[102581] = mobster_team,
	[102583] = mobster_team,
	-- Spawn group intervals
	[400035] = cloaker_spawn,
	[400036] = cloaker_spawn,
	[400037] = cloaker_spawn,
	[400038] = cloaker_spawn,
	[400039] = cloaker_spawn,
	[400040] = cloaker_spawn,
	[400041] = cloaker_spawn,
	[400042] = cloaker_spawn,
}
