---@module PONR unit replacements
local M = {
	normal = {},
	hard = {},
	overkill = {
		[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
		[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		[("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
	},
	overkill_145 = {
		[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
		[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		[("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
	},
	easy_wish = {
		[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = "units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36",
		[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = "units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870",
		[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"):key()] = "units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city/ene_swat_heavy_policia_federale_city",
		[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = "units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870",
	},
}

return M
