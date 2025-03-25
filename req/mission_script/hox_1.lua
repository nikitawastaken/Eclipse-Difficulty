local preferred = Eclipse.preferred

local van_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local flank_spawn = {
	values = {
		interval = 15,
	},
}
local upper_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
return {
	-- add point of no return
	[100580] = {
		ponr = {
			length = 600,
			player_mul = { 1.8, 1.5, 1.3, 1.2 },
		},
	},
	[100124] = {
		values = {
			difficulty = 0.75,
		},
	},
	-- spawn point delays
	[100128] = van_spawn,
	[100130] = van_spawn,
	[100131] = van_spawn,
	[100132] = van_spawn,
	[101719] = flank_spawn,
	[101728] = flank_spawn,
	[101731] = flank_spawn,
	[101791] = flank_spawn,
	[101722] = upper_spawn,
	[101725] = upper_spawn,
	[101734] = upper_spawn,
	[101737] = upper_spawn,
	[101789] = upper_spawn,
}
