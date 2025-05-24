local preferred = Eclipse.preferred
local reinforce_amount = {
	values = {
		amount = 3,
	},
}
local street_spawn = {
	values = {
		interval = 15,
	},
}
local elevator_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_snipers,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_group = {
	values = {
		interval = 120,
	},
}
return {
	[107196] = {
		ponr = {
			length = 60,
			player_mul = { 2.5, 1.5, 1, 1 },
		},
	},
	[101871] = reinforce_amount,
	[105167] = reinforce_amount,
	-- Spwnn group delays
	[101385] = street_spawn,
	[105699] = street_spawn,
	[105705] = street_spawn,
	[100960] = street_spawn,
	[100963] = elevator_spawn,
	[100961] = window_spawn,
	[100962] = window_spawn,
	[103968] = cloaker_group,
	[103969] = cloaker_group,
	[103971] = cloaker_group,
	[103972] = cloaker_group,
	[103973] = cloaker_group,
	[103974] = cloaker_group,
	[103975] = cloaker_group,
}
