local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local skylight_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
return {
	-- Delay enemy spawns
	[100224] = { -- Combat ON
		on_executed = {
			{ id = 101024, delay = 60 }, -- elevators
		},
	},
	[101907] = { -- start enemies delay end
		on_executed = {
			{ id = 100230, delay = 90 }, -- wall spawns
		},
	},
	-- Remove vanilla reinforce
	[103204] = disabled,
	[103205] = disabled,
	[103206] = disabled,
	[103207] = disabled,
	[103209] = disabled,
	-- New reinforce points
	[100229] = { -- enemies add
		reinforce = {
			{
				name = "exterior_entrance",
				force = 4,
				position = Vector3(0, -8000, 0),
			},
			{
				name = "exterior_right1",
				force = 2,
				position = Vector3(3400, -2600, 20),
			},
			{
				name = "exterior_right2",
				force = 2,
				position = Vector3(2200, -5400, 20),
			},
			{
				name = "exterior_left1",
				force = 2,
				position = Vector3(-3000, -3200, 20),
			},
			{
				name = "exterior_left2",
				force = 2,
				position = Vector3(-2900, -5500, 20),
			},
		},
	},
	[101620] = { -- assemble the winch
		reinforce = {
			{
				name = "bar",
				force = 3,
				position = Vector3(20, -4000, 10),
			},
			{
				name = "interior_balcony1",
				force = 2,
				position = Vector3(-1300, -550, 600),
			},
			{
				name = "interior_balcony2",
				force = 2,
				position = Vector3(1200, 600, 600),
			},
			{
				name = "interior_balcony3",
				force = 2,
				position = Vector3(-1300, -2400, 500),
			},
			{
				name = "interior_balcony4",
				force = 2,
				position = Vector3(1300, -2400, 500),
			},
		},
	},
	[100379] = { -- drill done
		reinforce = {
			{
				name = "security1",
				force = 2,
				position = Vector3(-1100, 1500, 100),
			},
			{
				name = "security2",
				force = 2,
				position = Vector3(1000, 1500, 100),
			},
		},
	},
	-- Spawn group delays
	[103218] = skylight_spawn,
	[102035] = cloaker_spawn,
	[102036] = cloaker_spawn,
	[102037] = cloaker_spawn,
	[102038] = cloaker_spawn,
}
