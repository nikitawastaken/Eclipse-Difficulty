local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec_to = Vector3()
local mvec_spread_direction = Vector3()

local function ray_table_contains(table, unit)
	for i, hit in pairs(table) do
		if hit.unit == unit then
			return true
		end
	end

	return false
end

local function ray_copy(table, ray)
	for i, hit in pairs(table) do
		if hit.unit == ray.unit then
			hit.body = ray.body
			hit.distance = ray.distance

			mvector3.set(hit.hit_position, ray.hit_position)
			mvector3.set(hit.normal, ray.normal)
			mvector3.set(hit.position, ray.position)
			mvector3.set(hit.ray, ray.ray)
		end
	end
end

-- Elite Shields cannot be penetrated
Hooks:OverrideFunction(SawWeaponBase, "_fire_raycast", function(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	local result = {}
	local hit_unit = nil

	mvec3_add(from_pos, direction * -30)
	mvector3.set(mvec_spread_direction, direction)
	mvector3.set(mvec_to, mvec_spread_direction)
	mvector3.multiply(mvec_to, 140)
	mvector3.add(mvec_to, from_pos)

	local damage = self:_get_current_damage(dmg_mul)
	local valid_hit = false
	local col_ray = nil

	if self._saw_through_shields then
		local hits = {}
		col_ray = World:raycast_all("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units, "ray_type", "body bullet lock")

		for i, hit in ipairs(col_ray) do
			local is_shield = hit.unit:in_slot(8) and alive(hit.unit:parent())
			local parent_unit_tweak = hit.unit:parent() and hit.unit:parent():base() and hit.unit:parent():base()._tweak_table
			local no_penetration = parent_unit_tweak and tweak_data.character[parent_unit_tweak] and tweak_data.character[parent_unit_tweak].no_shield_penetration

			if is_shield and no_penetration then
				break
			end

			if not ray_table_contains(hits, hit.unit) then
				table.insert(hits, hit)
			elseif hit.unit:character_damage() and hit.unit:character_damage().is_head and hit.unit:character_damage():is_head(hit.body) then
				ray_copy(hits, hit)
			end
		end

		for i, hit in pairs(hits) do
			hit_unit = SawHit:on_collision(hit, self._unit, user_unit, damage * (is_shield and 0.5 or 1), direction)
		end

		valid_hit = #col_ray > 0
	else
		col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units, "ray_type", "body bullet lock")

		if col_ray then
			hit_unit = SawHit:on_collision(col_ray, self._unit, user_unit, damage, direction)
			valid_hit = true
		end
	end

	result.hit_enemy = hit_unit

	if self._alert_events then
		result.rays = {
			col_ray,
		}
	end

	if col_ray then
		managers.statistics:shot_fired({
			hit = true,
			weapon_unit = self._unit,
		})
	end

	return result, valid_hit
end)

-- Bring back the lock damage multiplier. It worked better with Eclipse's reduced damage values.
function SawHit:on_collision(col_ray, weapon_unit, user_unit, damage)
	local hit_unit = col_ray.unit
	local base_ext = hit_unit:base()

	if base_ext and base_ext.has_tag and base_ext:has_tag("tank") then
		damage = damage * (weapon_unit:base():weapon_tweak_data().tank_damage_multiplier or 1)
	end

	local result = InstantBulletBase.on_collision(self, col_ray, weapon_unit, user_unit, damage)

	if hit_unit:damage() and col_ray.body:extension() and col_ray.body:extension().damage then
		local lock_damage = damage
		lock_damage = damage * managers.player:upgrade_value("saw", "lock_damage_multiplier", 1) * (weapon_unit:base():weapon_tweak_data().lock_damage_multiplier or 1)
		lock_damage = math.clamp(lock_damage, 0, 200)

		col_ray.body:extension().damage:damage_lock(user_unit, col_ray.normal, col_ray.position, col_ray.direction, lock_damage)

		if hit_unit:id() ~= -1 then
			managers.network:session():send_to_peers_synched("sync_body_damage_lock", col_ray.body, lock_damage)
		end
	end

	return result
end
