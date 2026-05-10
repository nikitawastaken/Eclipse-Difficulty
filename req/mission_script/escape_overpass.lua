local disabled = {
	values = {
		enabled = false,
	},
}

return {
	-- Infinite assault at the very start
	[102194] = { -- func_difficulty_002 
		hunt = true,
	},
	[102047] = { -- obj1_complete
		set_ponr_state = true,
	},
	-- Disable vanilla reinforce
	[101877] = disabled,
	[101880] = disabled,
	[101883] = disabled,
	[101884] = disabled,
	[101885] = disabled,
	[101886] = disabled,
	-- Add reinforce
	[101355] = { -- enable_all_preferreds
		reinforce = {
			{
				name = "overpass01",
				force = 3,
				position = Vector3(-300, 4650, 5000),
			},
			{
				name = "overpass02",
				force = 3,
				position = Vector3(-3100, 1800, 5000),
			},
			{
				name = "overpass03",
				force = 3,
				position = Vector3(1600, 7800, 5000),
			},
		},
	},
}
