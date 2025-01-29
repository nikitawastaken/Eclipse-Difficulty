local disabled = {
	values = {
		enabled = false
	}
}

return {
	[103501] = disabled,
	[103051] = disabled,
	--Reinforce Spots
	[102477] = {
		reinforce = {
			{
				name = "traincar1",
				force = 3,
				position = Vector3(-6220, 5800, 450)
			},
			{
				name = "traincar2",
				force = 3,
				position = Vector3(-3220, 4790, 450)
			},
			{
				name = "traincar3",
				force = 3,
				position = Vector3(2090, 5770, 450)
			}
		}
	}
}
