local normal, hard, eclipse = Eclipse.utils.diff_groups()
local flank_spawn = {
	values = {
		interval = 10
	}
}
local roof_spawn = {
	values = {
		interval = 15
	},
	groups = {
		tac_shield_wall = false,
		tac_shield_wall_ranged = false,
		tac_shield_wall_charge = false,
		tac_bull_rush = false,
	},
}
local elevator_spawn = {
	values = {
		interval = 20
	}
}
local wall_c4_chance = {
	values = {
		chance = normal and 25 or hard and 50 or 75
	}
}
return {
	[100809] = {
		ponr = {
			length = 180,
			player_mul = { 2, 1.25, 1., 1 }
		}
	},
	[105844] = {
		reinforce = {
			{
				name = "meetingroom",
				force = 2,
				position = Vector3(-3400, 1000, -600)
			},
			{
				name = "outside_vault",
				force = 2,
				position = Vector3(-3000, 500, -1000)
			}
		}
	},
	[100834] = {
		reinforce = {
			{
				name = "elevator",
				force = 2,
				position = Vector3(-1200, -650, -900)
			},
		}
	},
	[104523] = {
		reinforce = {
			{
				name = "bus",
				force = 2,
				position = Vector3(-2150, -2050, -500)
			},
		}
	},
	-- enable roof spawngroups
	[100006] = {
		values = {
			spawn_groups = { 100019, 100007, 100692 }
		}
	},
	-- wall c4 chance
	[102451] = wall_c4_chance,
	[102469] = wall_c4_chance,
	-- disable cheat spawns
	[102267] = {
		values = {
			enabled = false
		}
	},
	-- spawn point delays
	[100019] = flank_spawn,
	[100692] = roof_spawn,
	[100007] = roof_spawn,
	[105450] = elevator_spawn,
	[105500] = elevator_spawn,
	[105434] = elevator_spawn
	-- make server hack guranteed when solo
	[104494] = {
		pre_func = function (self)
			if table.size(managers.network:session():peers()) == 0 then
				self._chance = 100
			end
		end
	},
}
