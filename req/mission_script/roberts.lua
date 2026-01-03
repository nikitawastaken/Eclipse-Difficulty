local gensec_operators = {
	Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
	Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
}
local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local diff_i = Eclipse.utils.difficulty_index()
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
local us_soldier_3 = scripted_enemy.soldier_4
--local us_soldier_tank = scripted_enemy.soldier_bulldozer
local taser = scripted_enemy.taser_1
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 5, [elite_sniper] = 1 } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local us_soldiers = { [us_soldier_1] = 4, [us_soldier_2] = 2, [us_soldier_3] = 1 }
local us_soldier = {
	enemy = us_soldiers,
}
local taser_spawn = {
	enemy = taser,
}
local gensec_truck = {
	enemy = overkill_and_above and gensec_operators,
}
local ambush_chance = {
	chance = (normal and 20 or hard and 30 or 40) + (is_pro_job and 20 or 0),
}
local donut_lords_at_the_gas_station = {
	chance = (eclipse and 20 or 10) + (is_pro_job and 10 or 0),
}
local gensec_van_at_the_bank = {
	chance = (eclipse and 10 or 5) + (is_pro_job and 5 or 0),
}
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local sewer_spawn = {
	values = {
		interval = 30,
	},
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}

return {
	-- Instantly enter full force onslaught upon plane securing the bags or crashing down
	[101971] = {
		set_ponr_state = true,
	},
	-- remove vanilla PONRs
	[101949] = {
		on_executed = {
			{ id = 101952, remove = true },
			{ id = 101955, remove = true },
		},
	},
	[101938] = { -- Bag in cage
		values = {
			callback = function() -- Somebody call the National Guard!
				if not normal then
					managers.groupai:state():enable_timed_spawngroup("us_scripted_group1")
				end
			end,
		},
	},
	-- add gensec response on loud
	[100109] = {
		on_executed = {
			{ id = 103028, delay = 10, delay_rand = 5 },
			{ id = 105567, delay = 10, delay_rand = 5 },
		},
	},
	-- chance tweaks for gensec van/cops at gas station
	[106343] = donut_lords_at_the_gas_station,
	[106344] = donut_lords_at_the_gas_station,
	[105744] = gensec_van_at_the_bank,
	-- Add early reinforce around the bank
	[100109] = {
		reinforce = {
			{
				name = "bank_left",
				force = 3,
				position = Vector3(-525, -3000, -75),
			},
			{
				name = "bank_right",
				force = 3,
				position = Vector3(450, 1750, -75),
			},
			{
				name = "bank_front",
				force = 3,
				position = Vector3(2925, -650, -75),
			},
			{
				name = "bank_back",
				force = 3,
				position = Vector3(-3250, -1375, -60),
			},
		},
	},
	-- Add manhole reinforce
	[102504] = {
		reinforce = { -- manhole 1
			{
				name = "manhole",
				force = 2,
				position = Vector3(4010, -1710, 75),
			},
		},
	},
	[102505] = { -- manhole 2
		reinforce = {
			{
				name = "manhole",
				force = 2,
				position = Vector3(1185, 1615, 75),
			},
		},
	},
	[102506] = { -- manhole 3
		reinforce = {
			{
				name = "manhole",
				force = 2,
				position = Vector3(-1085, -3440, 75),
			},
		},
	},
	[102507] = { -- manhole 4
		reinforce = {
			{
				name = "manhole",
				force = 2,
				position = Vector3(-2015, -115, 75),
			},
		},
	},
	-- tweak the ambush near the end
	-- both soldiers and dozer ambush on Death Wish pro
	[106416] = {
		values = {
			amount = is_eclipse_pro and 2 or 1,
		},
	},
	-- all 8 ambush units on Death Wish pro
	[104534] = {
		values = {
			amount = is_eclipse_pro and 8 or 6,
		},
	},
	-- replace the turret with a spawngroup
	[106548] = {
		on_executed = {
			{ id = 106539, remove = true },
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	-- Increase plank amounts
	[101803] = {
		values = {
			amount = 12,
		},
	},
	[101804] = {
		values = {
			amount = 16,
		},
	},
	[101805] = {
		values = {
			amount = 8,
		},
	},
	-- GenSec Operators near the GenSec truck on overkill and above
	[105748] = gensec_truck,
	[105749] = gensec_truck,
	--replace the fbi with soldiers+some tasers
	[106434] = us_soldier,
	[106433] = taser_spawn,
	[106435] = us_soldier,
	[106432] = us_soldier,
	[106440] = taser_spawn,
	[106434] = us_soldier,
	-- replace the door knocking dozer with army one on ovk above
	-- [106414] = army_dozer,
	-- tweak ambush spawn chances
	[106427] = ambush_chance,
	[106428] = ambush_chance,
	[106429] = ambush_chance,
	-- Spawn group intervals
	-- It's a bit of a departure from the original which had all spawn group intervals set to 0, which was kind of lame.
	-- Having sewer spawns set to the minimum possible interval is a pretty bad idea.
	[400007] = scripted_swat_van_spawn,
	[100128] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[100130] = standard_spawn,
	[100694] = standard_spawn,
	[103294] = sewer_spawn,
	[103295] = sewer_spawn,
	[103296] = sewer_spawn,
	[103297] = sewer_spawn,
	[103298] = sewer_spawn,
	[103788] = sewer_spawn,
	[103789] = sewer_spawn,
	[103790] = sewer_spawn,
	[103791] = sewer_spawn,
	[103792] = sewer_spawn,
	[103793] = sewer_spawn,
	[104629] = sewer_spawn,
	[104631] = sewer_spawn,
	[104649] = sewer_spawn,
	[104686] = sewer_spawn,
	[104687] = sewer_spawn,
	[104689] = sewer_spawn,
	-- Holy harassers, Batman...
	[103098] = harasser,
	[103099] = harasser,
	[103100] = harasser,
	[103117] = harasser,
	[103118] = harasser,
	[103119] = harasser,
	[103175] = harasser,
	[103176] = harasser,
	[103177] = harasser,
	[103191] = harasser,
	[103192] = harasser,
	[103193] = harasser,
	[103207] = harasser,
	[103208] = harasser,
	[103209] = harasser,
	[103223] = harasser,
	[103224] = harasser,
	[103225] = harasser,
	[103239] = harasser,
	[103240] = harasser,
	[103241] = harasser,
	[103255] = harasser,
	[103256] = harasser,
	[103257] = harasser,
	[103271] = harasser,
	[103272] = harasser,
	[103273] = harasser,
	[103287] = harasser,
	[103288] = harasser,
	[103289] = harasser,
}
