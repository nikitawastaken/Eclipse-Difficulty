local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
-- more based miki changes from ASS, kuss kuss
local beat_cops = {
	Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
	Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"),
}
local beat_cop = { enemy = beat_cops }
local guards = {
	Idstring("units/pd2_dlc_bex/characters/ene_bex_security_01/ene_bex_security_01"),
	Idstring("units/pd2_dlc_bex/characters/ene_bex_security_02/ene_bex_security_02"),
	Idstring("units/pd2_dlc_bex/characters/ene_bex_security_03/ene_bex_security_03"),
}
local guard = { enemy = guards }
local suit_guards = {
	Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"),
	Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"),
	Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03"),
}
local suit_guard = { enemy = suit_guards }
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local side_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}

local bags_required = {
	values = {
		counter_target = (eclipse and 6 or 4) + (is_pro_job and 2 or 0),
	},
}
local bags_required_objective = {
	values = {
		amount = (eclipse and 6 or 4) + (is_pro_job and 2 or 0),
	},
}

return {
	[101829] = {
		ponr = {
			length = 240,
			player_mul = { 2, 1.5, 1.25, 1 },
		},
		-- add dozers chance based event to the vault
		on_executed = {
			{id = 400009, delay = 10},
			{id = 400010, delay = 10}
		},
	},
	[100109] = { -- police, executed on alarm
		reinforce = {
			{
				name = "fountain",
				force = 3,
				position = Vector3(0, 1200, 50),
			},
			{
				name = "side_entrance",
				force = 3,
				position = Vector3(-2250, -2350, 0),
			},
		},
	},
	[102311] = { -- func sequence trigger 003
		reinforce = {
			{
				name = "backdoor", -- lockpick door by the mechanic shop
				force = 2,
				position = Vector3(1750, -2100, 0),
			},
		},
	},
	[102541] = { -- link activate navlinks roof
		on_executed = {
			{ id = 101618, remove = true }, -- why does this spawn a guard ?
		},
		reinforce = {
			{
				name = "roof1",
				force = 2,
				position = Vector3(0, -1150, 850),
			},
			{
				name = "roof2",
				force = 2,
				position = Vector3(0, -4000, 850),
			},
		},
	},
	[103692] = { -- break wall
		reinforce = {
			{
				name = "back_turret",
				force = 2,
				position = Vector3(-1700, -5650, 0),
			},
		},
	},
	-- add reenforce to office rooms at start
	[101758] = { -- server room point 1
		reinforce = {
			{
				name = "office1",
				force = 2,
				position = Vector3(700, -6000, 0),
			},
			{
				name = "office2",
				force = 2,
				position = Vector3(-700, -6000, 0),
			},
		},
	},
	[101013] = { -- server room point 2
		reinforce = {
			{
				name = "office2",
				force = 2,
				position = Vector3(-700, -6000, 0),
			},
			{
				name = "office3",
				force = 2,
				position = Vector3(1150, -4400, 0),
			},
		},
	},
	[101886] = { -- server room point 3 (same room as 1)
		reinforce = {
			{
				name = "office1",
				force = 2,
				position = Vector3(700, -6000, 0),
			},
			{
				name = "office2",
				force = 2,
				position = Vector3(-700, -6000, 0),
			},
		},
	},
	[101022] = { -- server room point 4
		reinforce = {
			{
				name = "office1",
				force = 2,
				position = Vector3(700, -6000, 0),
			},
			{
				name = "office3",
				force = 2,
				position = Vector3(1150, -4400, 0),
			},
		},
	},
	[101801] = { -- hacking completed - server room is fair game for reenforce
		reinforce = {
			{
				name = "office1",
				force = 2,
				position = Vector3(700, -6000, 0),
			},
			{
				name = "office2",
				force = 2,
				position = Vector3(-700, -6000, 0),
			},
			{
				name = "office3",
				force = 2,
				position = Vector3(1150, -4400, 0),
			},
		},
	},
	-- restores some unused sniper spawns with their SOs
	[100372] = enabled,
	[100402] = enabled,
	[100392] = enabled,
	[100412] = enabled,
	[100377] = enabled,
	[100407] = enabled,
	[100397] = enabled,
	[100417] = enabled,
	-- disable turrets sequences
	[102990] = disabled,
	[102991] = disabled,
	[102992] = disabled,
	[103003] = disabled,
	-- add scripted spawns that come out of swat vans
	[102987] = { 
		on_executed = {
			{ id = 400024, delay = 10 }, 
		},
	},
	[103002] = { 
		on_executed = {
			{ id = 400016, delay = 10 },
		},
	},
	-- disable dozers
	[100018] = {
		on_executed = {
			{ id = 400004, delay = 0 },
		},
	},
	-- enable dozer depending on which swat van arrrived
	[102989] = {
		on_executed = {
			{ id = 400005, delay = 0 },
		},
	},
	[102988] = {
		on_executed = {
			{ id = 400006, delay = 0 },
		},
	},
	-- spawn the skulldozer that defends your van on Eclipse
	[101499] = {
		on_executed = {
			{ id = 400000, delay = 10 },
			{ id = 400001, delay = 10 },
		},
	},
	-- disable guaranteed reenforce in one of the server rooms, the others dont have reenforce, why this one ?
	[101835] = disabled, -- point area min police force 2
	-- fix Locke repeating the same "Play_loc_bex_108" dialogue instead of using the right one
	[103317] = {
		values = {
			dialogue = "Play_loc_bex_109",
		},
	},
	-- change amount of required bags
	[101482] = bags_required_objective,
	[102533] = bags_required_objective,
	[101498] = bags_required,
	[103954] = bags_required,
	-- Spawn group delays
	-- Frankly, with the cancerous cheat spawns gone, this might not be entirely needed.
	-- I just wasn't a huge fan of the side spawn near the mechanic shop in particular.
	-- The other 2 spawn groups were slowed down because they are stacked on top of each other, simple as that.
	[100019] = flank_spawn,
	[100128] = flank_spawn,
	[100132] = flank_spawn,
	-- cheat spawns, replaced with reenforce
	[102369] = disabled,
	[102355] = disabled,
	[102363] = disabled,
	[100007] = disabled,
	[102388] = disabled,
	[102847] = disabled,
	[100020] = disabled,
	[100198] = disabled,
	[104687] = beat_cop, -- pre-spawned policia
	[104688] = beat_cop,
	[100675] = beat_cop,
	[100676] = beat_cop,
	[104689] = guard, -- securitys
	[100670] = guard,
	[100671] = guard,
	[100672] = guard,
	[100673] = guard,
	[100674] = guard,
	[100677] = guard,
	[100678] = guard,
	[100679] = guard,
	[101570] = guard,
	[101571] = guard,
	[101574] = guard,
	[101507] = guard,
	[101508] = guard,
	[101618] = suit_guard,
	[103084] = suit_guard,
	[103087] = suit_guard,
	[101579] = suit_guard, -- suits
	[101587] = suit_guard,
	[101599] = suit_guard,
	[101625] = suit_guard,
	[103092] = suit_guard,
	[103103] = suit_guard,
}
