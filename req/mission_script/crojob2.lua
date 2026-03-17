local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local army_guard = scripted_enemy.soldier_1
local security_army = {
	enemy = army_guard,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local close_spawn = {
	values = {
		interval = 15,
	},
}
local upper_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 2, 1.66, 1.33, 1 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[101531] = {
		ai_area = {
			{ 6, 85 },
			{ 74, 157 },
			{ 143, 175 },
		},
	},
	[104838] = {
		ponr = {
			length = 240,
			length_balance_mul = { 1.25, 1.125, 1, 1 },
		},
	},
	[106867] = disabled,
	[104040] = { -- This spawngroup is split
		values = {
			interval = fence_spawn.interval,
			elements = {
				--	105353,
				--	105354,
				100810,
				100812,
				100814,
			},
		},
	},
	-- Add new reinforce
	[101882] = {
		reinforce = {
			{
				name = "crane01",
				force = 2,
				position = Vector3(-4500, 600, 125),
			},
			{
				name = "crane02",
				force = 2,
				position = Vector3(2100, 550, 125),
			},
			{
				name = "wagon01",
				force = 2,
				position = Vector3(-2900, 2900, 500),
			},
			{
				name = "wagon02",
				force = 2,
				position = Vector3(-3700, 0, 500),
			},
		},
	},
	-- Disable very imaginative vanilla reinforce
	[101167] = disabled, -- min_force_hacking_left_ON
	[101168] = disabled, -- min_force_hacking_right_ON
	[102661] = disabled, -- min_force_van_escape
	[102663] = disabled, -- min_force_chopper_escape
	-- Spawn group intervals
	[101768] = close_spawn,
	[101769] = close_spawn,
	[100869] = close_spawn,
	[101574] = close_spawn,
	[104040] = close_spawn,
	[101630] = upper_spawn,
	[101770] = upper_spawn,
	[101771] = upper_spawn,
	[101772] = upper_spawn,
	[102887] = upper_spawn,
	[108179] = upper_spawn,
	--National Guard instead of regular security
	[101764] = security_army,
	[101317] = security_army,
	[101318] = security_army,
	[101765] = security_army,
	[101939] = security_army,
	[101940] = security_army,
	[101941] = security_army,
	[101942] = security_army,
	[101943] = security_army,
	[101944] = security_army,
	[102917] = security_army,
	[103678] = security_army,
	[103679] = security_army,
	[103680] = security_army,
	[103681] = security_army,
	[103682] = security_army,
	[103691] = security_army,
	[100051] = security_army,
	[100171] = security_army,
	[101113] = security_army,
	[101238] = security_army,
	[102495] = security_army,
	[102751] = security_army,
	[103303] = security_army,
	[106011] = security_army,
	[106015] = security_army,
	[106019] = security_army,
	[106020] = security_army,
	[106138] = security_army,
	[106141] = security_army,
}
