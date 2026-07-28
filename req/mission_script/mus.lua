local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local courtyard_spawn = {
	groups = preferred.no_cops_agents,
}
local staircase_window_spawn = {
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local matrix_window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local exhibit_rappel_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
local exhibit_slow_rappel_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents,
}
local last_rappel_spawn = {
	groups = preferred.no_cops_agents_bulldozers,
}
local green_security = {
	enemy = {
		[scripted_enemy.green_security_1] = 2,
		[scripted_enemy.green_security_2] = 2,
		[scripted_enemy.green_security_3] = 2,
		[scripted_enemy.green_security_4] = 1,
		[scripted_enemy.green_security_5] = 2,
	},
}
return {
	[102425] = {
		ponr = {
			length = 240,
			length_balance_mul = { 1.25, 1.125, 1, 1 },
		},
	},
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 4, 52 },
			{ 136, 129 },
			{ 153, 139 },
			{ 140, 154 },
		},
	},
	-- Add new reinforce
	[100109] = { -- Police arrived
		reinforce = {
			{
				name = "entrance",
				force = 3,
				position = Vector3(-3475, 225, -700),
			},
			{
				name = "south",
				force = 2,
				position = Vector3(-1300, 200, -350),
			},
			{
				name = "west",
				force = 2,
				position = Vector3(0, 2900, -300),
			},
			{
				name = "north",
				force = 2,
				position = Vector3(1200, 200, -350),
			},
			{
				name = "east",
				force = 2,
				position = Vector3(0, -2500, -300),
			},
		},
		on_executed = { -- standard_preferreds
			{ id = 100127, delay = 60 }, -- vanilla: 0
		},
	},
	-- restore ground snipers
	[100369] = enabled,
	[100370] = enabled,
	[100371] = enabled,
	[100372] = enabled,
	-- keep other snipers enabled at all times
	[100368] = enabled,
	[100373] = enabled,
	[100374] = enabled,
	-- add missing spawns to elementrandom
	[100366] = {
		on_executed = {
			{ id = 100369, delay = 0 },
			{ id = 100370, delay = 0 },
			{ id = 100371, delay = 0 },
			{ id = 100372, delay = 0 },
		},
	},
	-- don't disable ground snipers after some point
	[100264] = disabled,
	-- add missing Bain's warning about snipers
	[100363] = {
		on_executed = {
			{ id = 400003, delay = 0 },
			{ id = 400004, delay = 0 },
			{ id = 400002, delay = 2 },
			{ id = 400001, delay = 3 },
		},
	},
	[102154] = { -- 1st timelock done
		on_executed = {
			{ id = 100128, delay = 0, delay_rand = 45 }, -- add 40
			{ id = 100130, delay = 0, delay_rand = 45 }, -- add 41
			{ id = 102129, delay = 0, delay_rand = 45 }, -- add 11
		},
	},
	-- Spawn group intervals
	[100786] = courtyard_spawn,
	[100789] = courtyard_spawn,
	[100790] = courtyard_spawn,
	[100791] = courtyard_spawn,
	[100007] = staircase_window_spawn,
	[102418] = staircase_window_spawn,
	[102399] = matrix_window_spawn,
	[102400] = matrix_window_spawn,
	[101946] = exhibit_rappel_spawn,
	[101959] = exhibit_rappel_spawn,
	[100019] = exhibit_slow_rappel_spawn,
	[100809] = exhibit_slow_rappel_spawn,
	[100810] = exhibit_slow_rappel_spawn,
	[100021] = exhibit_slow_rappel_spawn,
	[101924] = last_rappel_spawn,
	[101941] = last_rappel_spawn,
	[101942] = last_rappel_spawn,
	[101943] = last_rappel_spawn,
	-- Replace regular security with green security
	[100670] = green_security,
	[100671] = green_security,
	[100672] = green_security,
	[100673] = green_security,
	[100674] = green_security,
	[100675] = green_security,
	[100676] = green_security,
	[100677] = green_security,
	[101371] = green_security,
	[101372] = green_security,
	[101373] = green_security,
	[101368] = green_security,
	[101369] = green_security,
	[101677] = green_security,
	[101678] = green_security,
	[101758] = green_security,
	[101759] = green_security,
	[101760] = green_security,
	[100512] = green_security,
	[100720] = green_security,
	[101388] = green_security,
	[101568] = green_security,
	[101576] = green_security,
}
