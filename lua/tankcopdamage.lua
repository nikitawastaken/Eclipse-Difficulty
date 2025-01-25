-- Make Bulldozer armor prevent damage
TankCopDamage.IS_TANK = true

TankCopDamage.armor_body_names = {
	[Idstring("body_armor_back"):key()] = true,
	[Idstring("body_armor_chest"):key()] = true,
	[Idstring("body_armor_neck"):key()] = true,
	[Idstring("body_armor_stomache"):key()] = true,
	[Idstring("body_armor_throat"):key()] = true,
	[Idstring("body_helmet_glass"):key()] = true,
	[Idstring("body_helmet_plate"):key()] = true,
	[Idstring("body_ammo"):key()] = true,
	[Idstring("body_vest"):key()] = true
}

function TankCopDamage:damage_bullet(attack_data, ...)
	if self._dead or self._invulnerable then
		return
	end

	local plate_name = self._ids_plate_name
	local hit_body_name = attack_data.col_ray.body and attack_data.col_ray.body:name()
	if self.armor_body_names[hit_body_name:key()] then
		self._ids_plate_name = hit_body_name
	end

	local result = TankCopDamage.super.damage_bullet(self, attack_data, ...)

	if self._ids_plate_name ~= plate_name then
		self._ids_plate_name = plate_name
		if not result and attack_data.attacker_unit == managers.player:player_unit() then
			local weapon_base = alive(attack_data.weapon_unit) and attack_data.weapon_unit:base()
			local is_weak_hit = weapon_base and weapon_base.is_weak_hit
			local weak_hit = is_weak_hit and is_weak_hit(weapon_base, attack_data.col_ray and attack_data.col_ray.distance, attack_data.attacker_unit)
			managers.hud:on_hit_confirmed(weak_hit and 0.5 or 1)
		end
	end

	return result
end