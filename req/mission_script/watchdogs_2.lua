return {
	--Spawn Ground Snipers after 3 minutes
	[100486] = {
		on_executed = {
			{ id = 400035, delay = 180 }
		}
	},
	--Spawn Snipers on the ships
	[102182] = {
		on_executed = {
			{ id = 400013, delay = 20 }
		}
	},
	[102388] = {
		on_executed = {
			{ id = 400014, delay = 20 }
		}
	},
	[102335] = {
		on_executed = {
			{ id = 400015, delay = 20 }
		}
	}
}