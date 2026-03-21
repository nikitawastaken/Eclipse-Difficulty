local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local jerome_man = scripted_enemy.security_3
local bags_required = {
	values = {
		amount = (normal and 4 or hard and 8 or 12) + (is_pro_job and 4 or 0),
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local murky_choppers = {
	values = {
		amount = is_eclipse and 2 or 1,
		amount_random = (is_pro_job and not is_eclipse) and 1 or 0,
	},
}
local surv_keycard_man = {
	enemy = jerome_man,
}

return {
	-- replace regular murkywater with shotgun guard in the surv room
	[100711] = surv_keycard_man,
	-- change murkywater's model to regular shotgun guard to better indicate who has the keycard
	[101076] = surv_keycard_man,
	[101266] = surv_keycard_man,
	[101272] = surv_keycard_man,
	[101279] = surv_keycard_man,
	-- disable chopper exploit (only for the chopper that deploys murkies :dajoker:)
	[104603] = disabled,
	[104604] = disabled,
	-- 2 choppers can get deployed on Death Wish :dwpj: (with a random chance of 2 choppers on Pro Jobs below Death Wish)
	[101384] = murky_choppers,
	-- the same chopper that deploys murkies can now return :dajoker:
	[100340] = {
		on_executed = {
			{ id = 100303, delay = (is_eclipse and 300 or 360) - (is_pro_job and 60 or 0) },
		},
	},
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
