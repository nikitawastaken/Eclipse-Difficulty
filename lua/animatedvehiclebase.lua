local level_id = Eclipse.utils.level_id()
local is_testmap = Eclipse.utils.is_testmap()
local swat_turret_whitelist = Eclipse.swat_turret_whitelist

-- Get rid of stupid turrets on most heists
-- courtesy of gorg bus
set_animated_vehicle_base_spawn_original = AnimatedVehicleBase.spawn_module
function AnimatedVehicleBase:spawn_module(module_unit_name, ...)
	if not swat_turret_whitelist[level_id] and not is_testmap then
		if type_name(module_unit_name) == "spawn_turret" then
			return set_animated_vehicle_base_spawn_original(self, module_unit_name, ...)
		end
	elseif swat_turret_whitelist[level_id] then
		Eclipse:log_console("SWAT turrets are enabled for " .. level_id)
	end
end
