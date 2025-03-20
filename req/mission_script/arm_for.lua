local normal, hard, eclipse = Eclipse.utils.diff_groups()
local overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local army_guard = scripted_enemy.soldier_1
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
--local us_soldier_tank = scripted_enemy.soldier_bulldozer
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
--[[
local army_dozer_vault = {
	enemy = overkill_and_above and us_soldier_tank,
	values = {
		participate_to_group_ai = false,
	},
}
]]
--
local security_army = {
	enemy = army_guard,
}
local us_soldiers = {
	Idstring(us_soldier_1),
	Idstring(us_soldier_1),
	Idstring(us_soldier_1),
	Idstring(us_soldier_2),
}
local us_soldier = {
	enemy = us_soldiers,
}
local specials_list_eclipse = {
	Idstring(cloaker),
	Idstring(cloaker),
	Idstring(taser),
	Idstring(taser),
	Idstring(medic),
	Idstring(medic),
	Idstring(elite_ben_bulldozer),
	Idstring(elite_skull_bulldozer),
}
local specials_list_hard_ovk = {
	Idstring(cloaker),
	Idstring(cloaker),
	Idstring(taser),
	Idstring(taser),
	Idstring(medic),
	Idstring(medic),
	Idstring(cloaker),
	Idstring(cloaker),
	Idstring(taser),
	Idstring(taser),
	Idstring(medic),
	Idstring(medic),
	Idstring(green_bulldozer),
	Idstring(black_bulldozer),
}
local specials_list_easy_normal = {
	Idstring(cloaker),
	Idstring(taser),
	Idstring(taser),
	Idstring(taser),
	Idstring(taser),
	Idstring(taser),
	Idstring(taser),
	Idstring(taser),
}
local specials = {
	enemy = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse,
}

local bile_has_budget_costs = is_eclipse and 1
local dozer_in_the_vault_chance = {
	values = {
		chance = overkill_and_above and 30 or 10,
	},
}
local shells_required = {
	values = {
		counter_target = normal and 5 or hard and 8 or 10,
	},
}
local shells_required_objective = {
	values = {
		amount = normal and 5 or hard and 8 or 10,
	},
}

return {
	[105046] = {
		ponr = {
			length = 300,
			player_mul = { 1.20, 1.10, 1, 1 },
		},
	},
	-- play the background sirens that are supposed to play
	[100022] = {
		on_executed = {
			{ id = 100109, delay = 30 },
		},
	},
	-- restores unused sniper spawn
	[100370] = {
		values = {
			enabled = true,
		},
	},
	-- delay police choppers arrival
	[100129] = {
		on_executed = {
			{ id = 102767, delay = 120 },
		},
	},
	-- loop the choppers
	[102767] = {
		on_executed = {
			{ id = 102767, delay = overkill_and_above and 240 or 300 },
		},
	},
	-- Bile drops only one thermal drill on Eclipse
	[102895] = {
		values = {
			amount = bile_has_budget_costs,
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
	--[103224] = army_dozer_vault,
	-- [103225] = army_dozer_vault,
	-- [103226] = army_dozer_vault,
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
}
