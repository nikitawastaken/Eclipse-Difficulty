local unit_load_dependency_packages = Eclipse:require("unit_load_dependency_packages")

Hooks:PostHook(GameSetup, "load_packages", "eclipse_load_packages", function(self)
	-- Load custom faction packages based on the level's AI group type.
	-- This should also ensure compatibility with custom heists that use non-American factions.
	local ai_group_type = tweak_data.levels:get_ai_group_type()
	local faction_package_path = "packages/custom/faction_" .. ai_group_type
	if PackageManager:package_exists(faction_package_path) and not PackageManager:loaded(faction_package_path) then
		table.insert(self._loaded_diff_packages, faction_package_path)
		PackageManager:load(faction_package_path)

		Eclipse:log_console("Loaded " .. ai_group_type .. " faction package.")
	end

	-- Load other units if any of the loaded packages contain the unit dependency.
	-- Used to, for example, load variants of security guards whose units are inside level packages without having to XML-tweak every level package that contains them.
	for unit_dependency, package in pairs(unit_load_dependency_packages) do
		local package_path = "packages/custom/" .. package

		if PackageManager:has(IDS_UNIT, Idstring(unit_dependency)) then
			if PackageManager:package_exists(package_path) and not PackageManager:loaded(package_path) then
				table.insert(self._loaded_diff_packages, package_path)
				PackageManager:load(package_path)

				Eclipse:log_console("Loaded " .. package .. " package.")
			end
		end
	end
end)
