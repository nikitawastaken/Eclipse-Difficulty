local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred

local cloaker = scripted_enemy.cloaker

local disabled = {
	values = {
		enabled = false,
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local fail_add_chance = {
	values = {
		chance = 5,
	},
}
local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false,
	},
}
local scaffolding_spawn = {
	values = {
		interval = 15,
	},
}
local penthouse_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 40,
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
	-- Snipers that look on Panic Room zone now spawn more than 1 time
	[101128] = sniper_trigger_times,
	[101121] = sniper_trigger_times,
	[101520] = sniper_trigger_times,
	[101113] = sniper_trigger_times,
	[101140] = sniper_trigger_times,
	[101136] = sniper_trigger_times,
	--Should decrease sniper spawn intensity (I hope)
	[100685] = {
		values = {
			chance = 10,
		},
	},
	[101202] = fail_add_chance,
	[100686] = fail_add_chance,
	-- Fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
	-- Disable penthouse reinforce
	[100183] = disabled,
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
