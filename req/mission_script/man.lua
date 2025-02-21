local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local bulldozer = scripted_enemy.bulldozer_1
local elite_bulldozer = scripted_enemy.elite_bulldozer_1

local dozer_heli = {
	values = {
		enemy = is_eclipse and elite_bulldozer or bulldozer,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local window_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 20,
	},
}
return {
	--enables/disables NPCs flashlights when the power is off/on like in PDTH
	[100756] = {
		flashlight = true,
	},
	[101801] = {
		flashlight = false,
	},
	--PONR
	--Have the gas chopper be a dozer chopper
	--Trigger the heli spawn during escape instead of during hacking objectives
	[100695] = {
		ponr = {
			length = 60,
			player_mul = { 1.25, 1, 0.75, 0.5 },
		},
		on_executed = {
			{ id = 101608, delay = 0 },
		},
	},
	-- remove the line
	[102010] = {
		on_executed = {
			{ id = 101608, remove = true },
		},
	},
	-- remove bain's *chopper coming in, roof guys roof!* as it doesn't deploy tear gas anymore
	[103295] = {
		on_executed = {
			{ id = 102950, remove = true },
		},
	},
	-- unused snipers
	[102160] = enabled,
	[101815] = disabled,
	[101816] = disabled,
	[102155] = enabled,
	[102156] = enabled,
	[102157] = enabled,
	[102238] = enabled,
	[102232] = enabled,
	[102191] = enabled,
	--Replace the spawns with dozers
	[103293] = dozer_heli,
	[103294] = dozer_heli,
	[104045] = dozer_heli,
	[104046] = dozer_heli,
	[104047] = dozer_heli,
	[104048] = dozer_heli,
	[104049] = dozer_heli,
	[104050] = dozer_heli,
	--disable the Gas SO (it's useless anyway)
	[103302] = disabled,
	[103303] = disabled,
	-- Give saw to all players
	[101865] = {
		func = function(self)
			managers.network:session():send_to_peers_synched("give_equipment", self._values.equipment, self._values.amount)
		end,
	},
	--  this disables multiple spawn points when limo lands on the balcony, which is weird, to say the least
	[101898] = {
		values = {
			enabled = false,
		},
	},
	-- No code chance increase on fail or knockout
	[102865] = {
		on_executed = {
			{ id = 102887, remove = true },
		},
	},
	[102872] = {
		on_executed = {
			{ id = 102887, remove = true },
		},
	},
	-- Code chance increase each time taxman is hit
	[102006] = {
		on_executed = {
			{ id = 102887, delay = 0 },
		},
	},
	[102868] = {
		on_executed = {
			{ id = 102887, delay = 0 },
		},
	},
	-- Code chance increase amount
	[102887] = {
		chance = 10,
	},
	-- Faint duration increase
	[102860] = {
		values = {
			action_duration_min = 60,
			action_duration_max = 90,
		},
	},
	-- spawn point delays
	[102368] = {
		values = {
			interval = 10,
		},
		groups = preferred.no_shields,
	},
	[101940] = window_spawn,
	[101954] = window_spawn,
	[101950] = window_spawn,
	[101951] = window_spawn,
	[101937] = roof_spawn,
	[102189] = roof_spawn,
}
