local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local goats_required = {
	values = {
		counter_target = (normal and 5 or hard and 8 or 10) + (is_pro_job and 2 or 0),
	},
}
local random_goats = {
	values = {
		amount = (normal and 2 or hard and 5 or 7) + (is_pro_job and 2 or 0),
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local scene_cop_count = {
	values = {
		amount = diff_i + 2,
		amount_random = 4,
	},
}
local wave_cop_count = {
	values = {
		amount = diff_i * 2,
		amount_random = 6,
	},
}
local rappel_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local apartment_guaranteed_spawn = {
	values = {
		spawn_type = "group_guaranteed",
	},
	groups = preferred.no_cops_agents,
}
return {
	-- Scale goat requirements
	[100086] = goats_required,
	[100087] = goats_required,
	[100088] = goats_required,
	[100089] = goats_required,
	[100090] = goats_required,
	[103479] = random_goats,
	[103480] = random_goats,
	[103481] = random_goats,
	[103482] = random_goats,
	[105634] = random_goats,
	[100159] = disabled,
	-- Scale initial cop amount
	[103446] = scene_cop_count, -- scene cops
	[103445] = scene_cop_count,
	[103444] = scene_cop_count,
	[103443] = scene_cop_count,
	[103442] = scene_cop_count,
	[100229] = scene_cop_count, -- scene cops 1
	[100422] = scene_cop_count,
	[100428] = scene_cop_count,
	[100444] = scene_cop_count,
	[100484] = scene_cop_count,
	[100519] = scene_cop_count, -- scene cops 2
	[100518] = scene_cop_count,
	[100507] = scene_cop_count,
	[100506] = scene_cop_count,
	[100630] = scene_cop_count,
	-- Scale assault cop amount
	[103451] = wave_cop_count,
	[103450] = wave_cop_count,
	[103449] = wave_cop_count,
	[103448] = wave_cop_count,
	[103447] = wave_cop_count,
	-- tweak apartment spawns
	[106165] = apartment_guaranteed_spawn,
	[106167] = apartment_guaranteed_spawn,
	[106166] = apartment_guaranteed_spawn,
	[106170] = apartment_guaranteed_spawn,
	[106162] = apartment_guaranteed_spawn,
	-- Spawn group intervals
	[100131] = rappel_spawn,
	[100694] = rappel_spawn,
}
