local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local cop_4 = scripted_enemy.cop_4
local street_cop_enemy = { [cop_1] = 3, [cop_2] = 1, [cop_4] = 1 }
local street_cop = { enemy = outside_cop_enemy }
local assault_cop_enemy = { [cop_3] = 3, [cop_4] = 2, [cop_1] = 2, [cop_2] = 1 }
local assault_cop = { enemy = assault_cop_enemy }
local enabled = {
	values = {
		enabled = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local cop_4 = scripted_enemy.cop_4
local street_cop_enemy = { [cop_1] = 3, [cop_2] = 1, [cop_4] = 1 }
local street_cop = { enemy = street_cop_enemy }
local assault_cop_enemy = { [cop_3] = 3, [cop_4] = 2, [cop_1] = 2, [cop_2] = 1 }
local assault_cop = { enemy = assault_cop_enemy }
local street_spawn = {
	values = {
		interval = 10,
	},
}
local alleyway_spawn = {
	values = {
		interval = 25,
	},
}
local rappel_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_shields_bulldozers,
}
local scripted_swat_heli_spawn = {
	groups = preferred.no_cops_agents_cloakers_snipers,
}
return {
	[103342] = { -- Allow one more sniper
		values = {
			amount = 1,
			amount_random = 1,
		},
	},
	-- edit SWAT heli dropoff
	-- 100% chance for guaranteed chopper
	[102861] = { chance = 100 },
	-- remove SO from SWATs
	[102595] = {
		on_executed = {
			{ id = 102603, remove = true },
		},
	},
	[102602] = {
		on_executed = {
			{ id = 102604, remove = true },
		},
	},
	-- replace mission scripts with a actual spawngroup
	[102599] = {
		on_executed = {
			{ id = 102602, remove = true },
			{ id = 102595, remove = true },
			{ id = 400003, delay = 0 },
		},
	},
	-- open/close the left heli door
	[102597] = {
		on_executed = {
			{ id = 400005, delay = 0 },
		},
	},
	[102598] = {
		on_executed = {
			{ id = 400006, delay = 0 },
		},
	},
	-- loop the chopper after it goes hidden
	[102601] = {
		on_executed = {
			{ id = 102594, delay = 120, delay_rand = 60 },
		},
	},
	[103344] = enabled, -- Enable unused sniper spawns (vantage point roof, but, vanilla san martin)
	[103347] = enabled,
	-- Disable escape reinforce, it's frankly redundant
	[104089] = disabled,
	[104093] = disabled,
	-- Make Beat Cops random
	[102044] = street_cop,
	[102045] = street_cop,
	[102046] = street_cop,
	[102048] = street_cop,
	-- Spawn Group delays
	[400004] = scripted_swat_heli_spawn,
	[103884] = street_spawn,
	[103887] = street_spawn,
	[104050] = street_spawn,
	[103917] = alleyway_spawn,
	[104008] = alleyway_spawn,
	[104015] = alleyway_spawn,
	[100704] = rappel_spawn,
	[101030] = rappel_spawn,
	[104070] = flank_spawn,
	-- You have alerted the Beat Cop horde
	[102536] = assault_cop,
	[102537] = assault_cop,
	[102538] = assault_cop,
	[102539] = assault_cop,
	[104179] = assault_cop,
	[104180] = assault_cop,
	[104181] = assault_cop,
	[104182] = assault_cop,
	[104183] = assault_cop,
	[104184] = assault_cop,
	[104185] = assault_cop,
	[104186] = assault_cop,
	[104187] = assault_cop,
	[104188] = assault_cop,
	[104189] = assault_cop,
	[104190] = assault_cop,
}
