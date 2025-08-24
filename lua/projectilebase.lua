-- Friendly Fire
local mvec1 = Vector3()
local mvec2 = Vector3()
local mrot1 = Rotation()
local is_pro_job = Eclipse.utils.is_pro_job()

function ProjectileBase:update(unit, t, dt)
	if not self._simulated and not self._collided then
		self._unit:m_position(mvec1)
		mvector3.set(mvec2, self._velocity * dt)
		mvector3.add(mvec1, mvec2)
		self._unit:set_position(mvec1)

		if self._orient_to_vel then
			mrotation.set_look_at(mrot1, mvec2, math.UP)
			self._unit:set_rotation(mrot1)
		end

		self._velocity = Vector3(self._velocity.x, self._velocity.y, self._velocity.z - 980 * dt)
	end

	if self._sweep_data and not self._collided then
		self._unit:m_position(self._sweep_data.current_pos)

		local col_ray = nil
		local __ignore_units = {}

		-- Cannot shoot yourself
		if alive(self._thrower_unit) then
			table.insert(__ignore_units, self._thrower_unit)
		end

		-- Cannot shoot peers
		local _peers = _peers or managers.network:session():peers()
		for _, _peer in pairs(_peers) do
			if alive(_peer:unit()) then
				table.insert(__ignore_units, _peer:unit())
			end
		end

		if #__ignore_units > 0 then
			col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask, "ignore_unit", __ignore_units)
		else
			col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask)
		end

		if self._draw_debug_trail then
			Draw:brush(Color(1, 0, 0, 1), nil, 3):line(self._sweep_data.last_pos, self._sweep_data.current_pos)
		end

		if col_ray and col_ray.unit then
			mvector3.direction(mvec1, self._sweep_data.last_pos, self._sweep_data.current_pos)
			mvector3.add(mvec1, col_ray.position)
			self._unit:set_position(mvec1)
			self._unit:set_position(mvec1)

			if self._draw_debug_impact then
				Draw:brush(Color(0.5, 0, 0, 1), nil, 10):sphere(col_ray.position, 4)
				Draw:brush(Color(0.5, 1, 0, 0), nil, 10):sphere(self._unit:position(), 3)
			end

			col_ray.velocity = self._unit:velocity()
			self._collided = true

			self:_on_collision(col_ray)
		end

		self._unit:m_position(self._sweep_data.last_pos)
	end
end

function ProjectileBase:create_sweep_data()
	self._sweep_data = {
		slot_mask = self._slot_mask,
	}

	if is_pro_job then
		self._sweep_data.slot_mask = self._sweep_data.slot_mask + 3
	else
		self._sweep_data.slot_mask = managers.mutators:modify_value("ProjectileBase:create_sweep_data:slot_mask", self._sweep_data.slot_mask)
	end

	self._sweep_data.current_pos = self._unit:position()
	self._sweep_data.last_pos = mvector3.copy(self._sweep_data.current_pos)
end

function ProjectileBase.throw_projectile(projectile_type, pos, dir, owner_peer_id, dont_apply_player_velocity, source_grenade_damage)
	if not ProjectileBase.check_time_cheat(projectile_type, owner_peer_id) then
		return
	end

	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local unit = World:spawn_unit(unit_name, pos, Rotation(dir, math.UP))

	if owner_peer_id and managers.network:session() then
		local peer = managers.network:session():peer(owner_peer_id)
		local thrower_unit = peer and peer:unit()

		if alive(thrower_unit) then
			unit:base():set_thrower_unit(thrower_unit, true, false, source_grenade_damage)

			if not tweak_entry.throwable and thrower_unit:movement() and thrower_unit:movement():current_state() then
				unit:base():set_weapon_unit(thrower_unit:movement():current_state()._equipped_unit)
			end
		end
	end

	unit:base():throw({
		dir = dir,
		projectile_entry = projectile_type,
		dont_apply_player_velocity = dont_apply_player_velocity,
	})

	if unit:base().set_owner_peer_id then
		unit:base():set_owner_peer_id(owner_peer_id)
	end

	local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

	managers.network:session():send_to_peers_synched("sync_throw_projectile", unit:id() ~= -1 and unit or nil, pos, dir, projectile_type_index, owner_peer_id or 0)

	if tweak_data.blackmarket.projectiles[projectile_type].impact_detonation then
		unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
		unit:base():create_sweep_data()
	end

	return unit
