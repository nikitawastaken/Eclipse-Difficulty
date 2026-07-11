local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()

local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local no_participate_to_group_ai = {
	values = {
		participate_to_group_ai = false,
	},
}

local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_1,
}

local blockade_enemy1 = {
	enemy = is_eclipse and random_elite_dozers or random_dozers,
}
local blockade_enemy2 = {
	enemy = is_eclipse_pro and scripted_enemy.elite_shield or scripted_enemy.shield,
}
local heli_enemy1 = {
	enemy = scripted_enemy.taser,
}
local heli_enemy2 = {
	enemy = is_eclipse_pro and random_elite_dozers or random_dozers,
	values = {
		trigger_times = 0,
	},
}

local standard_spawn = {
	values = {
		interval = 15,
	},
}
local ship_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}

local heli_chance = (normal and 30 or hard and 40 or 60) * (is_pro_job and 1.5 or 0)

local ground_sniper_delay = 120
local ground_sniper_delay_rand = overkill_and_above and 90 or 120

local ship_sniper_delay = 30
local ship_sniper_delay_rand = overkill_and_above and 60 or 90

local escape_heli_delay = 90
local escape_heli_delay_rand = (normal and 0 or hard and 45 or 90) + (is_pro_job and 45 or 0)

local function cloaker_add(id)
	return id and {
		modify_list_value = {
			elements = {
				[id] = true,
			},
		},
	} or nil
end

local john_boat_driver_chance = math.random()

local john_dialogue_1 = nil
local john_dialogue_2 = nil
local john_dialogue_3 = nil
local john_dialogue_4 = nil
local john_dialogue_5 = nil
local john_dialogue_6 = nil
local john_dialogue_7 = nil
local john_dialogue_8 = nil
local john_dialogue_9 = nil
local john_dialogue_10 = nil
local john_dialogue_11 = nil
local john_dialogue_12 = nil
local john_dialogue_13 = nil
local john_dialogue_14 = nil
local john_dialogue_15 = nil

if john_boat_driver_chance <= 0.1 then
	john_dialogue_1 = "bot_watchdogs_new_stage2_01"
	john_dialogue_2 = "bot_watchdogs_new_stage2_05"
	john_dialogue_3 = "bot_watchdogs_new_stage2_06"
	john_dialogue_4 = "bot_watchdogs_new_stage2_07"
	john_dialogue_5 = "bot_watchdogs_new_stage2_08"
	john_dialogue_6 = "bot_watchdogs_new_stage2_09"
	john_dialogue_7 = "bot_watchdogs_new_stage2_10"
	john_dialogue_8 = "bot_watchdogs_new_stage2_07"
	john_dialogue_9 = "bot_watchdogs_new_stage2_11"
	john_dialogue_10 = "bot_watchdogs_new_stage2_12"
	john_dialogue_11 = "bot_watchdogs_new_stage2_13"
	john_dialogue_12 = "bot_watchdogs_new_stage2_14"
	john_dialogue_13 = "bot_watchdogs_new_stage2_02"
	john_dialogue_14 = "bot_watchdogs_new_stage2_03"
	john_dialogue_15 = "bot_watchdogs_new_stage2_04"
else
	john_dialogue_1 = "bot_wd2_01"
	john_dialogue_2 = "bot_wd2_02"
	john_dialogue_3 = "bot_wd2_04a"
	john_dialogue_4 = "bot_wd2_03"
	john_dialogue_5 = "bot_wd2_06"
	john_dialogue_6 = "bot_wd2_07"
	john_dialogue_7 = "bot_wd2_08"
	john_dialogue_8 = "bot_wd2_10"
	john_dialogue_9 = "bot_wd2_11"
	john_dialogue_10 = "bot_wd2_19"
	john_dialogue_11 = "bot_wd2_20"
	john_dialogue_12 = "bot_wd2_21b"
	john_dialogue_13 = "Play_bot_a04"
	john_dialogue_14 = "Play_bot_a05"
	john_dialogue_15 = "Play_bot_a06"
end

local invisible_walls_large_ids = Idstring("units/dev_tools/level_tools/dev_collision_4m_bag")
local invisible_walls_large_rot = Rotation(90, 0, 0)
local invisible_walls_small_ids = Idstring("units/dev_tools/level_tools/dev_collision_1m_2_bag")
local invisible_walls_small_rot = Rotation(-90, 0, 0)

local invisible_walls_large = {}
for i = 0, 3 do
	table.insert(invisible_walls_large, {
		name = invisible_walls_large_ids,
		pos = Vector3(-4370, -480 + (i * 480), 0),
		rot = invisible_walls_large_rot,
		visible = false,
	})
