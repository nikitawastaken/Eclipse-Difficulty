local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local scripted_enemy = Eclipse.scripted_enemy
local is_solo = Eclipse.utils.is_solo()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()

local cop_smg = scripted_enemy.la_cop_3
local cop_pistol = scripted_enemy.la_cop_1
local cop_revolver = scripted_enemy.la_cop_2
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield
local sniper = scripted_enemy.sniper

local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}

local filter_players_all = {
	values = {
		player_1 = true,
		player_2 = true,
		player_3 = true,
		player_4 = true,
	},
}
local filter_players_disable = {
	values = {
		player_1 = false,
		player_2 = false,
		player_3 = false,
		player_4 = false,
	},
}

local shield = {
	enemy = is_eclipse_pro and elite_shield or shield,
}
local mitchell_sniper = {
	enemy = sniper,
}
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
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "sniper", "spooc" },
}
local crowbar_amount = {
	values = {
		amount = eclipse and 1 or 2,
	},
}
local crowbar_sewer_amount = {
	values = {
		amount = eclipse and 0 or 1,
	},
}
local c4_amount = eclipse and 7 or 4
local c4_amount_solo = eclipse and 4 or 2
local c4_event_func = {
	pre_func = function(self)
		local values = self._values
		local is_solo = table.size(managers.network:session():peers()) == 0

		if values.amount then
			values.amount = is_solo and c4_amount_solo or c4_amount
		end
	end,
}
local c4_event_counter_func = {
	pre_func = function(self)
		local values = self._values
		local is_solo = table.size(managers.network:session():peers()) == 0

		if values.counter_target then
			values.counter_target = is_solo and c4_amount_solo or c4_amount
		end
	end,
}
local van_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
return {
	-- Combine some navigation areas
	[100023] = {
		ai_area = {
			{ 249, 255 },
			{ 269, 393 },
			{ 270, 297 },
			{ 330, 358, 368 },
		},
	},
	[100023] = {
		on_executed = {
			{ id = 400044, delay = 3 },
		},
	},
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
	-- restore Bain's SWAT warnings from PDTH (why they were removed is beyond me)
	[100714] = {
		on_executed = {
			{ id = 400046, delay = 0 },
		},
	},
	[100713] = {
		on_executed = {
			{ id = 400047, delay = 0 },
		},
	},
	[100715] = {
		on_executed = {
			{ id = 400048, delay = 0 },
		},
	},
	[100720] = {
		on_executed = {
			{ id = 400049, delay = 0 },
		},
	},
	-- disable turret spawn from vans completely as they're disabled in Eclipse
	-- Wilson's Swat Van
	[102820] = filter_easy_above,
	[102819] = filter_disable,
	[101965] = filter_disable,
	-- Mitchell's Swat van
	[102388] = filter_easy_above,
	[102383] = filter_disable,
	[102382] = filter_disable,
	-- Swat van near beach_spawn
	[102216] = filter_easy_above,
	[102320] = filter_disable,
	[102369] = filter_disable,
	-- change c4's amount event to resemble more from PDTH
	--[[
	[101890] = c4_event_func,
	[102569] = c4_event_func,
	[101891] = c4_event_func,
	[101815] = c4_event_func,
	[102590] = c4_event_counter_func,
	[102591] = c4_event_counter_func,
	[101565] = c4_event_counter_func,
	[102284] = filter_easy_above,
	[102287] = filter_disable,
	[102288] = filter_disable,
	[102294] = filter_players_all,
	[102568] = filter_players_disable,
	[102307] = filter_players_disable,
	-- change crowbar's amount depeniding on diffculties
	[100127] = crowbar_amount,
	[100129] = crowbar_sewer_amount,
	]]
	-- reinforce Spots
	[100031] = {
		reinforce = {
			{
				name = "bbq",
				force = 3,
				position = Vector3(-3750, 2400, 30),
			},
			{
				name = "mitchell01",
				force = 2,
				position = Vector3(-125, 2625, 25),
			},
			{
				name = "mitchell02",
				force = 2,
				position = Vector3(-2400, 4350, 25),
			},
			{
				name = "wilson01",
				force = 2,
				position = Vector3(-3710, -1285, 25),
			},
			{
				name = "wilson02",
				force = 2,
				position = Vector3(-1125, 625, 50),
			},
		},
		-- force SWAT vans arrival on police_called like it's in PDTH
		on_executed = {
			{ id = 400050, delay = 30 },
		},
	},
	-- disable vanilla's swat van randomizer
	[102080] = disabled,
	-- don't disable neighbour swat vans
	[101850] = disabled,
	[101852] = disabled,
	[101853] = disabled,
	[101854] = disabled,
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
	-- replace cops with lapd
	[100725] = { enemy = cop_smg },
	[100726] = { enemy = cop_pistol },
	[100210] = { enemy = cop_pistol },
	[100212] = { enemy = cop_revolver },
	-- disable the 2nd police crusier if the cops are already alerted
	[103034] = {
		on_executed = {
			{ id = 400015, delay = 0 },
		},
	},
	-- fixes SWAT chopper that lands on Mitchell's roof not spawning at all (also fixes choppers having no sounds)
	[102085] = {
		on_executed = {
			{ id = 101687, remove = true },
			{ id = 101688, remove = true },
			{ id = 101689, remove = true },
			{ id = 400039, delay = 0 },
			{ id = 400040, delay = 0 },
			{ id = 400041, delay = 0 },
		},
	},
	[101685] = {
		on_executed = {
			{ id = 101687, remove = true },
			{ id = 101688, remove = true },
			{ id = 101689, remove = true },
			{ id = 400039, delay = 0 },
			{ id = 400040, delay = 0 },
			{ id = 400041, delay = 0 },
		},
	},
	[101570] = {
		on_executed = {
			{ id = 400045, delay = 0 },
		},
	},
	[101704] = {
		on_executed = {
			{ id = 101603, remove = true },
			{ id = 400042, delay = 20 },
		},
	},
	[101709] = {
		on_executed = {
			{ id = 101706, remove = true },
			{ id = 400043, delay = 20 },
		},
	},
	-- snipers on Mitchell's rooftop
	[101717] = mitchell_sniper,
	[101719] = mitchell_sniper,
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
	-- keep vanilla snipers off on lower diffs
	[102941] = {
		values = {
			enabled = overkill_and_above and true or false,
		},
	},
	-- spawn two extra tasers with blockade shields on Death Wish (193+ throwback)
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
	-- civs go full alert when you mask up
	[100302] = {
		values = {
			amount = 1,
		},
		func = function()
			for _, u_data in pairs(managers.enemy:all_civilians()) do
				u_data.unit:movement():set_cool(false)
			end
		end,
	},
	-- Beach valve disables nearby spawngroups
	[101219] = { -- valve 1
		on_executed = { -- beach preferred remove
			{ id = 400056, delay = 0 },
		},
	},
	[100587] = { -- valve timer done
		on_executed = { -- beach preferred add
			{ id = 400055, delay = 0 },
		},
	},
	-- Elite Shields replaces FBI ones that cover the manhole on Death Wish (PJ only)
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
	-- Spawn group intervals
	[100911] = van_spawn,
	[101105] = van_spawn,
	[101106] = van_spawn,
	[101107] = van_spawn,
	[101825] = van_spawn,
	[101827] = van_spawn,
	[101828] = van_spawn,
	[101829] = van_spawn,
}
