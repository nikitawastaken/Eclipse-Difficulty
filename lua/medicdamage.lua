local heal_unit_orig = MedicDamage.heal_unit
function MedicDamage:heal_unit(...)
	if self._unit:movement():chk_action_forbidden("action") then
		return false
	end

	return heal_unit_orig(self, ...)
end
