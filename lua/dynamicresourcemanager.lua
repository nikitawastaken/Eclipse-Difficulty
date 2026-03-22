DynamicResourceManager.unit_load_lookup = Eclipse:require("tables/dynamicresourcemanager/unit_load_lookup") 

local ids_unit = Idstring("unit")
local level_id = Eclipse.utils.level_id()
local lvl_tweak = tweak_data.levels[level_id]

Hooks:PostHook(DynamicResourceManager, "preload_units", "eclipse_preload_units", function(self)
	local function load_unload_unit(path, load, load_husk)
		local has = self:has_resource(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
		if load and not has then
			self:load(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
			
			if load_husk then
				self:load(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)		
			end
			
			Eclipse:log_console("Loaded " .. path)
		elseif not load and has then
			self:unload(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
			
			if load_husk then
				self:unload(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)	
			end
			
			Eclipse:log_console("Unloaded " .. path)
		end
	end
	
	-- Load custom packages
	if lvl_tweak and lvl_tweak.custom_package then
		for _, custom_package in pairs(lvl_tweak.custom_package) do
			local package_units = Eclipse:require(custom_package) or {}
			for _, package_unit in pairs(package_units) do
				load_unload_unit(package_unit, true)
			end
		end
	end

	-- Load individual custom units
	for _, load_list in pairs(self.unit_load_lookup) do
		local package_has_unit = PackageManager:has(ids_unit, Idstring(load_list.unit_included))
		if package_has_unit then
			for _, unit_to_load in pairs(load_list.units_to_load) do
				load_unload_unit(unit_to_load.path, package_has_unit, unit_to_load.load_husk)
			end					
		end
	end
end)
