-- Make bow quick shots actually usable
function BowWeaponBase:charge_fail()
	return false
end

-- Increase minimum projectile speed
function BowWeaponBase:projectile_speed_multiplier()
	return math.lerp(0.5, 1, self:charge_multiplier())
end
