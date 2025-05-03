local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local cop_4 = scripted_enemy.cop_4
local swat_1 = scripted_enemy.swat_1
local swat_2 = scripted_enemy.swat_2
local heavy_1 = scripted_enemy.heavy_swat_1
local heavy_2 = scripted_enemy.heavy_swat_2
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local elite_sniper = scripted_enemy.elite_sniper
local outside_cop_enemy = { [cop_1] = 3, [cop_2] = 1, [cop_4] = 1 }
local outside_cop = { enemy = outside_cop_enemy }
local inside_cop_enemy = { [cop_3] = 2, [cop_2] = 1, [cop_1] = 1 }
local inside_cop = { enemy = inside_cop_enemy }
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local elevator_dozer = { enemy = is_eclipse_pro and random_elite_dozers or random_dozers }
local low_harasser_enemy = {
	[cop_1] = 4,
	[cop_3] = 2,
	[cop_2] = 1,
}
local low_harasser = { enemy = low_harasser_enemy }
local med_harasser_enemy = swat_1
local med_harasser = { enemy = med_harasser_enemy }
local high_harasser_enemy = is_eclipse and { [heavy_1] = 10, [elite_sniper] = 1 } or heavy_1
local high_harasser = { enemy = high_harasser_enemy }
local low_escape_enemy = {
	[swat_1] = 4,
	[cop_3] = 1,
	[cop_4] = 1,
}
local low_escape = { enemy = low_escape_enemy }
local med_escape_enemy = { Idstring(swat_1), Idstring(swat_2) }
local med_escape = { enemy = med_escape_enemy }
local high_escape_enemy = {
	[swat_1] = 2,
	[swat_2] = 1,
	[heavy_1] = 2,
	[heavy_2] = 1,
}
local high_escape = { enemy = high_escape_enemy }
local front_spawn = {
	values = {
		interval = 10,
	},
}
local front_left_spawn = {
	values = {
		interval = 15,
	},
}
local mall_spawn = {
	values = {
		interval = 15,
	},
}
local atrium_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields,
}
local ladder_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_bulldozers,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local front_short_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 180,
	},
}
return {
	[104782] = {
		ponr = {
			length = 420,
			player_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	-- Delay the assault
	[102711] = {
		on_executed = {
			{ id = 102734, delay = 20 },
		},
	},
	-- New reinforce
	[104306] = {
		reinforce = {
			{
				name = "atrium_left",
				force = 2,
				position = Vector3(-450, 150, 0),
			},
			{
				name = "atrium_middle",
				force = 3,
				position = Vector3(-1300, -1600, 0),
			},
			{
				name = "atrium_right",
				force = 2,
				position = Vector3(-450, -3350, 0),
			},
		},
	},
	-- Vault is open, diff 1
	[104599] = {
		difficulty = 1,
	},
	-- Prevent sniper respawn delays becoming ridiculously small as more assaults pass
	[100082] = {
		on_executed = {
			{ id = 100321, remove = true },
		},
	},
	[100446] = {
		on_executed = {
			{ id = 100321, delay = 0 },
		},
	},
	-- Remove garage preferreds from initial preferreds
	[102753] = {
		on_executed = {
			{ id = 103481, remove = true },
		},
	},
	[100110] = { -- 2nd assault done
		on_executed = {
			{ id = 103481, delay = 0 },
		},
	},
	-- elevator Dozer
	[103222] = elevator_dozer,
	[103241] = elevator_dozer,
	[103254] = elevator_dozer,
	-- Spawn group delays
	-- More or less a port of the original intervals with some twists as per usual.
	-- The main one being increasing intervals of the groups outside the bank building as they are stacked pretty close to each other.
	-- Ladder spawns have been slowed down as well since they are very close to the area where players are expected to hold out.
	[102751] = front_spawn,
	[102730] = front_left_spawn,
	[100424] = mall_spawn,
	[100435] = mall_spawn,
	[100439] = atrium_spawn,
	[100431] = atrium_spawn,
	[104838] = atrium_spawn,
	[101794] = ladder_spawn,
	[101795] = ladder_spawn,
	[103702] = window_spawn,
	[100438] = window_spawn,
	[103505] = front_short_spawn,
	[102792] = cloaker_spawn,
	[103435] = cloaker_spawn,
	[103437] = cloaker_spawn,
	-- Scripted Beat Cops
	[103944] = outside_cop,
	[102662] = outside_cop,
	[102663] = outside_cop,
	[102666] = outside_cop,
	[102667] = outside_cop,
	[102669] = outside_cop,
	[102670] = outside_cop,
	[102953] = outside_cop,
	[102954] = outside_cop,
	[103952] = inside_cop,
	[103953] = inside_cop,
	-- Sophisticated harasser setup, bravo Overkill!
	-- SO FUCKING MANY
	-- "Supressers"
	[100119] = low_harasser,
	[100128] = med_harasser,
	[100131] = med_harasser,
	[100189] = med_harasser,
	[100199] = med_harasser,
	[100208] = high_harasser,
	[100132] = low_harasser,
	[100164] = med_harasser,
	[100176] = med_harasser,
	[100190] = med_harasser,
	[100201] = med_harasser,
	[100209] = high_harasser,
	[100145] = low_harasser,
	[100170] = med_harasser,
	[100177] = med_harasser,
	[100191] = med_harasser,
	[100203] = med_harasser,
	[100210] = high_harasser,
	[100150] = low_harasser,
	[100171] = med_harasser,
	[100179] = med_harasser,
	[100192] = med_harasser,
	[100204] = med_harasser,
	[100211] = high_harasser,
	[100152] = low_harasser,
	[100174] = med_harasser,
	[100181] = med_harasser,
	[100193] = med_harasser,
	[100206] = med_harasser,
	[100212] = high_harasser,
	[100154] = low_harasser,
	[100175] = med_harasser,
	[100182] = med_harasser,
	[100197] = med_harasser,
	[100207] = med_harasser,
	[100213] = high_harasser,
	-- Escape enemies
	[100141] = low_escape,
	[100267] = low_escape,
	[100268] = low_escape,
	[100268] = low_escape,
	[100271] = low_escape,
	[100272] = low_escape,
	[100273] = low_escape,
	[100274] = low_escape,
	[100293] = med_escape,
	[100294] = med_escape,
	[100295] = med_escape,
	[100298] = med_escape,
	[100299] = med_escape,
	[100300] = med_escape,
	[100301] = med_escape,
	[100302] = med_escape,
	[100304] = high_escape,
	[100305] = high_escape,
	[100306] = high_escape,
	[100307] = high_escape,
	[100308] = high_escape,
	[100309] = high_escape,
	[100310] = high_escape,
	[100311] = high_escape,
	-- Escape enmies "other side"
	[103307] = low_escape,
	[103310] = low_escape,
	[103313] = low_escape,
	[103316] = low_escape,
	[103319] = low_escape,
	[103322] = low_escape,
	[103325] = low_escape,
	[103328] = low_escape,
	[103338] = med_escape,
	[103337] = med_escape,
	[103336] = med_escape,
	[103335] = med_escape,
	[103334] = med_escape,
	[103333] = med_escape,
	[103332] = med_escape,
	[103331] = med_escape,
	[103346] = high_escape,
	[103345] = high_escape,
	[103344] = high_escape,
	[103344] = high_escape,
	[103342] = high_escape,
	[103341] = high_escape,
	[103340] = high_escape,
	[103339] = high_escape,
}
