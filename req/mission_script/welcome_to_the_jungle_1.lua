local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local so_access = Eclipse.access_filter
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

local exclude_cop_agents_shields_dozers = {
	so_access_filter = so_access.acrobatic,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	-- Disable Titan cams
	[101301] = disabled,
	-- Disable reinforce
	[103145] = disabled,
	[103146] = disabled,
	[103149] = disabled,
	[103150] = disabled,
	[103153] = disabled,
	[103154] = disabled,
	[103157] = disabled,
	-- Drop units from swat van
	[102439] = {
		on_executed = {
			{ id = 400005, delay = 0, delay_rand = 5 },
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
	[101577] = biker,
	[101596] = biker,
	[101609] = biker,
	[101614] = biker,
	[101615] = biker,
	[101616] = biker,
	[101617] = biker,
	[101619] = biker,
	[101711] = biker,
	[101712] = biker,
	[101713] = biker,
	[101714] = biker,
	[101716] = biker,
	[100950] = biker, -- camera man
	[101779] = biker,
	[102065] = biker,
	[102066] = biker,
	[102068] = biker,
	[102069] = biker,
	[103258] = biker,
	[103260] = biker,
	[103261] = biker,
	[103276] = biker,
	[103277] = biker,
	[103278] = biker,
	[103336] = biker,
	[103337] = biker,
	[103338] = biker,
	[103339] = biker,
	-- spawn group tweaks
	[400007] = scripted_swat_van_spawn,
}
