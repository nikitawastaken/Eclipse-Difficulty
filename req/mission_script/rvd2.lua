local taser = scripted_enemy.taser

return {
	-- Replace dozer spam with less stupid enemies
	[101565] = {
		enemy = taser
	},
	[101176] = {
		enemy = taser
	},
	[101207] = {
		enemy = taser
	},
	[102176] = {
		values = {
			enabled = false
		}
	},
	-- instantly enter full force onslaught upon securing all bags
	[100884] = {
		set_ponr_state = true
	}
}
