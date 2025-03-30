local preferred = Eclipse.preferred
local rear_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_bulldozers,	
}
local breach_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,	
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	-- Set difficulty
	[100648] = {
		difficulty = 0.5,
	},
	[101961] = {
		values = {
			difficulty = 0.5,
		},
	},
	[100812] = {
		values = {
			difficulty = 0.5,
		},
		on_executed = {
			{ id = 101495, delay = 0 },
		},
	},
	-- Spawn Group delays
	[102061] = rear_spawn,
	[102065] = rear_spawn,
	[101043] = rear_spawn,
	[101685] = breach_spawn,
	[101694] = breach_spawn,
	[102439] = breach_spawn,
	[104060] = cloaker_spawn,
	[104058] = cloaker_spawn,
	[104059] = cloaker_spawn,
	[104061] = cloaker_spawn,
}
