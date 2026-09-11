local disabled = {
	values = {
		enabled = false,
	},
}
local ledge_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
}
return {
	-- Disable scripted headless dozers
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
