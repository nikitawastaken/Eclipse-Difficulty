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
}
return {
	-- Combine some navigation areas
	[100040] = {
		ai_area = {
			{ 182, 181 },
			{ 178, 179 },
			{ 173, 183 },
		},
	},
	-- Boss spawn
	[100154] = {
		difficulty_max = 0.1,
	},
	-- Boss dead
	[100153] = {
		difficulty_max = 1,
		difficulty_min = 1,
	},
	[101133] = cloaker_enemy,
	[101141] = cloaker_enemy,
	-- Disable reinforce (the drill already has it)
	[100183] = disabled,
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
	-- Spawn group intervals
	[100629] = roof_spawn,
	[100627] = roof_spawn,
	[100629] = roof_spawn,
	[100666] = roof_spawn,
	[101034] = roof_spawn,
	[101530] = roof_spawn,
	[101534] = roof_spawn,
}