end

local invisible_walls_small = {
	{
		name = invisible_walls_large_ids,
		pos = Vector3(2460, 0, 0),
		rot = invisible_walls_large_rot,
		visible = false,
	},
	{
		name = invisible_walls_small_ids,
		pos = Vector3(3800, 980, 370),
		rot = invisible_walls_small_rot,
		visible = false,
	},
	{
		name = invisible_walls_small_ids,
		pos = Vector3(2900, 980, -20),
		rot = invisible_walls_small_rot,
		visible = false,
	},
	{
		name = invisible_walls_small_ids,
		pos = Vector3(2900, -1000, -20),
		rot = invisible_walls_small_rot,
		visible = false,
	},
	{
		name = invisible_walls_small_ids,
		pos = Vector3(2700, -570, 370),
		rot = invisible_walls_small_rot,
		visible = false,
	},
}

return {
	[100324] = { -- escapeHere
		ponr = {
			length = 240,
			length_balance_mul = { 1.125, 1, 0.875, 0.75 },
		},
	},
	-- 10% of pre beta boat driver taking it's place
	-- lights are on
	[101233] = {
		values = {
			dialogue = john_dialogue_1,
		},
	},
	-- 2 mins to arrive
	[100628] = {
		values = {
			dialogue = john_dialogue_13,
		},
	},
	-- 1 min to arrive
	[101231] = {
		values = {
			dialogue = john_dialogue_14,
		},
	},
	-- 30 secs to arrive
	[101232] = {
		values = {
			dialogue = john_dialogue_15,
		},
	},
	-- boat arrived
	[101586] = {
		values = {
			dialogue = john_dialogue_2,
		},
	},
	-- 4 bags only reminder
	[101588] = {
		values = {
			dialogue = john_dialogue_3,
		},
	},
	-- bag secured
	[101592] = {
		values = {
			dialogue = john_dialogue_4,
		},
	},
	-- all 4 bags are in
	[102357] = {
		values = {
			dialogue = john_dialogue_5,
		},
	},
	-- going back soon, unloading the bags
	[103808] = {
		values = {
			dialogue = john_dialogue_6,
		},
	},
	-- going back soon, bags unloaded
	[103809] = {
		values = {
			dialogue = john_dialogue_7,
		},
	},
	-- 4 bags only reminder (again)
	[103810] = {
		values = {
			dialogue = john_dialogue_8,
		},
	},
	-- threw the bag into the water
	[103811] = {
		values = {
			dialogue = john_dialogue_9,
		},
	},
	-- coming in dock 7
	[103812] = {
		values = {
			dialogue = john_dialogue_10,
		},
	},
	-- coming in dock 8
	[103813] = {
		values = {
			dialogue = john_dialogue_11,
		},
	},
	-- coming in dock 9
	[103815] = {
		values = {
			dialogue = john_dialogue_12,
		},
	},
	-- Add a new loot drop point
	[100415] = disabled,
	[102864] = {
		loot_drop = {
			{ name = "right_gate", position = Vector3(-2100, 4750, 0) },
		},
	},
	-- Add new reinforce
	[100511] = {
		reinforce = {
			{
				name = "gate",
				force = 4,
				position = Vector3(-2500, 1500, 0),
			},
			{
				name = "besiege_init01",
				force = 2,
				position = Vector3(-600, -1600, 0),
			},
			{
				name = "besiege_init02",
				force = 2,
				position = Vector3(-100, 2750, 0),
			},
		},
	},
	[103636] = { -- end_assault
		reinforce = {
			{ name = "besiege_init01" },
			{ name = "besiege_init02" },
			{
				name = "besiege01",
				force = 2,
				position = Vector3(1800, -1500, 0),
			},
			{
				name = "besiege02",
				force = 2,
				position = Vector3(1500, 2700, 0),
			},
			{
				name = "besiege03",
				force = 2,
				position = Vector3(4700, 1800, 0),
			},
			{
				name = "besiege04",
				force = 2,
				position = Vector3(4100, -1600, 0),
			},
		},
	},
	-- initial bag blockade is now EVIL (on DWPJ)
	[102040] = {
		values = {
			difficulty_overkill = true,
		},
	},
	[102375] = blockade_enemy1,
	[102374] = blockade_enemy1,
	[104026] = blockade_enemy2,
	[104027] = blockade_enemy2,
	[102157] = blockade_enemy2,
	[102256] = blockade_enemy2,
	[104025] = disabled,
	[104028] = disabled,
	[102117] = disabled,
	[102369] = disabled,
	-- helicopter spawns
	[100443] = {
		on_executed = {
			{ id = 100446, delay = 0.5, delay_rand = 0.5 },
			{ id = 100447, delay = 0.5, delay_rand = 0.5 },
			{ id = 100448, delay = 2, delay_rand = 2 }, -- logic link 28
		},
	},
	[100448] = {
		on_executed = {
			{ id = 100454, delay = 120, delay_rand = overkill_and_above and 120 or 180 },
			{ id = 100446, remove = true }, -- don't make same units spawn twice
			{ id = 100447, remove = true },
		},
	},
	[100454] = {
		values = {
			chance = heli_chance,
		},
	},
	[100446] = heli_enemy1,
	[100447] = heli_enemy2,
	-- Closed gate chance
	[101485] = {
		values = {
			chance = 25,
		},
	},
	-- Closed fence chance
	[101513] = {
		values = {
			chance = 25,
		},
	},
	-- Add invisible walls to the warehouse if needed
	[104004] = {
		spawn = invisible_walls_small, -- Add invisible walls to the warehouse
	},
	-- The warehouse can either be closed or open on all difficulties
	[104003] = {
		values = {
			difficulty_overkill = true,
			difficulty_hard = true,
			difficulty_normal = true,
			difficulty_overkill_145 = true,
		},
	},
	[104001] = {
		values = {
			difficulty_easy_wish = true,
		},
	},
	[100169] = {
		on_executed = {
			{ id = 400052, delay = 1 },
			{ id = 104000, remove = true },
		},
	},
	-- Delay the escape helicopter
	[100059] = { -- amountOfBagsToTriggerEsc
		on_executed = {
			{ id = 100985, delay = escape_heli_delay, delay_rand =  escape_heli_delay_rand },
		},
	},
	-- make early spawns not participate to group AI
	[100761] = no_participate_to_group_ai,
	[100765] = no_participate_to_group_ai,
	[101212] = no_participate_to_group_ai,
	[101214] = no_participate_to_group_ai,
	[101216] = no_participate_to_group_ai,
	[101218] = no_participate_to_group_ai,
	[101412] = no_participate_to_group_ai,
	[101413] = no_participate_to_group_ai,
	[101222] = no_participate_to_group_ai,
	[100344] = no_participate_to_group_ai,
	-- add cloakers
	[103962] = cloaker_add(103961),
	[103964] = cloaker_add(103963),
	[103966] = cloaker_add(103965),
	[103968] = cloaker_add(103967),
	[103970] = cloaker_add(103969),
	[103972] = cloaker_add(103971),
	[103974] = cloaker_add(103973),
	[103976] = cloaker_add(103975),
	[103978] = cloaker_add(103977),
	[103980] = cloaker_add(103979),
	-- spawn ground Snipers
	[100486] = {
		on_executed = {
			{ id = 400035, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
		},
	},
	-- spawn Snipers on the ships
	[102182] = {
		on_executed = {
			{ id = 400013, delay = ship_sniper_delay, delay_rand = ship_sniper_delay_rand },
		},
	},
	[102388] = {
		on_executed = {
			{ id = 400014, delay = ship_sniper_delay, delay_rand = ship_sniper_delay_rand },
		},
	},
	[102335] = {
		on_executed = {
			{ id = 400015, delay = ship_sniper_delay, delay_rand = ship_sniper_delay_rand },
		},
	},
	-- Enlarge area triggers responsible for toggling cheat spawngroups hidden behind containers.
	-- This should prevent them from spawning in plain sight.
	[101010] = {
		values = {
			width = 6500,
			depth = 15200,
		},
	},
	[101013] = {
		values = {
			width = 6500,
			depth = 15200,
		},
	},	
	[101220] = {
		values = {
			width = 6500,
			depth = 19000,
		},
	},
	[101235] = {
		values = {
			width = 6500,
			depth = 19000,
		},
	},
	-- Do not remove groups closest to the gate alongside cheat spawngroups. They are well hidden.
	[100899] = { -- ai_enemy_prefered_remove_001
		on_executed = {
			{ id = 101482, remove = true }, -- ai_enemy_prefered_add_003
		},
	},
	[101009] = { -- ai_enemy_prefered_remove_002
		on_executed = {
			{ id = 100168, remove = true }, -- ai_enemy_prefered_add_001
		},
	},
	-- Spawn group intervals
	-- Not much going on here, you won't be getting swarmed by enemies that spawn on the ships.
	[100146] = standard_spawn,
	[100154] = standard_spawn,
	[100167] = standard_spawn,
	[102387] = ship_spawn,
	[102331] = ship_spawn,
	[102173] = ship_spawn,
	[400042] = scripted_swat_van_spawn,
	[400050] = scripted_swat_van_spawn,
}
