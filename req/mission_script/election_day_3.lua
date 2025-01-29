local is_eclipse = Eclipse.utils.is_eclipse()

local sniper_interval = is_eclipse and 15 or 25

return {
	[104782] = {
		ponr = {
			length = 420,
			player_mul = { 1.5, 1.25, 1, 1 }
		}
	},
	[100082] = {  -- prevent sniper respawn delays becoming ridiculously small as more assaults pass
		on_executed = {
			{ id = 100321, remove = true, }
		}
	},
	[100446] = {
		on_executed = {
			{ id = 100321, delay = 0, }
		}
	},
	[103702] = {
		values = {
			interval = sniper_interval
		}
	},
	[100438] = {
		values = {
			interval = sniper_interval
		}
	},
}