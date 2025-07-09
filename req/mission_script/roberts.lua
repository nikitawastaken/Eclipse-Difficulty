local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local overkill_and_above = Eclipse.utils.diff_threshold()
local is_pro_job = Eclipse.utils.is_pro_job()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_pro_job and eclipse
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
--local us_soldier_tank = scripted_enemy.soldier_bulldozer
local taser = scripted_enemy.taser_1
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 10, [elite_sniper] = 1 } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local us_soldiers = { [us_soldier_1] = 4, [us_soldier_2] = 1 }
local us_soldier = {
	enemy = us_soldiers,
}
--[[
local army_dozer = {
	enemy = overkill_and_above and us_soldier_tank,
}
]]
local taser_spawn = {
	enemy = taser,
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
local plank_amount = {
	values = {
		amount = 4,
		amount_random = 6 - (is_pro_job and 4 or 0),
	},
}
local street_spawn = {
	values = {
		interval = 5,
	},
}
local wall_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_shields_bulldozers,
}
local rear_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
local sewer_spawn = {
	values = {
		interval = 20,
	},
}
return {
	[101949] = {
		ponr = {
			length = 60,
			player_mul = { 2, 1.5, 1, 1 },
		},
		on_executed = {
			{ id = 101952, remove = true },
			{ id = 101955, remove = true },
		},
	},
	[101938] = { -- Bag in cage
		values = {
			callback = function() -- Somebody call the National Guard!
				if not normal then
					managers.groupai:state():enabled_timed_group(1)
				end
			end,
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
				force = 2,
				position = Vector3(-500, -3000, -75),
			},
			{
				name = "bank_right",
				force = 2,
				position = Vector3(450, 1750, -75),
			},
			{
				name = "bank_front",
				force = 2,
				position = Vector3(2950, -650, -75),
			},
			{
				name = "bank_back",
				force = 2,
				position = Vector3(-3250, -1375, -60),
			},
		},
	},
	-- Delay initial diff
	[100116] = {
		on_executed = {
			{ id = 100122, delay = 30 },
		},
	},
	-- tweak the ambush near the end
	-- both soldiers and dozer ambush on eclipse pro
	[106416] = {
		values = {
			amount = is_eclipse_pro and 2 or 1,
		},
	},
	-- all 8 ambush units on eclipse pro
	[104534] = {
		values = {
			amount = is_eclipse_pro and 8 or 6,
		},
	},
	-- adjust plank amount
	[101803] = plank_amount,
	[101804] = plank_amount,
	[101805] = plank_amount,
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
	-- Spawn group delays
	-- It's a bit of a departure from the original which had all spawn group intervals set to 0, which was kind of lame.
	-- Having sewer spawns set to the minimum possible interval is a pretty bad idea.
	[100128] = street_spawn,
	[100132] = street_spawn,
	[100133] = street_spawn,
	[100694] = rear_spawn,
	[100130] = wall_spawn,
	[100131] = wall_spawn,
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
