return {
	[101433] = {
		ponr = {
			length = 60,
			player_mul = {1.25, 1, 1, 0.75}
		}
	},
	-- Give saw to all players
	[101865] = {
		func = function(self)
			managers.network:session():send_to_peers_synched("give_equipment", self._values.equipment, self._values.amount)
		end
	},
	--  this disables multiple spawn points when limo lands on the balcony, which is weird, to say the least
	[101898] = {
		values = {
			enabled = false,
		},
	},
	-- No code chance increase on fail or knockout
	[102865] = {
		on_executed = {
			{ id = 102887, remove = true }
		}
	},
	[102872] = {
		on_executed = {
			{ id = 102887, remove = true }
		}
	},
	-- Code chance increase each time taxman is hit
	[102006] = {
		on_executed = {
			{ id = 102887, delay = 0 }
		}
	},
	[102868] = {
		on_executed = {
			{ id = 102887, delay = 0 }
		}
	},
	-- Code chance increase amount
	[102887] = {
		chance = 10
	},
	-- Faint duration increase
	[102860] = {
		values = {
			action_duration_min = 60,
			action_duration_max = 90
		}
	}
}
