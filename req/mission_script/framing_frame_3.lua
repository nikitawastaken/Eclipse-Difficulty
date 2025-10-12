local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local no_shields_and_dozers = {
	so_access_filter = so_access.no_heavyweight,
}
local standard_spawn = {
	values = {
		interval = 20,
	},
}
local balcony_close_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
local balcony_far_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local ffo_countdown = {
	ponr = {
		length = 420,
		player_mul = { 1.5, 1.25, 1, 1 },
	},
}
return {
	[101094] = ffo_countdown,
	[101097] = ffo_countdown,
	[101100] = ffo_countdown,
	-- Fix power cut SO delay and add some random delay
	[104685] = {
		values = {
			base_delay = 15,
			base_delay_rand = 15,
		},
	},
	--Spawn snipers after 120 seconds of starting the assault
	[103812] = {
		on_executed = {
			{ id = 400009, delay = 120 },
		},
	},
	--this makes snipers in the nearby building not floating
	[100318] = {
		on_executed = {
			{ id = 105543, delay = 1 },
		},
	},
	-- prevent shields and dozers from disabling the power
	[104699] = no_shields_and_dozers,
	[104700] = no_shields_and_dozers,
	[104701] = no_shields_and_dozers,
	[104702] = no_shields_and_dozers,
	[104703] = no_shields_and_dozers,
	[104704] = no_shields_and_dozers,
	[104705] = no_shields_and_dozers,
	[104706] = no_shields_and_dozers,
	[104707] = no_shields_and_dozers,
	[104708] = no_shields_and_dozers,
	--fix vent covers not dropping when cloaker spawns in
	[104773] = {
		values = {
			elements = {
				104183,
			},
		},
	},
	[104623] = {
		values = {
			elements = {
				104173,
			},
		},
	},
	[104767] = {
		values = {
			elements = {
				104180,
			},
		},
	},
	-- let the wine be securable via the zipline
	[105900] = {
		values = {
			counter_target = 1,
		},
	},
	[105224] = {
		values = {
			operation = "secure",
		},
	},
	-- Spawn Group delays
	[100817] = standard_spawn,
	[100329] = standard_spawn,
	[100887] = balcony_close_spawn,
	[100896] = balcony_close_spawn,
	[105200] = balcony_close_spawn,
	[105201] = balcony_close_spawn,
	[105489] = balcony_far_spawn,
}
