---@module Unit alternatives
local level_id = Eclipse.utils.clean_level_id()

local nyc_cop_heists = table.list_to_set({
	"red2",
	"run",
	"flat",
	"glace",
	"dah",
	"nmh",
	"brb",
	"spa",
})
local is_nyc_cop_heist = nyc_cop_heists[level_id]

local nyc_security_heists = table.list_to_set({
	"red2",
	"glace",
	"nmh",
})
local is_nyc_security_heist = nyc_security_heists[level_id]

local cop_1, cop_2, cop_3, cop_4
local security_1, security_2, security_3

if is_nyc_cop_heist then
	cop_1 = {
		["units/payday2/characters/ene_nyc_cop_1/ene_nyc_cop_1"] = 6,
		["units/payday2/characters/ene_nyc_cop_female_1/ene_nyc_cop_female_1"] = 2,
		["units/payday2/characters/ene_nyc_cop_fat_1/ene_nyc_cop_fat_1"] = 1,		
	}
	cop_2 = {
		["units/payday2/characters/ene_nyc_cop_2/ene_nyc_cop_2"] = 4,
		["units/payday2/characters/ene_nyc_cop_female_2/ene_nyc_cop_female_2"] = 2,
		["units/payday2/characters/ene_nyc_cop_fat_2/ene_nyc_cop_fat_2"] = 1,		
	}
	cop_3 = {
		["units/payday2/characters/ene_nyc_cop_3/ene_nyc_cop_3"] = 8,
		["units/payday2/characters/ene_nyc_cop_fat_3/ene_nyc_cop_fat_3"] = 1,		
	}
	cop_4 = {
		["units/payday2/characters/ene_nyc_cop_4/ene_nyc_cop_4"] = 6,
		["units/payday2/characters/ene_nyc_cop_fat_4/ene_nyc_cop_fat_4"] = 1,	
	}
else
	cop_1 = {
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = 6,
		["units/payday2/characters/ene_cop_female_1/ene_cop_female_1"] = 2,
		["units/payday2/characters/ene_cop_fat_1/ene_cop_fat_1"] = 1,
	}
	cop_2 = {
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = 4,
		["units/payday2/characters/ene_cop_female_2/ene_cop_female_2"] = 2,
		["units/payday2/characters/ene_cop_fat_2/ene_cop_fat_2"] = 1,	
	}
	cop_3 = {
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = 8,
		["units/payday2/characters/ene_cop_fat_3/ene_cop_fat_3"] = 1,	
	}
	cop_4 = {
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = 6,
		["units/payday2/characters/ene_cop_fat_4/ene_cop_fat_4"] = 1,
	}	
end

if is_nyc_security_heist then
	security_1 = {
		["units/payday2/characters/ene_nyc_security_1/ene_nyc_security_1"] = 4,
		["units/payday2/characters/ene_nyc_security_female_1/ene_nyc_security_female_1"] = 1,
		["units/payday2/characters/ene_nyc_security_fat_1/ene_nyc_security_fat_1"] = 1,
	}
	security_2 = {
		["units/payday2/characters/ene_nyc_security_2/ene_nyc_security_2"] = 4,
		["units/payday2/characters/ene_nyc_security_female_2/ene_nyc_security_female_2"] = 1,
		["units/payday2/characters/ene_nyc_security_fat_2/ene_nyc_security_fat_2"] = 1,
	}
	security_3 = {
		["units/payday2/characters/ene_nyc_security_3/ene_nyc_security_3"] = 2,
		["units/payday2/characters/ene_nyc_security_fat_3/ene_nyc_security_fat_3"] = 1,
	}
else
	security_1 = {
		["units/payday2/characters/ene_security_1/ene_security_1"] = 4,
		["units/payday2/characters/ene_security_female_1/ene_security_female_1"] = 1,
		["units/payday2/characters/ene_security_fat_1/ene_security_fat_1"] = 1,
	}
	security_2 = {
		["units/payday2/characters/ene_security_2/ene_security_2"] = 4,
		["units/payday2/characters/ene_security_female_2/ene_security_female_2"] = 1,
		["units/payday2/characters/ene_security_fat_2/ene_security_fat_2"] = 1,
	}
	security_3 = {
		["units/payday2/characters/ene_security_3/ene_security_3"] = 2,
		["units/payday2/characters/ene_security_fat_3/ene_security_fat_3"] = 1,
	}
end
	
