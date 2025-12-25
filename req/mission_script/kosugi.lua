local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local bags_required = {
	values = {
		amount = (normal and 4 or hard and 8 or 12) + (is_pro_job and 4 or 0),
	},
}

return {
	-- bag tweaks (4 on easy and normal, 8 on hard and overkill and 12 on Death Wish)
	-- 4 more bags to secure on pro jobs
	[101156] = bags_required,
	[103407] = bags_required,
	[103419] = bags_required,
	[103780] = bags_required,
	[101157] = bags_required,
	[103412] = bags_required,
	[103420] = bags_required,
	[103795] = bags_required,
	[101158] = bags_required,
	[103413] = bags_required,
	[103421] = bags_required,
	[101159] = bags_required,
	[103414] = bags_required,
	[103422] = bags_required,
	[102848] = bags_required,
	[103393] = bags_required,
	[103539] = bags_required,
}
