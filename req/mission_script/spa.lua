local spawn_1 = {
	values = {
		interval = 20,
	},
}
local spawn_2 = {
	values = {
		interval = 30,
	},
}

return {
	-- add point of no return and disable endless assault
	[100875] = {
		ponr = {
			length = 240,
			player_mul = { 1.5, 1, 0.85, 0.75 },
		},
	},
	[100877] = {
		values = {
			enabled = false,
		},
	},
	-- Slow down all spawnpoints cause this is a very cramped map
	[102664] = spawn_1,
	[102668] = spawn_1,
	[102667] = spawn_1,
	[107262] = spawn_1,
	[107263] = spawn_1,
	[104472] = spawn_1,
	[102140] = spawn_1,
	[102139] = spawn_1,
	[104336] = spawn_1,
	[104337] = spawn_1,
	[104347] = spawn_2,
	[102151] = spawn_2,
	[107261] = spawn_2,
	[107260] = spawn_2,
	[100750] = spawn_2,
	[101012] = spawn_2,
	[102138] = spawn_2,
	[104338] = spawn_2,
}
