local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local rappel_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local upper_spawn = {
	values = {
		interval = 30,
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
local bags_required = {
	values = {
		counter_target = 4 + (is_pro_job and 2 or 0),
	},
}
return {
	-- Add new reinforce
	[101577] = {
		reinforce = {
			{
				name = "lobby",
				force = 4,
				position = Vector3(-300, 550, 0),
			},
		},
	},
	-- change amount of required bags
	-- the amount of required bags in vanilla sucks so hard
	[101753] = bags_required,
	[101758] = bags_required,
	[101759] = bags_required,
	[101760] = bags_required,
	[101761] = bags_required,
	[100470] = disabled,
	-- Remove a few stupid reinforce spots
	[102051] = disabled,
	[102053] = disabled,
	[102054] = disabled,
	[102070] = disabled,
	[102079] = disabled,
	-- Remove curly spawns
	[101653] = disabled,
	-- Remove the skylight spawns
	[101660] = disabled,
	-- Spawn group intervals
	[100128] = rappel_spawn,
	[101166] = rappel_spawn,
	[101309] = rappel_spawn,
	[104406] = rappel_spawn,
	[104471] = upper_spawn,
	[100132] = upper_spawn,
	[101310] = garage_spawn,
	[102066] = garage_spawn,
	[100805] = elevator_spawn,
	[101555] = elevator_spawn,
}
