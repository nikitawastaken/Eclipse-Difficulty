return {
    [101433] = {
        ponr = 60,
        ponr_player_mul = {1.25, 1, 1, 0.75}
    },
	-- Give saw to all players
	[101865] = {
		func = function(self)
			managers.network:session():send_to_peers_synched("give_equipment", self._values.equipment, self._values.amount)
		end
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
		values = {
			chance = 10
		}
	},
	-- Faint duration increase
	[102860] = {
		values = {
			action_duration_min = 60,
			action_duration_max = 90
		}
	}
}