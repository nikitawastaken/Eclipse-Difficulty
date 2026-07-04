local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local standard_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
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
	-- Spawn group intervals
	[100128] = standard_spawn,
	[100132] = standard_spawn,
	[101166] = standard_spawn,
	[101309] = standard_spawn,
	[104406] = standard_spawn,
	[104471] = standard_spawn,
	[101310] = garage_spawn,
	[102066] = garage_spawn,
	[100805] = elevator_spawn,
	[101555] = elevator_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
}
