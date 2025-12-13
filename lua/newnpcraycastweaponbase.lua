if not Network:is_server() then
	return
end

-- Make team AI weapons alert enemies (oversight from when bots got the ability to use player weapons)
Hooks:PostHook(NewNPCRaycastWeaponBase, "set_user_is_team_ai", "sh_set_user_is_team_ai", function(self)
	if not self._setup or not alive(self._setup.user_unit) then
		return
	end

	self._setup.alert_AI = true
	self._setup.alert_filter = self._setup.user_unit:brain():SO_access()
	self._alert_events = {}
end)

-- This should not set ammo data for NPCs
function NewNPCRaycastWeaponBase:_update_stats_values(...)
	local can_shoot_through_shield = self._can_shoot_through_shield
	local can_shoot_through_enemy = self._can_shoot_through_enemy
	local can_shoot_through_wall = self._can_shoot_through_wall
	local bullet_class = self._bullet_class
	local bullet_slotmask = self._bullet_slotmask
	local blank_slotmask = self._blank_slotmask

	NewRaycastWeaponBase._update_stats_values(self, ...)

	self._can_shoot_through_shield = can_shoot_through_shield
	self._can_shoot_through_enemy = can_shoot_through_enemy
	self._can_shoot_through_wall = can_shoot_through_wall
	self._bullet_class = bullet_class
	self._bullet_slotmask = bullet_slotmask
	self._blank_slotmask = blank_slotmask
end

-- Disable player skills affecting NPC weapons
function NewNPCRaycastWeaponBase:get_add_head_shot_mul() end

function NewNPCRaycastWeaponBase:is_stagger() end

local mvec_to = Vector3()
local mvec_spread = Vector3()
local mvec1 = Vector3()

--Elite Shields cannot be penetrated
function NewNPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, shoot_through_data)
	local result = {}
	local hit_unit = nil
	local ray_distance = shoot_through_data and shoot_through_data.ray_distance or self._weapon_range or 20000

	mvector3.set(mvec_to, direction)
	mvector3.multiply(mvec_to, ray_distance)
	mvector3.add(mvec_to, from_pos)

	local damage = self._damage * (dmg_mul or 1)
	local ray_from_unit = shoot_through_data and alive(shoot_through_data.ray_from_unit) and shoot_through_data.ray_from_unit or nil
	local col_ray = (ray_from_unit or World):raycast("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)

	if shoot_through_data and shoot_through_data.has_hit_wall then
		if not col_ray then
			return result
		end

		mvector3.set(mvec1, col_ray.ray)
		mvector3.multiply(mvec1, -5)
		mvector3.add(mvec1, col_ray.position)

		local ray_blocked = World:raycast("ray", mvec1, shoot_through_data.from, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units, "report")

		if ray_blocked then
			return result
		end
	end

	local right = direction:cross(math.UP):normalized()
	local up = direction:cross(right):normalized()

	if col_ray then
		if col_ray.unit:in_slot(self._character_slotmask) then
			hit_unit = InstantBulletBase:on_collision(col_ray, self._unit, user_unit, damage, self._fires_blanks)
		elseif shoot_player and self._hit_player and self:damage_player(col_ray, from_pos, direction) then
			InstantBulletBase:on_hit_player(col_ray, self._unit, user_unit, self._damage * (dmg_mul or 1))
		else
			hit_unit = InstantBulletBase:on_collision(col_ray, self._unit, user_unit, damage, self._fires_blanks)
		end
	elseif shoot_player and self._hit_player then
		local hit, ray_data = self:damage_player(col_ray, from_pos, direction)

		if hit then
			InstantBulletBase:on_hit_player(ray_data, self._unit, user_unit, damage)
		end
	end

	if not col_ray or col_ray.distance > 600 then
		local name_id = self.non_npc_name_id and self:non_npc_name_id() or self._name_id
		local num_rays = (tweak_data.weapon[name_id] or {}).rays or 1

		for i = 1, num_rays do
			mvector3.set(mvec_spread, direction)

			if i > 1 then
				local spread_x, spread_y = self:_get_spread(user_unit)
				local theta = math.random() * 360
				local ax = math.sin(theta) * math.random() * spread_x
				local ay = math.cos(theta) * math.random() * (spread_y or spread_x)

				mvector3.add(mvec_spread, right * math.rad(ax))
				mvector3.add(mvec_spread, up * math.rad(ay))
			end

			self:_spawn_trail_effect(mvec_spread, col_ray)
		end
	end

	result.hit_enemy = hit_unit

	if self._alert_events then
		result.rays = {
			col_ray,
		}
	end

	if col_ray and col_ray.unit then
		local ap_skill = self._is_team_ai and self._has_ap_rounds

		repeat
			if hit_unit and not ap_skill then
				break
			end

			if col_ray.distance < 0.1 or ray_distance - col_ray.distance < 50 then
				break
			end

			local has_hit_wall = shoot_through_data and shoot_through_data.has_hit_wall
			local has_passed_shield = shoot_through_data and shoot_through_data.has_passed_shield
			local is_shoot_through, is_shield, is_wall = nil

			if not hit_unit then
				local is_world_geometry = col_ray.unit:in_slot(managers.slot:get_mask("world_geometry"))

				if is_world_geometry then
					is_shoot_through = not col_ray.body:has_ray_type(Idstring("ai_vision"))

					if not is_shoot_through then
						if has_hit_wall or not ap_skill then
							break
						end

						is_wall = true
					end
				else
					if not ap_skill then
						break
					end

					local parent_unit = col_ray.unit:parent()
					local parent_tweak = parent_unit and parent_unit:base() and parent_unit:base()._tweak_table
					local no_penetration = parent_tweak and tweak_data.character[parent_tweak] and tweak_data.character[parent_tweak].no_shield_penetration

					if no_penetration then
						break
					end

					is_shield = col_ray.unit:in_slot(8) and alive(parent_unit)
				end
			end

			if not hit_unit and not is_shoot_through and not is_shield and not is_wall then
				break
			end

			local ray_from_unit = (hit_unit or is_shield) and col_ray.unit
			self._shoot_through_data.has_hit_wall = has_hit_wall or is_wall
			self._shoot_through_data.has_passed_shield = has_passed_shield or is_shield
			self._shoot_through_data.ray_from_unit = ray_from_unit
			self._shoot_through_data.ray_distance = ray_distance - col_ray.distance
		
			mvector3.set(self._shoot_through_data.from, direction)
			mvector3.multiply(self._shoot_through_data.from, is_shield and 5 or 40)
			mvector3.add(self._shoot_through_data.from, col_ray.position)
			managers.game_play_central:queue_fire_raycast(
				Application:time() + 0.0125,
				self._unit,
				user_unit,
				self._shoot_through_data.from,
				mvector3.copy(direction),
				dmg_mul * (self._shoot_through_data.has_passed_shield and 0.5 or 1),
				shoot_player,
				self._shoot_through_data
			)
		until true
	end

	return result
end
