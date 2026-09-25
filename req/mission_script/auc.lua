local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local is_eclipse = Eclipse.utils.is_eclipse()
local harasser_enemy = is_eclipse and { [scripted_enemy.swat_1] = 9, [scripted_enemy.elite_sniper] = 1 } or scripted_enemy.swat_1
local harasser = {
	enemy = harasser_enemy,
}
local indoor_spawn = {
	values = {
		interval = 10,
	},
}
local agile_horizntal_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local agile_vertical_spawn = deep_clone(agile_horizntal_spawn)
agile_vertical_spawn.groups = preferred.no_cops_agents

local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local fastup_navlink = {
	values = {
		interval = 8, -- (Vanilla: 4s)
	},
	so_access_filter = so_access.acrobatic,
}

return {
	-- Combine some navigation areas
	[101204] = { -- link_startup
		ai_area = {
			{ 97, 129, 130, 131, 132, 133 },
			{ 94, 134, 135 },
			{ 95, 35 },
			{ 150, 162 },
		},
	},
	-- New reinforce
	[103141] = {
		reinforce = {
			{
				name = "fountain",
				force = 3,
				position = Vector3(2600, 2850, -80),
			},
			{
				name = "what_a_nice_truck",
				force = 2,
				position = Vector3(-1415, 5375, -100),
			},
			{
				name = "what_a_nice_kubelwagen",
				force = 2,
				position = Vector3(-3250, 5000, 0),
			},
			{
				name = "entrance",
				force = 2,
				position = Vector3(-500, 2350, 0),
			},
		},
	},
	-- Disable auctioneer sniper objective on damage
	[105761] = {
		values = {
			interruptible = true,
			interrupt_dmg = 0.1,
			interrupt_dis = 3,
		},
	},
	-- Restrict and slow down select navlinks
	[106133] = fastup_navlink,
	[106134] = fastup_navlink,
	[106135] = fastup_navlink,
	[106144] = fastup_navlink,
	[106145] = fastup_navlink,
	[106145] = fastup_navlink,
	[106157] = fastup_navlink,
	[106161] = fastup_navlink,
	[106162] = fastup_navlink,
	[106163] = fastup_navlink,
	[106164] = fastup_navlink,
	[106167] = fastup_navlink,
	[107420] = fastup_navlink,
	-- Spawn group intervals
	[102292] = indoor_spawn,
	[102317] = indoor_spawn,
	[100716] = agile_horizntal_spawn, -- Funny elevator group with 2 dummies.
	[101931] = agile_vertical_spawn,
	[101656] = agile_vertical_spawn,
	[101918] = agile_vertical_spawn,
	[107273] = cloaker_spawn,
	[107274] = cloaker_spawn,
	[107275] = cloaker_spawn,
	[107276] = cloaker_spawn,
	[107277] = cloaker_spawn,
	[107278] = cloaker_spawn,
	[107279] = cloaker_spawn,
	[107280] = cloaker_spawn,
	[107281] = cloaker_spawn,
	[107356] = cloaker_spawn,
	-- All the harasser dummies
	[106074] = harasser,
	[106075] = harasser,
	[106076] = harasser,
	[106077] = harasser,
	[106078] = harasser,
	[106079] = harasser,
	[106080] = harasser,
	[106081] = harasser,
	[106082] = harasser,
	[106083] = harasser,
	[106084] = harasser,
	[106085] = harasser,
	[106086] = harasser,
	[106087] = harasser,
	[106088] = harasser,
	[106088] = harasser,
}
