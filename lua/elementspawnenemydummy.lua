-- Don't replace spawns on custom enemy spawner map
local level_id =  Global.game_settings and Global.game_settings.level_id
if Global.editor_mode or level_id == "modders_devmap" or level_id == "Enemy_Spawner" then
	StreamHeist:log("Editor/Spawner mode is active, spawn group fixes disabled")
	return
end

local enemy_mapping = {
	[Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
	[Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"):key()] = "units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
	[Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"):key()] = "units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"):key()] = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"):key()] = "units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"):key()] = "units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
	[Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
	[Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
	[Idstring("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = "units/payday2/characters/ene_shield_1/ene_shield_1",
	[Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
	[Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
	[Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
	[Idstring("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
	[Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
	[Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
	[Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
	[Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
	[Idstring("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = "units/payday2/characters/ene_shield_1/ene_shield_1",
	[Idstring("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = "units/payday2/characters/ene_shield_1/ene_shield_1",
	[Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"):key()] = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
	[Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2"):key()] = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
	[Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
	[Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
	[Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
	[Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"):key()] = "units/payday2/characters/ene_shield_1/ene_shield_1",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"):key()] = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3"
}

Hooks:PostHook(ElementSpawnEnemyDummy, "init", "sh_init", function(self)
	local mapped_unit = enemy_mapping[self._enemy_name:key()]
	local mapped_unit_ids = mapped_unit and Idstring(mapped_unit)
	if mapped_unit_ids and mapped_unit_ids ~= self._enemy_name then
		self._enemy_name = mapped_unit_ids
	end
end)