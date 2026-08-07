local preferred = Eclipse.preferred
local swat_spawn_fix = {
	spawn_action = "e_sp_down_16m_right",
}
local sniper_so = {
	on_executed = {
		{ id = 100677, delay = 0 }
	}
}
return {
	-- Infinite assault at the very start
	[101580] = { -- func_difficulty_001
		hunt = true,
	},
	[100756] = { -- obj1_complete
		set_ponr_state = true,
	},
	-- Add reinforce
	[102073] = { -- enable_all_preferred_spawns
		reinforce = {
			{
				name = "park01",
				force = 3,
				position = Vector3(325, -1500, 25),
			},
			{
				name = "park02",
				force = 2,
				position = Vector3(350, 450, -150),
			},
			{
				name = "park03",
				force = 2,
				position = Vector3(3000, -1500, -150),
			},
			{
				name = "park04",
				force = 2,
				position = Vector3(350, -3100, -150),
			},
			{
				name = "park05",
				force = 2,
				position = Vector3(-2100, -1500, -150),
			},
		},
	},
	-- Enable missing escape SO SWATs
	[102457] = sniper_so,
	[102486] = sniper_so,
	-- fix spawn anims for rappeling SWATs
	[100747] = swat_spawn_fix,
	[100748] = swat_spawn_fix,
	[100737] = swat_spawn_fix,
	[100738] = swat_spawn_fix,
	[100846] = swat_spawn_fix,
	[100847] = swat_spawn_fix,
	[100844] = swat_spawn_fix,
	[100845] = swat_spawn_fix,
}
