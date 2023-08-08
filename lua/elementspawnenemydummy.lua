-- Don't replace spawns on custom enemy spawner map
local level_id = Global.game_settings and Global.game_settings.level_id
if Global.editor_mode or level_id == "modders_devmap" or level_id == "Enemy_Spawner" then
	StreamHeist:log("Editor/Spawner mode is active, spawn group fixes disabled")
	return
end

-- Map to correct incorrect faction spawns
local enemy_replacements = {
	normal = {
		swat_1 = "units/payday2/characters/ene_swat_1/ene_swat_1",
		swat_2 = "units/payday2/characters/ene_swat_2/ene_swat_2",
		swat_3 = "units/payday2/characters/ene_swat_1/ene_swat_1",
		heavy_1 = "units/payday2/characters/ene_swat_1/ene_swat_1",
		heavy_2 = "units/payday2/characters/ene_swat_2/ene_swat_2",
		shield = "units/payday2/characters/ene_shield_2/ene_shield_2",
		sniper = "units/payday2/characters/ene_sniper_1/ene_sniper_1",
		dozer_1 = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
	},
	overkill = {
		swat_1 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		swat_2 = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		swat_3 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		heavy_1 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		heavy_2 = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		shield = "units/payday2/characters/ene_shield_1/ene_shield_1",
		sniper = "units/payday2/characters/ene_sniper_1/ene_sniper_1",
		dozer_1 = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
	},
	overkill_145 = {
		swat_1 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		swat_2 = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		swat_3 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		heavy_1 = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		heavy_2 = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		shield = "units/payday2/characters/ene_shield_1/ene_shield_1",
		sniper = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
		dozer_1 = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
	},
	easy_wish = {
		swat_1 = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
		swat_2 = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		swat_3 = "units/payday2/characters/ene_city_swat_3/ene_city_swat_3",
		heavy_1 = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		heavy_2 = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		shield = "units/payday2/characters/ene_shield_1/ene_shield_1",
		sniper = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
		dozer_1 = "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
	},
}
enemy_replacements.hard = enemy_replacements.normal
local enemy_mapping = {
	[Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = "dozer_1",
	[Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"):key()] = "dozer_1",
	[Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"):key()] = "dozer_1",
	[Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = "heavy_1",
	[Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = "heavy_2",
	[Idstring("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = "shield",
	[Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = "swat_3",
	[Idstring("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = "heavy_1",
	[Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = "heavy_2",
	[Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = "shield",
	[Idstring("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = "shield",
	[Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"):key()] = "sniper",
	[Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2"):key()] = "sniper",
	[Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = "heavy_1",
	[Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = "heavy_2",
	[Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = "medic_1",
	[Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = "medic_2",
	[Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"):key()] = "taser",
	[Idstring("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = "cloaker",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"):key()] = "heavy_1",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"):key()] = "shield",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"):key()] = "swat_1",
	[Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/ene_male_marshal_marksman_1"):key()] = "swat_1",
	[Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_1/ene_male_marshal_shield_1"):key()] = "shield",
}

local difficulty
if tweak_data.levels[level_id] and tweak_data.levels[level_id].group_ai_state == "skirmish" then
	difficulty = "normal"
else
	difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
end
Hooks:PostHook(ElementSpawnEnemyDummy, "init", "sh_init", function(self)
	local mapped_name = enemy_mapping[self._enemy_name:key()]
	local mapped_unit = enemy_replacements[difficulty] and enemy_replacements[difficulty][mapped_name]
	local mapped_unit_ids = mapped_unit and Idstring(mapped_unit)
	if mapped_unit_ids and mapped_unit_ids ~= self._enemy_name then
		self._enemy_name = mapped_unit_ids
	end
end)
