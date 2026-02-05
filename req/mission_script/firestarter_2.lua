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
		interval = 15,
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
			length = 90,
			player_mul = { 2.5, 1.5, 1, 1 },
		},
	},
	-- Additional flee points
	[102375] = {
		flee_point = {
			{ name = "side", position = Vector3(-3900, -50, 1) },
			{ name = "street", position = Vector3(4600, 4600, 1) },
		},
	},
	-- Increase reinforce
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
