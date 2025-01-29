local is_eclipse = Eclipse.utils.is_eclipse()

local bulldozer = scripted_enemy.bulldozer_1
local elite_bulldozer = scripted_enemy.elite_bulldozer_1

local dozer_heli = {
	values = {
        enemy = is_eclipse and elite_bulldozer or bulldozer
	}
}
local disabled = {
	values = {
        enabled = false
	}
}	
return {
--enables/disables NPCs flashlights when the power is off/on like in PDTH
[100756] = {
		flashlight = true
	},
	[101801] = {
		flashlight = false
	},
	--PONR
	--Have the gas chopper be a dozer chopper
	--Trigger the heli spawn during escape instead of during hacking objectives
	[100695] = {
		ponr = {
			length = 60,
			player_mul = { 1.25, 1, 0.75, 0.5 }
		},
		on_executed = {
			{id = 101608, delay = 0}
		}
	},
	--remove the line
	[102010] = {
		on_executed = {
			{ id = 101608, remove = true}
		}
	},
	--Bain warns about incoming dozers from the chopper
	[103295] = {
		on_executed = {
			{ id = 102950, remove = true},
			{ id = 400001, delay = 16}
		}
	},
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
		end
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
			{ id = 102887, remove = true }
		}
	},
	[102872] = {
		on_executed = {
			{ id = 102887, remove = true }
		}
	},
	-- Code chance increase each time taxman is hit
	[102006] = {
		on_executed = {
			{ id = 102887, delay = 0 }
		}
	},
	[102868] = {
		on_executed = {
			{ id = 102887, delay = 0 }
		}
	},
	-- Code chance increase amount
	[102887] = {
		chance = 10
	},
	-- Faint duration increase
	[102860] = {
		values = {
			action_duration_min = 60,
			action_duration_max = 90
		}
	}
}
