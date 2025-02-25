local scripted_enemy = Eclipse.scripted_enemy
local taser = scripted_enemy.taser

local ambush_enemy = {
	values = {
		enemy = taser,
	},
}

return {
	-- Replace dozer spam with less stupid enemies
	[101565] = ambush_enemy,
	[101176] = ambush_enemy,
	[101207] = ambush_enemy,
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
