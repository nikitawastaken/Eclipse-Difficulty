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
local penthouse_spawn = {
	values = {
		interval = 5,
	},
}
local roof_far_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents_shields,
}
local roof_close_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Boss spawn
	[100154] = {
		difficulty_max = 0.1,
	},
	-- Boss dead
	[100153] = {
		difficulty_max = 1,
		difficulty_min = 0.8,
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
	[101084] = penthouse_spawn,
	[101085] = penthouse_spawn,
	[100666] = roof_far_spawn,
	[101034] = roof_far_spawn,
	[101530] = roof_close_spawn,
	[101534] = roof_close_spawn,
}
