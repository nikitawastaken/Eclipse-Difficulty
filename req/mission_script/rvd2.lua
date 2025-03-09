local scripted_enemy = Eclipse.scripted_enemy
local taser = scripted_enemy.taser_1
local taser_shotgun = scripted_enemy.taser_2

local ambush_enemy_1 = {
	values = {
		enemy = taser,
	},
}
local ambush_enemy_2 = {
	values = {
		enemy = taser_shotgun,
	},
}

return {
	-- Replace dozer spam with less stupid enemies
	[101565] = ambush_enemy_1,
	[101176] = ambush_enemy_2,
	[101207] = ambush_enemy_1,
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
