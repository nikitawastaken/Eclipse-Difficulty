function SawWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if self:get_ammo_remaining_in_clip() == 0 then
		return
	end

	local user_unit = self._setup.user_unit
	local ray_res, hit_something = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)

	if hit_something then
		self:_start_sawing_effect()

		local ammo_usage = self:weapon_tweak_data().saw_ammo_usage

		if ray_res.hit_enemy then
			ammo_usage = ammo_usage * 2

			if managers.player:has_category_upgrade("saw", "enemy_slicer") then
				ammo_usage = managers.player:upgrade_value("saw", "enemy_slicer", 10)
			end
		end

		if managers.player:has_category_upgrade("saw", "consume_no_ammo_chance") then
			local roll = math.rand(1)
			local chance = managers.player:upgrade_value("saw", "consume_no_ammo_chance", 0)

			if roll < chance then
				ammo_usage = 0
			end
		end

		if managers.player:has_active_temporary_property("bullet_storm") then
			ammo_usage = 0
		end

		ammo_usage = math.min(ammo_usage, self:get_ammo_remaining_in_clip())

		self:set_ammo_remaining_in_clip(math.max(self:get_ammo_remaining_in_clip() - ammo_usage, 0))
		self:set_ammo_total(math.max(self:get_ammo_total() - ammo_usage, 0))
		self:_check_ammo_total(user_unit)
	else
		self:_stop_sawing_effect()
	end

	if self._alert_events and ray_res.rays then
		if hit_something then
			self._alert_size = self._hit_alert_size
		else
			self._alert_size = self._no_hit_alert_size
		end

		self._current_stats.alert_size = self._alert_size

		self:_check_alert(ray_res.rays, from_pos, direction, user_unit)
	end

	return ray_res
end

function SawHit:on_collision(col_ray, weapon_unit, user_unit, damage)
	local hit_unit = col_ray.unit
	local is_enemy = hit_unit:character_damage() ~= nil
	local base_ext = hit_unit:base()

	local enemy_dmg_mul = 2

	if base_ext and base_ext.has_tag and base_ext:has_tag("tank") then
		enemy_dmg_mul = enemy_dmg_mul * 2

		damage = damage * enemy_dmg_mul
	elseif is_enemy then
		damage = damage * enemy_dmg_mul
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
end
