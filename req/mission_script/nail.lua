local disabled = {
	values = {
		enabled = false,
	},
}
local ledge_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.75, 1.5, 1.25, 1 },
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
    -- disable scripted headless dozers
    [100351] = disabled,
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
