local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local hub_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
}
local garage_door_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_shields,
}
local upper_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
}
local room_spawn = {
	values = {
		interval = 25,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_upper_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_lower_spawn = {
	values = {
		interval = 45,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
	groups = preferred.no_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	-- Combine some navigation areas
	[133029] = {
		ai_area = {
			{ 6, 7, 9, 10, 111, 113 },
			{ 27, 28 },
			{ 29, 57 },
			{ 44, 54, 56 },
			{ 45, 46 },
			{ 114, 115 },
		},
	},
	-- Add new reinforce
	[100304] = { -- objective_completed001
		reinforce = {
			{
				name = "main_hall",
				force = 5,
				position = Vector3(-120, -2400, 100),
			},
		},
		on_executed = {
			{ id = 400007, delay = 0 },
		},
	},
	[100286] = {
		ponr = { -- add point of no return
			length = 300,
			length_balance_mul = { 1.75, 1.25, 1, 1 },
		},
		reinforce = {
			{ name = "main_hall" },
		},
		on_executed = {
			{ id = 400008, delay = 0 },
			{ id = 400002, delay = 30, delay_rand = 30 }, -- Add a flanking group in the hub area
			{ id = 400006, delay = 0 }, -- Remove the flanking group in the intro area
		},
	},
	-- Scripted difficulty scaling
	[102855] = { -- complete_objective038
		on_executed = {
			{ id = 400009, delay = 0 },
		},
	},
	[100355] = { -- objective_started002
		on_executed = {
			{ id = 100800, delay = 0 }, -- Begin spawning Cloakers earlier
			{ id = 400004, delay = 30, delay_rand = 30 }, -- Add a flanking group in the intro area
		},
	},
	-- Disable a bunch of cheaty preferreds
	[100919] = disabled, -- weapon preferreds 6
	[101320] = disabled, -- biolab preferreds 6
	[101334] = disabled, -- books preferreds 4
	-- Spawn group intervals
	[102439] = hub_spawn,
	[107909] = garage_door_spawn,
	[108287] = garage_door_spawn,
	[100128] = upper_spawn,
	[107911] = upper_spawn,
	[101451] = upper_spawn,
	[104794] = upper_spawn,
	[107908] = upper_spawn,
	[107975] = upper_spawn,
	[107977] = upper_spawn,
	[108290] = upper_spawn,
	[108291] = upper_spawn,
	[108292] = upper_spawn,
	[100130] = room_spawn,
	[100131] = room_spawn,
	[100132] = room_spawn,
	[100133] = room_spawn,
	[100941] = room_spawn,
	[102407] = room_spawn,
	[107913] = room_spawn,
	[107979] = room_spawn,
	[107980] = room_spawn,
	[107981] = room_spawn,
	[107983] = room_spawn,
	[101074] = flank_upper_spawn,
	[101350] = flank_upper_spawn,
	[108289] = flank_lower_spawn,
	[400001] = flank_lower_spawn,
	[400004] = flank_lower_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
}
