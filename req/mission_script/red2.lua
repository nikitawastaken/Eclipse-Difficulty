return {
	-- Disable forced manager flee objective
	[100665] = {
		values = {
			enabled = false
		}
	},
	-- add point of no return
	[103334] = {
		ponr = {
			length = 150,
			player_mul = {1.1, 0.9, 0.7, 0.5}
		}
	},
	-- remove a few cancer dozers
	[103603] = {
		values = {
			enabled = false
		}
	},
	[104132] = {
		enemy = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	},
	[104710] = {
		enemy = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	},
	[104131] = {
		enemy = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
	},
	[104169] = {
		enemy = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
	},
	[104000] = {
		chance = 100
	},
	[100225] = {
		values = {
			amount = 5
		}
	},
	-- slow down a few repel spawnpoints
	[105112] = {
		values = {
			interval = 30
		}
	},
	[106890] = {
		values = {
			interval = 30
		}
	},
	[103953] = {
		values = {
			interval = 10
		}
	},
}
