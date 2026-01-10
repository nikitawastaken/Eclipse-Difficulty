local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local bags_required = {
	values = {
		amount = normal and 4 or hard and 6 or 8,
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
		interval = 15,
	},
}
local rappel_horizontal_spawn = {
	values = {
		interval = 20,
	},
}
local casino_balcony_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local rappel_vertical_spawn = {
	values = {
		interval = 40,
	},
}
local vent_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local los_blockers = {}
local los_blocker_ids = Idstring("units/payday2/architecture/mkp/mkp_int_floor_4x4m_a")
local los_blocker_rot = Rotation(0, -90, 0)
for i = 0, 3 do
	table.insert(los_blockers, {
		name = los_blocker_ids,
		pos = Vector3(-10100 + (i * 400), 4300, 1250),
		rot = los_blocker_rot
	})
end
return {
	-- Add LoS blockers
	[143003] = {
		spawn = los_blockers
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
				name = "casino",
				force = 3,
				position = Vector3(-9300, 2500, 100),
			},
			{
				name = "courtyard",
				force = 2,
				position = Vector3(-9350, 7950, 0),
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
			{ name = "elevator" },
			{ name = "corridor_right" },
			{ name = "corridor_left" },
			{ name = "casino" },
			{ name = "courtyard" },
			{
				name = "helipad",
				force = 4,
				position = Vector3(-9300, 17000, 100),
			},
			{
				name = "spa_outside01",
				force = 2,
				position = Vector3(-7500, 14250, 0),
			},
			{
				name = "spa_outside02",
				force = 2,
				position = Vector3(-11000, 14250, 0),
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
	[101470] = vent_spawn,
}
