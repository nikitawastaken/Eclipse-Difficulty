local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 15,
	},
}
return {
	[101377] = { -- enable main preferreds
		reinforce = {
			{
				name = "blockade01",
				force = 2,
				position = Vector3(-550, -5675, 550),
			},
			{
				name = "blockade02",
				force = 2,
				position = Vector3(-5800, -150, 550),
			},
			{
				name = "blockade03",
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
