local security_army = {
	enemy = "units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1",
}
return {
	-- restores unused sniper spawn
	[100370] = {
		values = {
			enabled = true,
		},
	},
	-- National Guard instead of secret service
	[100670] = security_army,
	[100671] = security_army,
	[100672] = security_army,
	[100673] = security_army,
	[100674] = security_army,
	[100675] = security_army,
	[100676] = security_army,
	[100677] = security_army,
	[100678] = security_army,
	[100679] = security_army,
	[102127] = security_army,
	[103124] = security_army,
	[103033] = security_army,
	[105209] = security_army,
	[105241] = security_army,
}
