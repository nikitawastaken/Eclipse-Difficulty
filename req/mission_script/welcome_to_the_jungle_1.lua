-- add female bikers to spawn roster
local bikers = {
	Idstring("units/payday2/characters/ene_biker_1/ene_biker_1"),
	Idstring("units/payday2/characters/ene_biker_2/ene_biker_2"),
	Idstring("units/payday2/characters/ene_biker_3/ene_biker_3"),
	Idstring("units/payday2/characters/ene_biker_4/ene_biker_4"),
	Idstring("units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1"),
	Idstring("units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2"),
	Idstring("units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3"),
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "spooc" },
}

return {
	-- Disable Titan cams
	[101301] = {
		values = {
			enabled = false,
		},
	},
	-- only let swats, tasers and cloakers use climbing SOs like in rats day 1
	-- e_nl_up_3_down_1m
	[100178] = exclude_cop_agents_shields_dozers,
	[100182] = exclude_cop_agents_shields_dozers,
	[100183] = exclude_cop_agents_shields_dozers,
	[100376] = exclude_cop_agents_shields_dozers,
	[102060] = exclude_cop_agents_shields_dozers,
	[103005] = exclude_cop_agents_shields_dozers,
	[100694] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_6_2_down_1m
	[103453] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_7_down_1m
	[100437] = exclude_cop_agents_shields_dozers,
	[103454] = exclude_cop_agents_shields_dozers,
	[103455] = exclude_cop_agents_shields_dozers,
	[103456] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_6_2_down_1m_var2
	[103457] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_2_2_down_1m
	[103458] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_7_down_1m_var2
	[100096] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_9_down_1m
	[100099] = exclude_cop_agents_shields_dozers,
	[100100] = exclude_cop_agents_shields_dozers,
	-- gangsters
	[101577] = { enemy = bikers },
	[101596] = { enemy = bikers },
	[101609] = { enemy = bikers },
	[101614] = { enemy = bikers },
	[101615] = { enemy = bikers },
	[101616] = { enemy = bikers },
	[101617] = { enemy = bikers },
	[101619] = { enemy = bikers },
	[101711] = { enemy = bikers },
	[101712] = { enemy = bikers },
	[101713] = { enemy = bikers },
	[101714] = { enemy = bikers },
	[101716] = { enemy = bikers },
	[100950] = { enemy = bikers }, -- camera man
	[101779] = { enemy = bikers },
	[102065] = { enemy = bikers },
	[102066] = { enemy = bikers },
	[102068] = { enemy = bikers },
	[102069] = { enemy = bikers },
	[103258] = { enemy = bikers },
	[103260] = { enemy = bikers },
	[103261] = { enemy = bikers },
	[103276] = { enemy = bikers },
	[103277] = { enemy = bikers },
	[103278] = { enemy = bikers },
	[103336] = { enemy = bikers },
	[103337] = { enemy = bikers },
	[103338] = { enemy = bikers },
	[103339] = { enemy = bikers },
}
