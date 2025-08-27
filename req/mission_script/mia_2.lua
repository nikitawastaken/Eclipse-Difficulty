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
local side_spawn = {
	values = {
		interval = 5,
	},
	groups = preferred.no_cops_agents,
}
local roof_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
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
	-- Don't remove 3rd floor spawns
	[100512] = {
		on_executed = {
			{ id = 100511, remove = true },
		},
	},
	-- Fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
	-- Spawn group intervals

	--[[
		[101633] = third_floor_spawn,
		[101636] = third_floor_spawn,
		[101642] = third_floor_spawn,
		[101651] = third_floor_spawn,
		[101657] = third_floor_spawn,
		[101663] = third_floor_spawn,
	]]
	[101084] = side_spawn,
	[101085] = side_spawn,
	[100627] = roof_spawn,
	[100629] = roof_spawn,
	[100666] = roof_spawn,
	[101034] = roof_spawn,
	[101530] = roof_spawn,
	[101534] = roof_spawn,
}
