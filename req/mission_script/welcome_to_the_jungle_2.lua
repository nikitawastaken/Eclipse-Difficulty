local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local flank_spawn = {
	values = {
		interval = 15,
	},
}
local porch_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
local skylight_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_group = {
	values = {
		interval = 90,
	},
}
local forest_navlink = {
	values = {
		align_position = false,
	},
	so_action = "e_nl_slide_down_2m",
}
	
return {
	-- Add power cut SO delay
	[100313] = {
		values = {
			base_delay = 30,
			base_delay_rand = 30,
		},
	},
	-- Add new reinforce
	[104421] = { -- light flare
		reinforce = {
			{
				name = "pool",
				force = 4,
				position = Vector3(2100, -3000, 0),
			},
		},
	},
	[100006] = { -- ditto
		reinforce = {
			{
				name = "runway",
				force = 4,
				position = Vector3(-6800, 550, 0),
			},
		},
	},
	[100069] = disabled,
	[101618] = disabled,
	[103415] = disabled,
	[103421] = disabled,
	-- Enable the pool heli below Death Wish
	[104393] = filter_disable,
	-- Add new navlinks
	[100232] = {
		on_executed = {
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
			{ id = 400004, delay = 0 },
		},
	},
	-- Tweak existing navlinks
	[100244] = forest_navlink,
	[100245] = forest_navlink,
	-- Spawn group intervals
	[100571] = flank_spawn,
	[100610] = flank_spawn,
	[103172] = porch_spawn,
	[103437] = porch_spawn,
	[100116] = skylight_spawn,
	[103249] = skylight_spawn,
	[103501] = cloaker_group,
	[103503] = cloaker_group,
	[103504] = cloaker_group,
	[103505] = cloaker_group,
	[103506] = cloaker_group,
}
