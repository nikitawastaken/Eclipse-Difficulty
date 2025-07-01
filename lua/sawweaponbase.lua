-- Fix hardcoded damage increase against Bulldozers and make it multiply instead of static
Hooks:OverrideFunction(SawHit, "on_collision", function(self, col_ray, weapon_unit, user_unit, damage)
	local hit_unit = col_ray.unit
	if hit_unit:base() and hit_unit:base().has_tag and hit_unit:base():has_tag("tank") then
		damage = damage * 5
	end

	local result = InstantBulletBase.on_collision(self, col_ray, weapon_unit, user_unit, damage)

	if hit_unit:damage() and col_ray.body:extension() and col_ray.body:extension().damage then
		damage = math.clamp(damage * managers.player:upgrade_value("saw", "lock_damage_multiplier", 1) * 4, 0, 200)
		col_ray.body:extension().damage:damage_lock(user_unit, col_ray.normal, col_ray.position, col_ray.direction, damage)
		if hit_unit:id() ~= -1 then
			managers.network:session():send_to_peers_synched("sync_body_damage_lock", col_ray.body, damage)
		end
	end

	return result
end)

-- Make ammo use consistent
Hooks:OverrideFunction(SawHit, "fire", function(self, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if self:get_ammo_remaining_in_clip() == 0 then
		return
	end

	local user_unit = self._setup.user_unit
	local ray_res, hit_something = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)

	if hit_something then
		self:_start_sawing_effect()

		local ammo_usage = 10
		if managers.player:has_active_temporary_property("bullet_storm") then
			ammo_usage = 0
		elseif managers.player:has_category_upgrade("saw", "consume_no_ammo_chance") then
			if math.random() < managers.player:upgrade_value("saw", "consume_no_ammo_chance", 0) then
				ammo_usage = 0
			end
		elseif ray_res.hit_enemy and managers.player:has_category_upgrade("saw", "enemy_slicer") then
			ammo_usage = managers.player:upgrade_value("saw", "enemy_slicer", 10)
		end

		ammo_usage = math.min(ammo_usage, self:get_ammo_remaining_in_clip())

		self:set_ammo_remaining_in_clip(math.max(self:get_ammo_remaining_in_clip() - ammo_usage, 0))
		self:set_ammo_total(math.max(self:get_ammo_total() - ammo_usage, 0))
		self:_check_ammo_total(user_unit)
	else
		self:_stop_sawing_effect()
	end

	if self._alert_events and ray_res.rays then
		self._alert_size = hit_something and self._hit_alert_size or self._no_hit_alert_size
		self._current_stats.alert_size = self._alert_size
		self:_check_alert(ray_res.rays, from_pos, direction, user_unit)
	end

	return ray_res
end)
