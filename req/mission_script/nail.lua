local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local headless_dozer_black = scripted_enemy.headless_bulldozer_1
local headless_dozer_white = scripted_enemy.headless_bulldozer_2
local headless_tanks = is_eclipse and { [headless_dozer_black] = 2, [headless_dozer_white] = 1 } or headless_dozer_black
local headless_tank = {
	enemy = headless_tanks,
	values = {
		participate_to_group_ai = true,
	},
}
local ledge_spawn = {
	values = {
		interval = 20,
	},
}
return {
	-- Add new reinforce
	[101610] = { -- start up spawns
		reinforce = {
			{
				name = "pillow01",
				force = 2,
				position = Vector3(-6650, 1000, 200),
			},
			{
				name = "pillow02",
				force = 2,
				position = Vector3(-4550, -975, 200),
			},
			{
				name = "pillow03",
				force = 2,
				position = Vector3(-2050, 1000, 200),
			},
		},
	},
	[101809] = { -- plane dropped ingredient bags
		reinforce = {
			{
				name = "zipline",
				force = 2,
				position = Vector3(-8400, -600, 350),
			},
			{
				name = "bucket",
				force = 2,
				position = Vector3(-5225, 300, 1200),
			},
			{
				name = "lid",
				force = 2,
				position = Vector3(-3550, -75, 2050),
			},
		},
	},
	[100342] = headless_tank,
	[100343] = headless_tank,
	[100344] = headless_tank,
	[100345] = headless_tank,
	[100346] = headless_tank,
	[100347] = headless_tank,
	[100348] = headless_tank,
	[100349] = headless_tank,
	[100350] = headless_tank,
	-- Spawn group intervals
	[101601] = ledge_spawn,
	[101603] = ledge_spawn,
	[101604] = ledge_spawn,
	[101605] = ledge_spawn,
	[101607] = ledge_spawn,
	[101501] = ledge_spawn,
	[101799] = ledge_spawn,
	[101800] = ledge_spawn,
	[101801] = ledge_spawn,
}
