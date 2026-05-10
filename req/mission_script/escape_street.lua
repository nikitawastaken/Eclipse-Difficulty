return {	
	-- Infinite assault at the very start
	[102461] = { -- func_difficulty_002 
		hunt = true,
	},
	[101970] = { -- obj1_complete
		set_ponr_state = true,
	},
	-- Add reinforce
	[102508] = { -- activte all preferreds
		reinforce = {
			{
				name = "street01",
				force = 3,
				position = Vector3(-850, -2500, 0),
			},
			{
				name = "street03",
				force = 3,
				position = Vector3(2850, -1500, 0),
			},
			{
				name = "street04",
				force = 3,
				position = Vector3(2700, 1400, 0),
			},
		},
	},
}
