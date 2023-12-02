local init_original = RaycastWeaponBase.init
function RaycastWeaponBase:init(...)
	init_original(self, ...)

	-- Shock and Awe shotgun interaction restoration
	if table.contains(tweak_data.weapon[self._name_id].categories, "shotgun") then
		self.SHIELD_KNOCK_BACK_CHANCE = tweak_data.upgrades.values.player.shield_knock_bullet.chance / tweak_data.weapon[self._name_id].rays
	end

	-- Friendly Fire
	if Global.game_settings and Global.game_settings.one_down then
		self._bullet_slotmask = self._bullet_slotmask + 3
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end
end

-- No aim assist (shc)
Hooks:PostHook(RaycastWeaponBase, "init", "eclipse_init", function(self)
	if self._autohit_data then
		self._autohit_current = 0
		self._autohit_data.INIT_RATIO = 0
		self._autohit_data.MIN_RATIO = 0
		self._autohit_data.MAX_RATIO = 0
	end
end)

local mvec_to = Vector3()
local mvec_right_ax = Vector3()
local mvec_up_ay = Vector3()
local mvec_spread_direction = Vector3()
local mvec3_norm = mvector3.normalize
local mvec3_set = mvector3.set
local mvec3_mul = mvector3.multiply
local mvec3_add = mvector3.add
local math_clamp = math.clamp

