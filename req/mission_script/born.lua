local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "spooc" },
}
return {
	[100628] = {
		values = {
			enabled = false,
		},
	},
	[100720] = {
		set_ponr_state = true,
	},
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
			{ id = 102530, delay = 360 }, --6 mins delay to trigger
		},
	},
	-- not need to have that anymore
	[101908] = {
		values = {
			enabled = false,
		},
	},
	-- and you too
	[102538] = {
		values = {
			enabled = false,
		},
	},
	-- loop the choppa
	[102530] = {
		values = {
			trigger_times = 0,
		},
		on_executed = {
			{ id = 102530, delay = 180 },
		},
	},
	-- slow down a few spawnpoints
	[100007] = {
		values = {
			interval = 20,
		},
	},
	[100130] = {
		values = {
			interval = 10,
		},
	},
	[100131] = {
		values = {
			interval = 10,
		},
	},
	[100019] = {
		values = {
			interval = 10,
		},
	},
	[100133] = {
		values = {
			interval = 10,
		},
	},
}
