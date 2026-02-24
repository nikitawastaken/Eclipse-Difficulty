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
	}
}
