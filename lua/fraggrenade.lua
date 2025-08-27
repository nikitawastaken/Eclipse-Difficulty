function FragGrenade:bullet_hit() end

function FragGrenade:set_thrower_unit(unit, ...)
	FragGrenade.super.set_thrower_unit(self, unit, ...)

	self._explosive_team_damage_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_team_damage_multiplier") or 1
	self._explosive_range_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_range_multiplier") or 1
	self._explosive_curve_multiplier = self._thrower_unit:base():upgrade_value("weapon", "explosive_curve_multiplier") or 1
	self._has_explosive_cluster_grenades_bonus = self._thrower_unit:base():upgrade_value("weapon", "explosive_cluster_grenades") or nil
	self._cluster_grenade_type = self._thrower_unit:base():upgrade_value("weapon", "cluster_incendiary_grenades") and "cluster_incendiary" or "cluster"

	self._player_damage = self._player_damage * self._explosive_team_damage_multiplier
	self._range = self._range * self._explosive_range_multiplier
	self._curve_pow = self._curve_pow * self._explosive_curve_multiplier

	--[[
	Eclipse:log_chat(
		"_explosive_team_damage_multiplier: "
			.. self._explosive_team_damage_multiplier
			.. "\n_explosive_range_multiplier: "
			.. self._explosive_range_multiplier
			.. "\n_explosive_curve_multiplier: "
			.. self._explosive_curve_multiplier
			.. "\n_has_explosive_cluster_grenades_bonus: "
			.. tostring(self._has_explosive_cluster_grenades_bonus)
			.. "\n_cluster_grenade_type: "
			.. self._cluster_grenade_type
	)
	]]

	if self._source_grenade_damage then
		self._damage = self._source_grenade_damage * tweak_data.upgrades.cluster_grenade_damage_multiplier
	end
end

-- selene: allow(unused_variable)
function FragGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._detonated then
		return
	end

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
		owner = self._unit,
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

	self:_handle_hiding_and_destroying(true, nil)
end

ClusterGrenade = ClusterGrenade or class(FragGrenade)

function ClusterGrenade:_setup_from_tweak_data()
	local grenade_entry = self._tweak_projectile_entry or "cluster"
	local tweak_entry = tweak_data.projectiles[grenade_entry]
	self._init_timer = tweak_entry.init_timer or 2.5
	self._mass_look_up_modifier = tweak_entry.mass_look_up_modifier
	self._range = tweak_entry.range
	self._effect_name = tweak_entry.effect_name or "effects/payday2/particles/explosions/grenade_explosion"
	self._curve_pow = tweak_entry.curve_pow or 3
	self._damage = tweak_entry.damage
	self._player_damage = tweak_entry.player_damage
	self._alert_radius = tweak_entry.alert_radius
	self._idstr_decal = tweak_entry.idstr_decal
	self._idstr_effect = tweak_entry.idstr_effect
	local sound_event = tweak_entry.sound_event or "grenade_explode"
	self._custom_params = {
		camera_shake_max_mul = 2,
		sound_muffle_effect = true,
		effect = self._effect_name,
		idstr_decal = self._idstr_decal,
		idstr_effect = self._idstr_effect,
		sound_event = sound_event,
		feedback_range = self._range * 2,
	}

	return tweak_entry
end
