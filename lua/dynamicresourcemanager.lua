local ids_unit = Idstring("unit")
Hooks:PostHook(DynamicResourceManager, "preload_units", "sh_preload_units", function(self)
	local function load_unit(path)
		self:load(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
		self:load(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)
	end

	Eclipse:log("Loading custom units...")

	if PackageManager:loaded("packages/sm_wish") then
		Eclipse:log("Zeal package loaded, loading custom Zeal units...")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870")
	end
end)
