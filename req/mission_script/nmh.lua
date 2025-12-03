local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local cops_so = {
	so_access_filter = so_access.law,
}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local scripted_enemy = Eclipse.scripted_enemy
local security_guard = scripted_enemy.security_1
local green_dozer = scripted_enemy.bulldozer_1
local ben_dozer = scripted_enemy.elite_bulldozer_1
local security_spawn = { enemy = security_guard }
local cloaker_respawn_amount = normal and 1 or hard and 2 or 3
local terminator_dozers_entrance_chance = (is_eclipse and 50 or 30) + (is_pro_job and 10 or 0)
local disabled = {
	values = {
		enabled = false,
	},
}
local vent_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_respawn_trigger = {
	values = {
		trigger_times = cloaker_respawn_amount,
	},
}
local terminator_dozer_1 = {
	enemy = is_eclipse and ben_dozer or green_dozer,
	spawn_action = "e_sp_kick_enter_bulldozer",
	values = {
		position = Vector3(-2378.635, 2784.454, 0),
		rotation = Rotation(88.329, 0, 0),
	},
}

local terminator_dozer_2 = {
	enemy = is_eclipse and ben_dozer or green_dozer,
	spawn_action = "e_sp_kick_enter_bulldozer",
	values = {
		position = Vector3(-2376, 2887, 0),
		rotation = Rotation(90, 0, 0),
	},
}
return {
	-- begin FFO countdown when doing blood samples objective
	[103450] = {
		ponr = {
			length = 900,
			player_mul = { 1, 1, 0.867, 0.666 }, -- 666, so scary
		},
		-- begin dozers spam
		on_executed = {
			{ id = 400063, delay = 0 },
		},
	},
	-- add sniper access to SO navlinks
	[103238] = cops_so,
	[103237] = cops_so,
	[103272] = cops_so,
	[103239] = cops_so,
	[103240] = cops_so,
	[103050] = cops_so,
	[103051] = cops_so,
	[103090] = cops_so,
	[103091] = cops_so,
	[103285] = cops_so,
	[103286] = cops_so,
	[103065] = cops_so,
	[103064] = cops_so,
	[103188] = cops_so,
	[103189] = cops_so,
	[103190] = cops_so,
	[103187] = cops_so,
	[103192] = cops_so,
	[103191] = cops_so,
	[103185] = cops_so,
	[103186] = cops_so,
	[103193] = cops_so,
	-- spawn snipers on DW when the assault ends for the first time
	[103278] = {
		on_executed = {
			{ id = 400034, delay = 15 },
		},
	},
	-- disable custom spawns when all players are in the elevator
	[102880] = {
		on_executed = {
			{ id = 400076, delay = 0 },
		},
	},
	-- disable unnecesary collision blockers in the elevator
	[102304] = {
		on_executed = {
			{ id = 400077, delay = 1 },
		},
	},
	-- open the elevator doors when you reach the top
	-- yes, they forgot to make it open for some reason
	[103586] = {
		on_executed = {
			{ id = 102876, delay = 2 },
		},
	},
	-- replace investigate beat cops with security guards to match with PDTH
	[102633] = security_spawn,
	[102632] = security_spawn,
	[102631] = security_spawn,
	[102629] = security_spawn,
	[102630] = security_spawn,
	[102625] = security_spawn,
	[102628] = security_spawn,
	[102626] = security_spawn,
	[102627] = security_spawn,
	-- disable most vanilla reinforce points
	[103706] = disabled,
	[103707] = disabled,
	[103847] = disabled,
	[102551] = { -- ALARM ALARM
		reinforce = {
			{
				name = "reception",
				force = 2,
				position = Vector3(900, 650, 0),
			},
			{
				name = "canteen",
				force = 2,
				position = Vector3(3350, 1150, 0),
			},
		},
	},
	-- Reduce this reinforce point's force from 3
	[103882] = {
		values = {
			amount = 2,
		},
	},
	-- diff 1, blow the wall
	[104057] = disabled,
	[103279] = {
		on_executed = {
			{ id = 104066, delay = 0, delay_rand = 10 },
		},
	},
	-- alert all civs on mask up and delay panic button SO
	[102518] = {
		on_executed = {
			{ id = 102540, delay = 10 },
		},
		func = function()
			for _, u_data in pairs(managers.enemy:all_civilians()) do
				u_data.unit:movement():set_cool(false)
			end
		end,
	},
	-- enable flashlights when power is cut
	[103469] = {
		flashlight = true,
	},
	[103470] = {
		flashlight = false,
	},
	-- restore ovk 145+'s elevator dozers ambush at the end of the heist
	-- keep it only on Overkill and DW
	[104122] = disabled,
	[104123] = disabled,
	[104323] = {
		values = {
			difficulty_overkill = false,
		},
	},
	-- 30/50% chance for the event to happen depending on the difficulty
	[104124] = { chance = terminator_dozers_entrance_chance },
	-- replace the shield and blackdozer with green or elite dozers depending on the difficulty
	-- also change their position and spawn anim to match their spawn arrival from PDTH
	[104113] = terminator_dozer_1,
	[104112] = terminator_dozer_2,
	-- tweak elevator cloakers respawns (up to 6 cloakers on DW)
	[104261] = cloaker_respawn_trigger,
	[104262] = cloaker_respawn_trigger,
	-- Spawn group intervals
	[103683] = vent_spawn,
	[103086] = vent_spawn,
	[103111] = vent_spawn,
	[101740] = vent_spawn,
	[102665] = vent_spawn,
	[103097] = vent_spawn,
	[103761] = vent_spawn,
	[103479] = vent_spawn,
	[103751] = vent_spawn,
	[103099] = vent_spawn,
	[103104] = vent_spawn,
	[103128] = vent_spawn,
	[103273] = vent_spawn,
	[100406] = vent_spawn,
	[103134] = vent_spawn,
	[103113] = vent_spawn,
}
