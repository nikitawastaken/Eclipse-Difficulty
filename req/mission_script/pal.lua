local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local is_solo = Eclipse.utils.is_solo()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job

local cop_smg = scripted_enemy.cop_3
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield

local shield = {
	enemy = is_eclipse_pro and elite_shield or shield,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "sniper", "spooc" },
}
local crowbar_amount = {
	values = {
		amount = (normal or hard) and 2 or 1,
	},
}
local crowbar_sewer_amount = {
	values = {
		amount = (normal or hard) and 1 or 0,
	},
}
local c4_amount_solo = normal and 2 or 4
local c4_amount = normal and 4 or 7
local c4_event = {
	values = {
		amount = is_solo and c4_amount_solo or c4_amount,
	},
}

return {
	-- water from the hose fills the safe much slower like in PDTH
	[101229] = {
		values = {
			timer = 240,
		},
	},
	[101237] = {
		values = {
			time = 200,
		},
	},
	[101236] = {
		values = {
			time = 140,
		},
	},
	[101235] = {
		values = {
			time = 60,
		},
	},
	[100897] = {
		values = {
			time = 30,
		},
	},
	-- change c4's amount event to resemble more from PDTH
	[101890] = c4_event,
	[102569] = c4_event,
	[101891] = c4_event,
	-- change crowbar's amount depeniding on diffculties
	[100127] = crowbar_amount,
	[100129] = crowbar_sewer_amount,
	-- reinforce Spots
	[100031] = {
		reinforce = {
			{
				name = "protect_the_BBQ",
				force = 3,
				position = Vector3(-3680, 1926, 26.700),
			},
			{
				name = "Mitchell_house_1",
				force = 3,
				position = Vector3(-2286, 2640, 78.789),
			},
			{
				name = "Mitchell_house_2",
				force = 3,
				position = Vector3(-2556, 3836, 75.500),
			},
			{
				name = "Wilson_house_1",
				force = 3,
				position = Vector3(-2080, 39, 28.970),
			},
			{
				name = "Wilson_house_2",
				force = 3,
				position = Vector3(-2980, 1441, -324.500),
			},
		},
	},
	-- disable vanilla's reinforce points
	[100218] = disabled,
	[101635] = disabled,
	[101636] = disabled,
	-- only let swats, tasers, snipers and cloakers use climbing SOs
	[102393] = exclude_cop_agents_shields_dozers,
	[102394] = exclude_cop_agents_shields_dozers,
	[102395] = exclude_cop_agents_shields_dozers,
	[102396] = exclude_cop_agents_shields_dozers,
	[102397] = exclude_cop_agents_shields_dozers,
	[102398] = exclude_cop_agents_shields_dozers,
	[102399] = exclude_cop_agents_shields_dozers,
	[102400] = exclude_cop_agents_shields_dozers,
	[102401] = exclude_cop_agents_shields_dozers,
	[102402] = exclude_cop_agents_shields_dozers,
	[102403] = exclude_cop_agents_shields_dozers,
	[102404] = exclude_cop_agents_shields_dozers,
	[102405] = exclude_cop_agents_shields_dozers,
	[102406] = exclude_cop_agents_shields_dozers,
	[102407] = exclude_cop_agents_shields_dozers,
	[102408] = exclude_cop_agents_shields_dozers,
	[102409] = exclude_cop_agents_shields_dozers,
	[101438] = exclude_cop_agents_shields_dozers,
	[101440] = exclude_cop_agents_shields_dozers,
	[102719] = exclude_cop_agents_shields_dozers,
	[102808] = exclude_cop_agents_shields_dozers,
	[102809] = exclude_cop_agents_shields_dozers,
	[102810] = exclude_cop_agents_shields_dozers,
	[102811] = exclude_cop_agents_shields_dozers,
	[102812] = exclude_cop_agents_shields_dozers,
	[102813] = exclude_cop_agents_shields_dozers,
	[102814] = exclude_cop_agents_shields_dozers,
	[102815] = exclude_cop_agents_shields_dozers,
	[102816] = exclude_cop_agents_shields_dozers,
	-- replace 2nd bronco cop with smg cop to match with PDTH style (even if he doesn't carry a shotgun)
	[100725] = {
		values = {
			enemy = cop_smg,
		},
	},
	-- disable the 2nd police crusier if the cops are already alerted
	[103034] = {
		on_executed = {
			{ id = 400015, delay = 0 },
		},
	},
	-- delay the next anim by few more seconds to let the previous anim end (fix for Wilson's SWAT van)
	[101647] = {
		on_executed = {
			{ id = 101648, delay = 10.5 },
		},
	},
	-- spawn custom PDTH styled snipers at the start of 2nd assault
	-- Bain warns about them
	[102082] = {
		on_executed = {
			{ id = 400001, delay = 5 },
			{ id = 400002, delay = 5 },
			{ id = 400003, delay = 5 },
			{ id = 400004, delay = 5 },
			{ id = 400005, delay = 5 },
			{ id = 400016, delay = 3.5 },
		},
	},
	-- disable vanilla snipers
	[102941] = disabled,
	-- spawn two extra tasers with blockade shields on Eclipse (193+ throwback)
	[101926] = {
		on_executed = {
			{ id = 400017, delay = 0 },
			{ id = 400018, delay = 0 },
		},
	},
	[101928] = {
		on_executed = {
			{ id = 400019, delay = 0 },
			{ id = 400020, delay = 0 },
		},
	},
	-- elite Shields replaces FBI ones that cover the manhole on Eclipse (PJ only)
	[100036] = shield,
	[100039] = shield,
	[100044] = shield,
	[101848] = shield,
	[101908] = shield,
	[101911] = shield,
	[100642] = shield,
	[100777] = shield,
	[100795] = shield,
	[101804] = shield,
	[101883] = shield,
	[102098] = shield,
}
