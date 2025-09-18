local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local elite_sniper = scripted_enemy.elite_sniper
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local ready_team_amount = {
	values = {
		amount = 4,
		amount_random = math.max(diff_i - 2, 0),
	},
}
local ready_team_dozer = {
	enemy = is_eclipse_pro and random_elite_dozers or diff_i > 3 and random_dozers or green_bulldozer,
}
local ready_team_dozer_chance = {
	values = {
		chance = (is_pro_job and 1.25 or 1) * (diff_i * 10),
	},
}
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 10, [elite_sniper] = 1 } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local flank_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local van_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- Boss spawn
	[102107] = {
		difficulty_max = 0.1,
	},
	-- Boss dead
	[100788] = {
		difficulty_max = 1,
		difficulty_min = 1,
	},
	-- replace the turret with spawngroup
	[103524] = {
		on_executed = {
			{ id = 400032, delay = 0 },
			{ id = 400047, delay = 0 },
		},
	},
	-- make the swat van crash into the gate earlier
	[103551] = {
		on_executed = {
			{ id = 103521, remove = true },
			{ id = 103522, delay = 5 },
		},
	},
	-- fix swat van lights being turned off when starting another sequence
	[103558] = {
		on_executed = {
			{ id = 103552, remove = true },
			{ id = 400048, delay = 0.05 },
		},
	},
	-- replace vanilla swat van spawn system with new one
	[100022] = {
		on_executed = {
			{ id = 103525, remove = true },
		},
	},
	[100327] = {
		on_executed = {
			{ id = 400036, delay = 90, delay_rand = 30 },
		},
	},
	-- Add new reinforce around the house
	[100109] = {
		reinforce = {
			{
				name = "house_front",
				force = 3,
				position = Vector3(-1600, 0, 0),
			},
			{
				name = "house_left",
				force = 3,
				position = Vector3(-650, 2500, -150),
			},
			{
				name = "house_right",
				force = 3,
				position = Vector3(1600, -900, 0),
			},
			{
				name = "house_back",
				force = 3,
				position = Vector3(3000, 800, 20),
			},
		},
	},
	-- Ready Team enemy amount scales with difficulty (kind of, it's a bit random)
	[102361] = ready_team_amount,
	[102362] = ready_team_amount,
	[102363] = ready_team_amount,
	[102364] = ready_team_amount,
	[102365] = ready_team_amount,
	-- Ready Team Bulldozers
	[102366] = ready_team_dozer_chance,
	[102369] = ready_team_dozer_chance,
	[102370] = ready_team_dozer_chance,
	[102372] = ready_team_dozer_chance,
	[102338] = ready_team_dozer,
	[102339] = ready_team_dozer,
	[102340] = ready_team_dozer,
	[102341] = ready_team_dozer,
	[102342] = ready_team_dozer,
	[102343] = ready_team_dozer,
	[102344] = ready_team_dozer,
	[102345] = ready_team_dozer,
	[102346] = ready_team_dozer,
	[102347] = ready_team_dozer,
	[102348] = ready_team_dozer,
	[102349] = ready_team_dozer,
	-- Spawn group intervals
	[400008] = van_spawn,
	[400017] = van_spawn,
	[400026] = van_spawn,
	[400035] = scripted_swat_van_spawn,
	[100019] = flank_spawn,
	[102424] = flank_spawn,
	[102438] = flank_spawn,
	[102459] = flank_spawn,
	-- Harassers
	[100883] = harasser,
	[100884] = harasser,
	[100885] = harasser,
	[100332] = harasser,
	[100334] = harasser,
	[100336] = harasser,
	[100906] = harasser,
	[100907] = harasser,
	[100908] = harasser,
	[100922] = harasser,
	[100923] = harasser,
	[100924] = harasser,
	[100938] = harasser,
	[100939] = harasser,
	[100940] = harasser,
	[100954] = harasser,
	[100955] = harasser,
	[100956] = harasser,
	[100969] = harasser,
	[100970] = harasser,
	[100971] = harasser,
	[100985] = harasser,
	[100986] = harasser,
	[100987] = harasser,
	[101001] = harasser,
	[101002] = harasser,
	[101003] = harasser,
	[101017] = harasser,
	[101018] = harasser,
	[101019] = harasser,
	[101033] = harasser,
	[101034] = harasser,
	[101035] = harasser,
	[101049] = harasser,
	[101050] = harasser,
	[101051] = harasser,
	[101065] = harasser,
	[101066] = harasser,
	[101067] = harasser,
	[101081] = harasser,
	[101082] = harasser,
	[101083] = harasser,
	[101097] = harasser,
	[101098] = harasser,
	[101099] = harasser,
	[101113] = harasser,
	[101114] = harasser,
	[101115] = harasser,
	[101129] = harasser,
	[101130] = harasser,
	[101131] = harasser,
	[101145] = harasser,
	[101146] = harasser,
	[101147] = harasser,
	[101161] = harasser,
	[101162] = harasser,
	[101163] = harasser,
	[101177] = harasser,
	[101178] = harasser,
	[101179] = harasser,
}
