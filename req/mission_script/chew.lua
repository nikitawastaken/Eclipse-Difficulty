local overkill_and_above = Eclipse.utils.diff_threshold()

return {
	-- Boss spawn
	[100707] = {
		difficulty = 0.1,
	},
	-- Boss dead
	[100645] = {
		difficulty = 0.75,
	},
	-- Disable difficulty 1 element
	[100909] = {
		values = {
			enabled = false,
		},
	},
	-- restore 4 Player C4 Event
	-- make it appear on ovk above and enable it to all players
	[100560] = {
		values = {
			enabled = not overkill_and_above and false or true,
			player_1 = true,
			player_2 = true,
			player_3 = true,
		},
	},
}
