local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()

local light_harasser = scripted_enemy.swat_1
local heavy_harasser = is_eclipse and { [scripted_enemy.heavy_swat_1] = 5, [scripted_enemy.elite_sniper] = 1 } or scripted_enemy.heavy_swat_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}
local ready_team_dozer = {
	enemy = is_eclipse_pro and random_elite_dozers or random_dozers,
}
local ready_team_dozer_chance = {
	values = {
		chance = (diff_i * 10) * (is_pro_job and 1.25 or 1),
	},
}
local ready_team_amount = {
	values = {
		amount = 4,
		amount_random = diff_i_no_easy,
	},
}
local flank_far_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local flank_close_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local van_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}

return {
	[101735] = {
		ponr = {
			length = 180,
			length_balance_mul = { 1.25, 1.15, 1, 1 },
		},
	},
	-- Boss spawn
	[102107] = {
		add_drama = {
			amount = 1,
			balance_mul = { 1, 1, 1, 1 },
			team_ai_balance_mul_weight = 1,
			ignore_gain_mul = true,
		},
		forced_difficulty = {
			amount = 0.1,
			time = { 15, 30 },
			delay = 0,
		},
	},
	-- Boss dead
	[100788] = {
		forced_difficulty = false, -- Disable forced diff
	},
	-- begin the cloaker hunt at the start of the first assault
	[100842] = {
		on_executed = {
			{ id = 400084, delay = 0 },
		},
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
				position = Vector3(-1700, 0, 0),
			},
			{
				name = "house_left",
				force = 2,
				position = Vector3(1900, 2000, 0),
			},
			{
				name = "house_right",
				force = 2,
				position = Vector3(1650, -1100, 0),
			},
			{
				name = "house_back",
				force = 3,
				position = Vector3(3000, 900, 20),
			},
		},
	},
	-- Enable reinforce based on the panic room's location
	[101696] = { -- position_001
		on_executed = {
			{ id = 400091, delay = 0 },
		},
	},
	[101697] = { -- position_002
		on_executed = {
			{ id = 400092, delay = 0 },
		},
	},
	[101698] = { -- position_003
		on_executed = {
			{ id = 400093, delay = 0 },
		},
	},
	[101699] = { -- position_004
		on_executed = {
			{ id = 400094, delay = 0 },
		},
	},
	[101700] = { -- position_005
		on_executed = {
			{ id = 400095, delay = 0 },
		},
	},
	[101701] = { -- position_006
		on_executed = {
			{ id = 400096, delay = 0 },
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
	[100019] = flank_far_spawn,
	[102424] = flank_far_spawn,
	[102438] = flank_close_spawn,
	[102459] = flank_close_spawn,
	[400074] = cloaker_spawn,
	[400075] = cloaker_spawn,
	[400076] = cloaker_spawn,
	[400077] = cloaker_spawn,
	[400078] = cloaker_spawn,
	[400079] = cloaker_spawn,
	[400080] = cloaker_spawn,
	[400081] = cloaker_spawn,
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
