local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local bellmead_1 = scripted_enemy.bellmead_security_1
local bellmead_2 = scripted_enemy.bellmead_security_1
local bellmead_3 = scripted_enemy.bellmead_security_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local filters_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filters_hard_above = {
	values = Eclipse.utils.set_diff_groups("hard_above"),
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local rappel_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local fueling_area_lower_spawn = {
	values = {
		interval = 20,
	},
}
local pillar_spawn = {
	values = {
		interval = 30,
	},
}
local tower_spawn = {
	values = {
		interval = 30,
	},
}
local fueling_area_upper_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}
local drill_room_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local bellmeads = {
	bellmead_1,
	bellmead_2,
	bellmead_3,
}
local bellmead_enemy = {
	enemy = bellmeads,
}
local ambush_bulldozers = {
	green_bulldozer,
	black_bulldozer,
}
local ambush_bulldozers_eclipse = {
	[green_bulldozer] = 3,
	[black_bulldozer] = 3,
	[elite_ben_bulldozer] = 2,
	[elite_skull_bulldozer] = 2,
}
local ambush_bulldozer_enemy = {
	enemy = is_eclipse and ambush_bulldozers_eclipse or ambush_bulldozers,
}
local ambush_dozer_amount = is_eclipse and 3 or 2 + (is_pro_job and 1 or 0)
local door_ambush_dozer = (is_eclipse and 50 or 30) * (is_pro_job and 1.5 or 1)
local door_ambush_dozer_chance = {
	chance = door_ambush_dozer,
}
return {
	-- Disable crappy vanilla reinforce
	[104207] = disable,
	[104208] = disable,
	[104210] = disable,
	[100109] = {
		reinforce = {
			{
				name = "helipad",
				force = 5,
				position = Vector3(4375, 150, 4500),
			},
			{
				name = "stairs1",
				force = 2,
				position = Vector3(2900, 3800, 4000),
			},
			{
				name = "stairs2",
				force = 2,
				position = Vector3(4500, 2800, 3800),
			},
			{
				name = "stairs3",
				force = 2,
				position = Vector3(1300, -875, 4000),
			},
		},
	},
	-- Adjust the frankly unhinged scripted Dozer spam at the escape (the ASS way)
	[104222] = filter_disable, -- escape ambush spawn filters
	[104211] = filter_disable,
	[105001] = filter_disable,
	[104212] = {
		values = filters_hard_above.values,
		on_executed = {
			{ id = 104213, remove = true },
			{ id = 104214, remove = true },
			{ id = 104216, remove = true },
			{ id = 104218, remove = true },
			{ id = 104220, remove = true },
		},
	},
	[105003] = { -- "random dozer mayham", now controls spawning all ambush dozers instead of only one at the zipline
		values = {
			amount = ambush_dozer_amount,
		},
		on_executed = {
			{ id = 104213, delay = 0 },
			{ id = 104214, delay = 0 },
			{ id = 104216, delay = 0 },
			{ id = 104218, delay = 0 },
			{ id = 104220, delay = 0 },
		},
	},
	-- Door ambush dozers
	[102314] = filter_disable,
	[104514] = filter_disable,
	[104515] = filter_disable,
	[104516] = filters_hard_above,
	[102313] = door_ambush_dozer_chance,
	-- Let Snipers spawn more than once/reenable unused ones
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	[100373] = sniper_trigger_times,
	[100374] = sniper_trigger_times,
	[100375] = sniper_trigger_times,
	[100376] = sniper_trigger_times,
	[100377] = sniper_trigger_times,
	-- Change pipe puzzle preferreds
	-- Add 2 new ground groups to diversify spawn locations and remove a 3 excess "drop" groups.
	-- It's raining men.
	[101773] = { -- Fueling area
		values = {
			spawn_groups = {
				101777, -- 45s
				101778, -- 45s
				--102086, -- 45s
				--103986, -- 45s
				--105278, -- 45s
				400006, -- 20s
				400012, -- 20s
			},
		},
	},
	-- Spawn group intervals
	[100132] = rappel_spawn,
	[100133] = rappel_spawn,
	[101769] = rappel_spawn,
	[101775] = rappel_spawn,
	[400006] = fueling_area_lower_spawn,
	[400012] = fueling_area_lower_spawn,
	[101836] = pillar_spawn,
	[101837] = pillar_spawn,
	[101838] = pillar_spawn,
	[101839] = pillar_spawn,
	[101780] = tower_spawn,
	[101781] = tower_spawn,
	[101777] = fueling_area_upper_spawn,
	[101778] = fueling_area_upper_spawn,
	[102086] = fueling_area_upper_spawn,
	[103986] = fueling_area_upper_spawn,
	[105278] = fueling_area_upper_spawn,
	[101779] = drill_room_spawn,
	[104786] = drill_room_spawn,
	-- Scripted enemies
	[104213] = ambush_bulldozer_enemy,
	[104214] = ambush_bulldozer_enemy,
	[104216] = ambush_bulldozer_enemy,
	[104218] = ambush_bulldozer_enemy,
	[104220] = ambush_bulldozer_enemy,
	[104993] = ambush_bulldozer_enemy,
	[104999] = ambush_bulldozer_enemy,
	[102312] = ambush_bulldozer_enemy,
	[104519] = ambush_bulldozer_enemy,
	[104518] = ambush_bulldozer_enemy,
	[104517] = ambush_bulldozer_enemy,
	[104205] = bellmead_enemy, -- scripted swats
	[104223] = bellmead_enemy,
	[104224] = bellmead_enemy,
	[104225] = bellmead_enemy,
	[104226] = bellmead_enemy,
	[104234] = bellmead_enemy,
	[104235] = bellmead_enemy,
	[104236] = bellmead_enemy,
	[104247] = bellmead_enemy,
	[104248] = bellmead_enemy,
}
