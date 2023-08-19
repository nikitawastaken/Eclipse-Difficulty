-- Fix crash when civilians check friendly fire on destroyed units
function CivilianDamage:is_friendly_fire(unit)
	if unit == managers.player:player_unit() then
		return false
	end

	return CopDamage.is_friendly_fire(self, unit)
end