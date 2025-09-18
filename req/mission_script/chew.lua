local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local disabled = {
	values = {
		enabled = false,
	},
}
return {
	-- Boss spawn
	[100707] = {
		difficulty_max = 0.1,
	},
	-- Boss dead
	[100645] = {
		difficulty_max = 1,
		difficulty_min = 1,
	},
	-- Disable difficulty 1 element
	[100909] = disabled,
	-- disable anything related to swat turret
	[101107] = disabled,
	[101108] = disabled,
	-- restore 4 Player C4 Event
	-- make it appear on ovk above and enable it to all players
	[100560] = {
		values = {
			enabled = overkill_and_above and true or false,
			player_1 = true,
			player_2 = true,
			player_3 = true,
		},
	},
}