-- lower damage on shield pen
function RaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("_fire_raycast", self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	end

	local result = {}
	local ray_distance = self:weapon_range()
	local spread_x, spread_y = self:_get_spread(user_unit)
	spread_y = spread_y or spread_x
	spread_mul = spread_mul or 1

	mvector3.cross(mvec_right_ax, direction, math.UP)
	mvec3_norm(mvec_right_ax)
	mvector3.cross(mvec_up_ay, direction, mvec_right_ax)
	mvec3_norm(mvec_up_ay)
	mvec3_set(mvec_spread_direction, direction)

	local theta = math.random() * 360

	mvec3_mul(mvec_right_ax, math.rad(math.sin(theta) * math.random() * spread_x * spread_mul))
	mvec3_mul(mvec_up_ay, math.rad(math.cos(theta) * math.random() * spread_y * spread_mul))
	mvec3_add(mvec_spread_direction, mvec_right_ax)
	mvec3_add(mvec_spread_direction, mvec_up_ay)
	mvec3_set(mvec_to, mvec_spread_direction)
	mvec3_mul(mvec_to, ray_distance)
	mvec3_add(mvec_to, from_pos)

	local ray_hits, hit_enemy, enemies_hit = self:_collect_hits(from_pos, mvec_to)

	if self._autoaim and self._autohit_data then
		local weight = 0.1

		if hit_enemy then
			self._autohit_current = (self._autohit_current + weight) / (1 + weight)
		else
			local auto_hit_candidate, enemies_to_suppress = self:check_autoaim(from_pos, direction, nil, nil, nil, true)
			result.enemies_in_cone = enemies_to_suppress or false

			if auto_hit_candidate then
				local autohit_chance = self:get_current_autohit_chance_for_roll()

				if autohit_mul then
					autohit_chance = autohit_chance * autohit_mul
				end

				if math.random() < autohit_chance then
					self._autohit_current = (self._autohit_current + weight) / (1 + weight)

					mvec3_set(mvec_spread_direction, auto_hit_candidate.ray)
					mvec3_set(mvec_to, mvec_spread_direction)
					mvec3_mul(mvec_to, ray_distance)
					mvec3_add(mvec_to, from_pos)

					ray_hits, hit_enemy, enemies_hit = self:_collect_hits(from_pos, mvec_to)
				end
			end

			if hit_enemy then
				self._autohit_current = (self._autohit_current + weight) / (1 + weight)
			elseif auto_hit_candidate then
				self._autohit_current = self._autohit_current / (1 + weight)
			end
		end
	end

	local hit_count = 0
	local hit_anyone = false
	local cop_kill_count = 0
	local hit_through_wall = false
	local hit_through_shield = false
	local is_civ_f = CopDamage.is_civilian
	local damage = self:_get_current_damage(dmg_mul)

	for _, hit in ipairs(ray_hits) do
		local dmg = self:get_damage_falloff(damage, hit, user_unit)

		-- penetrating a surface reduces the damage you deal to an enemy
		if hit.unit:in_slot(managers.slot:get_mask("world_geometry")) then
			hit_through_wall = true
			damage = damage * 0.5
		elseif hit.unit:in_slot(managers.slot:get_mask("enemy_shield_check")) then
			hit_through_shield = hit_through_shield or alive(hit.unit:parent())
			damage = damage * 0.4
		end

		if dmg > 0 then
			local hit_result = self:bullet_class():on_collision(hit, self._unit, user_unit, dmg)
			hit_through_wall = hit_through_wall or hit.unit:in_slot(self.wall_mask)
			hit_through_shield = hit_through_shield or hit.unit:in_slot(self.shield_mask) and alive(hit.unit:parent())

			if hit_result then
				hit.damage_result = hit_result
				hit_anyone = true
				hit_count = hit_count + 1

				if hit_result.type == "death" then
					local unit_base = hit.unit:base()
					local unit_type = unit_base and unit_base._tweak_table
					local is_civilian = unit_type and is_civ_f(unit_type)

					if not is_civilian then
						cop_kill_count = cop_kill_count + 1
					end

					self:_check_kill_achievements(cop_kill_count, unit_base, unit_type, is_civilian, hit_through_wall, hit_through_shield)
				end
			end
		end
	end

	self:_check_tango_achievements(cop_kill_count)

	result.hit_enemy = hit_anyone

	if self._autoaim then
		self._shot_fired_stats_table.hit = hit_anyone
		self._shot_fired_stats_table.hit_count = hit_count

		if not self._ammo_data or not self._ammo_data.ignore_statistic then
			managers.statistics:shot_fired(self._shot_fired_stats_table)
		end
	end

	local furthest_hit = ray_hits[#ray_hits]

	if (not furthest_hit or furthest_hit.distance > 600) and alive(self._obj_fire) then
		self._obj_fire:m_position(self._trail_effect_table.position)
		mvec3_set(self._trail_effect_table.normal, mvec_spread_direction)

		local trail = World:effect_manager():spawn(self._trail_effect_table)

		if furthest_hit then
			World:effect_manager():set_remaining_lifetime(trail, math_clamp((furthest_hit.distance - 600) / 10000, 0, furthest_hit.distance))
		end
	end

	if result.enemies_in_cone == nil then
		result.enemies_in_cone = self._suppression and self:check_suppression(from_pos, direction, enemies_hit) or nil
	elseif enemies_hit and self._suppression then
		result.enemies_in_cone = result.enemies_in_cone or {}
		local all_enemies = managers.enemy:all_enemies()

		for u_key, enemy in pairs(enemies_hit) do
			if all_enemies[u_key] then
				result.enemies_in_cone[u_key] = {
					error_mul = 1,
					unit = enemy,
				}
			end
		end
	end

	if self._alert_events then
		result.rays = ray_hits
	end

	return result
end

-- no elite shield pen
function RaycastWeaponBase.collect_hits(from, to, setup_data)
	setup_data = setup_data or {}
	local ray_hits = nil
	local hit_enemy = false
	local ignore_unit = setup_data.ignore_units or {}
	local enemy_mask = setup_data.enemy_mask
	local bullet_slotmask = setup_data.bullet_slotmask or managers.slot:get_mask("bullet_impact_targets")

	if setup_data.stop_on_impact then
		ray_hits = {}
		local hit = World:raycast("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)

		if hit then
			table.insert(ray_hits, hit)

			hit_enemy = hit.unit:in_slot(enemy_mask)
		end

		return ray_hits, hit_enemy, hit_enemy and {
			[hit.unit:key()] = hit.unit,
		} or nil
	end

	local can_shoot_through_wall = setup_data.can_shoot_through_wall
	local can_shoot_through_shield = setup_data.can_shoot_through_shield
	local can_shoot_through_enemy = setup_data.can_shoot_through_enemy
	local wall_mask = setup_data.wall_mask
	local shield_mask = setup_data.shield_mask
	local ai_vision_ids = Idstring("ai_vision")
	local bulletproof_ids = Idstring("bulletproof")

	if can_shoot_through_wall then
		ray_hits = World:raycast_wall("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit, "thickness", 40, "thickness_mask", wall_mask)
	else
		ray_hits = World:raycast_all("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)
	end

	local unique_hits = {}
	local enemies_hit = {}
	local unit, u_key, is_enemy = nil
	local units_hit = {}
	local in_slot_func = Unit.in_slot
	local has_ray_type_func = Body.has_ray_type

	for i, hit in ipairs(ray_hits) do
		unit = hit.unit
		u_key = unit:key()

		if not units_hit[u_key] then
			units_hit[u_key] = true
			unique_hits[#unique_hits + 1] = hit
			hit.hit_position = hit.position
			is_enemy = in_slot_func(unit, enemy_mask)

			if is_enemy then
				enemies_hit[u_key] = unit
				hit_enemy = true
			end

			if not can_shoot_through_enemy and is_enemy then
				break
			elseif not can_shoot_through_shield and in_slot_func(unit, shield_mask) then
				break
			elseif not can_shoot_through_wall and in_slot_func(unit, wall_mask) and (has_ray_type_func(hit.body, ai_vision_ids) or has_ray_type_func(hit.body, bulletproof_ids)) then
				break
			elseif hit.unit:in_slot(shield_mask) and (hit.unit:name():key() == "af254947f0288a6c" or hit.unit:name():key() == "15cbabccf0841ff8") then -- hi thanks resmod if you're reading this :)
				break
			end
		end
	end

	return unique_hits, hit_enemy, hit_enemy and enemies_hit or nil
end

-- Auto Fire Sound Fix
-- Thanks offyerrocker

_G.AutoFireSoundFixBlacklist = {
	["saw"] = true,
	["saw_secondary"] = true,
	["flamethrower_mk2"] = true,
	["m134"] = true,
	["mg42"] = true,
	["shuno"] = true,
	["system"] = true,
	["par"] = true,
}

Hooks:Register("AFSF2_OnWriteBlacklist")
Hooks:Add("BaseNetworkSessionOnLoadComplete", "AFSF2_OnLoadComplete", function()
	Hooks:Call("AFSF2_OnWriteBlacklist", AutoFireSoundFixBlacklist)
end)

--Check for if AFSF's fix code should apply to this particular weapon
function RaycastWeaponBase:_soundfix_should_play_normal()
	local name_id = self:get_name_id() or "xX69dank420blazermachineXx"
	if not self._setup.user_unit == managers.player:player_unit() then
		return true
	elseif tweak_data.weapon[name_id].use_fix ~= nil then
		return tweak_data.weapon[name_id].use_fix
	elseif AutoFireSoundFixBlacklist[name_id] then
		return true
	elseif not self:weapon_tweak_data().sounds.fire_single then
		return true
	end
	return false
end

--Prevent playing sounds except for blacklisted weapons
local orig_fire_sound = RaycastWeaponBase._fire_sound
function RaycastWeaponBase:_fire_sound(...)
	if self:_soundfix_should_play_normal() then
		return orig_fire_sound(self, ...)
	end
end

--Play sounds here instead for fix-applicable weapons; or else if blacklisted, use original function and don't play the fixed single-fire sound
--U200: there goes AFSF2's compatibility with other mods
Hooks:PreHook(RaycastWeaponBase, "fire", "autofiresoundfix2_raycastweaponbase_fire", function(self, ...)
	if not self:_soundfix_should_play_normal() then
		self._bullets_fired = 0
		self:play_tweak_data_sound(self:weapon_tweak_data().sounds.fire_single, "fire_single")
	end
end)

--stop_shooting is only used for fire sound loops, so playing individual single-fire sounds means it doesn't need to be called
local orig_stop_shooting = RaycastWeaponBase.stop_shooting
function RaycastWeaponBase:stop_shooting(...)
	if self:_soundfix_should_play_normal() then
		return orig_stop_shooting(self, ...)
	end
end