local M = {
	-- Fat variant alternatives
	-- Security
	[("units/payday2/characters/ene_security_1/ene_security_1"):key()] = security_1,
	[("units/payday2/characters/ene_security_2/ene_security_2"):key()] = security_2,
	[("units/payday2/characters/ene_security_3/ene_security_3"):key()] = security_3,
	[("units/payday2/characters/ene_security_4/ene_security_4"):key()] = {
		["units/payday2/characters/ene_security_4/ene_security_4"] = 5,
		["units/payday2/characters/ene_security_female_3/ene_security_female_3"] = 2,
		["units/payday2/characters/ene_security_fat_4/ene_security_fat_4"] = 1,
	},
	[("units/payday2/characters/ene_security_5/ene_security_5"):key()] = {
		["units/payday2/characters/ene_security_5/ene_security_5"] = 5,
		["units/payday2/characters/ene_security_female_4/ene_security_female_4"] = 2,
		["units/payday2/characters/ene_security_fat_5/ene_security_fat_5"] = 1,
	},
	[("units/payday2/characters/ene_security_6/ene_security_6"):key()] = {
		["units/payday2/characters/ene_security_6/ene_security_6"] = 9,
		["units/payday2/characters/ene_security_fat_6/ene_security_fat_6"] = 1,
	},
	[("units/payday2/characters/ene_security_7/ene_security_7"):key()] = {
		["units/payday2/characters/ene_security_7/ene_security_7"] = 7,
		["units/payday2/characters/ene_security_fat_7/ene_security_fat_7"] = 1,
	},
	[("units/payday2/characters/ene_security_8/ene_security_8"):key()] = {
		["units/payday2/characters/ene_security_8/ene_security_8"] = 1,
		["units/payday2/characters/ene_security_fat_8/ene_security_fat_8"] = 2,
	},
	-- Beat Cops
	[("units/payday2/characters/ene_cop_1/ene_cop_1"):key()] = cop_1,
	[("units/payday2/characters/ene_cop_2/ene_cop_2"):key()] = cop_2,
	[("units/payday2/characters/ene_cop_3/ene_cop_3"):key()] = cop_3,
	[("units/payday2/characters/ene_cop_4/ene_cop_4"):key()] = cop_4,
	-- LAPD Beat Cops
	[("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"] = 6,
		["units/pd2_dlc_rvd/characters/ene_la_cop_female_1/ene_la_cop_female_1"] = 2,
		["units/pd2_dlc_rvd/characters/ene_la_cop_fat_1/ene_la_cop_fat_1"] = 1,
	},
	[("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"] = 4,
		["units/pd2_dlc_rvd/characters/ene_la_cop_female_2/ene_la_cop_female_2"] = 2,
		["units/pd2_dlc_rvd/characters/ene_la_cop_fat_2/ene_la_cop_fat_2"] = 1,
	},
	[("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"] = 8,
		["units/pd2_dlc_rvd/characters/ene_la_cop_fat_3/ene_la_cop_fat_3"] = 1,
	},
	[("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"):key()] = {
		["units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"] = 6,
		["units/pd2_dlc_rvd/characters/ene_la_cop_fat_4/ene_la_cop_fat_4"] = 1,
	},
	-- SFPD Beat Cops
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"] = 6,
		["units/pd2_dlc_chas/characters/ene_female_chas_police_01/ene_female_chas_police_01"] = 2,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_fat_01/ene_male_chas_police_fat_01"] = 1,
	},
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02"] = 4,
		["units/pd2_dlc_chas/characters/ene_female_chas_police_02/ene_female_chas_police_02"] = 2,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_fat_02/ene_male_chas_police_fat_02"] = 1,
	},
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03"] = 8,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_fat_03/ene_male_chas_police_fat_03"] = 1,
	},
	[("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"):key()] = {
		["units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04"] = 6,
		["units/pd2_dlc_chas/characters/ene_male_chas_police_fat_04/ene_male_chas_police_fat_04"] = 1,
	},
	-- Texas Rangers
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"] = 6,
		["units/pd2_dlc_ranc/characters/ene_female_ranc_ranger_01/ene_female_ranc_ranger_01"] = 2,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_fat_01/ene_male_ranc_ranger_fat_01"] = 1,
	},
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02/ene_male_ranc_ranger_02"] = 4,
		["units/pd2_dlc_ranc/characters/ene_female_ranc_ranger_02/ene_female_ranc_ranger_02"] = 2,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_fat_02/ene_male_ranc_ranger_fat_02"] = 1,
	},
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03"] = 4,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_fat_03/ene_male_ranc_ranger_fat_03"] = 1,
	},
	[("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"):key()] = {
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04"] = 4,
		["units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_fat_04/ene_male_ranc_ranger_fat_04"] = 1,
	},
}

return M
