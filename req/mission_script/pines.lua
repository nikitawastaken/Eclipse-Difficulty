return {
	-- replace police sirens with the same one used in Boiling Point
	[100288] = {
		values = {
            sound_event = "earthquake_siren"
		}
	},
	[104193] = {
		values = {
            sound_event = "earthquake_siren"
		}
	},
	-- disable scripted megaphone cop
	[106309] = {
		values = {
            enabled = false
		}
	},
	-- disable cop car lights on startup
	[100018] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
}
