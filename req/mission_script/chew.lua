local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local disabled = {
	values = {
		enabled = false,
	},
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
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
	[101091] = filter_easy_above,
	[101092] = filter_disable,
	[101093] = {
		on_executed = {
			{ id = 101097, delay = 0 },
		},
	},
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
