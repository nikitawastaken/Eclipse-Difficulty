return {
	[101356] = {
		ponr = 480,
		ponr_player_mul = {2, 1.5, 1.25, 1}
	},
	-- ovk145-alike dozer spawn on armitage avenue
	-- ideas list for this one:
	-- maybe rework the spawngroup as a whole tbh, idk yet
	-- potentially make this into a bossfight by adding a fourth dozer, making them all elite and dropping the diff value(?)
	[103592] = {
		values = {
			enabled = false -- this one is used for difficulties below ovk (for now, will add ovk to the filter later)
			-- todo: enable this one and just replace enemies with weaker ones
		}
	},
	[103590] = {
		values = {
			difficulty_overkill_145 = false -- eclipse only filter
		}
	},
	[103593] = {
		values = {
			chance = 100
		}
	},
	[100232] = {
		enemy = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
	},
	[100341] = {
		enemy = Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
	},
	[100351] = {
		enemy = Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
	},
	[101202] = {
		values = {
			on_executed = {
				{delay = 5, id = 100232},
				{delay = 5, id = 100341},
				{delay = 5, id = 100351},
				{delay = 0, id = 101669},
				{delay = 15, id = 101648},
			}
		}
	},
	-- add missing sniper
	[103582] = {
		values = {
			difficulty_overkill_145 = true,
			difficulty_easy_wish = true
		}
	},
	[102866] = {
		values = {
			enabled = false
		}
	},
	[102880] = {
		values = {
			enabled = false
		}
	},
	[100029] = {
		values = {
			interval = 20
		}
	},
	-- slow down inkwell industrial spawnpoints
	[100441] = {
		values = {
			interval = 60
		}
	},
	[103333] = {
		values = {
			interval = 40
		}
	},
	[103719] = {
		values = {
			interval = 30
		}
	}
}
