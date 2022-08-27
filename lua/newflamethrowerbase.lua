Hooks:PostHook(NewFlamethrowerBase, "setup_default", "eclipse_setup_default", function(self)
    if Global.game_settings and Global.game_settings.one_down then self._bullet_slotmask = self._bullet_slotmask + 3 end
end)

local mvec_to = Vector3()

function NewFlamethrowerBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	if self._rays == 1 then
		local result = NewFlamethrowerBase.super._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)

		return result
	end

	local result = {}
	local hit_enemies = 0
	local damage = self:_get_current_damage(dmg_mul)
	local autoaim, dodge_enemies = self:check_autoaim(from_pos, direction, self._range)
	local damage_range = self._flame_max_range
	local spread_x, spread_y = self:_get_spread(user_unit)

	mvector3.set(mvec_to, direction)
	mvector3.multiply(mvec_to, damage_range)
	mvector3.add(mvec_to, from_pos)

	local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask("world_geometry"), "ignore_unit", self._setup.ignore_units)

	if col_ray then
		damage_range = math.min(damage_range, col_ray.distance)
	end

	self:_spawn_flame_effect(mvec_to, direction, true)

	local cone_spread = math.rad(spread_x) * damage_range

	mvector3.set(mvec_to, direction)
	mvector3.multiply(mvec_to, damage_range)
	mvector3.add(mvec_to, from_pos)

	local hit_bodies = World:find_bodies(user_unit, "intersect", "cone", from_pos, mvec_to, cone_spread, self._bullet_slotmask)

	for idx, body in ipairs(hit_bodies) do
		local unit = body:unit()
		local fake_ray = {
			body = body,
			unit = body:unit(),
			ray = direction,
			normal = direction,
			position = from_pos
		}

		self._bullet_class:on_collision(fake_ray, self._unit, user_unit, damage)

		if unit:character_damage() and unit:character_damage().is_head then
			hit_enemies = hit_enemies + 1
		end
	end

	if dodge_enemies and self._suppression then
		for enemy_data, dis_error in pairs(dodge_enemies) do
			enemy_data.unit:character_damage():build_suppression(suppr_mul * dis_error * self._suppression, self._panic_suppression_chance)
		end
	end

	result.hit_enemy = hit_enemies > 0 and true or false

	if self._alert_events then
		result.rays = {
			{
				position = from_pos
			}
		}
	end

	managers.statistics:shot_fired({
		hit = false,
		weapon_unit = self._unit
	})

	for i = 1, hit_enemies, 1 do
		managers.statistics:shot_fired({
			skip_bullet_count = true,
			hit = true,
			weapon_unit = self._unit
		})
	end

	return result
end
