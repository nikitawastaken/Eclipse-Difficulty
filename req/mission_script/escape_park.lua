local preferred = Eclipse.preferred
local swat_spawn_fix = {
	spawn_action = "e_sp_down_16m_right",
}
local wall_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- fix some sniping swats not spawning
	[102486] = {
		on_executed = {
			{ id = 100677, delay = 0 },
		},
	},
	[102457] = {
		on_executed = {
			{ id = 100677, delay = 0 },
		},
	},
	-- fix spawn anims for rappeling SWATs
	[100747] = swat_spawn_fix,
	[100748] = swat_spawn_fix,
	[100737] = swat_spawn_fix,
	[100738] = swat_spawn_fix,
	[100846] = swat_spawn_fix,
	[100847] = swat_spawn_fix,
	[100844] = swat_spawn_fix,
	[100845] = swat_spawn_fix,
	-- Spawn group intervals
	[100634] = wall_spawn,
	[102326] = wall_spawn,
}
