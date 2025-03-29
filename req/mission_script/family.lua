local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local bags_required = {
	values = {
		amount = (normal and 4 or hard and 6 or 8) + (is_pro_job and 4 or 0),
	},
}
return {
	-- Restores unused sniper spawn
	[100370] = {
		values = {
			enabled = true,
		},
	},
	-- Delay Twitch from leaving the area after the heist goes loud
	[100022] = {
		on_executed = {
			{ id = 100168, delay = 8 },
		},
	},
	-- tweak the amount of required bags
	[100744] = bags_required,
	[100745] = bags_required,
	[100746] = bags_required,
	[101825] = bags_required,
}
