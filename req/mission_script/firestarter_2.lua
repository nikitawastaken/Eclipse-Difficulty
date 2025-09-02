local preferred = Eclipse.preferred
local reinforce_amount = {
	values = {
		amount = 3,
	},
}
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_group = {
	values = {
		interval = 90,
	},
}
local fbi_with_keycard = {
	values = {
		force_pickup = "keycard",
	},
}
return {
	[107143] = {
		ponr = {
			length = 60,
			player_mul = { 2.5, 1.5, 1, 1 },
		},
	},
	[101871] = reinforce_amount,
	[105167] = reinforce_amount,
	-- give keycard to fbi_1
	[103085] = fbi_with_keycard,
	[103092] = fbi_with_keycard,
	[103097] = fbi_with_keycard,
	-- Spwnn group delays
	[101385] = standard_spawn,
	[105699] = standard_spawn,
	[105705] = standard_spawn,
	[100960] = standard_spawn,
	[100963] = standard_spawn,
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
