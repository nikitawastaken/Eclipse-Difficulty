-- Get rid of stupid turrets (exceptions made for henry's rock and black cat to not break things)
-- courtesy of gorg bus
local level_id = Eclipse.utils.level_id()

set_animated_vehicle_base_spawn_original = AnimatedVehicleBase.spawn_module

local turret_whitelist = {
	corp = true,
	chca = true,
	fex = true,
	des = true,
	friend = true,
}

if not turret_whitelist[level_id] then
	function AnimatedVehicleBase:spawn_module(module_unit_name, ...)
		if type_name(module_unit_name) == "spawn_turret" then
			return set_animated_vehicle_base_spawn_original(self, module_unit_name, ...)
		end
	end
end
