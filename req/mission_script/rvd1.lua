local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local roof_far_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents,
}
local roof_close_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local mortuary_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local difficulty_add_25 = {
	difficulty_add = 0.25,
}
local disable_car_reinforce = {
	reinforce = {
		{ name = "pink_car" },
	},
}
local cop_car_crash_amount = {
	values = {
		amount = is_eclipse and 2 or 1,
	},
}

return {
	[100115] = {
		ponr = {
			length = 900,
			length_balance_mul = { 2, 1.25, 1, 1 },
		},
	},
	-- 2 cop cars crashing down on Death Wish
	[100300] = cop_car_crash_amount,
	-- Add new reinforce
	[100109] = {
		reinforce = {
			{
				name = "warehouse01",
				force = 2,
				position = Vector3(1200, -2200, 0),
			},
			{
				name = "warehouse02",
				force = 2,
				position = Vector3(-150, -1250, 0),
			},
			{
				name = "warehouse03",
				force = 2,
				position = Vector3(-1500, -2200, 0),
			},
			{
				name = "warehouse04",
				force = 2,
				position = Vector3(-2925, -3400, -20),
			},
		},
	},
	-- Place the reinforce point near the car crash site
	[101096] = {
		reinforce = {
			{
				name = "pink_car",
				force = 2,
				position = Vector3(-3100, 1400, 0),
			},
		},
	},
	[101130] = disable_car_reinforce,
	[101095] = {
		reinforce = {
			{
				name = "pink_car",
				force = 2,
				position = Vector3(-2100, -1200, 0),
			},
		},
	},
	[101200] = disable_car_reinforce,
	[101101] = {
		reinforce = {
			{
				name = "pink_car",
				force = 2,
				position = Vector3(-400, 0, 0),
			},
		},
	},
	[101195] = disable_car_reinforce,
	[100545] = {
		reinforce = {
			{
				name = "pink_car",
				force = 2,
				position = Vector3(-4700, -2000, 0),
			},
		},
	},
	[101543] = disable_car_reinforce,
	-- Add scripted difficulty increases
	--	[101392] = difficulty_add_25, -- start_saw_pickup_location
	--	[100727] = difficulty_add_25, -- start_escape
	-- Spawn group intervals
	[100007] = roof_far_spawn,
	[100130] = roof_far_spawn,
	[100131] = roof_far_spawn,
	[101683] = roof_far_spawn,
	[101820] = roof_far_spawn,
	[100133] = roof_close_spawn,
	[101715] = roof_close_spawn,
	[100019] = mortuary_spawn,
}
