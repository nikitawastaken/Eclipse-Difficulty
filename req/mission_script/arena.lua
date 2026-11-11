local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local rappel_horizontal_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields,
}
local rappel_vertical_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local garage_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local elevator_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local bags_required = {
	values = {
		counter_target = 4 + (is_pro_job and 2 or 0),
	},
}
return {
	-- Add a new loot drop point
	[100405] = disabled,
	[102864] = {
		loot_drop = {
			{ name = "player_spawn", position = Vector3(-300, -250, 0) },
		},
	},
	-- Change amount of required bags
	-- The amount of required bags in vanilla sucks so hard
	[101753] = bags_required,
	[101758] = bags_required,
	[101759] = bags_required,
	[101760] = bags_required,
	[101761] = bags_required,
	[100470] = disabled,
	-- Disable reinforce inside the pyro booth
	[102070] = disabled,
	-- Disable curly cheat spawns
	[101653] = disabled, -- curly_near_top_2_3
	[101308] = disabled, -- curly_near_top_1_group
	[101649] = disabled, -- curly_near_top_1_group
	-- Scripted difficulty scaling
	[101452] = { -- override_complete (Initial hack complete)
		on_executed = {
			{ id = 400002, delay = 0 },
		},
	},
	[100244] = { -- Enable Hackable Laptop (Pyro Booth)
		on_executed = {
			{ id = 400003, delay = 0 },
		},
	},
	[101646] = { -- drilling (Opening the vaults from below)
		on_executed = {
			{ id = 400004, delay = 0 },
		},
	},
	-- Spawn group intervals
	[100128] = rappel_horizontal_spawn,
	[101309] = rappel_horizontal_spawn,
	[101166] = rappel_vertical_spawn,
	[104406] = rappel_vertical_spawn,
	[101310] = garage_spawn,
	[102066] = garage_spawn,
	[100805] = elevator_spawn,
	[101555] = elevator_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
}
