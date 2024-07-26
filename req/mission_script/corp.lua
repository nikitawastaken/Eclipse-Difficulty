local enemy_filter_dozers = {
	values = {
		rules = {
			enemy_names = {
				"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
				"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
				"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
				"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"	
			}
		}
	}
}
return {
	[100115] = {
		reinforce = {
			{
				name = "admin",
				force = 2,
				position = Vector3(-5600, 1200, -200)
			},
			{
				name = "parkinglot",
				force = 2,
				position = Vector3(6000, 5100, 0)
			},
			{
				name = "garden",
				force = 2,
				position = Vector3(7200, -3900, 10)
			},
			{
				name = "labroof1",
				force = 2,
				position = Vector3(4000, 400, 670)
			},
			{
				name = "labroof2",
				force = 2,
				position = Vector3(-1200, 2600, 670)
			},
			{
				name = "statue",
				force = 3,
				position = Vector3(700, -75, 0)
			}
		}
	},
	--Update turret dozer filters to include benellidozer
	[102783] = enemy_filter_dozers,
	--DON'T DESPAWN THOSE UNITS, PLEASEEEEE! THEY ARE IMPORTANT!
	[103639] = enemy_filter_dozers,
	[103640] = enemy_filter_dozers,
	[103641] = enemy_filter_dozers,
	[103642] = enemy_filter_dozers,
	[103643] = enemy_filter_dozers,
	[103644] = enemy_filter_dozers
}