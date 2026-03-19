local disabled = {
	values = {
		enabled = false,
	},
}
local alleyway_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
}
return {
	-- Improve reinforce spots
	[100022] = {
		reinforce = {
			{
				name = "touch_grass",
				force = 3,
				position = Vector3(2000, -900, 30),
			},
		},
	},
	[100589] = disabled,
	[100590] = disabled,
	-- Spawn group intervals
	[100089] = alleyway_spawn,
	[100143] = alleyway_spawn,
}
