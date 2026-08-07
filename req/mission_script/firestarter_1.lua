local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local heavy = scripted_enemy.heavy_swat_2
local bulldozer = scripted_enemy.bulldozer_1
local shield = scripted_enemy.shield
local hangar_reinforce_amount = {
	values = {
		amount = 3,
	},
}
local gangster_outside_amount = {
	values = {
		amount = 3,
		amount_random = 3,
	},
}
local gangster_inside_amount = {
	values = {
		amount = 2,
		amount_random = 2,
	},
}
local gangster_stationary_amount = {
	values = {
		amount = 3,
		amount_random = 0,
	},
}
local heli_enemy1 = {
	enemy = heavy,
	on_executed = {
		{ id = 103457, delay = 0 },
	},
}
local heli_enemy2 = {
	enemy = shield,
	on_executed = {
		{ id = 103456, delay = 0 },
	},
}
local heli_enemy3 = {
	enemy = bulldozer,
	on_executed = {
		{ id = 103455, delay = 0 },
	},
}
local heli_enemy4 = {
	values = {
		participate_to_group_ai = false,
	},
}
local invisible_wall_ids = Idstring("units/dev_tools/level_tools/dev_collision_4m_bag")
local swat_shield_dozer_filter = {
	so_access_filter = { "swat", "shield", "tank" },
}
local no_align_pos1 = {
	values = {
		align_position = false,
	}
}
local no_align_pos2 = deep_clone(no_align_pos1)
no_align_pos2.values.so_action = "e_nl_down_4m_var3"

return {
	-- Add missing hangar reinforce spots
	[103162] = {
		on_executed = {
			{ id = 101359, delay = 0 }
		}
	},
	[103211] = {
		on_executed = {
			{ id = 101360, delay = 0 }
		}
	},
	-- increase reinforce outside hangars
	[101355] = hangar_reinforce_amount,
	[101352] = hangar_reinforce_amount,
	[101347] = hangar_reinforce_amount,
	[101349] = hangar_reinforce_amount,
	-- adjust FBI chopper ambush
	-- fix the chopper leaving too early
	[103386] = {
		on_executed = {
			{ id = 103387, delay = 14 },
		},
	},
	[103432] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103433] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103434] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103435] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	-- Currently disabled cause of amazing devs of Sidetrack Games fucking it up
	-- will re-enable it once they *fix* it
	--[[
	[103136] = {
		on_executed = {
			{ id = 103437, delay = 0 },
		},
	},
	]]
	--
	[103422] = heli_enemy1,
	[103422] = heli_enemy4,
	[103424] = heli_enemy2,
	[103425] = heli_enemy3,
	[103455] = swat_shield_dozer_filter,
	[103456] = swat_shield_dozer_filter,
	[103457] = swat_shield_dozer_filter,
	-- restore unused snipers
	[102569] = {
		on_executed = {
			{ id = 101907, delay = 120 },
		},
	},
	-- fix tower sniper not using SOs
	[101905] = {
		on_executed = {
			{ id = 101906, delay = 0 },
			{ id = 101908, delay = 0 },
			{ id = 100168, delay = 0 },
			{ id = 100163, delay = 0 },
		},
	},
	-- disable 'align_position' for select navlinks
	[103692] = no_align_pos1,
	[104450] = no_align_pos1,
	[104451] = no_align_pos1,
	[103935] = no_align_pos1,
	[103936] = no_align_pos1,
	[103938] = no_align_pos1,
	[103937] = no_align_pos1,
	[103918] = no_align_pos1,
	[103917] = no_align_pos1,
	[103916] = no_align_pos1,
	[103921] = no_align_pos1,
	[103920] = no_align_pos1,
	[103919] = no_align_pos1,
	[100767] = no_align_pos2,
	[100785] = no_align_pos2,
	[100842] = no_align_pos2,
	[100912] = no_align_pos2,
	-- tweak gangsters amount
	[101298] = gangster_outside_amount,
	[101040] = gangster_outside_amount,
	[100918] = gangster_outside_amount,
	[100910] = gangster_outside_amount,
	[100642] = gangster_outside_amount,
	[103254] = gangster_inside_amount,
	[102342] = gangster_inside_amount,
	[103168] = gangster_inside_amount,
	[101306] = gangster_stationary_amount,
	[101046] = gangster_stationary_amount,
}
