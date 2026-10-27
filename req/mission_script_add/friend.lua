---@module Scarface's Mansion
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()

local bags_required = (is_eclipse and 6 or 4) + (is_pro_job and 2 or 0)

local optsBesiegeDummyCloaker01 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_over_3m",
	enabled = true,
}

local optsBesiegeDummyCloaker02 = deep_clone(optsBesiegeDummyCloaker01)
optsBesiegeDummyCloaker02.spawn_action = "e_sp_over_2_3m"

local optsBesiegeDummyCloaker03 = deep_clone(optsBesiegeDummyCloaker01)
optsBesiegeDummyCloaker03.spawn_action = "e_sp_climb_over_2m"

local optsBesiegeDummyCloaker04 = deep_clone(optsBesiegeDummyCloaker01)
optsBesiegeDummyCloaker04.spawn_action = "e_sp_climb_over_4m"

local optsBesiegeDummyCloaker05 = deep_clone(optsBesiegeDummyCloaker01)
optsBesiegeDummyCloaker05.spawn_action = "e_sp_clk_up_water"

local optsPreferedAdd1 = {
	spawn_groups = { 100130 },
	enabled = true,
}
local optsPreferedRemove1 = {
	elements = { 400001 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100132, 102381 },
	enabled = true,
}
local optsPreferedRemove2 = {
	elements = { 400003 },
	enabled = true,
}

local optsinstance_bag_requirment = {
	instance = "obj_link_005",
	params = {
		var_amount_death_wish = bags_required,
		var_amount_hard = bags_required,
		var_amount_normal = bags_required,
		var_amount_overkill = bags_required,
		var_amount_very_hard = bags_required,
		var_objective = "friend_loud_08",
	},
}

local optsLoudAlert = {
	AI_event = "police_called",
	blame = "csgo_gunfire",
}
local optsGunfiretrigger = {
	filter = "1073741823", -- copied from Big Oil Day 1
	alert_types = {
		"bullet",
		"explosion",
	},
	on_executed = {
		{ id = 400006, delay = 8 },
		{ id = 400024, delay = 0 },
	},
}
local optsGunfireoperator = {
	enabled = true,
	elements = {
		400007,
		400008,
		400009,
		400010,
		400011,
		400011,
		400012,
		400013,
		400014,
		400015,
		400016,
		400017,
		400018,
		400019,
		400020,
		400021,
		400022,
	},
}
local optsAlertAllEnemies = {
	enabled = true,
}
local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 60,
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	-- Prefereds
	Eclipse.mission_elements.gen_preferedadd(400001, "van_driveway_preferedadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedremove(400002, "van_driveway_preferedremove", optsPreferedRemove1),
	Eclipse.mission_elements.gen_preferedadd(400003, "van_garden_preferedadd", optsPreferedAdd2),
	Eclipse.mission_elements.gen_preferedremove(400004, "van_garden_preferedremove", optsPreferedRemove2),

	-- Change bag requirments
	Eclipse.mission_elements.gen_instance_params(400005, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),

	-- Add custom alert
	Eclipse.mission_elements.gen_aiglobalevent(400006, "friend_gang_alert", optsLoudAlert),

	Eclipse.mission_elements.gen_alerttrigger(400007, "gunfire_trigger_1", Vector3(3183, -3210, 623), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400008, "gunfire_trigger_2", Vector3(3183, -5403, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400009, "gunfire_trigger_3", Vector3(3183, -333, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400010, "gunfire_trigger_4", Vector3(3183, 1525, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400011, "gunfire_trigger_5", Vector3(1252, 1525, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400012, "gunfire_trigger_6", Vector3(-1803, 1525, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400013, "gunfire_trigger_7", Vector3(-3602, -478, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400014, "gunfire_trigger_8", Vector3(-3602, -2277, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400013, "gunfire_trigger_9", Vector3(-5938, -2277, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400014, "gunfire_trigger_10", Vector3(-1902, -5312, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400015, "gunfire_trigger_11", Vector3(844, 5571, 234), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400016, "gunfire_trigger_12", Vector3(5991, -3121, -150), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400017, "gunfire_trigger_13", Vector3(-930, -2864, 294), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400018, "gunfire_trigger_14", Vector3(-930, -1079, 294), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400019, "gunfire_trigger_15", Vector3(-930, -3956, 91), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400020, "gunfire_trigger_16", Vector3(-930, -4480, 91), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400021, "gunfire_trigger_17", Vector3(-1736, -3093, 91), Rotation(0, 0, 0), optsGunfiretrigger),
	Eclipse.mission_elements.gen_alerttrigger(400022, "gunfire_trigger_18", Vector3(-1736, -3093, 575), Rotation(0, 0, 0), optsGunfiretrigger),

	Eclipse.mission_elements.gen_operator(400023, "add_alert_trigger", Vector3(0, 0, 0), Rotation(0, 0, 0), optsGunfireoperator),

	Eclipse.mission_elements.gen_missionscript(400024, "alert_all_guards", optsAlertAllEnemies),

	-- Scripted difficulty addends
	Eclipse.mission_elements.gen_difficulty(400025, "friend_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400026, "friend_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),

	-- Replace Vanilla's Cloaker group with custom ones
	Eclipse.mission_elements.gen_dummy(400027, "friend_cloaker_spawn01", Vector3(-5750, -3400, -160), Rotation(0, 0, 0), optsBesiegeDummyCloaker05),
	Eclipse.mission_elements.gen_dummy(400028, "friend_cloaker_spawn02", Vector3(-7025, -2075, -160), Rotation(-90, 0, 0), optsBesiegeDummyCloaker05),
	Eclipse.mission_elements.gen_dummy(400029, "friend_cloaker_spawn03", Vector3(3550, -6150, -150), Rotation(0, 0, 0), optsBesiegeDummyCloaker01),
	Eclipse.mission_elements.gen_dummy(400030, "friend_cloaker_spawn04", Vector3(4025, 2550, -150), Rotation(0, 0, 0), optsBesiegeDummyCloaker01),
	Eclipse.mission_elements.gen_dummy(400031, "friend_cloaker_spawn05", Vector3(-575, -5725, -50), Rotation(-45, 0, 0), optsBesiegeDummyCloaker02),
	Eclipse.mission_elements.gen_dummy(400032, "friend_cloaker_spawn06", Vector3(-125, 3050, -150), Rotation(135, 0, 0), optsBesiegeDummyCloaker03),
	Eclipse.mission_elements.gen_dummy(400033, "friend_cloaker_spawn07", Vector3(9575, -3700, -800), Rotation(90, 0, 0), optsBesiegeDummyCloaker04),
	Eclipse.mission_elements.gen_dummy(400034, "friend_cloaker_spawn08", Vector3(9575, -2550, -800), Rotation(90, 0, 0), optsBesiegeDummyCloaker04),

	Eclipse.mission_elements.gen_spawngroup(400035, "friend_cloaker_group01", { 400027 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400036, "friend_cloaker_group02", { 400028 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400037, "friend_cloaker_group03", { 400029 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400038, "friend_cloaker_group04", { 400030 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400039, "friend_cloaker_group05", { 400031 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400040, "friend_cloaker_group06", { 400032 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400041, "friend_cloaker_group07", { 400033 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400042, "friend_cloaker_group08", { 400034 }, 0),
}
return M
