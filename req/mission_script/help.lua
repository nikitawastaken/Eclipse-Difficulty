local preferred = Eclipse.preferred

local spawn_so = {
	values = {
		so_action = "e_nl_down_9_3m_rappel",
	},
}

local window_far_spawn = {
	values = {
		interval = 15,
	},
}
local bridge_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local water_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local upper_far_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields,
}
local upper_close_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}
local window_close_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_shields_bulldozers,
}
local portal_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

return {
	-- Fix Prison Nightmare SO animations
	[100347] = spawn_so,
	[100348] = spawn_so,
	[100349] = spawn_so,
	[100351] = spawn_so,
	[100352] = spawn_so,
	[100353] = spawn_so,
	[100354] = spawn_so,
	[100355] = spawn_so,
	[100360] = spawn_so,
	-- Add new reinforce to make up for slower spawn groups.
	[100178] = {
		reinforce = {
			{
				name = "canteen",
				force = 2,
				position = Vector3(-50, -1200, 40),
			},
			{
				name = "security",
				force = 2,
				position = Vector3(0, -2600, 450),
			},
			{
				name = "zipline",
				force = 2,
				position = Vector3(-5000, -6250, 400),
			},
			{
				name = "stairs",
				force = 2,
				position = Vector3(-2950, -4700, 25),
			},
		},
	},
	-- Make difficulty scaling faster
	[100122] = {
		values = {
			counter_target = 2,
		},
	},
	[100062] = {
		values = {
			counter_target = 3,
		},
	},
	[100521] = {
		difficulty = 1,
	},
	-- Spawn group delays
	-- This heist is pretty cramped and also has verticality, which makes having all those spawn groups packed so close to each other especially egregious. What's new?
	-- Every spawn group has had its interval increased, I frankly couldn't justify keeping any of them below 15s.
	-- You will immediately notice fewer enemies spawning from the lake at the start, but also much slower catwalk spawns inside the prison.
	-- A lot of spawngroups have also been made inaccessible to Bulldozers and Shields to ensure that they don't spawn on top of you.
	[100933] = window_far_spawn,
	[101369] = window_far_spawn,
	[100554] = water_spawn,
	[100575] = upper_far_spawn,
	[100618] = upper_far_spawn,
	[100619] = upper_far_spawn,
	[100631] = upper_far_spawn,
	[100673] = upper_far_spawn,
	[101050] = upper_far_spawn,
	[101056] = upper_far_spawn,
	[100576] = bridge_spawn,
	[100419] = upper_close_spawn,
	[100659] = upper_close_spawn,
	[100659] = upper_close_spawn,
	[100900] = upper_close_spawn,
	[100906] = upper_close_spawn,
	[100939] = upper_close_spawn,
	[100955] = upper_close_spawn,
	[100907] = window_close_spawn,
	[100913] = window_close_spawn,
	[100932] = window_close_spawn,
	[100684] = flank_spawn,
	[100921] = flank_spawn,
	[101143] = portal_spawn,
	[101160] = portal_spawn,
	[101161] = portal_spawn,
	[101162] = portal_spawn,
	[101163] = portal_spawn,
}
