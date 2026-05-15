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
local close_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
}
local close_spawn_why_does_it_have_1_spawn_point = {
	values = {
		interval = close_spawn.values.interval,
		interval_balance_mul = close_spawn.values.interval_balance_mul,
		elements = { 101848, 108178, 108177, 108176, 108175 },
	},
}
local crowbar_amount = {
	values = {
		amount = one_additional_crowbar_chance and 3 or 2,
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
	[106867] = disabled,
	-- Add new reinforce
	[101540] = { -- police_called
		reinforce = {
			{
				name = "crane01",
				force = 3,
				position = Vector3(-4500, 600, 125),
			},
			{
				name = "crane02",
				force = 3,
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
	-- Add circuit breaker SO delay
	[102302] = {
		on_executed = {
			{ id = 104665, delay = 30, delay_rand = 30 },
		},
	},
	-- Disable very imaginative vanilla reinforce
	[101167] = disabled, -- min_force_hacking_left_ON
	[101168] = disabled, -- min_force_hacking_right_ON
	[102661] = disabled, -- min_force_van_escape
	[102663] = disabled, -- min_force_chopper_escape
	-- Spawn group intervals
	[101630] = close_spawn,
	[102887] = close_spawn,
	[104040] = close_spawn,
	[101771] = close_spawn,
	[101772] = close_spawn,
	[108179] = close_spawn,
	[101770] = close_spawn_why_does_it_have_1_spawn_point,
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
