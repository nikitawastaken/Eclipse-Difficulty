local preferred = Eclipse.preferred
local no_shields_and_dozers = {
	so_access_filter = { "cop", "swat", "fbi", "taser", "spooc" },
}
local roof_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,	
}
local staircase_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,	
}
local elevator_spawn = {
	values = {
		interval = 30,
	},
}
local balcony_spawn1 = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,	
}
local balcony_spawn2 = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,	
}
return {
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
			{ id = 400010, delay = 120 },
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
	-- Spawn Group delays
	[102364] = roof_spawn,
	[105718] = roof_spawn,
	[100817] = staircase_spawn,
	[100329] = elevator_spawn,
	[100887] = balcony_spawn1,
	[100896] = balcony_spawn1,
	[105200] = balcony_spawn1,
	[105201] = balcony_spawn1,
	[105489] = balcony_spawn2,
}
