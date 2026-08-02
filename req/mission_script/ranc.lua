local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local spawn_anim_fix = {
	spawn_action = "e_sp_over_3m",
}
local dock_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local agile_spawn = {
	values = {
		interval = 30,
	},
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local bags_required = {
	values = {
		amount = 4 + (is_pro_job and 2 or 0),
	},
}
local objective_diff_add = {
	difficulty_addends = {
		{
			amount = 0.375,
			time = 60,
			delay = 0,
		},
	},
}
local assault_end_diff_add = {
	difficulty_addends = {
		{
			amount = 0.125,
			time = 30,
			delay = 0,
		},
	},
}

return {
	[100109] = { -- Police
		reinforce = {
			{
				name = "fork",
				force = 4,
				position = Vector3(-2015, -145, 200),
			},
			{
				name = "main_gate1",
				force = 4,
				position = Vector3(5670, 1125, 400),
			},
			{
				name = "main_gate2",
				force = 4,
				position = Vector3(5310, -1090, 400),
			},
			{
				name = "outside_garage",
				force = 2,
				position = Vector3(7875, -9315, 400),
			},
			{
				name = "such_a_nice_car",
				force = 2,
				position = Vector3(2985, -7040, 400),
			},
			{
				name = "barn1",
				force = 2,
				position = Vector3(6755, 5320, 400),
			},
			{
				name = "barn2",
				force = 2,
				position = Vector3(4285, 5215, 400),
			},
			{
				name = "workshop_a",
				force = 3,
				position = Vector3(3070, 2890, 400),
			},
			{
				name = "workshop_c",
				force = 3,
				position = Vector3(9215, 1625, 450),
			},
		},
	},
	[103874] = { -- arrive 1
		on_executed = {
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[103873] = { -- arrive 2
		on_executed = {
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	[103875] = { -- arrive 3
		on_executed = {
			{ id = 400019, delay = 0, delay_rand = 5 },
		},
	},
	-- change the amount of required loot
	[101731] = bags_required,
	[102161] = bags_required,
	[103698] = bags_required,
	[100957] = bags_required,
	[101042] = bags_required,
	[103635] = bags_required,
	[103683] = bags_required,
	[103696] = bags_required,
	-- fix snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	-- fixes some spawn typos
	[100683] = spawn_anim_fix,
	[100684] = spawn_anim_fix,
	[100787] = spawn_anim_fix,
	[100789] = spawn_anim_fix,
	[100790] = spawn_anim_fix,
	[100791] = spawn_anim_fix,
	-- Scripted difficulty scaling
	[100929] = objective_diff_add, -- output_gate_opened_c4 
	[100123] = assault_end_diff_add, -- end_assault
	-- Spawn group intervals
	[100131] = dock_spawn,
	[100130] = dock_spawn,
	[102397] = dock_spawn,
	[100019] = agile_spawn,
	[102484] = agile_spawn,
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
	[400021] = scripted_swat_van_spawn,
}
