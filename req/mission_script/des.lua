local weaponlab_spawn = {
	values = {
		interval = 20,
	},
}
local computerlab_spawn_1 = {
	values = {
		interval = 20,
	},
}
local intro_spawn = {
	values = {
		interval = 15,
	},
}
local computerlab_spawn_2 = {
	values = {
		interval = 10,
	},
}
local archeology_spawn = {
	values = {
		interval = 10,
	},
}

return {
	[100286] = {
		reinforce = {
			{ name = "main_hall" },
		},
		-- add point of no return
		ponr = {
			length = 300,
			player_mul = { 1.6, 1.2, 1, 0.8 },
		},
	},
	[100304] = {
		reinforce = {
			{
				name = "main_hall",
				force = 5,
				position = Vector3(-120, -2400, 100),
			},
		},
	},
	-- slow down the spawnpoints in weaponlab
	[107981] = weaponlab_spawn,
	[100133] = weaponlab_spawn,
	[100941] = weaponlab_spawn,
	[107911] = weaponlab_spawn,
	[107983] = weaponlab_spawn,
	[102407] = weaponlab_spawn,
	-- slow down the spawnpoints in computerlab
	[100128] = computerlab_spawn_1,
	[107977] = computerlab_spawn_1,
	[100130] = computerlab_spawn_2,
	[107913] = computerlab_spawn_2,
	-- slightly in archeologylab too
	[100131] = archeology_spawn,
	-- slow down the top spawnpoints in the starting sequence
	[101074] = intro_spawn,
	[101350] = intro_spawn,
}
