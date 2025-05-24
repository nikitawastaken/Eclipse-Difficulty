local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local cloaker = scripted_enemy.cloaker
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
local scaffolding_spawn = {
	values = {
		interval = 10,
	},
}
local penthouse_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
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
	[101133] = {
		enemy = cloaker,
	},
	[101141] = {
		enemy = cloaker,
	},
	--Should decrease sniper spawn intensity (I hope)
	[101202] = {
		values = {
			chance = 2
		}
	},
	[100686] = {
		values = {
			chance = 4
		}
	},
	-- Fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
	-- Keep some spawns around for the penthouse holdout
	[100512] = {
		on_executed = {
			{ id = 100511, remove = true },
		},
	},
	-- Spawn point delays
	[101607] = scaffolding_spawn,
	[100147] = scaffolding_spawn,
	[100148] = scaffolding_spawn,
	[100335] = scaffolding_spawn,
	[101622] = scaffolding_spawn,
	[100161] = scaffolding_spawn,
	[101633] = scaffolding_spawn,
	[101636] = scaffolding_spawn,
	[101642] = scaffolding_spawn,
	[101663] = scaffolding_spawn,
	[101651] = scaffolding_spawn,
	[101657] = scaffolding_spawn,
	[101084] = penthouse_spawn,
	[101085] = penthouse_spawn,
	[100666] = roof_spawn,
	[101034] = roof_spawn,
	[101530] = roof_spawn,
	[101534] = roof_spawn,
}
