return {
	-- Enter main hall
	[103594] = {
		difficulty = 0.1
	},
	-- Boss dead, safe objective
	[101169] = {
		difficulty = 1
	},
	 -- Disable Sosa retreat on low health during boss fight
	[101596] = {
		values = {
			enabled = false
		}
	},
	-- Fallback to make Sosa retreat when house is accessible
	[102653] = {
		on_executed = {
			{ id = 102692, delay = 0 }
		}
	}
}