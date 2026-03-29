Hooks:PostHook(ConcussionGrenade, "_setup_from_tweak_data", "eclipse_setup_from_tweak_data", function(self)
	self._custom_params.camera_shake_max_mul = 0.75 -- reduce screenshake
end)

function ConcussionGrenade:_flash_player()
	local detonate_pos = self._unit:position() + math.UP * 100
	local range = self._PLAYER_FLASH_RANGE
	local affected, line_of_sight, travel_dis, linear_dis = QuickFlashGrenade._chk_dazzle_local_player(self, detonate_pos, range)

	if affected then
		managers.environment_controller:set_flashbang(detonate_pos, line_of_sight, travel_dis, linear_dis, 0.8, nil, true)

		local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.3, 1)

		managers.player:player_unit():character_damage():on_flashbanged(sound_eff_mul)
	end
end


function ConcussionGrenade:set_thrower_unit(unit, ...)
	ConcussionGrenade.super.set_thrower_unit(self, unit, ...)

	if self._thrower_unit:base() and self._thrower_unit:base().upgrade_value then
		self._has_launchers_allow_clusters_bonus = self._thrower_unit:base():upgrade_value("weapon", "launchers_allow_clusters") or nil
		local launcher_grenades = {
			"launcher_frag",
			"launcher_incendiary",
			"launcher_electric",
			"launcher_poison",
			"launcher_incendiary_m79",
			"launcher_electric_m79",
			"launcher_poison_m79",
			"launcher_frag_slap",
			"launcher_incendiary_slap",
			"launcher_electric_slap",
			"launcher_poison_slap",
			"launcher_m203",
			"underbarrel_m203_groza",
			"launcher_frag_m32",
			"launcher_incendiary_m32",
			"launcher_electric_m32",
			"launcher_poison_m32",
			"launcher_frag_china",
			"launcher_incendiary_china",
			"launcher_electric_china",
			"launcher_poison_china",
			"launcher_frag_arbiter",
			"launcher_incendiary_arbiter",
			"launcher_electric_arbiter",
			"launcher_poison_arbiter",
			"launcher_frag_ms3gl",
			"launcher_incendiary_ms3gl",
			"launcher_electric_ms3gl",
			"launcher_poison_ms3gl",
			"launcher_rocket",
			"rocket_ray_frag"
		}

		local cluster_allowed = not table.contains(launcher_grenades, self._tweak_projectile_entry) or self._has_launchers_allow_clusters_bonus and table.contains(launcher_grenades, self._tweak_projectile_entry)

		self._explosive_range_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_range_multiplier") or 1
		self._explosive_curve_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_curve_multiplier") or 1
		self._has_explosive_cluster_grenades_bonus = self._thrower_unit:base():upgrade_value("weapon", "explosive_cluster_grenades") and cluster_allowed or nil
		self._cluster_grenade_type = self._thrower_unit:base():upgrade_value("weapon", "cluster_incendiary_grenades") and "cluster_incendiary" or "cluster"

		self._range = self._range * self._explosive_range_multiplier
		self._curve_pow = self._curve_pow * self._explosive_curve_multiplier
	end
end

function ConcussionGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._detonated then
		return
	end

	self._detonated = true
	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range
	local slot_mask = managers.slot:get_mask("explosion_targets")

	managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)

	local hit_units, splinters = managers.explosion:detect_and_stun({
		player_damage = 0,
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = self._curve_pow,
		damage = self._damage,
		ignore_unit = self._unit,
		alert_radius = self._alert_radius,
		user = self:thrower_unit() or self._unit,
		owner = self._unit,
		verify_callback = callback(self, self, "_can_stun_unit")
	})

	if self._has_explosive_cluster_grenades_bonus then
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

	if self._unit:id() ~= -1 and managers.network:session() then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
	end

	self:_flash_player()
	self:_handle_hiding_and_destroying(true, nil)
end