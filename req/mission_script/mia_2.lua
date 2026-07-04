local scripted_enemy = Eclipse.scripted_enemy
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local preferred = Eclipse.preferred

local specials_list = {
	[scripted_enemy.taser_1] = get_difficulty_group_specific_value({ 3, 2, 3 }),
	[scripted_enemy.medic_1] = get_difficulty_group_specific_value({ 0, 1, 2 }),
	[scripted_enemy.cloaker] = get_difficulty_group_specific_value({ 1, 2, 3 }),
}
local random_special = specials_list
local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}

local bulldozer_enemy = {
	enemy = is_eclipse_pro and random_elite_dozers or random_dozers,
}
local cloaker_enemy = {
	enemy = scripted_enemy.cloaker,
}
local swats = {
	enemy = {
		[overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1] = 1,
		[overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2] = 1,
	},
}
local shield_enemy = {
	enemy = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield,
}
local special_enemy = {
	enemy = random_special,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false,
	},
}
local apartment_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
}
local skylight_navlink_interval = {
	values = {
		interval = 6, -- (Vanilla: 10s)
	},
}
local skylight_navlink_interval_enable = deep_clone(skylight_navlink_interval)
skylight_navlink_interval_enable.values.enabled = true

return {
	[100043] = { -- player_spawned
		paused_difficulty_addends = { -- disable addends
			on_entered_regroup = 1,
		},
	},
	[100512] = { -- add_spawn (apartment spawns)
		paused_difficulty_addends = { -- enable addends
			on_entered_regroup = false,
		},
		on_executed = { -- Don't remove 3rd floor spawngroups
			{ id = 100511, remove = true }, -- ai_enemy_prefered_remove_002
		},
	},
	-- Boss spawn
	[100154] = {
		add_drama = {
			amount = 1,
			balance_mul = { 1, 1, 1, 1 },
			team_ai_balance_mul_weight = 1,
			ignore_gain_mul = true,
		},
		forced_difficulty = {
			amount = 0.1,
			time = { 15, 30 },
			delay = 0,
		},
	},
	-- Boss dead
	[100153] = {
		ponr = { -- FFO
			length = 60,
			length_balance_mul = { 2, 1.5, 1, 1 },
		},
		forced_difficulty = false, -- Disable forced diff
	},
	[101133] = cloaker_enemy,
	[101141] = cloaker_enemy,
	-- change up Commissar's room enemies
	[101164] = shield_enemy,
	[101151] = shield_enemy,
	[101156] = swat_enemy,
	[101160] = swat_enemy,
	[101158] = swat_enemy,
	[101159] = swat_enemy,
	--Use unhooked scripted swat spawn for random special unit (can be either medic, taser or cloaker)
	[101678] = {
		on_executed = {
			{ id = 101166, delay = 0 },
		},
	},
	[101166] = special_enemy,
	-- Randomize all dozers in the room
	[101133] = bulldozer_enemy,
	[101137] = bulldozer_enemy,
	[101141] = bulldozer_enemy,
	-- Tweak other scripted spawns
	[101977] = bulldozer_enemy,
	[102018] = bulldozer_enemy,
	[101970] = shield_enemy,
	[101971] = shield_enemy,
	[101968] = swat_enemy,
	[101088] = swat_enemy,
	[101969] = swat_enemy,
	[102014] = shield_enemy,
	[102015] = shield_enemy,
	[102016] = swat_enemy,
	[102019] = swat_enemy,
	[102020] = swat_enemy,
	--Should decrease sniper spawn intensity (I hope)
	[101202] = {
		values = {
			chance = 2,
		},
	},
	[100686] = {
		values = {
			chance = 4,
		},
	},
	-- Fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
	-- Decrease skylight navlink intervals
	-- e_nl_down_4m
	[101055] = skylight_navlink_interval,
	[101086] = skylight_navlink_interval_enable,
	[101087] = skylight_navlink_interval_enable,
	[101089] = skylight_navlink_interval,
	[101090] = skylight_navlink_interval,
	[101091] = skylight_navlink_interval,
	[101092] = skylight_navlink_interval,
	[101093] = skylight_navlink_interval,
	[101094] = skylight_navlink_interval,
	[101185] = skylight_navlink_interval,
	[101190] = skylight_navlink_interval,
	-- Spawn group intervals
	[101084] = apartment_spawn,
	[101085] = apartment_spawn,
	[100627] = apartment_spawn,
	[100629] = apartment_spawn,
	[100666] = apartment_spawn,
	[101034] = apartment_spawn,
	[101530] = apartment_spawn,
	[101534] = apartment_spawn,
}
