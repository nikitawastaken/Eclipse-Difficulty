-- Disable mission waypoints if No Outlines mutator is enabled
local on_executed_original = Hooks:GetFunction(ElementWaypoint, "on_executed")
Hooks:OverrideFunction(ElementWaypoint, "on_executed", function(...)
	if managers.mutators:modify_value("ElementWaypoint:NoOutlines", false) then
		return ElementWaypoint.super.on_executed(...)
	end
	return on_executed_original(...)
end)
