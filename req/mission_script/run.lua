return {
    -- ovk145-alike dozer spawn on armitage avenue
	[103593] = {
		values = {
			chance = 100
		}
	},
    [100232] = {
        values = {
            enemy = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"
        }
    },
    [100341] = {
        values = {
            enemy = "units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"
        }
    },
    [100351] = {
        values = {
            enemy = "units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"
        }
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
	[100441] = {
		values = {
			interval = 20
		}
	},
	[103333] = {
		values = {
			interval = 20
		}
	}
}