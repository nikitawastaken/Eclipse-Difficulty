return {
    -- Disable forced manager flee objective
	[100665] = {
		values = {
			enabled = false
		}
	},
    -- add point of no return
    [103334] = {
        ponr = 150,
        ponr_player_mul = {1.25, 1, 0.85, 0.75}
    },
    -- remove a few cancer dozers
    [103603] = {
		values = {
			enabled = false
		}
	},
    [104132] = {
        values = {
            enemy = "units/payday2/characters/ene_spook_1/ene_spook_1"
        }
    },
    [104710] = {
        values = {
            enemy = "units/payday2/characters/ene_spook_1/ene_spook_1"
        }
    },
    [104131] = {
        values = {
            enemy = "units/payday2/characters/ene_tazer_1/ene_tazer_1"
        }
    },
    [104169] = {
        values = {
            enemy = "units/payday2/characters/ene_tazer_1/ene_tazer_1"
        }
    },
    [104000] = {
        values = {
            chance = 1
        }
    },
    [100225] = {
        values = {
            amount = 5
        }
    },
}
