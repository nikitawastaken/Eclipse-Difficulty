local normal, hard, eclipse = Eclipse.utils.diff_groups()
local overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
--local us_soldier_tank = scripted_enemy.soldier_bulldozer
local taser = scripted_enemy.taser_1
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper

local light_harasser = swat_1
local heavy_harasser = is_eclipse and { heavy_1, heavy_1, elite_sniper } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}

local us_soldiers = {
	us_soldier_1,
	us_soldier_1,
	us_soldier_1,
	us_soldier_2,
}
local us_soldier = {
	enemy = us_soldiers,
}
--[[
local army_dozer = {
	enemy = overkill_and_above and us_soldier_tank,
}
]]--
local taser_spawn = {
	enemy = taser,
}

local ambush_chance = {
    chance = normal and 45 or hard and 70 or 100
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
	-- restore the bulldozer that drops from the chopper on higher diffs
	[102992] = {
		values = {
			enabled = overkill_and_above and true,
		},
	}
	-- loop the chopper
    [100022] = {
		on_executed = {
			{ id = 104075, delay = overkill_and_above and 300 or 360 },
		},
	},
	[104078] = {
		on_executed = {
			{ id = 104075, delay = overkill_and_above and 240 or 300 },
		},
	},
    [104076] = {
		on_executed = {
			{ id = 104075, remove = true },
		},
	},
    [104075] = {
		values = {
			trigger_times = 0,
		},
	},
    -- tweak the ambush near the end
    -- both soldiers and dozer ambush on eclipse
    [106416] = {
		values = {
			amount = is_eclipse and 2,
		},
	},
    -- all 8 ambush units on eclipse
    [104534] = {
		values = {
			amount = is_eclipse and 8,
		},
	},
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
