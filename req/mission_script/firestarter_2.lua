local preferred = Eclipse.preferred
return {
	[107196] = {
		ponr = {
			length = 60,
			player_mul = { 2.5, 1.5, 1, 1 },
		},
	},
	[100963] = {
		values = {
			interval = 15,
		},
	},
	[100962] = {
		values = {
			interval = 20,
		},
		groups = preferred.no_cops_agents_shields_bulldozers,
	},
	[100961] = {
		values = {
			interval = 30,
		},
		groups = preferred.no_cops_agents,
	},
}
