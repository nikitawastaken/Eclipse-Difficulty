local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local scripted_enemy = Eclipse.scripted_enemy
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
local security_spawn = { enemy = scripted_enemy.security_1 }
local terminator_dozer_1 = {
	enemy = is_eclipse and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1,
	spawn_action = "e_sp_kick_enter_bulldozer",
	values = {
		position = Vector3(-2378.635, 2784.454, 0),
		rotation = Rotation(88.329, 0, 0),
	},
}

local terminator_dozer_2 = {
	enemy = is_eclipse and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1,
	spawn_action = "e_sp_kick_enter_bulldozer",
	values = {
		position = Vector3(-2376, 2887, 0),
		rotation = Rotation(90, 0, 0),
	},
}
local sniper_so = {
	so_access_filter = so_access.law,
	values = {
		interval = 1,
	},
}
local vent_navlink_interval = {
	values = {
		interval = 1,
	},
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
return {
	-- begin FFO countdown when doing blood samples objective
	[103450] = {
		ponr = {
			length = 810,
			length_balance_mul = { 1, 1, 0.867, 0.666 }, -- 666, so scary
		},
		-- begin dozers spam
		on_executed = {
			{ id = 400063, delay = 0 },
		},
	},
	-- decrease the interval of vent navlinks
	[103194] = vent_navlink_interval,
	[103195] = vent_navlink_interval,
	[103198] = vent_navlink_interval,
	[103199] = vent_navlink_interval,
	[103202] = vent_navlink_interval,
	[103203] = vent_navlink_interval,
	[103206] = vent_navlink_interval,
	[103207] = vent_navlink_interval,
	[103210] = vent_navlink_interval,
	[103211] = vent_navlink_interval,
	[103238] = vent_navlink_interval,
	[103239] = vent_navlink_interval,
	[103233] = vent_navlink_interval,
	[103235] = vent_navlink_interval,
	[103267] = vent_navlink_interval,
	[103268] = vent_navlink_interval,
	[103217] = vent_navlink_interval,
	[103218] = vent_navlink_interval,
	[103231] = vent_navlink_interval,
	[103077] = vent_navlink_interval,
	[103161] = vent_navlink_interval,
	[103162] = vent_navlink_interval,
	[103165] = vent_navlink_interval,
	[103166] = vent_navlink_interval,
	[103168] = vent_navlink_interval,
	[103170] = vent_navlink_interval,
	[103172] = vent_navlink_interval,
	[103175] = vent_navlink_interval,
	[103178] = vent_navlink_interval,
	[103179] = vent_navlink_interval,
	[103153] = vent_navlink_interval,
	[103154] = vent_navlink_interval,
	[103150] = vent_navlink_interval,
	[103151] = vent_navlink_interval,
	[103145] = vent_navlink_interval,
	[103146] = vent_navlink_interval,
	-- add sniper access to SO navlinks
	[103238] = sniper_so,
	[103239] = sniper_so,
	[103240] = sniper_so,
	[103050] = sniper_so,
	[103051] = sniper_so,
	[103090] = sniper_so,
	[103091] = sniper_so,
	[103285] = sniper_so,
	[103286] = sniper_so,
	[103065] = sniper_so,
	[103064] = sniper_so,
	[103189] = sniper_so,
	[103187] = sniper_so,
	[103185] = sniper_so,
	[103186] = sniper_so,
	-- disable most of the navlinks
	[103064] = disabled,
	[103065] = disabled,
	[103290] = disabled,
	[103291] = disabled,
	[103196] = disabled,
	[102436] = disabled,
	[103216] = disabled,
	[103215] = disabled,
	[103200] = disabled,
	[103197] = disabled,
	[103201] = disabled,
	[103204] = disabled,
	[103214] = disabled,
	[103205] = disabled,
	[103208] = disabled,
	[103213] = disabled,
	[103209] = disabled,
	[103212] = disabled,
	[103240] = disabled,
	[103237] = disabled,
	[103272] = disabled,
	[103236] = disabled,
	[103234] = disabled,
	[103266] = disabled,
	[103270] = disabled,
	[103271] = disabled,
	[103230] = disabled,
	[103193] = disabled,
	[103191] = disabled,
	[103190] = disabled,
	[103192] = disabled,
	[103188] = disabled,
	[103160] = disabled,
	[103163] = disabled,
	[103167] = disabled,
	[103164] = disabled,
	[103171] = disabled,
	[103169] = disabled,
	[103174] = disabled,
	[103173] = disabled,
	[103176] = disabled,
	[103177] = disabled,
	[103158] = disabled,
	[103152] = disabled,
	[103159] = disabled,
	[103149] = disabled,
	[103146] = disabled,
	[103157] = disabled,
	[103143] = disabled,
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
	-- enable 2 more cloaker spawns when the ICU doors is open
	[102325] = {
		on_executed = {
			{ id = 400099, delay = 0 },
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
	-- Tweak elevator cloakers respawns (up to 6 cloakers on DW)
	[104261] = cloaker_respawn_trigger,
	[104262] = cloaker_respawn_trigger,
	-- Spawn group intervals
	[400092] = cloaker_spawn,
	[400093] = cloaker_spawn,
	[400094] = cloaker_spawn,
	[400095] = cloaker_spawn,
	[400096] = cloaker_spawn,
	[400097] = cloaker_spawn,
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
