local disabled = {
	values = {
		enabled = false,
	},
}
local air_siren = {
	values = {
		sound_event = "earthquake_siren"
	},
}
return {
	-- replace police sirens with the same one used in Boiling Point
	[100288] = air_siren,
	[104193] = air_siren,
	-- disable scripted megaphone cop
	[106309] = disabled,
	-- disable cop car lights on startup
	[100018] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	-- disable endless assault (the heist doesn't need one)
	[101473] = disabled,
}
