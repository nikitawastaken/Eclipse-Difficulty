function ElectricGrenade:bullet_hit() end

function ElectricGrenade:set_thrower_unit(unit, ...)
	ElectricGrenade.super.set_thrower_unit(self, unit, ...)

	self._explosive_range_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_range_multiplier") or 1
	self._explosive_curve_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_curve_multiplier") or 1
	self._has_explosive_cluster_grenades_bonus = self._thrower_unit:base():upgrade_value("weapon", "explosive_cluster_grenades") or nil
	self._cluster_grenade_type = self._thrower_unit:base():upgrade_value("weapon", "cluster_incendiary_grenades") and "cluster_incendiary" or "cluster"

	self._range = self._range * self._explosive_range_multiplier
	self._curve_pow = self._curve_pow * self._explosive_curve_multiplier
end

function ElectricGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._detonated then
		return
	end

	self._detonated = true
	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range
	local slot_mask = managers.slot:get_mask("explosion_targets")

	managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)

	local hit_units, splinters = managers.explosion:detect_and_tase({
		player_damage = 0,
		tase_strength = "heavy",
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = self._curve_pow,
		damage = self._damage,
		ignore_unit = self._unit,
		alert_radius = self._alert_radius,
		user = self:thrower_unit() or self._unit,
		owner = self._unit,
		verify_callback = callback(self, self, "_can_tase_unit"),
	})

	if self._has_explosive_cluster_grenades_bonus and self._projectile_entry ~= "cluster" and self._projectile_entry ~= "cluster_incendiary" then
		local base_angle = math.random() * 360
		local player_peer_id = managers.network:session():peer_by_unit(self:thrower_unit()):id()
		local dont_apply_player_velocity = true

		for i = 0, 3 do
			local angle = (base_angle + i * 90)
			local speed = math.rand(0.2, 0.3)
			local dir_x = math.cos(angle) * speed
			local dir_y = math.sin(angle) * speed

			ProjectileBase.throw_projectile(self._cluster_grenade_type, pos, Vector3(dir_x, dir_y, 0.2), player_peer_id, dont_apply_player_velocity, self._damage)
		end
	end

	if self._unit:id() ~= -1 then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
	end

	self:_tase_player()
	self:_handle_hiding_and_destroying(true, nil)
end
