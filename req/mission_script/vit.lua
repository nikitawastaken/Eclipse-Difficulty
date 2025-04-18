local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()

local humvee_crash_event_chance = {
	values = {
		enabled = (normal and 0.1 or hard and 0.3 or 0.5) + ((is_pro_job and normal) and 0.1 or is_pro_job and 0.3),
	},
}

return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 44, 84, 85 },
			{ 103, 104, 105, 106 },
			{ 97, 99 },
			{ 52, 86 },
		},
	},
	[100022] = {
		ponr = {
			length = 3000,
			player_mul = { 1.75, 1.25, 1.125, 1 },
		},
	},
	-- make humvee event be chance based
	[101606] = humvee_crash_event_chance,
	-- Increase delay on side door spawns
	[103347] = {
		values = {
			interval = 30,
		},
	},
	[103348] = {
		values = {
			interval = 30,
		},
	},
	[103360] = {
		values = {
			enabled = false,
		},
	},
	[101416] = {
		values = {
			enabled = false,
		},
	},
	-- slow down the spawnpoints in peoc (ones that are close to the staircase)
	[100694] = {
		values = {
			interval = 30,
		},
	},
	[102557] = {
		values = {
			interval = 20,
		},
	},
}
