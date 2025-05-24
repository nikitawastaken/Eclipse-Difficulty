local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local enabled = {
	values = {
		enabled = true,
	},
}
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local cop_4 = scripted_enemy.cop_4
local street_cop_enemy = { [cop_1] = 3, [cop_2] = 1, [cop_4] = 1 }
local street_cop = { enemy = street_cop_enemy }
local street_spawn = {
	values = {
		interval = 10,
	},
}
local alleyway_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields_bulldozers_snipers,
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
	groups = preferred.no_shields_bulldozers_snipers,
}
return {
	[103342] = { -- Allow one more sniper
		values = {
			amount = 1,
			amount_random = 1,
		},
	},
	[103344] = enabled, -- Enable unused sniper spawns (vantage point roof, but, vanilla san martin)
	[103347] = enabled,
	-- Make Beat Cops random
	[102044] = street_cop,
	[102045] = street_cop,
	[102046] = street_cop,
	[102048] = street_cop,
	-- Spawn Group delays
	[103884] = street_spawn,
	[103887] = street_spawn,
	[104050] = street_spawn,	
	[103917] = alleyway_spawn,
	[104008] = alleyway_spawn,
	[104015] = alleyway_spawn,
	[100704] = rappel_spawn,
	[101030] = rappel_spawn,
	[104070] = flank_spawn,	
}
