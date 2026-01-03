local preferred = Eclipse.preferred
local mobster_team = {
	values = {
		team = "mobster1",
	},
}
local roof_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local disabled = {
	values = {
		enabled = false,
	},
}
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
			{ 87, 90, 91, 92, 93, 94 }
		}
	},
	[101103] = {
		ponr = {
			length = 360,
			player_mul = { 1.25, 1.15, 1, 1 },
		},
	},
	-- Disable bad navlink
	[101057] = disabled,
	-- Enter main hall
	[103594] = {
		difficulty_max = 0.1,
	},
	-- Boss dead, safe objective
	[101169] = {
		difficulty_max = 1,
		difficulty_min = 1,
		reinforce = {
			{
				name = "main_hall",
				force = 4,
				position = Vector3(-1700, -1075, 50),
			},
		},
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
	-- disable vanilla bag instance requirments
	[100165] = disabled,
	-- Disable vanilla reinforce
	-- Timed objective/escape zone reinforce BORING
	[100007] = disabled,
	[100207] = disabled,
	[100208] = disabled,
	[100210] = disabled,
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
	-- Van escapes disable nearby spawngroups and reinforce
	[100240] = { -- add loot bag van 1
		reinforce = {
			{ name = "mansion_right" },
		},
		on_executed = {
			{ id = 400002, delay = 0 },
		},
	},
	[101208] = { -- add loot bag van 2
		reinforce = {
			{ name = "mansion_front" },
		},
		on_executed = {
			{ id = 400004, delay = 0 },
		},
	},
	-- Spawn group intervals
	[100206] = roof_spawn,
	[100719] = roof_spawn,
	[100810] = roof_spawn,
	[100921] = roof_spawn,
	[101920] = roof_spawn,
}
