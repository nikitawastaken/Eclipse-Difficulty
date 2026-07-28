local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
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
local disabled = {
	values = {
		enabled = false,
	},
}
local loot_weapons_chance = {
	chance = 20 + (is_pro_job and 5 or 0),
}
local loot_coke_chance = {
	chance = 30 + (is_pro_job and 5 or 0),
}
local loot_gold_chance = {
	chance = 10 + (is_pro_job and 10 or 0),
}
local loot_money_train_chance = {
	chance = 40 + (is_pro_job and 10 or 0),
}
return {
	[107143] = {
		ponr = {
			length = 90,
			length_balance_mul = { 2.5, 1.5, 1, 1 },
		},
	},
	-- Additional flee points
	[102375] = {
		flee_point = {
			{ name = "side", position = Vector3(-3900, -50, 1) },
			{ name = "street", position = Vector3(4600, 4600, 1) },
		},
	},
	-- disable the goat
	[100797] = disabled,
	-- tweak the confiscated loot chance
	[102728] = loot_coke_chance,
	[102731] = loot_money_train_chance,
	[102743] = loot_weapons_chance,
	[102747] = loot_gold_chance,
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
