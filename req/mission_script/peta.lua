local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
local goats_required = {
	values = {
		counter_target = (diff_i + 2) + (is_pro_job and 2 or 0),
	},
}
local scene_cop_count = {
	values = {
		amount = diff_i + 2,
		amount_random = diff_i,
	},
}
local wave_cop_count = {
	values = {
		amount = diff_i + 4,
		amount_random = diff_i + 2,
	},
}
local close_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_shields_bulldozers_snipers,
}
local rappel_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 180,
	},
}
return {
	-- Scale goat requirements
	[100086] = goats_required,
	[100087] = goats_required,
	[100088] = goats_required,
	[100089] = goats_required,
	[100090] = goats_required,
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
	-- Spawn group delays
	[100132] = close_spawn,
	[106017] = close_spawn,
	[106019] = close_spawn,
	[106021] = close_spawn,
	[100131] = rappel_spawn,
	[100694] = rappel_spawn,
}
