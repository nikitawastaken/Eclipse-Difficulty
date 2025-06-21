local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local cloaker = scripted_enemy.cloaker
local cloaker_enemy = {
	enemy = cloaker,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false,
	},
}
local roof_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.only_swats_tasers_cloakers,
}
return {
	-- Boss spawn
	[100154] = {
		difficulty = 0.1,
	},
	-- Boss dead
	[100153] = {
		difficulty = 1,
	},
	[101133] = cloaker_enemy,
	[101141] = cloaker_enemy,
	--Should decrease sniper spawn intensity (I hope)
	[101202] = {
		values = {
			chance = 2,
		},
	},
	[100686] = {
		values = {
			chance = 4,
		},
	},
	-- Fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
	-- Spawn point delays
	[100666] = roof_spawn,
	[101034] = roof_spawn,
	[101530] = roof_spawn,
	[101534] = roof_spawn,
}
