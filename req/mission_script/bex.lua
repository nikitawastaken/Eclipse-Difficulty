local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
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
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
local van_scripted_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local bags_required = {
	values = {
		counter_target = 4 + (is_pro_job and 2 or 0),
	},
}
local bags_required_objective = {
	values = {
		amount = 4 + (is_pro_job and 2 or 0),
	},
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 57, 59 },
			{ 68, 77 },
		},
	},
	[101829] = {
		ponr = {
			length = 240,
			player_mul = { 2, 1.5, 1.25, 1 },
		},
		-- add dozers chance based event to the vault
		on_executed = {
			{ id = 400009, delay = 10 },
			{ id = 400010, delay = 10 },
		},
		-- Disable parts reinforce when drill is done
		reinforce = {
			{ name = "parts_car" },
		},
	},
	-- Increase difficulty when Hajrudin breaches the tellers
	[102308] = {
		difficulty_add = 0.2,
	},
	[100109] = { -- Police
		on_executed = { -- delay preferreds
			{ id = 100129, delay = 45 }, -- preferred
		},
	},
	[100810] = { -- start police car drive-in
		reinforce = {
			{
				name = "police_car1",
				force = 3,
				position = Vector3(2140, 485, 0),
			},
			{
				name = "police_car2",
				force = 3,
				position = Vector3(-100, 400, 0),
			},
			{
				name = "police_car3",
				force = 3,
				position = Vector3(-1900, -150, 0),
			},
			{
				name = "police_car3",
				force = 3,
				position = Vector3(-2200, -2600, 0),
			},
		},
	},
	[102311] = { -- func sequence trigger 003
		reinforce = {
			{
				name = "backdoor",
				force = 2,
				position = Vector3(1800, -2200, 0),
			},
		},
	},
	[103692] = { -- break wall
		reinforce = {
			{
				name = "breach",
				force = 2,
				position = Vector3(-1700, -5100, 0),
			},
		},
	},
	-- Reinforce inside the bank
	[100123] = { -- 1st assault done
		reinforce = {
			{
				name = "teller_balcony1",
				force = 2,
				position = Vector3(1200, -2200, 400),
			},
			{
				name = "teller_balcony2",
				force = 2,
				position = Vector3(-1200, -2200, 400),
			},
			{
				name = "bank_interior",
				force = 2,
				position = Vector3(0, -1100, 0),
			},
		},
	},
	-- Reinforce drill parts car on first break
	[103346] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(3100, -1400, 0),
			},
		},
	},
	[103347] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(1600, 2100, 0),
			},
		},
	},
	[103352] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(1800, -2000, 0),
			},
		},
	},
	[103354] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(-1700, 3300, 0),
			},
		},
	},
	[102541] = { -- link activate navlinks roof
		on_executed = {
			{ id = 101618, remove = true }, -- why does this spawn a guard ?
		},
	},
	-- begin the cloaker hunt at the start of the first assault
	[100842] = {
		values = {
			trigger_times = 1,
		},
		on_executed = {
			{ id = 400062, delay = 0 },
		},
	},
	-- don't remove enemies for no reason
	[102856] = disabled,
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
	-- enable swat vans regardless of the side where player spawned
	[102988] = enabled,
	[102989] = enabled,
	-- disable a few reinforce points
	[101834] = disabled, -- drill, Eclipse automates those
	[101835] = disabled, -- server room, only 1, for some reason
	-- add guaranteed spawns that come out of swat vans
	[102987] = {
		on_executed = {
			{ id = 400022, delay = 0, delay_rand = 5 },
		},
	},
	[103002] = {
		on_executed = {
			{ id = 400015, delay = 0, delay_rand = 5 },
		},
	},
	-- disable dozers
	[100018] = {
		on_executed = {
			{ id = 400004, delay = 0 },
		},
	},
	-- enable dozers on loud
	[100022] = {
		on_executed = {
			{ id = 400005, delay = 0 },
		},
	},
	-- spawn the skulldozer that defends your van on Eclipse
	[100210] = {
		on_executed = {
			{ id = 400000, delay = 0 },
		},
	},
	[100211] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	-- fix Locke repeating the same "Play_loc_bex_108" dialogue instead of using the right one
	[103317] = {
		values = {
			dialogue = "Play_loc_bex_109",
		},
	},
	-- Fix/disable the broken navlinks
	-- this one has the wrong position
	[102544] = {
		values = {
			position = Vector3(475, -4598, 800),
			rotation = Rotation(0, 0, 0),
		},
	},
	-- this one makes the enemies stuck when they use it
	[104726] = {
		on_executed = {
			{ id = 101490, remove = true },
		},
	},
	-- change amount of required bags
	[101482] = bags_required_objective,
	[102533] = bags_required_objective,
	[101498] = bags_required,
	[103954] = bags_required,
	-- nuke stupid cheat spawns
	[100741] = disabled,
	[102369] = disabled,
	[102382] = disabled,
	[102781] = disabled,
	-- Spawn group intervals
	-- Frankly, with the cancerous cheat spawns gone, this might not be entirely needed.
	-- I just wasn't a huge fan of the side spawn near the mechanic shop in particular.
	-- The other 2 spawn groups were slowed down because they are stacked on top of each other, simple as that.
	[100019] = side_spawn,
	[100128] = side_spawn,
	[100132] = side_spawn,
	[400042] = cloaker_spawn,
	[400043] = cloaker_spawn,
	[400044] = cloaker_spawn,
	[400045] = cloaker_spawn,
	[400046] = cloaker_spawn,
	[400047] = cloaker_spawn,
	[400048] = cloaker_spawn,
	[400049] = cloaker_spawn,
	[400050] = cloaker_spawn,
	[400051] = cloaker_spawn,
	[400017] = van_scripted_spawn,
	[400024] = van_scripted_spawn,
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
