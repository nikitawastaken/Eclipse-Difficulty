local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter

local spawn_so = {
	values = {
		so_action = "e_nl_down_9_3m_rappel",
	},
}
local window_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local window_agile_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local upper_spawn = {
	values = {
		interval = 25,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local upper_agile_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 35,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local e_nl_up_1m_down_5m_swing_interval = {
	values = {
		interval = 10, -- (Vanilla: 5s)
	},
	so_access_filter = so_access.acrobatic,
}

return {
	-- instantly enter FFO when all players are gathered in one place
	[101213] = {
		set_ponr_state = true,
	},
	-- Add new reinforce to make up for slower spawn groups.
	[100178] = {
		reinforce = {
			{
				name = "ward",
				force = 2,
				position = Vector3(50, -1100, -400),
			},
			{
				name = "laundry",
				force = 2,
				position = Vector3(2000, -950, 0),
			},
			{
				name = "security",
				force = 2,
				position = Vector3(1750, -3200, 0),
			},
			{
				name = "gate",
				force = 3,
				position = Vector3(-2575, -5150, 10),
			},
		},
	},
	-- Fix Prison Nightmare SO animations
	[100347] = spawn_so,
	[100348] = spawn_so,
	[100349] = spawn_so,
	[100351] = spawn_so,
	[100352] = spawn_so,
	[100353] = spawn_so,
	[100354] = spawn_so,
	[100355] = spawn_so,
	[100360] = spawn_so,
	-- Increase navlink intervals
	-- e_nl_up_1m_down_5m_swing
	[100980] = e_nl_up_1m_down_5m_swing_interval,
	[100979] = e_nl_up_1m_down_5m_swing_interval,
	[100978] = e_nl_up_1m_down_5m_swing_interval,
	[100977] = e_nl_up_1m_down_5m_swing_interval,
	[100976] = e_nl_up_1m_down_5m_swing_interval,
	[100973] = e_nl_up_1m_down_5m_swing_interval,
	[100966] = e_nl_up_1m_down_5m_swing_interval,
	[100967] = e_nl_up_1m_down_5m_swing_interval,
	[100968] = e_nl_up_1m_down_5m_swing_interval,
	[100969] = e_nl_up_1m_down_5m_swing_interval,
	[100970] = e_nl_up_1m_down_5m_swing_interval,
	[100982] = e_nl_up_1m_down_5m_swing_interval,
	[100983] = e_nl_up_1m_down_5m_swing_interval,
	[100984] = e_nl_up_1m_down_5m_swing_interval,
	[100985] = e_nl_up_1m_down_5m_swing_interval,
	[100991] = e_nl_up_1m_down_5m_swing_interval,
	[100992] = e_nl_up_1m_down_5m_swing_interval,
	[100995] = e_nl_up_1m_down_5m_swing_interval,
	[100996] = e_nl_up_1m_down_5m_swing_interval,
	-- Spawn group intervals
	-- This heist is pretty cramped and also has verticality, which makes having all those spawn groups packed so close to each other especially egregious. What's new?
	[100933] = window_spawn,
	[101396] = window_spawn,
	[100907] = window_agile_spawn,
	[100932] = window_agile_spawn,
	[100913] = window_agile_spawn,
	[101143] = window_agile_spawn,
	[101160] = window_agile_spawn,
	[101161] = window_agile_spawn,
	[101162] = window_agile_spawn,
	[101163] = window_agile_spawn,
	[100576] = upper_spawn,
	[100618] = upper_spawn,
	[100619] = upper_spawn,
	[100673] = upper_spawn,
	[100921] = upper_spawn,
	[100939] = upper_spawn,
	[100955] = upper_spawn,
	[100419] = upper_agile_spawn,
	[100575] = upper_agile_spawn,
	[100659] = upper_agile_spawn,
	[100900] = upper_agile_spawn,
	[101050] = upper_agile_spawn,
	[101056] = upper_agile_spawn,
	[101062] = upper_agile_spawn,
	[101759] = upper_agile_spawn,
	[100684] = flank_spawn,
	[101795] = flank_spawn,
}
