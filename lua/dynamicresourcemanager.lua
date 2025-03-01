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

	local base_needed = PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"))
	load_unload_unit("units/payday2/characters/ene_acc_swat_cap/ene_acc_swat_cap", base_needed, true)
	load_unload_unit("units/payday2/characters/ene_swat_3/ene_swat_3", base_needed, false)
	load_unload_unit("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3", base_needed, false)
	load_unload_unit("units/payday2/characters/ene_acc_swat_heavy_visor/ene_acc_swat_heavy_visor", base_needed, true)
	load_unload_unit("units/payday2/characters/ene_acc_city_swat_cap/ene_acc_city_swat_cap", base_needed, true)
	load_unload_unit("units/payday2/characters/ene_sniper_3/ene_sniper_3", base_needed, false)

	local dlc1_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"))
	load_unload_unit("units/pd2_dlc1/characters/ene_acc_gensec_beret/ene_acc_gensec_beret", dlc1_needed, true)

	local gitgud_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"))
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2", gitgud_needed, false)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2", gitgud_needed, false)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4", gitgud_needed, false)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870", gitgud_needed, false)
end)
