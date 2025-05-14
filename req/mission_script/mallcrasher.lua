local preferred = Eclipse.preferred
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "spooc" },
}
local stairs_spawn = {
	values = {
		interval = 10,
	},
}
local skylight_spawn1 = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local skylight_spawn2 = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[300000] = {
		ai_area = {
			{ 47, 54, 67, 68, 70, 112 },
			{ 49, 61, 73 },
			{ 41, 52 },
			{ 29, 33, 42, 44 },
			{ 3, 4 },
			{ 45, 57, 60, 69 },
			{ 58, 65 },
			{ 76, 84 },
			{ 81, 72 },
			{ 55, 111 },
			{ 86, 101, 104, 106, 108, 109 },
			{ 24, 39 },
			{ 90, 93, 94, 96 },
		},
	},
	-- Delay SWAT response
	[300203] = {
		on_executed = {
			{ id = 300164, delay = 45 },
		},
	},
	-- fix one of the cop cars not being hidden
	[302012] = {
		values = {
			unit_ids = {
				302026,
				302025,
				302023,
				302027,
				500501,
				500857,
				500851
			}
		},
	},
	-- disable the silly jump SOs for some enemies
	[301777] = exclude_cop_agents_shields_dozers,
	[302013] = exclude_cop_agents_shields_dozers,
	[302020] = exclude_cop_agents_shields_dozers,
	[302024] = exclude_cop_agents_shields_dozers,
	[302035] = exclude_cop_agents_shields_dozers,
	[302047] = exclude_cop_agents_shields_dozers,
	[302048] = exclude_cop_agents_shields_dozers,
	[302049] = exclude_cop_agents_shields_dozers,
	[302050] = exclude_cop_agents_shields_dozers,
	[302051] = exclude_cop_agents_shields_dozers,
	[302052] = exclude_cop_agents_shields_dozers,
	[302053] = exclude_cop_agents_shields_dozers,
	[302054] = exclude_cop_agents_shields_dozers,
	[302055] = exclude_cop_agents_shields_dozers,
	[302056] = exclude_cop_agents_shields_dozers,
	[302057] = exclude_cop_agents_shields_dozers,
	[302060] = exclude_cop_agents_shields_dozers,
	[302061] = exclude_cop_agents_shields_dozers,
	[302062] = exclude_cop_agents_shields_dozers,
	[302063] = exclude_cop_agents_shields_dozers,
	[302064] = exclude_cop_agents_shields_dozers,
	[302065] = exclude_cop_agents_shields_dozers,
	[302066] = exclude_cop_agents_shields_dozers,
	[302067] = exclude_cop_agents_shields_dozers,
	[302068] = exclude_cop_agents_shields_dozers,
	[302069] = exclude_cop_agents_shields_dozers,
	[302070] = exclude_cop_agents_shields_dozers,
	[302071] = exclude_cop_agents_shields_dozers,
	[302072] = exclude_cop_agents_shields_dozers,
	[302073] = exclude_cop_agents_shields_dozers,
	[302074] = exclude_cop_agents_shields_dozers,
	-- Spawn group delays
	-- This heist got botched pretty hard when spawn group intervals were standardized.
	-- More or less what you'd expect, the skylight rappels have been slowed down drastically, but it's not a complete port of the old intervals.
	-- There are two different intervals for these rappels, the longer one is used for the groups that spawn directly in front of shops in straight lines, they cover a lot of playable space when they spawn.
	-- The staircase spawn very close to the escaltor is slightly slower to slow down the initial assault.
	[300314] = stairs_spawn,
	[301852] = skylight_spawn1,
	[301847] = skylight_spawn1,
	[302083] = skylight_spawn2,
	[302084] = skylight_spawn2,
}
