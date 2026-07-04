Hooks:PostHook(ShotgunBase, "init", "eclipse_init", function(self)
	self._do_shotgun_push = false
end)

Hooks:PostHook(ShotgunBase, "setup_default", "eclipse_setup_default", function(self)
	self._damage_near = tweak_data.weapon[self._name_id].damage_near
	self._damage_far = tweak_data.weapon[self._name_id].damage_far
end)

function ShotgunBase:_update_stats_values()
	ShotgunBase.super._update_stats_values(self)
	self:setup_default()

	local extra_pellets = managers.player:upgrade_value("shotgun", "extra_pellets", 0)

	if self._ammo_data then
		if self._ammo_data.rays ~= nil then
			self._rays = self._ammo_data.rays
		end

		if self._ammo_data.rays ~= 1 then
			self._rays = self._rays + extra_pellets
		end

		if self._ammo_data.damage_near ~= nil then
			self._damage_near = self._ammo_data.damage_near
		end

		if self._ammo_data.damage_near_mul ~= nil then
			self._damage_near = self._damage_near * self._ammo_data.damage_near_mul
		end

		if self._ammo_data.damage_far ~= nil then
			self._damage_far = self._ammo_data.damage_far
		end

		if self._ammo_data.damage_far_mul ~= nil then
			self._damage_far = self._damage_far * self._ammo_data.damage_far_mul
		end

		self._range = self._damage_far
	end
end

function ShotgunBase:_fire_raycast(user_unit, from_pos, direction, _, ...)
	self._enemy_penetrations = nil
	self._wall_penetrations = nil
	self._shield_penetrations = nil

	self._hit_through_enemy = nil
	self._hit_through_wall = nil
	self._hit_through_shield = nil

	local result = {
		hit_enemy = false,
		rays = {},
	}

	for _ = 1, self._rays do
		local res = ShotgunBase.super._fire_raycast(self, user_unit, from_pos, direction, ...)
		result.hit_enemy = result.hit_enemy or res.hit_enemy
		table.list_append(result.rays, res.rays)
	end

	return result
end

function ShotgunBase:get_damage_falloff(damage, col_ray, user_unit)
	local distance = col_ray.distance or mvector3.distance(col_ray.unit:position(), user_unit:position())
	local inc_range_mul = managers.player:upgrade_value("shotgun", "effective_range_multiplier", 1) or 1

	local multiplier = 1

	self._hit_through_enemy = self._hit_through_enemy or col_ray.unit:in_slot(self.enemy_mask)
	self._hit_through_wall = self._hit_through_wall or col_ray.unit:in_slot(self.wall_mask)
	self._hit_through_shield = self._hit_through_shield or col_ray.unit:in_slot(self.shield_mask)

	if self._hit_through_enemy then
		self._enemy_penetrations = (self._enemy_penetrations or 0) + 1

		multiplier = multiplier * (self._penetration_data.enemy.damage_mul or 1) ^ math.max(0, self._enemy_penetrations - 1)
	end

	if self._hit_through_wall then
		self._wall_penetrations = (self._wall_penetrations or 0) + 1

		multiplier = multiplier * (self._penetration_data.wall.damage_mul or 1) ^ math.max(0, self._wall_penetrations - 1)
	end

	if self._hit_through_shield then
		self._shield_penetrations = (self._shield_penetrations or 0) + 1

		multiplier = multiplier * (self._penetration_data.shield.damage_mul or 1) ^ math.max(0, self._shield_penetrations - 1)
	end

	return (1 - math.min(1, math.max(0, distance - self._damage_near * inc_range_mul) / (self._damage_far * inc_range_mul))) * damage * multiplier
end