end

function ProjectileBase:set_thrower_unit(unit, proj_ignore_thrower, thrower_ignore_proj, source_grenade_damage)
	if self._thrower_unit then
		if not unit or self._thrower_unit:key() ~= unit:key() then
			local has_destroy_listener = nil
			local listener_class = self._thrower_unit:base()

			if listener_class and listener_class.add_destroy_listener then
				has_destroy_listener = true
			else
				listener_class = self._thrower_unit:unit_data()

				if listener_class and listener_class.add_destroy_listener then
					has_destroy_listener = true
				end
			end

			if has_destroy_listener then
				listener_class:remove_destroy_listener(self._thrower_destroy_listener_key)
			end

			if self._ignore_units and table.contains(self._ignore_units, self._thrower_unit) then
				self:remove_ignore_unit(self._thrower_unit, true)

				local shield_unit = self._thrower_unit:inventory() and self._thrower_unit:inventory():shield_unit()

				if alive(shield_unit) and table.contains(self._ignore_units, shield_unit) then
					self:remove_ignore_unit(shield_unit)
				end
			end

			if self._thrower_ignore_proj then
				self._thrower_ignore_proj = nil

				self._thrower_unit:inventory():remove_ignore_unit(self._unit)
			end

			if not unit then
				return
			end
		else
			if proj_ignore_thrower then
				if not self._ignore_units or not table.contains(self._ignore_units, unit) then
					self._ignore_units = self._ignore_units or {}
					self._ignore_destroy_listener_key = self._ignore_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

					table.insert(self._ignore_units, unit)

					local shield_unit = unit:inventory() and unit:inventory():shield_unit()

					if alive(shield_unit) then
						self:add_ignore_unit(shield_unit)
					end
				end
			elseif self._ignore_units and table.contains(self._ignore_units, unit) then
				self:remove_ignore_unit(unit, true)

				local shield_unit = unit:inventory() and unit:inventory():shield_unit()

				if alive(shield_unit) and table.contains(self._ignore_units, shield_unit) then
					self:remove_ignore_unit(shield_unit)
				end
			end

			if thrower_ignore_proj then
				if not self._thrower_ignore_proj and unit:inventory() and unit:inventory().add_ignore_unit then
					self._thrower_ignore_proj = true

					unit:inventory():add_ignore_unit(self._unit)
				end
			elseif self._thrower_ignore_proj then
				self._thrower_ignore_proj = nil

				unit:inventory():remove_ignore_unit(self._unit)
			end
		end
	end

	local has_destroy_listener = nil
	local listener_class = unit:base()

	if listener_class and listener_class.add_destroy_listener then
		has_destroy_listener = true
	else
		listener_class = unit:unit_data()

		if listener_class and listener_class.add_destroy_listener then
			has_destroy_listener = true
		end
	end

	if not has_destroy_listener then
		print("[ProjectileBase:set_thrower_unit] Cannot set thrower unit as it lacks a destroy listener.", unit)

		return
	end

	self._thrower_destroy_listener_key = self._thrower_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

	listener_class:add_destroy_listener(self._thrower_destroy_listener_key, callback(self, self, "_clbk_thrower_unit_destroyed"))

	self._thrower_unit = unit

	if proj_ignore_thrower then
		self._ignore_units = self._ignore_units or {}
		self._ignore_destroy_listener_key = self._ignore_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

		table.insert(self._ignore_units, unit)

		local shield_unit = unit:inventory() and unit:inventory():shield_unit()

		if alive(shield_unit) then
			self:add_ignore_unit(shield_unit)
		end
	end

	if thrower_ignore_proj and unit:inventory() and unit:inventory().add_ignore_unit then
		self._thrower_ignore_proj = true

		unit:inventory():add_ignore_unit(self._unit)
	end

	if source_grenade_damage then
		self._source_grenade_damage = source_grenade_damage
	end
end
