local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local bags_required = {
	values = {
		amount = (is_eclipse and 6 or 4) + (is_pro_job and 2 or 0),
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local standard_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
}
local rappel_horizontal_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local casino_balcony_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local rappel_vertical_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
}
local vent_spawn = {
	values = {
		interval = 60,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn_why_does_it_have_10_spawn_points = {
	values = {
		interval = vent_spawn.values.interval,
		interval_balance_mul = vent_spawn.values.interval_balance_mul,
		elements = { 102515, 102516, 102517, 102518, 102519 },
	},
	groups = vent_spawn.groups,
}
local los_blockers = {}
local los_blocker_ids = Idstring("units/payday2/architecture/mkp/mkp_int_floor_4x4m_a")
local los_blocker_rot = Rotation(0, -90, 0)
for i = 0, 3 do
	table.insert(los_blockers, {
		name = los_blocker_ids,
		pos = Vector3(-10100 + (i * 400), 4300, 1250),
		rot = los_blocker_rot,
	})
end
return {
	-- FFOs
	-- vault is open (default route)
	[101331] = {
		ponr = {
			length = 480,
			length_balance_mul = { 1.125, 1, 0.875, 0.75 },
		},
	},
	-- 3 choppers went down (c4 route)
	[101683] = {
		ponr = {
			length = 300,
			length_balance_mul = { 1.125, 1, 0.875, 0.75 },
		},
	},
	-- Add LoS blockers
	[143003] = {
		spawn = los_blockers,
	},
	-- Reenforce points
	[103167] = disabled,
	[103168] = disabled,
	[103169] = disabled,
	[103170] = disabled,
	[103172] = disabled,
	[100109] = {
		reinforce = {
			{
				name = "elevator",
				force = 3,
				position = Vector3(-9300, 9850, 0),
			},
			{
				name = "casino",
				force = 3,
				position = Vector3(-9300, 2650, 100),
			},
			{
				name = "courtyard",
				force = 3,
				position = Vector3(-9300, 8500, 0),
			},
			{
				name = "spa",
				force = 3,
				position = Vector3(-9300, 11025, 400),
			},
			{
				name = "corridor_right",
				force = 2,
				position = Vector3(-7975, 6800, 20),
			},
			{
				name = "corridor_left",
				force = 2,
				position = Vector3(-10575, 6800, 20),
			},
			{
				name = "casino_left",
				force = 2,
				position = Vector3(-11600, 1900, 0),
			},
			{
				name = "casino_right",
				force = 2,
				position = Vector3(-7100, 1900, 0),
			},
			{
				name = "spa_left",
				force = 2,
				position = Vector3(-8000, 13300, 400),
			},
			{
				name = "spa_right",
				force = 2,
				position = Vector3(-10650, 13300, 400),
			},
		},
	},
	-- Escape reenforce/harasser stuff
	[100918] = {
		on_executed = {
			{ id = 100890, remove = true },
		},
	},
	[101449] = { --Escape signalled
		on_executed = {
			{ id = 100890, delay = 0 },
		},
		reinforce = {
			{ name = "casino" },
			{ name = "courtyard" },
			{ name = "corridor_right" },
			{ name = "corridor_left" },
			{ name = "casino_left" },
			{ name = "casino_right" },
			{ name = "spa_left" },
			{ name = "spa_right" },
			{
				name = "helipad",
				force = 4,
				position = Vector3(-9300, 17000, 100),
			},
			{
				name = "spa_outside_left",
				force = 2,
				position = Vector3(-7500, 14250, 400),
			},
			{
				name = "spa_outside_right",
				force = 2,
				position = Vector3(-11025, 14250, 400),
			},
		},
	},
	-- Enable unused snipers
	[100371] = enabled,
	[100372] = enabled,
	-- change the required amount of money bags
	[101818] = bags_required,
	[101819] = bags_required,
	[106920] = bags_required,
	[101195] = bags_required,
	[101810] = bags_required,
	[101811] = bags_required,
	-- Spawn group intervals
	-- The Black Cat is one of the newer heists, so its spawn groups are not spread out at all and reach players almost immediately.
	-- The shortest interval is 15s, for reference on most heists that would be 5s. It's not uncommon even for post-Jules heists to have 15s spawn groups, but the revival era team was seemingly pretty clueless in this respect.
	[100786] = standard_spawn,
	[101471] = standard_spawn,
	[100792] = standard_spawn,
	[100131] = standard_spawn,
	[100647] = standard_spawn,
	[100648] = rappel_horizontal_spawn,
	[100704] = rappel_horizontal_spawn,
	[100712] = rappel_horizontal_spawn,
	[100693] = rappel_horizontal_spawn,
	[100692] = rappel_horizontal_spawn,
	[100007] = rappel_horizontal_spawn,
	[100766] = rappel_horizontal_spawn,
	[100768] = rappel_horizontal_spawn,
	[100132] = rappel_horizontal_spawn,
	[100133] = rappel_horizontal_spawn,
	[100312] = casino_balcony_spawn,
	[100325] = casino_balcony_spawn,
	[100019] = rappel_vertical_spawn,
	[100757] = rappel_vertical_spawn,
	[100758] = rappel_vertical_spawn,
	[100759] = rappel_vertical_spawn,
	[100779] = rappel_vertical_spawn,
	[101468] = rappel_vertical_spawn,
	[101469] = vent_spawn,
	[101470] = vent_spawn_why_does_it_have_10_spawn_points,
}
