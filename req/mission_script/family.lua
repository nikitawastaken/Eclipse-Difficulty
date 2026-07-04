local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local bags_required_amount = (normal and 4 or hard and 6 or 8) + (is_pro_job and 4 or 0)
local bags_required = {
	values = {
		amount = bags_required_amount,
	},
}
local bags_required_job_value = {
	values = {
		value = bags_required_amount,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- Restores unused sniper spawn
	[100370] = {
		values = {
			enabled = true,
		},
	},
	-- Disable Titan Cams
	[102211] = {
		values = {
			enabled = false,
		},
	},
	-- add custom reinforce from ASS
	[100324] = disabled, -- reenforce
	[100022] = {
		on_executed = { -- delay Twitch from leaving the area after the heist goes loud
			{ id = 100168, delay = 8 },
		},
		reinforce = {
			{
				name = "street01",
				force = 2,
				position = Vector3(-750, 450, 0),
			},
			{
				name = "street02",
				force = 2,
				position = Vector3(-1750, 450, 0),
			},
			{
				name = "street03",
				force = 2,
				position = Vector3(-1000, -4000, 0),
			},
			{
				name = "street04",
				force = 2,
				position = Vector3(3000, -4000, 0),
			},
			{
				name = "alley",
				force = 2,
				position = Vector3(2200, 1000, 0),
			},
			{
				name = "plaza",
				force = 3,
				position = Vector3(4250, -1700, 0),
			},
		},
	},
	-- tweak the swat van
	[102031] = {
		on_executed = {
			{ id = 102033, remove = true },
		},
	},
	[102033] = {
		on_executed = {
			{ id = 102034, remove = true },
		},
	},
	-- trigger on diff 0.75
	[100124] = {
		on_executed = {
			{ id = 102033, delay = 0 },
		},
	},
	-- tweak the amount of required bags
	[100744] = bags_required,
	[100745] = bags_required,
	[100746] = bags_required,
	[101825] = bags_required,
	[104047] = bags_required,
	[104048] = bags_required,
	[104049] = bags_required,
	[100260] = bags_required,
	[100321] = bags_required,
	[100322] = bags_required,
	[102013] = bags_required,
	[102014] = bags_required,
	[102015] = bags_required,
	[102016] = bags_required,
	[104050] = bags_required_job_value,
	[104051] = bags_required_job_value,
	[104052] = bags_required_job_value,
	[100867] = bags_required_job_value,
	-- tweak swat van group
	[400007] = scripted_swat_van_spawn,
}
