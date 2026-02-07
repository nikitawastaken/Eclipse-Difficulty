local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local standard_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local garage_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local elevator_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local bags_required = {
	values = {
		counter_target = 4 + (is_pro_job and 2 or 0),
	},
}
return {
	-- Add new reinforce
	[102576] = {
		reinforce = {
			{
				name = "lobby",
				force = 3,
				position = Vector3(-300, 550, 0),
			},
			{
				name = "gensec",
				force = 2,
				position = Vector3(-325, 4450, -275),
			},
			{
				name = "basement",
				force = 2,
				position = Vector3(-2125, 2650, -800),
			},
			{
				name = "merch",
				force = 2,
				position = Vector3(-4975, 2950, 225),
			},
			{
				name = "curly",
				force = 2,
				position = Vector3(-5200, 825, 625),
			},
			{
				name = "sushi",
				force = 2,
				position = Vector3(-3350, 3225, 825),
			},
			{
				name = "red_kitchen",
				force = 2,
				position = Vector3(-3850, 1950, 225),
			},
			{
				name = "blue_kitchen",
				force = 2,
				position = Vector3(-2400, 4275, 225),
			},
			{
				name = "yellow_kitchen",
				force = 2,
				position = Vector3(-3275, 4900, 825),
			},
			{
				name = "green_kitchen",
				force = 2,
				position = Vector3(900, 4352, 825),
			},
		},
		on_executed = {
			{ id = 400002, delay = 0, delay_rand = 30 }, -- Lobby preferreds
			{ id = 400018, delay = 30, delay_rand = 30 }, -- Area report triggers
		},
	},
	[100123] = { -- end assault
		on_executed = {
			{ id = 400012, delay = 0, delay_rand = 30 }, -- Diff increase preferreds
		},
	},
	-- Add a new loot drop point
	[100405] = disabled,
	[102864] = {
		loot_drop = {
			{ name = "player_spawn", position = Vector3(-300, -250, 0) },
		},
	},
	-- Change amount of required bags
	-- The amount of required bags in vanilla sucks so hard
	[101753] = bags_required,
	[101758] = bags_required,
	[101759] = bags_required,
	[101760] = bags_required,
	[101761] = bags_required,
	[100470] = disabled,
	-- Disable all vanilla reinforce points, we have our own
	[102054] = disabled,
	[102055] = disabled,
	[102079] = disabled,
	[102069] = disabled,
	[102051] = disabled,
	[102070] = disabled,
	[102052] = disabled,
	[102053] = disabled,
	[102091] = disabled,
	[102062] = disabled,
	-- Disable all vanilla preferreds, replace them with custom ones
	[101167] = disabled,
	[101660] = disabled,
	[101649] = disabled,
	[101650] = disabled,
	[101651] = disabled,
	[101652] = disabled,
	[101653] = disabled,
	[101655] = disabled,
	[101656] = disabled,
	[101658] = disabled,
	[101659] = disabled,
	-- Spawn group intervals
	[100128] = standard_spawn,
	[100132] = standard_spawn,
	[101166] = standard_spawn,
	[101309] = standard_spawn,
	[104406] = standard_spawn,
	[104471] = standard_spawn,
	[101310] = garage_spawn,
	[102066] = garage_spawn,
	[100805] = elevator_spawn,
	[101555] = elevator_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
}
