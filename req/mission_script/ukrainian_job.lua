local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local enabled = {
	values = {
		enabled = true,
	},
}
local street_cop_enemy = { [cop_1] = 3, [cop_2] = 1, [cop_4] = 1 }
local street_cop = { enemy = outside_cop_enemy }
local assault_cop_enemy = { [cop_3] = 3, [cop_4] = 2, [cop_1] = 2, [cop_2] = 1 }
local assault_cop = { enemy = assault_cop_enemy }
local left_spawn = {
	values = {
		interval = 10,
	},
}
local right_spawn = {
	values = {
		interval = 10,
	},
}
local alleyway_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields_bulldozers,
}
local rappel_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
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
	[104015] = left_spawn,
	[103887] = right_spawn,
	[104050] = right_spawn,
	[103917] = alleyway_spawn,
	[104008] = alleyway_spawn,
	[104070] = alleyway_spawn,
	[101030] = rappel_spawn,
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
