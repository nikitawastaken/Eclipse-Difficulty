local scripted_enemy = Eclipse.scripted_enemy

local cloaker = scripted_enemy.cloaker

local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false,
	},
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
	-- fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
}
