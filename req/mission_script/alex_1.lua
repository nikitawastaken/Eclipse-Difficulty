local is_eclipse = Eclipse.utils.is_eclipse()
-- credit for these changes goes to ASS, thanks miki <3
local mexicans = {
	Idstring("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"),
	Idstring("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"),
	Idstring("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"),
	Idstring("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"),
}

local cloaker_spawn = {
	values = {
		enemy = scripted_enemy.cloaker
	},
}

local chopper_amount = is_eclipse and 2 or 1

return {
	--Replace Heavy SWATs that spawn from the chopper with cloakers
	[101571] = cloaker_spawn,
	[101572] = cloaker_spawn,
	--Loop helis
	--remove the line+trigger the loop here
	[100945] = {
		on_executed = {
			{ id = 100946, remove = true },
			{ id = 100965, delay = 180 }
		}
	},
	--loop the choppa+2 chopper spawns on Eclipse
	[100966] = {
		values = {
            amount = chopper_amount
		},
		on_executed = {
			{ id = 100965, delay = 300 }
		}
	},
	--trigger_times to 0; making the loop possible
	[100953] = {
		values = {
            trigger_times = 0
		}
	},
	[100887] = {
		values = {
            trigger_times = 0
		}
	},
	--disable this just in case
	[101652] = {
		values = {
            enabled = false
		}
	},
	-- planks amount, normally always 3, now you can get anywhere from fuck-all to more than you know what to do with
	[100822] = {
		values = {
			amount = 0,
			amount_random = 6,
		},
	},
	-- hurry up bain (cook chance evaluation delay, vanilla is 25s, cheat faster is 1s)
	[100724] = {
		on_executed = {
			{ id = 100494, delay = 15, delay_rand = 10, },
		},
	},
	-- added chance to cook each time the evaluation runs and fails, vanilla is 10%
	[100723] = {
		chance = 20
	},
	-- waiter !  waiter !  more gangsters please !
	[101520] = {
		values = {
			amount = 1,
			amount_random = 3,
		},
	},
	[101266] = {
		values = {
			amount = 2,
			amount_random = 2,
		},
	},
	[101297] = {
		values = {
			amount = 2,
			amount_random = 1,
		},
	},
	[101010] = {
		values = {
			amount = 2,
			amount_random = 3,
		},
	},
	-- some new reenforce spots
	[100941] = {
		reinforce = {
			{
				name = "basement",
				force = 1,
				position = Vector3(2050, 975, 924.84)  -- point special objective 25
			},
			{
				name = "such_a_nice_car",  -- mendoza car to the right of player spawn, near cloaker hiding spot
				force = 1,
				position = Vector3(675, -1197, 875.243)  -- point special objective 28
			},
		},
	},
	[101525] = { enemy = mexicans },  -- gangsters
	[101527] = { enemy = mexicans },
	[100825] = { enemy = mexicans },
	[100826] = { enemy = mexicans },
	[101529] = { enemy = mexicans },
	[101530] = { enemy = mexicans },
	[101531] = { enemy = mexicans },
	[101284] = { enemy = mexicans },
	[101286] = { enemy = mexicans },
	[100417] = { enemy = mexicans },
	[100420] = { enemy = mexicans },
	[101060] = { enemy = mexicans },
	[101061] = { enemy = mexicans },
	[101293] = { enemy = mexicans },
	[101288] = { enemy = mexicans },
	[101294] = { enemy = mexicans },
	[100426] = { enemy = mexicans },
	[100431] = { enemy = mexicans },
	[101262] = { enemy = mexicans },
	[101263] = { enemy = mexicans },
}
