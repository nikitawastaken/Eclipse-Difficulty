return {
	-- Make cloaker spawn participate to group AI
	[101320] = {
		values = {
			participate_to_group_ai = true
		}
	},
	-- Remove spawn groups closest to broken bridge part
	[101176] = {
		values = {
			spawn_groups = { 100867, 101153, 101157, 101154, 101160, 101156, 101159 }
		}
	},
	-- Increase spawn group intervals next to prison vans, closest to furthest
	[100867] = {
		values = {
			interval = 90
		}
	},
	[101153] = {
		values = {
			interval = 90
		}
	},
	[101157] = {
		values = {
			interval = 90
		}
	},
	[101154] = {
		values = {
			interval = 60
		}
	},
	[101160] = {
		values = {
			interval = 60
		}
	},
	[101156] = {
		values = {
			interval = 45
		}
	},
	[101159] = {
		values = {
			interval = 45
		}
	}
}