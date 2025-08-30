local level_id = Eclipse.utils.level_id()
local is_testmap = Eclipse.utils.is_testmap()
local swat_turret_whitelist = Eclipse:require("swat_turret_whitelist")

-- Get rid of stupid turrets on most heists
-- courtesy of gorg bus
if not swat_turret_whitelist[level_id] and not is_testmap then
	set_animated_vehicle_base_spawn_original = AnimatedVehicleBase.spawn_module
	function AnimatedVehicleBase:spawn_module(module_unit_name, ...)
		if type_name(module_unit_name) == "spawn_turret" then
			return set_animated_vehicle_base_spawn_original(self, module_unit_name, ...)
		end
	end
end
