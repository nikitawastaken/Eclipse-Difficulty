local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
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
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local balcony_far_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local powerboxes_amount = {
	values = {
		amount = (normal and 2 or hard and 3 or 4) + (is_pro_job and 1 or 0),
	},
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
return {
	[100318] = {
		ponr = {
			length = 720,
			player_mul = { 2, 1.5, 1, 1 },
		},
	},
	-- Fix power cut SO delay and add some random delay
	[104685] = {
		values = {
			base_delay = 15,
			base_delay_rand = 15,
		},
	},
	-- Add new reinforce
	[100879] = { -- preferreds
		reinforce = {
			{
				name = "stairs01",
				force = 2,
				position = Vector3(-2760, 2805, 3000),
			},
			{
				name = "stairs02",
				force = 2,
				position = Vector3(-4050, 4825, 3400),
			},
			{
				name = "stairs03",
				force = 2,
				position = Vector3(-4500, 4375, 3800),
			},
			{
				name = "stairs04",
				force = 2,
				position = Vector3(-5225, 2800, 3000),
			},
			{
				name = "stairs05",
				force = 2,
				position = Vector3(-4650, 2150, 3400),
			},
		},
	},
	-- tweak power boxes amount based on difficulty
	[105350] = filter_easy_above,
	[105351] = filter_disable,
	[105352] = powerboxes_amount,
	--Spawn snipers after 90-150 seconds of starting the assault
	[103812] = {
		on_executed = {
			{ id = 400009, delay = 90, delay_rand = 60 },
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
