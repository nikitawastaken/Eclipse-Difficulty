local side_building1 = {
	values = {
		interval = 15
	}
}
local side_building2 = {
	values = {
		interval = 15
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
	},
}
local side_building3 = {
	values = {
		interval = 25
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
	},
}
local upper_floor = {
	values = {
		interval = 20
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
	},
}
local atrium_spawn = {
	values = {
		interval = 30,
	},
}
local archives_spawn = {
	values = {
		interval = 45
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
return {
	-- add ponr state
	[102221] = {
		set_ponr_state = true
	},
	[101871] = {
		values = {
			enabled = false
		}
	},
	[101890] = {
		values = {
			on_executed = {
				{ delay = 0, id = 101891 },
				{ delay = 0, id = 102016 },
				{ delay = 0, id = 102218 },
				{ delay = 0, id = 101374 },
				{ delay = 0, id = 102239  },
				{ delay = 12, id = 102354 },
				{ delay = 0, id = 100087 },
			}
		}
	},
	-- spawnpoint delays
	[101662] = side_building1,
	[100140] = side_building1,
	[101672] = side_building2
	[101677] = side_building2,
	[100139] = side_building2,
	[100007] = side_building3,
	[101667] = side_building3,
	[100694] = upper_floor,
	[101441] = upper_floor,
	[100131] = upper_floor,
	[100128] = atrium_spawn,
	[100130] = atrium_spawn,
	[101687] = archives_spawn,
	[101682] = archives_spawn,
	[101688] = {
		values = {
			interval = 25
		},
		groups = {
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false,
			tac_bull_rush = false,
		},
	}
}
