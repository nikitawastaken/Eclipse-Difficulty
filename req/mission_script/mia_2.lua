local scripted_enemy = Eclipse.scripted_enemy
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local preferred = Eclipse.preferred
local cloaker = scripted_enemy.cloaker
local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2

local swats = { [swat_1] = 1, [swat_2] = 1 }
local specials_list = {
	[taser] = get_difficulty_group_specific_value({ 3, 2, 3 }),
	[medic] = get_difficulty_group_specific_value({ 0, 1, 2 }),
	[cloaker] = get_difficulty_group_specific_value({ 1, 2, 3 }),
}
local random_special = specials_list
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}

local bulldozer = is_eclipse_pro and random_elite_dozers or random_dozers
local bulldozer_enemy = {
	enemy = bulldozer,
}
local cloaker_enemy = {
	enemy = cloaker,
}
local swat_enemy = {
	enemy = swats,
}
local shield_enemy = {
	enemy = shield,
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
local roof_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
return {
	[100043] = { -- player_spawned
		allowed_difficulty_addends = { -- disable sustain addends
			on_entered_regroup = false,
		},
	},
	[100512] = { -- add_spawn (apartment spawns)
		allowed_difficulty_addends = { -- enable sustain addends
			on_entered_regroup = true,
		},
	},
	-- Boss spawn
	[100154] = {
		forced_difficulty = {
			amount = 0.1,
			time = { 15, 30 },
			delay = 0,
		},
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
	-- randomize all dozers in the room
	[101133] = bulldozer_enemy,
	[101137] = bulldozer_enemy,
	[101141] = bulldozer_enemy,
	-- tweak other scripted spawns
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
	-- Disable reinforce (the drill already has it)
	[100183] = disabled,
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
	-- Spawn group intervals
	[100629] = roof_spawn,
	[100627] = roof_spawn,
	[100629] = roof_spawn,
	[100666] = roof_spawn,
	[101034] = roof_spawn,
	[101530] = roof_spawn,
	[101534] = roof_spawn,
}
