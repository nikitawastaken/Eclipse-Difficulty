local preferred = Eclipse.preferred
local skylight_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	--[[ Delay SWAT response
	[100224] = {
		on_executed = {
			{ id = 101903, delay = 60 }, -- FIGURE OUT A WAY TO IMPLEMENT THIS BETTER
		},
	}, 
	]]
	[101620] = {
		reinforce = {
			{
				name = "stairs_right",
				force = 2,
				position = Vector3(375, -3675, 300),
			},
			{
				name = "stairs_left",
				force = 2,
				position = Vector3(-350, -3675, 300),
			},
			{
				name = "balcony_right",
				force = 2,
				position = Vector3(750, -2400, 500),
			},
			{
				name = "balcony_left",
				force = 2,
				position = Vector3(-675, -2400, 500),
			},
		},
	},
	[100379] = {
		reinforce = {
			{ name = "stairs_right" },
			{ name = "stairs_left" },
			{ name = "balcony_right" },
			{ name = "balcony_left" },
			{
				name = "security",
				force = 3,
				position = Vector3(125, 1575, 100),
			},
		},
	},
	-- Spawn group delays
	[103218] = skylight_spawn,
}
