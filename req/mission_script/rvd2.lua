return {
	-- Replace dozer spam with less stupid enemies
	[101565] = {
		enemy = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	},
	[101176] = {
		enemy = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
	},
	[101207] = {
		enemy = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
	},
	[102176] = {
		values = {
			enabled = false
		}
	},
	-- instantly enter point of no return upon securing all bags
	[100884] = {
		set_ponr_state = true
	}
}
