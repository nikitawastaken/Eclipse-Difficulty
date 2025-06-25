local preferred = Eclipse.preferred
local street_spawn = {
	values = {
		interval = 15,
	},
}
local rappel_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 180,
	},
}
return {
	-- Combine some navigation areas
	[101230] = {
		ai_area = {
			{ 59, 62 },
			{ 54, 55, 125, 126 },
			{ 46, 42, 50, 44, 36, 49, 45, 43, 48, 90, 47, 51 },
			{ 79, 80, 78, 77, 37, 16 },
			{ 35, 34 },
			{ 94, 95, 33, 32, 30, 31 },
			{ 40, 41, 96, 97, 98 },
			{ 39, 38 },
			{ 26, 29, 27 },
			{ 24, 25, 100, 23, 22 },
			{ 18, 20 },
			{ 61, 17, 15, 14 },
			{ 13, 9, 8 },
			{ 11, 81, 82, 83, 86, 84, 85, 87, 88, 89 },
			{ 5, 6, 92, 4, 3 },
			{ 66, 67, 60, 118, 117, 116 },
			{ 120, 121, 119, 123 },
			{ 103, 102, 105, 104, 106, 69 },
			{ 76, 111 },
			{ 130, 129 },
			{ 108, 109 },
			{ 131, 128, 101 },
			{ 107, 74, 133, 12, 19, 21 },
			{ 64, 135, 63, 58, 134 },
			{ 52, 53 },
		},
	},
	-- Add new reinforce
	[101169] = { -- First cop car arrived
		reinforce = {
			{
				name = "pear_shop",
				force = 2,
				position = Vector3(1450, -2700, 25),
			},
			{
				name = "convenience_store",
				force = 2,
				position = Vector3(-750, 2700, 25),
			},
			{
				name = "cafe",
				force = 2,
				position = Vector3(0, -4075, 25),
			},
			{
				name = "china",
				force = 2,
				position = Vector3(1450, -4050, 25),
			},
		},
	},
	[101470] = { -- Safe 5, Pear shop safe
		reinforce = {
			{ name = "pear_shop" },
		},
	},
	[101449] = { -- Safe 4, Cafe safe
		reinforce = {
			{ name = "cafe" },
		},
	},
	[101450] = { -- Safe 3, China store safe 2
		reinforce = {
			{ name = "china" },
		},
	},
	[101469] = { -- Safe 2, China store safe 1
		reinforce = {
			{ name = "china" },
		},
	},
	[101477] = { -- Safe 1, Convenience store safe
		reinforce = {
			{ name = "convenience_store" },
		},
	},
	-- disable Titan cams
	[103683] = {
		values = {
			enabled = false,
		},
	},
	-- spawn points (from ASS)
	[101112] = { -- spawn 1
		on_executed = {
			{ id = 103242, delay = 0 },
		},
	},
	[101113] = {
		on_executed = {
			{ id = 103242, delay = 0 },
		},
		values = {
			enabled = true,
		},
	},
	[101115] = {
		on_executed = {
			{ id = 103242, delay = 0 },
		},
		values = {
			enabled = true,
		},
	},
	[103240] = { -- open the door if you spawn at spawn 3, not based on difficulty
		on_executed = {
			{ id = 103242, remove = true },
		},
	},
	-- Remove the rappel group from initital preferreds
	[101334] = { -- 1st preferred add
		on_executed = {
			{ id = 101375, remove = true },
		},
	},
	[101832] = { -- diff 65
		on_executed = {
			{ id = 400001, delay = 0, delay_rand = 20 },
		},
	},
	-- Spawn group delays
	[101221] = street_spawn,
	[101213] = street_spawn,
	[101345] = street_spawn,
	[101369] = street_spawn,
	[101375] = rappel_spawn,
	[103543] = cloaker_spawn,
	[103544] = cloaker_spawn,
	[103545] = cloaker_spawn,
	[103546] = cloaker_spawn,
	[103547] = cloaker_spawn,
	[103548] = cloaker_spawn,
}
