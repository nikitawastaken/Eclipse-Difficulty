-- Dynamically load throwable if we have one
local unit_ids = Idstring("unit")
Hooks:PostHook(CopBase, "init", "sh_init", function (self)
	local throwable = self._char_tweak.throwable
	if not throwable then
		return
	end

	local tweak_entry = tweak_data.blackmarket.projectiles[throwable]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local sprint_unit_name = tweak_entry.sprint_unit and Idstring(tweak_entry.sprint_unit)

	if not PackageManager:has(unit_ids, unit_name) then
		StreamHeist:log("Loading projectile unit", throwable)
		managers.dyn_resource:load(unit_ids, unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end

	if sprint_unit_name and not PackageManager:has(unit_ids, sprint_unit_name) then
		StreamHeist:log("Loading projectile sprint unit", throwable)
		managers.dyn_resource:load(unit_ids, sprint_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)