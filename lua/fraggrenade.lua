function FragGrenade:bullet_hit() end

function FragGrenade:set_thrower_unit(unit, ...)
	FragGrenade.super.set_thrower_unit(self, unit, ...)

	self._explosive_team_damage_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_team_damage_multiplier") or 1
	self._explosive_range_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_range_multiplier") or 1
	self._has_explosive_no_curve_bonus = self._thrower_unit:base():upgrade_value("weapon", "explosive_no_damage_curve") or nil
	self._has_explosive_cluster_grenades_bonus = self._thrower_unit:base():upgrade_value("weapon", "explosive_cluster_grenades") or nil
	self._cluster_grenade_type = self._thrower_unit:base():upgrade_value("weapon", "cluster_incendiary_grenades") and "cluster_incendiary" or "cluster"

	self._player_damage = self._player_damage * self._explosive_team_damage_multiplier
	self._range = self._range * self._explosive_range_multiplier
	self._curve_pow = self._has_explosive_no_curve_bonus and 0 or self._curve_pow
end

function FragGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._detonated then
		return
	end

	Eclipse:log_chat(self._damage)

	self._detonated = true
	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range
	local slot_mask = managers.slot:get_mask("explosion_targets")

	managers.explosion:give_local_player_dmg(pos, range, self._player_damage)
	managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)

	local hit_units, splinters = managers.explosion:detect_and_give_dmg({
		player_damage = 0,
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = self._curve_pow,
		damage = self._damage,
		ignore_unit = self._unit,
		alert_radius = self._alert_radius,
		user = self:thrower_unit() or self._unit,
		owner = self._unit
	})

	if self._has_explosive_cluster_grenades_bonus and self._projectile_entry ~= "cluster" and self._projectile_entry ~= "cluster_incendiary" then
		local base_angle = math.random() * 360

		for i = 0, 3 do
			local angle = (base_angle + i * 90)
			local speed = math.rand(0.2, 0.3)
			local dir_x = math.cos(angle) * speed
			local dir_y = math.sin(angle) * speed

			ProjectileBase.throw_projectile(
				self._cluster_grenade_type,
				pos,
				Vector3(dir_x, dir_y, 0.2),
				managers.network:session():peer_by_unit(self:thrower_unit()):id()
			)
		end
	end

	if self._unit:id() ~= -1 then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
	end

	self:_handle_hiding_and_destroying(true, nil)
end