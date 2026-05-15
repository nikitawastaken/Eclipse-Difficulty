local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
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
local gensec_dozer = is_eclipse_pro and random_elite_dozers or random_dozers
local gensec_tank = {
	enemy = gensec_dozer,
}
local dozer_chance = (eclipse and 25 or hard and 15 or 0) + (is_pro_job and 20 or 0)
local dozer_van_chance = {
	chance = dozer_chance,
}
local standard_spawn = {
	values = {
		interval = 20,
	},
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
local bags_required_amount = normal and 2 or hard and 5 or 6
local bags_required = {
	values = {
		amount = bags_required_amount,
	},
}
local bags_required_job_value = {
	values = {
		value = bags_required_amount,
	},
}
return {
	-- Delay police response and add new reinforce
	[100109] = { -- police
		on_executed = { -- preferred
			{ id = 100129, delay = 45 }, -- vanilla: 30
		},
		reinforce = {
			{
				name = "north",
				force = 2,
				position = Vector3(0, -3200, -20),
			},
			{
				name = "west",
				force = 2,
				position = Vector3(3200, 0, -20),
			},
			{
				name = "east",
				force = 2,
				position = Vector3(-3200, 0, -20),
			},
			{
				name = "south",
				force = 2,
				position = Vector3(0, 3200, -20),
			},
		},
	},
	-- Reduce the number of spawngroups to a more reasonable amount.
	[100127] = { -- ai_enemy_prefered_add_001
		values = {
			spawn_groups = {
				--	100128,
				100130,
				--	100131,
				100132,
				--	101844,
				101843,
				100133,
			},
		},
	},
	-- restore one of unused snipers and change his sniper postion
	[100376] = {
		values = {
			enabled = true,
			position = Vector3(-1984, -3839.996, 1263),
			rotation = Rotation(90, 0, 0),
		},
	},
	[100416] = {
		values = {
			position = Vector3(-2507.843, -3302.226, 1265),
			rotation = Rotation(-43.515, 0, 0),
		},
	},
	-- Add actual cloaker hide groups
	[102206] = {
		on_executed = {
			{ id = 400010, delay = 0 },
		},
	},
	-- tweak the amount of required bags
	[100316] = bags_required,
	[100322] = bags_required,
	[100323] = bags_required,
	[101171] = bags_required,
	[101159] = bags_required,
	[101160] = bags_required,
	[101161] = bags_required,
	[101162] = bags_required,
	[100315] = bags_required,
	[101168] = bags_required,
	[101169] = bags_required,
	[101170] = bags_required,
	[101182] = bags_required_job_value,
	[101183] = bags_required_job_value,
	[101184] = bags_required_job_value,
	[101186] = bags_required_job_value,
	-- Disable vanilla reinforce on the trucks
	[100267] = disabled,
	[100268] = disabled,
	[100269] = disabled,
	[100270] = disabled,
	[100271] = disabled,
	[100272] = disabled,
	[100273] = disabled,
	[100274] = disabled,
	[100275] = disabled,
	[100276] = disabled,
	[100277] = disabled,
	[100278] = disabled,
	-- add more chance for dozers coming out the gensec van
	[101700] = dozer_van_chance,
	[101701] = dozer_van_chance,
	[101702] = dozer_van_chance,
	[101703] = dozer_van_chance,
	[101704] = dozer_van_chance,
	[101705] = dozer_van_chance,
	[101706] = dozer_van_chance,
	[101707] = dozer_van_chance,
	[101708] = dozer_van_chance,
	[101709] = dozer_van_chance,
	[101710] = dozer_van_chance,
	-- GenSec scripted spawns
	-- van bulldozers
	[101747] = gensec_tank,
	[101748] = gensec_tank,
	[101759] = gensec_tank,
	[101760] = gensec_tank,
	[101761] = gensec_tank,
	[101762] = gensec_tank,
	[101763] = gensec_tank,
	[101764] = gensec_tank,
	[101765] = gensec_tank,
	[101766] = gensec_tank,
	[101767] = gensec_tank,
	[101768] = gensec_tank,
	-- Spawn group intervals
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[101843] = standard_spawn,
	[101844] = standard_spawn,
	[101845] = standard_spawn,
	[101846] = standard_spawn,
	[400005] = cloaker_spawn,
	[400006] = cloaker_spawn,
	[400007] = cloaker_spawn,
	[400008] = cloaker_spawn,
}
