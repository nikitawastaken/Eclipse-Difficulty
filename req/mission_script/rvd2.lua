local scripted_enemy = Eclipse.scripted_enemy
local taser = scripted_enemy.taser_1
local taser_shotgun = scripted_enemy.taser_2

local tasers = {
      taser,
      taser_shotgun,
}

return {
	-- Replace dozer spam with less stupid enemies
    [101565] = { enemy = tasers },
	[101176] = { enemy = tasers },
	[101207] = { enemy = tasers },
	[102176] = {
		values = {
			enabled = false,
		},
	},
	-- instantly enter full force onslaught upon securing all bags
	[100884] = {
		set_ponr_state = true,
	},
}
