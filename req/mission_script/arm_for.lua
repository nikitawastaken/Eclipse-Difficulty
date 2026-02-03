local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local army_guard = scripted_enemy.soldier_1
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
local us_soldier_3 = scripted_enemy.soldier_4
--local us_soldier_tank = scripted_enemy.soldier_bulldozer
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
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
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local army_dozer_vault = {
	enemy = is_eclipse and random_elite_dozers or random_dozers,
	values = {
		participate_to_group_ai = false,
	},
}
local security_army = {
	enemy = army_guard,
}
local us_soldiers = { [us_soldier_1] = 4, [us_soldier_2] = 2, [us_soldier_3] = 1 }
local us_soldier = {
	enemy = us_soldiers,
}
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1, [elite_skull_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1, [black_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials = {
	enemy = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse,
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
	},
}
return {
	-- FFO
	[100023] = {
		ponr = {
			length = 1200,
			player_mul = { 2, 1.5, 1, 1 },
		},
	},
	-- play the background sirens that are supposed to play
	[100022] = {
		on_executed = {
			{ id = 103046, delay = 30 },
		},
	},
	-- restores unused sniper spawn
	[100370] = enabled,
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
	-- Remove a pointless reinforce spot
	[100907] = disabled,
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
	-- tweak the amount of required ammo shells
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
