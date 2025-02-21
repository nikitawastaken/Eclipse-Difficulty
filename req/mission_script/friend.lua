local mobster_team = {
	values = {
		team = "mobster1",
	},
}
return {
	-- Enter main hall
	[103594] = {
		difficulty = 0.1,
	},
	-- Boss dead, safe objective
	[101169] = {
		difficulty = 1,
	},
	-- Disable Sosa retreat on low health during boss fight
	[101596] = {
		values = {
			enabled = false,
		},
	},
	-- Fallback to make Sosa retreat when house is accessible
	[102653] = {
		on_executed = {
			{ id = 102692, delay = 0 },
		},
	},
	--You're Sosa's men, not undercover cops
	[100852] = mobster_team,
	[100854] = mobster_team,
	[100855] = mobster_team,
	[100856] = mobster_team,
	[100857] = mobster_team,
	[100858] = mobster_team,
	[100858] = mobster_team,
	[100859] = mobster_team,
	[100860] = mobster_team,
	[100861] = mobster_team,
	[100862] = mobster_team,
	[100863] = mobster_team,
	[101185] = mobster_team,
	[101185] = mobster_team,
	[101189] = mobster_team,
	[101771] = mobster_team,
	[102301] = mobster_team,
	[102395] = mobster_team,
	[102399] = mobster_team,
	[102404] = mobster_team,
	[102408] = mobster_team,
	[102419] = mobster_team,
	[102421] = mobster_team,
	[102532] = mobster_team,
	[102535] = mobster_team,
	[102538] = mobster_team,
	[102540] = mobster_team,
	[102542] = mobster_team,
	[102544] = mobster_team,
	[102546] = mobster_team,
	[102548] = mobster_team,
	[102550] = mobster_team,
	[102553] = mobster_team,
	[102557] = mobster_team,
	[102559] = mobster_team,
	[102562] = mobster_team,
	[102565] = mobster_team,
	[102569] = mobster_team,
	[102572] = mobster_team,
	[102576] = mobster_team,
	[102578] = mobster_team,
	[102581] = mobster_team,
	[102583] = mobster_team,
}
