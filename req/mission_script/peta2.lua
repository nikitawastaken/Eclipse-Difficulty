local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local goats_required = {
	values = {
		counter_target = (normal and 5 or hard and 8 or 10) + (is_pro_job and 2 or 0),
	},
}
local random_goats = {
	values = {
		amount = (normal and 5 or hard and 8 or 10) + (is_pro_job and 2 or 0),
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local farm_far_spawn = {
	values = {
		interval = 10,
	},
}
local farm_close_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- add point of no return
	[100580] = { -- All goats secured
		ponr = {
			length = 180,
			player_mul = { 2, 1.25, 1, 1 },
		},
		values = {
			callback = function() -- Somebody call the National Guard!
				if not normal then
					managers.groupai:state():enable_timed_spawngroup("us_scripted_group1")
				end
			end,
		},
	},
	[101707] = disabled, -- Disable hunt
	-- Tweak one of the bridge spawngroups
	[102374] = {
		values = {
			elements = {
				102376,
				102377,
				102378,
				102379,
				102380,
			},
		},
	},
	-- Scale goat requirements
	[100579] = goats_required,
	[101584] = goats_required,
	[101585] = goats_required,
	[101586] = goats_required,
	[101587] = goats_required,
	[101588] = random_goats,
	[101589] = random_goats,
	[101590] = random_goats,
	[101591] = random_goats,
	[101592] = random_goats,
	-- Disable one reinforce point on the bridge, increase the force of the other from 2 to 3
	[101385] = {
		values = {
			amount = 3,
		},
	},
	[101386] = disabled,
	-- replace the turret/scripted van spawn with a spawngroups
	[100264] = { -- arrive 1
		on_executed = {
			{ id = 400005, delay = 0 },
			{ id = 101791, remove = true },
		},
	},
	[101974] = { -- arrive 2
		on_executed = {
			{ id = 400011, delay = 0 },
			{ id = 101938, remove = true },
		},
	},
	[101972] = { -- arrive 3
		on_executed = {
			{ id = 400017, delay = 0 },
			{ id = 101936, remove = true },
		},
	},
	[101966] = { -- arrive 4
		on_executed = {
			{ id = 400023, delay = 0 },
			{ id = 101939, remove = true },
		},
	},
	-- Spawn group intervals
	-- Most of the spawns during the farm section are slower now akin to the original version.
	-- Fuck the bush spawngroup or something.
	[400006] = scripted_swat_van_spawn,
	[400012] = scripted_swat_van_spawn,
	[400018] = scripted_swat_van_spawn,
	[400024] = scripted_swat_van_spawn,
	[100019] = farm_far_spawn,
	[100131] = farm_far_spawn,
	[100132] = farm_far_spawn,
	[100693] = farm_far_spawn,
	[101217] = farm_close_spawn,
	[100007] = farm_close_spawn,
	[100128] = farm_close_spawn,
	[100130] = farm_close_spawn,
	[100133] = farm_close_spawn,
	[100692] = farm_close_spawn,
	[100694] = farm_close_spawn,
}
