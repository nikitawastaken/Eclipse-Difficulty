local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local army_guard = scripted_enemy.soldier_1
local one_additional_crowbar_chance = math.random() <= 0.5
local security_army = {
	enemy = army_guard,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local upper_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local upper_spawn_why_does_it_have_1_spawn_point = {
	values = {
		interval = upper_spawn.values.interval,
		interval_balance_mul = upper_spawn.values.interval_balance_mul,
		elements = { 101848, 108178, 108177, 108176, 108175 },
	},
}
local ship_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local crowbar_amount = {
	values = {
		amount = one_additional_crowbar_chance and 3 or 2,
	},
}
local roof_navlink_interval = {
	values = {
		interval = 5, -- (Vanilla: 2s)
	},
}
local ship_navlink_interval = {
	values = {
		interval = 7, -- (Vanilla: 2s)
	},
}
local ladder_navlink_interval = {
	values = {
		interval = 9, -- (Vanilla: 2s)
	},
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
	[107785] = disabled,
	-- Add new reinforce
	[101540] = { -- police_called
		reinforce = {
			{
				name = "gate01",
				force = 4,
				position = Vector3(-3300, -3200, 25),
			},
			{
				name = "gate02",
				force = 4,
				position = Vector3(2200, -3200, 25),
			},
			{
				name = "crane01",
				force = 3,
				position = Vector3(2000, 600, 125),
			},
			{
				name = "crane02",
				force = 3,
				position = Vector3(-4500, 600, 125),
			},
			{
				name = "wagon01",
				force = 2,
				position = Vector3(-2900, 2900, 500),
			},
			{
				name = "wagon02",
				force = 2,
				position = Vector3(-3700, 100, 500),
			},
			{
				name = "roof01",
				force = 2,
				position = Vector3(5350, -1700, 650),
			},
			{
				name = "roof02",
				force = 2,
				position = Vector3(5350, -3050, 650),
			},
		},
	},
	-- increase the amount of crowbars by 2-3
	[102223] = crowbar_amount,
	[102224] = crowbar_amount,
	[102274] = crowbar_amount,
	-- Reduce the number of spawngroups on the left side during the computer hack
	[104053] = { -- enemies_dockyard_left_add
		values = {
			spawn_groups = {
				104040,
				--		101771,
				--		101772,
				102043,
				101574,
			},
		},
	},
	-- Two of the spawnpoints of this group are way too far away from the main group
	[104040] = { -- swat_group_04
		values = {
			elements = {
				100814,
				100812,
				100810,
			},
		},
	},
	-- Add circuit breaker SO delay
	[102302] = {
		on_executed = {
			{ id = 104665, delay = 30, delay_rand = 30 },
		},
	},
	-- Disable very imaginative vanilla reinforce
	[102661] = disabled, -- min_force_van_escape
	[102663] = disabled, -- min_force_chopper_escape
	-- Increase navlink intervals
	-- e_nl_down_5_5m
	[101655] = roof_navlink_interval,
	[105061] = roof_navlink_interval,
	[101654] = roof_navlink_interval,
	[101653] = roof_navlink_interval,
	[105059] = roof_navlink_interval,
	[101650] = roof_navlink_interval,
	[101649] = roof_navlink_interval,
	[101648] = roof_navlink_interval,
	[105057] = roof_navlink_interval,
	[101645] = roof_navlink_interval,
	[101646] = roof_navlink_interval,
	[101644] = roof_navlink_interval,
	[101647] = roof_navlink_interval,
	[105042] = roof_navlink_interval,
	[105043] = roof_navlink_interval,
	[105044] = roof_navlink_interval,
	[105045] = roof_navlink_interval,
	[105046] = roof_navlink_interval,
	[105047] = roof_navlink_interval,
	[105048] = roof_navlink_interval,
	-- e_nl_up_1_fwd_1_5m
	[101456] = ship_navlink_interval,
	[101458] = ship_navlink_interval,
	[101463] = ship_navlink_interval,
	[101464] = ship_navlink_interval,
	[101466] = ship_navlink_interval,
	[101469] = ship_navlink_interval,
	[101470] = ship_navlink_interval,
	-- e_nl_cs_up_long_ladder
	[103709] = ladder_navlink_interval,
	[103711] = ladder_navlink_interval,
	-- e_nl_cs_up_front_ladder
	[103712] = ladder_navlink_interval,
	[102136] = ladder_navlink_interval,
	-- Spawn group intervals
	[104040] = upper_spawn,
	[101771] = upper_spawn,
	[101772] = upper_spawn,
	[108179] = upper_spawn,
	[101770] = upper_spawn_why_does_it_have_1_spawn_point,
	[101630] = ship_spawn,
	[102887] = ship_spawn,
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
