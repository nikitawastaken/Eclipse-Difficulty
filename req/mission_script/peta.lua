local calc_team_ai_wgt = Eclipse.utils.calculate_team_ai_weight
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
local found_any_goat = {
	on_executed = {
		{ id = 400002, delay = 0 },
	},
}
local scene_cop_count = {
	values = {
		amount = 3,
		amount_random = diff_i,
	},
}
local wave_cop_count = {
	values = {
		amount = 4,
		amount_random = diff_i,
	},
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
	-- Add new reinforce
	[100109] = { -- police
		reinforce = {
			{
				name = "park",
				force = 3,
				position = Vector3(-125, 50, 275),
			},
			{
				name = "crossroads1",
				force = 2,
				position = Vector3(-6350, 2575, -175),
			},
			{
				name = "crossroads2",
				force = 2,
				position = Vector3(4000, -8150, 50),
			},
			{
				name = "crossroads3",
				force = 2,
				position = Vector3(4050, 2075, 50),
			},
		},
	},
	-- Increase drama when Snipers spawn
	[100366] = { -- spawn_snipers
		add_drama = {
			amount = 0.2,
			balance_mul = { 1.25, 1, 0.75, 0.5 },
			team_ai_balance_mul_weight = calc_team_ai_wgt(2),
		},
	},
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
	-- Scripted difficulty scaling
	-- Add an element executed upon any goat being picked up, "free" or tied to an objective.
	[101441] = found_any_goat, -- random_goat_collected
	[105912] = found_any_goat, -- ap_goat_collected_l
	[105920] = found_any_goat, -- fan_goat_collected_l
	[105926] = found_any_goat, -- scaf_goat_collected_l
	[105931] = found_any_goat, -- store_goat_collected_l
	[105935] = found_any_goat, -- light_goat_collected_l
	[400002] = { -- found_any_goat
		on_executed = {
			{ id = 400003, delay = 0 },
		},
	},	 
	[100123] = { -- end_assault
		on_executed = {
			{ id = 400004, delay = 0 },
		},
	},
	-- Tweak apartment spawns
	[106165] = apartment_guaranteed_spawn,
	[106167] = apartment_guaranteed_spawn,
	[106166] = apartment_guaranteed_spawn,
	[106170] = apartment_guaranteed_spawn,
	[106162] = apartment_guaranteed_spawn,
}
