local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()
local is_pro_job = Eclipse.utils.is_pro_job()
local participate = {
	values = {
		participate_to_group_ai = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = so_access.acrobatic,
}
local standard_spawn = {
	values = {
		interval = 10,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_heli_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local chopper_delay_init = 420 - (diff_i_no_easy * 30) - (is_pro_job and 120 or 0)
local chopper_delay = 240 - (diff_i_no_easy * 15) - (is_pro_job and 60 or 0)

return {
	[100720] = {
		set_ponr_state = true,
	},
	[100628] = disabled,
	-- Disable reinforce inside the garage
	[101596] = disabled,
	-- Disable forced spawns inside the garage THEY SUCK
	[101589] = disabled,
	-- only let swats, tasers, snipers and cloakers use climbing SOs
	[100089] = exclude_cop_agents_shields_dozers,
	[100091] = exclude_cop_agents_shields_dozers,
	[100092] = exclude_cop_agents_shields_dozers,
	[100101] = exclude_cop_agents_shields_dozers,
	[100108] = exclude_cop_agents_shields_dozers,
	[100110] = exclude_cop_agents_shields_dozers,
	[100242] = exclude_cop_agents_shields_dozers,
	[100257] = exclude_cop_agents_shields_dozers,
	[100267] = exclude_cop_agents_shields_dozers,
	[100269] = exclude_cop_agents_shields_dozers,
	[100270] = exclude_cop_agents_shields_dozers,
	[100272] = exclude_cop_agents_shields_dozers,
	[100273] = exclude_cop_agents_shields_dozers,
	[100275] = exclude_cop_agents_shields_dozers,
	[100278] = exclude_cop_agents_shields_dozers,
	[100279] = exclude_cop_agents_shields_dozers,
	[100292] = exclude_cop_agents_shields_dozers,
	[100293] = exclude_cop_agents_shields_dozers,
	[100481] = exclude_cop_agents_shields_dozers,
	[101389] = exclude_cop_agents_shields_dozers,
	[101612] = exclude_cop_agents_shields_dozers,
	[101613] = exclude_cop_agents_shields_dozers,
	[101649] = exclude_cop_agents_shields_dozers,
	[101812] = exclude_cop_agents_shields_dozers,
	[100880] = exclude_cop_agents_shields_dozers,
	[100888] = exclude_cop_agents_shields_dozers,
	[100915] = exclude_cop_agents_shields_dozers,
	[102815] = exclude_cop_agents_shields_dozers,
	[100937] = exclude_cop_agents_shields_dozers,
	[102244] = exclude_cop_agents_shields_dozers,
	[102563] = exclude_cop_agents_shields_dozers,
	[102564] = exclude_cop_agents_shields_dozers,
	[100606] = exclude_cop_agents_shields_dozers,
	[100607] = exclude_cop_agents_shields_dozers,
	[100900] = exclude_cop_agents_shields_dozers,
	[101291] = exclude_cop_agents_shields_dozers,
	[100093] = exclude_cop_agents_shields_dozers,
	[100094] = exclude_cop_agents_shields_dozers,
	[100095] = exclude_cop_agents_shields_dozers,
	[100096] = exclude_cop_agents_shields_dozers,
	[100097] = exclude_cop_agents_shields_dozers,
	[100981] = exclude_cop_agents_shields_dozers,
	[101041] = exclude_cop_agents_shields_dozers,
	[101043] = exclude_cop_agents_shields_dozers,
	[101057] = exclude_cop_agents_shields_dozers,
	[101076] = exclude_cop_agents_shields_dozers,
	[100831] = exclude_cop_agents_shields_dozers,
	[100837] = exclude_cop_agents_shields_dozers,
	[101115] = exclude_cop_agents_shields_dozers,
	[101142] = exclude_cop_agents_shields_dozers,
	[101159] = exclude_cop_agents_shields_dozers,
	[101174] = exclude_cop_agents_shields_dozers,
	[101839] = exclude_cop_agents_shields_dozers,
	[101840] = exclude_cop_agents_shields_dozers,
	[100493] = exclude_cop_agents_shields_dozers,
	-- loopable heli
	-- trigger in alarm rather than in the second assault
	[100022] = {
		on_executed = {
			{ id = 102530, delay = chopper_delay_init },
		},
	},
	-- not need to have that anymore
	[101908] = disabled,
	-- and you too
	[102538] = disabled,
	-- loop the choppa
	[102530] = {
		values = {
			trigger_times = 0,
		},
		on_executed = {
			{ id = 102530, delay = 120, delay_rand = chopper_delay },
		},
	},
	-- tweak chopper spawngroup
	[102515] = {
		on_executed = {
			{ id = 400001, delay = 0 },
			{ id = 102110, remove = true },
			{ id = 102299, remove = true },
			{ id = 102513, remove = true },
			{ id = 102514, remove = true },
		},
	},
	[102549] = disabled,
	[101560] = participate,
	[101814] = participate,
	[101627] = participate,
	[101672] = participate,
	-- Spawn group intervals
	[400001] = scripted_swat_heli_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100019] = standard_spawn,
	[100133] = standard_spawn,
	[100007] = roof_spawn,
	[100128] = roof_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
}
