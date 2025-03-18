local disabled = {
	values = {
		enabled = false,
	},
}
local alleyway_spawn = {
	values = {
		interval = 30,
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
	-- Spawn point delays
	[100089] = alleyway_spawn,
	[100143] = alleyway_spawn,
}
