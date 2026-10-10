local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local enabled = {
	values = {
		enabled = true,
	},
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
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
	enemy = scripted_enemy.heavy_swat_2,
	on_executed = {
		{ id = 103457, delay = 0 },
	},
}
local heli_enemy2 = {
	enemy = scripted_enemy.shield,
	on_executed = {
		{ id = 103456, delay = 0 },
	},
}
local heli_enemy3 = {
	enemy = scripted_enemy.bulldozer_1,
	on_executed = {
		{ id = 103455, delay = 0 },
	},
}
local heli_enemy4 = {
	values = {
		participate_to_group_ai = false,
	},
}
local swat_shield_dozer_filter = {
	so_access_filter = { "swat", "shield", "tank" },
}
local no_align_pos1 = {
	values = {
		align_position = false,
	},
}
local no_align_pos2 = deep_clone(no_align_pos1)
no_align_pos2.values.so_action = "e_nl_down_4m_var3"

local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false,
	},
}
local enable_forest_group = {
	on_executed = {
		{ id = 400004, delay = 30 },
	},
}
local forest_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}

return {
	-- Add missing hangar reinforce spots
	[103162] = {
		on_executed = {
			{ id = 101359, delay = 0 },
		},
	},
	[103211] = {
		on_executed = {
			{ id = 101360, delay = 0 },
		},
	},
	-- Two guaranteed open hangars on Overkill+ and a chance for an additional one in a Pro Job regardless of difficulty.
	[102208] = { -- RandomizeHangar
		values = {
			amount = (overkill_and_above and 2 or 1) + (is_pro_job and 1 or 0),
		},
	},
	[103397] = filter_easy_above,
	[103398] = filter_disable,
	-- Add the new forest group to existing preferreds
	[102652] = { -- ai_enemy_prefered_add_001
		values = {
			spawn_groups = {
				101336,
				102499,
				102497,
				100223,
				103553,
				400003,
			},
		},
		on_executed = { -- Reduce the other preferred's delay and add a random delay
			{ id = 102380, delay = 60, delay_rand = 120 }, -- Vanilla: 240 + 0s
		},
	},
	-- Enable the new forest group when the fences are cut (extra precaution if you go loud before even cutting one of the fences)
	[102466] = enable_forest_group,
	[102467] = enable_forest_group,
	[102468] = enable_forest_group,
	-- Add Cloaker spawns
	[100428] = { -- trigger_global_event_001
		on_executed = {
			{ id = 400018, delay = 0 },
		},
	},
	-- Restore unused cloaker hiding spots
	[100944] = enabled,
	[101004] = enabled,
	[101166] = enabled,
	[101168] = enabled,
	[101976] = enabled,
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
	-- Fix sniper SO spots
	[100163] = no_spawn_instigator_ids,
	[100168] = no_spawn_instigator_ids,
	[101906] = no_spawn_instigator_ids,
	[101908] = no_spawn_instigator_ids,
	-- improve sniper spot select
	[101905] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	[100099] = {
		on_executed = {
			{ id = 400002, delay = 0 },
			{ id = 100160, remove = true },
			{ id = 100161, remove = true },
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
	-- Spawn group intervals
	[400003] = forest_spawn,
	[400011] = cloaker_spawn,
	[400012] = cloaker_spawn,
	[400013] = cloaker_spawn,
	[400014] = cloaker_spawn,
	[400015] = cloaker_spawn,
	[400016] = cloaker_spawn,
}
