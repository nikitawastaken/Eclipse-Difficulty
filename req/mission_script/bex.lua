local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
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
		interval = 15,
	},
}
local ovk_roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
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
local reenforce_office_1 = {
	name = "office01",
	force = 2,
	position = Vector3(700, -6000, 0),
}
local reenforce_office_2 = {
	name = "office02",
	force = 2,
	position = Vector3(-700, -6000, 0),
}
local reenforce_office_3 = {
	name = "office03",
	force = 2,
	position = Vector3(1150, -4400, 0),
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
			length = 300,
			length_balance_mul = { 2, 1.5, 1.25, 1 },
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
	-- Add new reinforce
	[100109] = { -- police
		reinforce = {
			{
				name = "edge",
				force = 2,
				position = Vector3(0, 400, 0),
			},
			{
				name = "grit",
				force = 2,
				position = Vector3(1600, 300, 0),
			},
			{
				name = "rush",
				force = 2,
				position = Vector3(-1600, 300, 0),
			},
			{
				name = "mioyes",
				force = 2,
				position = Vector3(-1800, -2600, 0),
			},
		},
		on_executed = { -- preferred
			{ id = 100129, delay = 45 }, -- vanilla: 30
		},
	},
	[102311] = { -- func_sequence_trigger_003
		reinforce = {
			{
				name = "backdoor", -- lockpick door by the mechanic shop
				force = 2,
				position = Vector3(1800, -2000, 0),
			},
		},
	},
	[103692] = { -- break_wal
		reinforce = {
			{
				name = "back_turret",
				force = 2,
				position = Vector3(-1700, -5700, 0),
			},
		},
	},
	[101758] = { -- add reenforce to office rooms at start, server room point 1
		reinforce = {
			reenforce_office_1,
			reenforce_office_2,
		},
	},
	[101013] = { -- server room point 2
		reinforce = {
			reenforce_office_2,
			reenforce_office_3,
		},
	},
	[101886] = { -- server room point 3 (same room as 1)
		reinforce = {
			reenforce_office_1,
			reenforce_office_2,
		},
	},
	[101022] = { -- server room point 4
		reinforce = {
			reenforce_office_1,
			reenforce_office_3,
		},
	},
	[101801] = { -- hacking completed - server room is fair game for reenforce
		reinforce = {
			reenforce_office_1,
			reenforce_office_2,
			reenforce_office_3,
		},
	},
	-- Reinforce second floor above tellers
	[100027] = {
		reinforce = {
			{
				name = "teller_balcony01",
				force = 2,
				position = Vector3(1200, -2200, 400),
			},
			{
				name = "teller_balcony02",
				force = 2,
				position = Vector3(-1200, -2200, 400),
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
	-- disable heat speech
	[102803] = disabled,
	-- Disable vanilla reinforce points
	[101834] = disabled, -- drill, Eclipse automates those
	[101835] = disabled, -- server room, only 1, for some reason
	-- begin the cloaker hunt at the start of the first assault
	[100842] = {
		values = {
			trigger_times = 1,
		},
		on_executed = {
			{ id = 400062, delay = 0 },
		},
	},
	-- Move vanilla groups to custom preferreds
	-- Introduce them gradually throughout the heist
	[100129] = { -- preferred
		on_executed = {
			{ id = 400077, delay = 0 },
		},
	},
	-- Activate 'side spawns' after the first assault
	[100121] = { -- 1
		on_executed = {
			{ id = 400078, delay = 0 },
			{ id = 400070, delay = 0 }, -- Activate an Overkill+ 'roof group' after the second assault
			{ id = 102541, delay = 0 }, -- link_activate_navlinks_roof
		},
	},
	-- Disable broken navlinks
	[102541] = {
		on_executed = {
			{ id = 101618, remove = true }, -- why does this spawn a guard ?
			{ id = 102544, remove = true },
		},
	},
	[104726] = {
		on_executed = {
			{ id = 101490, remove = true },
		},
	},
	-- Don't remove enemies for no reason
	[102856] = disabled,
	-- Restores some unused sniper spawns with their SOs
	[100372] = enabled,
	[100402] = enabled,
	[100392] = enabled,
	[100412] = enabled,
	[100377] = enabled,
	[100407] = enabled,
	[100397] = enabled,
	[100417] = enabled,
	-- Disable turrets sequences
	[102990] = disabled,
	[102991] = disabled,
	[102992] = disabled,
	[103003] = disabled,
	-- Enable swat vans regardless of the side where player spawned
	[102988] = enabled,
	[102989] = enabled,
	-- Disable dozers
	[100018] = {
		on_executed = {
			{ id = 400004, delay = 0 },
		},
	},
	-- Enable dozers on loud
	[100022] = {
		on_executed = {
			{ id = 400005, delay = 0 },
		},
	},
	-- Spawn the skulldozer that defends your van on Death Wish
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
	-- Fix Locke repeating the same "Play_loc_bex_108" dialogue instead of using the right one
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
	-- Change amount of required bags
	[101482] = bags_required_objective,
	[102533] = bags_required_objective,
	[101498] = bags_required,
	[103954] = bags_required,
	-- Nuke stupid cheat spawns
	[100741] = disabled,
	[102369] = disabled,
	[102382] = disabled,
	[102781] = disabled,
	-- Disable a few roof navlinks
	[102557] = disabled,
	[102565] = disabled,
	[102558] = disabled,
	[102559] = disabled,
	[102561] = disabled,
	[102562] = disabled,
	[102563] = disabled,
	[102564] = disabled,
	[102535] = disabled,
	[102536] = disabled,
	[102537] = disabled,
	[102538] = disabled,
	-- Spawn group intervals
	[100019] = side_spawn,
	[100128] = side_spawn,
	[100132] = side_spawn,
	[400069] = ovk_roof_spawn,
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
	-- Scripted spawns
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
