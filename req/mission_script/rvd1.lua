local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local objective_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local mortuary_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
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
			length = 750,
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
	-- Spawn group intervals
	[100133] = objective_spawn,
	[101715] = objective_spawn,
	[100019] = mortuary_spawn,
}
