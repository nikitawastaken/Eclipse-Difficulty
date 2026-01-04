local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2

local regular_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local eclipse_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local train_dozer = {
	enemy = is_eclipse and eclipse_dozers or regular_dozers,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local unused_sniper_trigger_times = {
	values = {
		trigger_times = 0,
		enabled = true,
	},
}
local window_spawn = {
	values = {
		interval = 30,
	},
}
local boat_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local filter_easy_normal = {
	values = Eclipse.utils.set_diff_groups("easy"),
}
local filter_hard_above = {
	values = Eclipse.utils.set_diff_groups("normal_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local chopper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
return {
	[100945] = { -- Open train doors - heist start
		ponr = {
			length = 800,
			player_mul = { 2, 1.25, 1, 0.75 },
		},
	},
	[100810] = {
		reinforce = {
			{
				name = "gate",
				force = 4,
				position = Vector3(1625, 3575, 950),
			},
		},
	},
	-- make Snipers respawn and re-enable unused ones
	[100520] = unused_sniper_trigger_times,
	[100525] = sniper_trigger_times,
	[100529] = sniper_trigger_times,
	[100534] = sniper_trigger_times,
	[100540] = unused_sniper_trigger_times,
	[100545] = unused_sniper_trigger_times,
	--[100549] = unused_sniper_trigger_times,
	[100553] = sniper_trigger_times,
	[100557] = unused_sniper_trigger_times,
	-- tweak the ambush enemy script
	-- difficulty tweaks
	[100353] = filter_easy_normal,
	[100354] = filter_hard_above,
	[100355] = filter_disable,
	[100356] = filter_disable,
	-- tweak the dozers
	[100498] = train_dozer,
	[100497] = train_dozer,
	[100500] = train_dozer,
	[100503] = train_dozer,
	-- get rid of roof dozers (that are not even on the roof lmao)
	[100434] = {
		on_executed = {
			{ id = 100365, remove = true },
		},
	},
	-- ambush sniper amount
	[100389] = {
		values = {
			amount = normal and 1 or hard and 2 or 3,
		},
	},
	-- trigger helis early in the heist
	--[[ "captain_reached_boat"
	[100877] = {
		on_executed = {
			{ id = 100612, delay = 15, delay_rand = 30 },
		},
	},
	-- tweak choppers
	[100613] = {
		values = {
			amount = normal and 1 or 2,
		},
	},
	[100614] = chopper_trigger_times,
	[100615] = chopper_trigger_times,
	[100616] = chopper_trigger_times,
	]]
	-- slow down a few spawnpoints
	[400007] = scripted_swat_van_spawn,
	[400015] = scripted_swat_van_spawn,
	[400023] = scripted_swat_van_spawn,
	[100605] = window_spawn,
	[100177] = boat_spawn,
	[100737] = boat_spawn,
}
