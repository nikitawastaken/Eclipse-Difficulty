return {
	[100628] = {
		values = {
			enabled = false,
		},
	},
	[100720] = {
		set_ponr_state = true,
	},
	-- loopable heli
	-- trigger in alarm rather than in the second assault
	[100022] = {
		on_executed = {
			{ id = 102530, delay = 360 }, --6 mins delay to trigger
		},
	},
	-- not need to have that anymore
	[101908] = {
		values = {
			enabled = false,
		},
	},
	-- and you too
	[102538] = {
		values = {
			enabled = false,
		},
	},
	-- loop the choppa
	[102530] = {
		values = {
			trigger_times = 0,
		},
		on_executed = {
			{ id = 102530, delay = 180 },
		},
	},
	-- slow down a few spawnpoints
	[100007] = {
		values = {
			interval = 20,
		},
	},
	[100130] = {
		values = {
			interval = 10,
		},
	},
	[100131] = {
		values = {
			interval = 10,
		},
	},
	[100019] = {
		values = {
			interval = 10,
		},
	},
	[100133] = {
		values = {
			interval = 10,
		},
	},
}
