local disabled = {
	values = {
		enabled = false,
	},
}
local alleyway_spawn = {
	values = {
		interval = 15,
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
	-- Scripted difficulty scaling
	[101429] = { -- done_with_gas_objective
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	[100394] = { -- inside_basement
		on_executed = {
			{ id = 400002, delay = 0 },
		},
	},
	-- Spawn group intervals
	[100089] = alleyway_spawn,
	[100143] = alleyway_spawn,
}
