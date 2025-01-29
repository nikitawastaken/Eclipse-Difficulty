local reinforce = {
	on_executed = {
		{ id = 100364, delay = 0 }
	}
}

return {
	-- Special ambush chance increase
	[103072] = {
		chance = 75
	},
	[105563] = {
		values = {
			player_1 = true
		}
	},
	[105574] = {
		values = {
			player_1 = true
		}
	},
	-- Enable spawns sooner
	[103882] = {
		on_executed = {
			{ id = 100251, delay = 30 },
			{ id = 105774, delay = 20 }
		}
	},
	-- Enable all street reinforce spots when first responders arrive
	[104727] = reinforce,
	[104728] = reinforce,
	[104729] = reinforce,
	[104730] = reinforce,
}