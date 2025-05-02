local ids_unit = Idstring("unit")
Hooks:PostHook(DynamicResourceManager, "preload_units", "eclipse_preload_units", function(self)
	local function load_unload_unit(path, load, no_husk)
		local has = self:has_resource(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
		if load and not has then
			self:load(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)

			Eclipse:log("Loaded " .. path)
			if not no_husk then
				self:load(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)

				Eclipse:log("Loaded " .. path .. "_husk")
			end
		elseif not load and has then
			self:unload(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)

			Eclipse:log("Unloaded " .. path)
			if not no_husk then
				self:unload(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)

				Eclipse:log("Unloaded " .. path .. "_husk")
			end
		end
	end

	local cop_needed = PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"))
	load_unload_unit("units/payday2/characters/ene_cop_1_fat/ene_cop_1_fat", cop_needed, false)
	load_unload_unit("units/payday2/characters/ene_cop_2_fat/ene_cop_2_fat", cop_needed, false)
	load_unload_unit("units/payday2/characters/ene_cop_3_fat/ene_cop_3_fat", cop_needed, false)
	load_unload_unit("units/payday2/characters/ene_cop_4_fat/ene_cop_4_fat", cop_needed, false)

	local security_needed = PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_security_1/ene_security_1"))
	load_unload_unit("units/payday2/characters/ene_security_1_fat/ene_security_1_fat", security_needed, false)
	load_unload_unit("units/payday2/characters/ene_security_2_fat/ene_security_2_fat", security_needed, false)
	load_unload_unit("units/payday2/characters/ene_security_3_fat/ene_security_3_fat", security_needed, false)

	local swat_needed = PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"))
	load_unload_unit("units/payday2/characters/ene_acc_swat_cap/ene_acc_swat_cap", swat_needed, true)
	load_unload_unit("units/payday2/characters/ene_swat_3/ene_swat_3", swat_needed, false)
	load_unload_unit("units/payday2/characters/ene_tazer_r870/ene_tazer_r870", swat_needed, false)
	load_unload_unit("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3", swat_needed, false)
	load_unload_unit("units/payday2/characters/ene_acc_swat_heavy_visor/ene_acc_swat_heavy_visor", swat_needed, true)
	load_unload_unit("units/payday2/characters/ene_acc_city_swat_cap/ene_acc_city_swat_cap", swat_needed, true)
	load_unload_unit("units/payday2/characters/ene_sniper_3/ene_sniper_3", swat_needed, false)

	local dlc1_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"))
	load_unload_unit("units/pd2_dlc1/characters/ene_acc_gensec_beret/ene_acc_gensec_beret", dlc1_needed, true)
	load_unload_unit("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1", dlc1_needed, false)
	load_unload_unit("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2", dlc1_needed, false)

	local headless_needed = PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"))
	load_unload_unit("units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5", headless_needed, false)

	local rvd_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"))
	load_unload_unit("units/pd2_dlc_rvd/characters/ene_la_cop_1_fat/ene_la_cop_1_fat", rvd_needed, false)
	load_unload_unit("units/pd2_dlc_rvd/characters/ene_la_cop_2_fat/ene_la_cop_2_fat", rvd_needed, false)
	load_unload_unit("units/pd2_dlc_rvd/characters/ene_la_cop_3_fat/ene_la_cop_3_fat", rvd_needed, false)
	load_unload_unit("units/pd2_dlc_rvd/characters/ene_la_cop_4_fat/ene_la_cop_4_fat", rvd_needed, false)

	local chas_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01"))
	load_unload_unit("units/pd2_dlc_chas/characters/ene_male_chas_police_03/ene_male_chas_police_03", chas_needed, false)
	load_unload_unit("units/pd2_dlc_chas/characters/ene_male_chas_police_04/ene_male_chas_police_04", chas_needed, false)
	load_unload_unit("units/pd2_dlc_chas/characters/ene_male_chas_police_01_fat/ene_male_chas_police_01_fat", chas_needed, false)
	load_unload_unit("units/pd2_dlc_chas/characters/ene_male_chas_police_02_fat/ene_male_chas_police_02_fat", chas_needed, false)
	load_unload_unit("units/pd2_dlc_chas/characters/ene_male_chas_police_03_fat/ene_male_chas_police_03_fat", chas_needed, false)
	load_unload_unit("units/pd2_dlc_chas/characters/ene_male_chas_police_04_fat/ene_male_chas_police_04_fat", chas_needed, false)

	local ranc_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01/ene_male_ranc_ranger_01"))
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_acc_ranc_ranger_hat/ene_acc_ranc_ranger_hat", ranc_needed, true)
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03/ene_male_ranc_ranger_03", ranc_needed, false)
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04/ene_male_ranc_ranger_04", ranc_needed, false)
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_01_fat/ene_male_ranc_ranger_01_fat", ranc_needed, false)
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_02_fat/ene_male_ranc_ranger_02_fat", ranc_needed, false)
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_03_fat/ene_male_ranc_ranger_03_fat", ranc_needed, false)
	load_unload_unit("units/pd2_dlc_ranc/characters/ene_male_ranc_ranger_04_fat/ene_male_ranc_ranger_04_fat", ranc_needed, false)

	local usm2_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_1/ene_male_marshal_shield_1"))
	load_unload_unit("units/pd2_dlc_usm2/characters/ene_acc_marshal_shield_helmet/ene_acc_marshal_shield_helmet", usm2_needed, true)
	load_unload_unit("units/pd2_dlc_usm2/characters/ene_acc_marshal_shield_helmet_2/ene_acc_marshal_shield_helmet_2", usm2_needed, true)
	load_unload_unit("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_hcar_1/ene_male_marshal_gunner_hcar_1", usm2_needed, false)
	load_unload_unit("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_hcar_2/ene_male_marshal_gunner_hcar_2", usm2_needed, false)
	load_unload_unit("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_sko12_1/ene_male_marshal_gunner_sko12_1", usm2_needed, false)
	load_unload_unit("units/pd2_dlc_usm2/characters/ene_male_marshal_gunner_sko12_2/ene_male_marshal_gunner_sko12_2", usm2_needed, false)

	local gitgud_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"))
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2", gitgud_needed, false)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2", gitgud_needed, false)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4", gitgud_needed, false)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870", gitgud_needed, false)
end)
