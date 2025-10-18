local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
-- add female bikers to spawn roster
local biker_enemy = {
	["units/payday2/characters/ene_biker_1/ene_biker_1"] = 5,
	["units/payday2/characters/ene_biker_2/ene_biker_2"] = 5,
	["units/payday2/characters/ene_biker_3/ene_biker_3"] = 5,
	["units/payday2/characters/ene_biker_4/ene_biker_4"] = 5,
	["units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1"] = 2,
	["units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2"] = 2,
	["units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3"] = 2,
}
local biker = { enemy = biker_enemy }
local disabled = {
	values = {
		enabled = false,
	},
}
local window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
local bags_required = {
	values = {
		amount = (normal and 4 or 6) + (is_pro_job and 2 or 0),
	},
}
return {
	-- Add pump and tanker reinforce
	[102160] = {
		reinforce = { -- pump 1
			{
				name = "pump",
				force = 2,
				position = Vector3(2750, -9850, -3200),
			},
		},
	},
	[102163] = {
		reinforce = { -- pump 2
			{
				name = "pump",
				force = 2,
				position = Vector3(3725, -12725, -3200),
			},
		},
	},
	[102616] = {
		reinforce = { -- tanker 1
			{
				name = "tanker",
				force = 2,
				position = Vector3(2425, -7375, -3100),
			},
		},
	},
	[102618] = {
		reinforce = { -- tanker 2
			{
				name = "tanker",
				force = 2,
				position = Vector3(1325, -12700, -3200),
			},
		},
	},
	-- disable selected spawngroup based on which tunnel has been chossen
	[101076] = {
		on_executed = {
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
		},
	},
	[103145] = {
		on_executed = {
			{ id = 400001, delay = 0 },
			{ id = 400003, delay = 0 },
		},
	},
	[103149] = {
		on_executed = {
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
		},
	},
	--Always spawn the keycard in Mexico
	[102270] = disabled,
	[100697] = {
		on_executed = {
			{ id = 102271, delay = 0 },
		},
	},
	-- Remove red lights from keycard readers since the vault can be opened in loud now
	[103709] = disabled,
	-- change the required amount of loot bags
	[101367] = bags_required,
	[102096] = bags_required,
	[102378] = bags_required,
	[102888] = bags_required,
	[102165] = bags_required,
	[102876] = bags_required,
	[102879] = bags_required,
	[102891] = bags_required,
	[102380] = bags_required,
	[102877] = bags_required,
	[102880] = bags_required,
	[102892] = bags_required,
	[102381] = bags_required,
	[102878] = bags_required,
	[102881] = bags_required,
	[102893] = bags_required,
	-- gangsters
	[100670] = biker,
	[100671] = biker,
	[100672] = biker,
	[100673] = biker,
	[100674] = biker,
	[100675] = biker,
	[100116] = biker,
	[101564] = biker,
	[101571] = biker,
	[101572] = biker,
	[101555] = biker,
	[101556] = biker,
	[101037] = biker,
	[101034] = biker,
	[101222] = biker,
	[101235] = biker,
	[101272] = biker,
	[101274] = biker,
	[101296] = biker,
	[101329] = biker,
	[101355] = biker,
	[101363] = biker,
	[101400] = biker,
	[101310] = biker, -- camera man
	[101683] = biker,
	[101774] = biker,
	[101866] = biker, -- camera man
	-- Spawn group intervals
	[103235] = window_spawn,
	[103048] = window_spawn,
	[103067] = window_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
	[102553] = cloaker_spawn,
	[102554] = cloaker_spawn,
	[102555] = cloaker_spawn,
	[102556] = cloaker_spawn,
	[102557] = cloaker_spawn,
	[102558] = cloaker_spawn,
	[102559] = cloaker_spawn,
	[102560] = cloaker_spawn,
}
