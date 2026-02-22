---@module PONR unit replacements
local M = {
	normal = {},
	hard = {},
	overkill = {
        -- America
		[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
		[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		[("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
        -- Russia
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_swat_ak47_ass/ene_akan_city_swat_ak47_ass",
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_swat_r870/ene_akan_city_swat_r870",
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_akmsu_smg/ene_akan_fbi_swat_akmsu_smg"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_swat_akmsu_smg/ene_akan_city_swat_akmsu_smg",
        -- Zombie
		[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"):key()] = "units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1",
		[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = "units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2",
		[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3"):key()] = "units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3",
        -- Murkywater
        [("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city",
		[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870",
		[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5",
        -- Federales
		[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"):key()] = "units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city",
		[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"):key()] = "units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870",
		[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5"):key()] = "units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5",
	},
	overkill_145 = {
		-- America
		[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
		[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		[("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
         -- Russia
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_swat_ak47_ass/ene_akan_city_swat_ak47_ass",
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_swat_r870/ene_akan_city_swat_r870",
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_akmsu_smg/ene_akan_fbi_swat_akmsu_smg"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_swat_akmsu_smg/ene_akan_city_swat_akmsu_smg",
        -- Zombie
		[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"):key()] = "units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1",
		[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = "units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2",
		[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3"):key()] = "units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3",
        -- Murkywater
        [("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city",
		[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870",
		[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5",
        -- Federales
		[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"):key()] = "units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city",
		[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"):key()] = "units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870",
		[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5"):key()] = "units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5",
	},
	easy_wish = {
        -- America
		[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = "units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36",
		[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = "units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870",
         -- Russia
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_heavy_g36/ene_akan_city_heavy_g36",
		[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"):key()] = "units/pd2_dlc_mad/characters/ene_akan_city_heavy_r870/ene_akan_city_heavy_r870",
        -- Zombie
		[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"):key()] = "units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_1/ene_city_heavy_hvh_1",
		[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870"):key()] = "units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_r870/ene_city_heavy_hvh_r870",
        -- Murkywater
		[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi/ene_murkywater_heavy_fbi"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_heavy_city/ene_murkywater_heavy_city",
		[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi_r870/ene_murkywater_heavy_fbi_r870"):key()] = "units/pd2_dlc_bph/characters/ene_murkywater_heavy_city_r870/ene_murkywater_heavy_city_r870",
        -- Federales
		[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"):key()] = "units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city/ene_swat_heavy_policia_federale_city",
		[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = "units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870",
	},
}

return M
