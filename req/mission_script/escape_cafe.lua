local preferred = Eclipse.preferred
local roof_spawn = {
	values = {
		interval = 15,
	},
}
return {
	[101377] = { -- enable main preferreds
		reinforce = {
			{
				name = "blockade1",
				force = 3,
				position = Vector3(-550, -5675, 550),
			},
			{
				name = "blockade2",
				force = 3,
				position = Vector3(-5800, -150, 550),
			},
			{
				name = "blockade3",
				force = 3,
				position = Vector3(800, 5250, 550),
			},
		},
	},
	-- Spawn group intervals
	[101200] = roof_spawn,
}
