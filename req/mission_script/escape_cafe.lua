local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
return {
	-- Infinite assault at the very start
	[101378] = { -- func_difficulty_001
		hunt = true,
	},
	[100252] = { -- obj1_complete
		set_ponr_state = true,
	},
	-- Add reinforce
	[101377] = { -- enable main preferreds
		reinforce = {
			{
				name = "cafe01",
				force = 2,
				position = Vector3(-550, -5675, 550),
			},
			{
				name = "cafe02",
				force = 2,
				position = Vector3(-5800, -150, 550),
			},
			{
				name = "cafe03",
				force = 2,
				position = Vector3(800, 5250, 550),
			},
		},
	},
	-- Spawn group intervals
	[101348] = standard_spawn,
	[101359] = standard_spawn,
	[101360] = standard_spawn,
	[101200] = standard_spawn,
}
