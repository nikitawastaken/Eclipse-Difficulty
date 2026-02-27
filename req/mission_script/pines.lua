local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}

local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
return {
	-- Add new reinforce
	[100109] = { -- Police
		reinforce = {
			{
				name = "lumber",
				force = 2,
				position = Vector3(-8100, 14500, 4255),
			},
			{
				name = "zipline",
				force = 2,
				position = Vector3(-10200, 9800, 3700),
			},
			{
				name = "wreckage",
				force = 2,
				position = Vector3(-3100, 10150, 2975),
			},
			{
				name = "logging_machine",
				force = 2,
				position = Vector3(-8895, 8000, 3115),
			},
			{
				name = "cliff",
				force = 2,
				position = Vector3(-11675, 11550, 4150),
			},
		},
	},
	-- disable endless assault (the heist doesn't need one)
	[101473] = disabled,
	-- cloaker spawngroup stuff
	[400026] = cloaker_spawn,
	[400027] = cloaker_spawn,
	[400028] = cloaker_spawn,
	[400029] = cloaker_spawn,
	[400030] = cloaker_spawn,
	[400031] = cloaker_spawn,
	[400032] = cloaker_spawn,
	[400033] = cloaker_spawn,
}
