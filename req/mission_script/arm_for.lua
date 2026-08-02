local calc_team_ai_wgt = Eclipse.utils.calculate_team_ai_weight
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local enabled = {
	values = {
		enabled = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}
local army_dozer_vault = {
	enemy = is_eclipse and random_elite_dozers or random_dozers,
	values = {
		participate_to_group_ai = false,
	},
}
local security_army = {
	enemy = scripted_enemy.soldier_1,
}
local us_soldiers = { [scripted_enemy.soldier_2] = 4, [scripted_enemy.soldier_3] = 2, [scripted_enemy.soldier_4] = 1 }
local us_soldier = {
	enemy = us_soldiers,
}
local specials_list = {
	[scripted_enemy.taser_1] = get_difficulty_group_specific_value({ 3, 2, 2 }),
	[scripted_enemy.cloaker] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[scripted_enemy.cloaker] = get_difficulty_group_specific_value({ 1, 2, 2 }),
	[scripted_enemy.elite_sniper] = get_difficulty_group_specific_value({ 0, 0, 1 }),
	[scripted_enemy.bulldozer_1] = get_difficulty_group_specific_value({ 0, 1, 0 }), -- no scripted green/blackdozers heli spawns on DW
	[scripted_enemy.bulldozer_2] = get_difficulty_group_specific_value({ 0, 1, 0 }),
	[scripted_enemy.elite_bulldozer_1] = get_difficulty_group_specific_value({ 0, 0, 2 }),
	[scripted_enemy.elite_bulldozer_2] = get_difficulty_group_specific_value({ 0, 0, 2 }),
}
local specials = {
	enemy = specials_list,
}

local bile_random_bags = math.random()

local bile_lottery = nil

if bile_random_bags <= 0.10 then
	bile_lottery = 3
elseif bile_random_bags <= 0.90 then
	bile_lottery = 2
else
	bile_lottery = 1
end

local dozer_in_the_vault_chance = {
	chance = (overkill_and_above and 30 or 10) + (is_pro_job and 10 or 0),
}
local shells_required = {
	values = {
		counter_target = (normal and 5 or hard and 8 or 10) + (is_pro_job and 2 or 0),
	},
}
local shells_required_objective = {
	values = {
		amount = (normal and 5 or hard and 8 or 10) + (is_pro_job and 2 or 0),
	},
}
local chopper_amount = (is_eclipse and 2 or 1) + (is_pro_job and 1 or 0)
local standard_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.3, 1.2, 1.1, 1 },
	},
}
return {
	-- FFO
	[100023] = {
		ponr = {
			length = 1200,
			length_balance_mul = { 2, 1.5, 1.25, 1 },
		},
	},
	-- Play the background sirens that are supposed to play
	[100022] = {
		on_executed = {
			{ id = 103046, delay = 30 },
		},
	},
	-- Restores unused sniper spawn
	[100370] = enabled,
	-- Increase drama when Snipers spawn
	[100366] = { -- spawn_snipers
		add_drama = {
			amount = 0.25,
			balance_mul = { 1.2, 1, 0.8, 0.6 },
			team_ai_balance_mul_weight = calc_team_ai_wgt(1),
		},
	},
	-- Disable boat escape
	[104979] = disabled,
	-- Disable a pointless reinforce spot
	[100907] = disabled,
	-- loop the choppers
	[102767] = {
		on_executed = {
			{ id = 102767, delay = overkill_and_above and 300 or 360 },
		},
	},
	[104600] = {
		values = {
			amount = chopper_amount,
		},
	},
	[104694] = disabled,
	-- Thermal Drill Lottery (feat. Bile The Pilot)
	[102893] = {
		values = {
			amount = bile_lottery,
		},
	},
	[102894] = {
		values = {
			amount = bile_lottery,
		},
	},
	[102895] = {
		values = {
			amount = bile_lottery,
		},
	},
	-- Tweak the amount of required ammo shells
	[105577] = shells_required,
	[105578] = shells_required,
	[105579] = shells_required,
	[105595] = shells_required,
	[103306] = shells_required,
	[100787] = shells_required_objective,
	[100776] = shells_required_objective,
	[100764] = shells_required_objective,
	[100681] = shells_required_objective,
	-- tweak chopper spawns to have variety
	-- fbi heavies are replaced with specials while swat heavies are replaced with us army soldiers
	-- 1st chopper
	[102772] = us_soldier,
	[102773] = specials,
	[102775] = us_soldier,
	-- 2nd chopper
	[102787] = us_soldier,
	[102789] = specials,
	[102788] = us_soldier,
	-- 3rd chopper
	[102805] = us_soldier,
	[102807] = specials,
	[102806] = us_soldier,
	-- tweak vault dozers
	[103224] = army_dozer_vault,
	[103225] = army_dozer_vault,
	[103226] = army_dozer_vault,
	[103227] = dozer_in_the_vault_chance,
	[103228] = dozer_in_the_vault_chance,
	[103229] = dozer_in_the_vault_chance,
	-- disable vault dozers to make them not spawn in stealth
	[100018] = {
		on_executed = {
			{ id = 400002, delay = 1 },
		},
	},
	[100022] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	-- National Guard instead of secret service
	[100670] = security_army,
	[100671] = security_army,
	[100672] = security_army,
	[100673] = security_army,
	[100674] = security_army,
	[100675] = security_army,
	[100676] = security_army,
	[100677] = security_army,
	[100678] = security_army,
	[100679] = security_army,
	[102127] = security_army,
	[103124] = security_army,
	[103033] = security_army,
	[105209] = security_army,
	[105241] = security_army,
	-- Spawn group intervals
	[100007] = standard_spawn,
	[100019] = standard_spawn,
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[102838] = standard_spawn,
	[103003] = standard_spawn,
}
