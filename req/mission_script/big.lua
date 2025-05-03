local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 4, [elite_sniper] = 1 } or heavy_1
local fail_to_believe_chance = (is_eclipse and 30 or 20) + (is_pro_job and 5 or 0)
local timelock_normal = (is_eclipse and 240 or 180) + (is_pro_job and 30 or 0)
local timelock_fast = (is_eclipse and 210 or 150) + (is_pro_job and 30 or 0)
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local flank_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_bulldozers,
}
local elevator_spawn = {
	values = {
		interval = 30,
	},
}
local elevator_spawn_2 = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local wall_c4_chance = {
	values = {
		chance = (normal and 40 or 60) * (is_pro_job and 1.5 or 1),
	},
}
local no_shields_and_dozers = {
	so_access_filter = { "cop", "swat", "fbi", "taser", "spooc" },
}

local bags_required = {
	values = {
		amount = (eclipse and 6 or 4) + (is_pro_job and 2 or 0),
	},
}

return {
	[100809] = {
		ponr = {
			length = 180,
			player_mul = { 2, 1.25, 1., 1 },
		},
	},
	[105844] = {
		reinforce = {
			{
				name = "meetingroom",
				force = 2,
				position = Vector3(-3400, 1000, -600),
			},
			{
				name = "outside_vault",
				force = 2,
				position = Vector3(-3000, 500, -1000),
			},
		},
	},
	[100834] = {
		reinforce = {
			{
				name = "elevator",
				force = 2,
				position = Vector3(-1200, -650, -900),
			},
		},
	},
	[104523] = {
		reinforce = {
			{
				name = "bus",
				force = 2,
				position = Vector3(-2150, -2050, -500),
			},
		},
	},
	-- Disable Titan Cams
	[106265] = {
		values = {
			enabled = false,
		},
	},
	-- Enable roof spawngroups
	[100006] = {
		values = {
			spawn_groups = { 100019, 100007, 100692 },
		},
	},
	-- enable new elevator spawngroup
	[104530] = {
		on_executed = {
			{ id = 400020, delay = 0 },
		},
	},
	--More timelock timer on Eclipse and Pro Jobs
	[103137] = {
		values = {
			time = timelock_normal,
		},
	},
	[100170] = {
		values = {
			time = timelock_fast,
		},
	},
	-- restore alternative phone call outcome that sends two beat cops to investigate (failed to fell for it)
	[105244] = { chance = fail_to_believe_chance },
	-- change amount of required bags
	[101868] = bags_required,
	[103961] = bags_required,
	-- Wall c4 chance
	[102451] = wall_c4_chance,
	[102469] = wall_c4_chance,
	-- Disable cheat spawns
	[102267] = {
		values = {
			enabled = false,
		},
	},
	-- Prevent shields/dozers from disabling the timelock
	[101195] = no_shields_and_dozers,
	[102268] = no_shields_and_dozers,
	-- trigger ambush cloakers when the time lock door opens
	[104397] = {
		on_executed = {
			{ id = 400012, delay = 0 },
		},
	},
	-- disable ambush cloakers on startup
	[100017] = {
		on_executed = {
			{ id = 400011, delay = 3 },
		},
	},
	-- enable ambush cloakers on loud
	[100023] = {
		on_executed = {
			{ id = 400010, delay = 0 },
		},
	},
	-- Make server hack guranteed when solo
	[104494] = {
		pre_func = function(self)
			if table.size(managers.network:session():peers()) == 0 then
				self._chance = 100
			end
		end,
	},
	-- Spawn Group delays
	[100019] = flank_spawn,
	[100692] = roof_spawn,
	[100007] = roof_spawn,
	[105450] = elevator_spawn,
	[105500] = elevator_spawn,
	[105434] = elevator_spawn,
	[400019] = elevator_spawn_2,
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
