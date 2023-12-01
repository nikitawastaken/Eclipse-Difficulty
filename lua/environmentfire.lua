local mrot_set_axis_angle = mrotation.set_axis_angle
local mvec_add = mvector3.add
local mvec_copy = mvector3.copy
local mvec_dir = mvector3.direction
local mvec_dis_sq = mvector3.distance_sq
local mvec_mul = mvector3.multiply
local mvec_norm = mvector3.normalize
local mvec_rot = mvector3.rotate_with
local mvec_set = mvector3.set
local mvec_set_static = mvector3.set_static
local mvec_sub = mvector3.subtract
local tmp_rot = Rotation()
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local tmp_vec4 = Vector3()
local offset_vec = Vector3(0, 0, 30)
local floor_vec = Vector3(0, 0, -500)

-- Improve the fire placement and visuals to match the damage range more accurately
-- Fire effect placement is now properly based on radius and weird fire generation on walls should be fixed
-- Added performance optimizations regarding updating effect positions, no need to check effect position every frame
function EnvironmentFire:on_spawn(data, normal, user_unit, weapon_unit, added_time, range_multiplier)
	self._unit:set_visible(false)

	local custom_params = {
		camera_shake_max_mul = 4,
		sound_muffle_effect = true,
		effect = data.effect_name,
		sound_event = data.sound_event,
		feedback_range = data.range * 2,
		sound_event_burning = data.sound_event_burning,
		sound_event_impact_duration = data.sound_event_impact_duration,
		sound_event_duration = data.burn_duration + added_time,
	}
	self._data = data
	self._normal = normal
	self._added_time = added_time
	self._range_multiplier = range_multiplier
	local dot_data = data.dot_data_name and tweak_data.dot:get_dot_data(data.dot_data_name)
	self._dot_data = dot_data and deep_clone(dot_data)
	self._user_unit = user_unit
	self._weapon_unit = weapon_unit
	self._burn_duration = data.burn_duration + added_time
	self._burn_duration_destroy = (self._dot_data and self._dot_data.dot_length or 0) + 1
	self._burn_tick_counter = 0
	self._burn_tick_period = data.burn_tick_period
	-- In vanilla this is set to the total fire size, however, it is used to check damage at every individual fire effect, which makes no sense
	self._range = 100
	self._curve_pow = data.curve_pow
	self._damage = data.damage
	self._player_damage = data.player_damage
	self._fire_alert_radius = data.fire_alert_radius
	self._is_molotov = data.is_molotov
	-- Vanilla code spawns fire effect at 2 times the actual range defined in data, so accommodate for that
	local radius = data.range * range_multiplier * 2
	self._damage_range = radius + self._range
	local effect_spacing = math.sqrt(4 * (self._range ^ 2))
	local needed_effects = math.ceil(radius / effect_spacing)
	local effect_offset = radius / needed_effects
	local slotmask = managers.slot:get_mask("molotov_raycasts")
	local from, to = tmp_vec1, tmp_vec2

	mvec_set(from, self._unit:position())

	mvec_set(to, from)
	mvec_add(to, floor_vec)

	local floor_ray = World:raycast("ray", from, to, "slot_mask", slotmask)
	if not floor_ray then
		self._burn_duration = 0
		return
	end

	self:_spawn_effect(floor_ray.position, floor_ray.normal, floor_ray.unit, floor_ray.body, custom_params)

	local tangent = tmp_vec3
	mvec_set_static(tangent, floor_ray.normal.z, floor_ray.normal.z, -floor_ray.normal.x - floor_ray.normal.y)
	if tangent.x == 0 and tangent.z == 0 then
		mvec_set_static(tangent, -floor_ray.normal.y - floor_ray.normal.z, floor_ray.normal.x, floor_ray.normal.x)
	end
	mvec_norm(tangent)

	local offset = tmp_vec4
	for i = 1, needed_effects do
		mvec_set(offset, tangent)
		mvec_mul(offset, effect_offset * i)

		local num_effects = 5 + i * 2
		local rot_step = 360 / num_effects
		mrot_set_axis_angle(tmp_rot, floor_ray.normal, rot_step)
		for j = 1, num_effects do
			mvec_rot(offset, tmp_rot)

			mvec_set(from, floor_ray.position)
			mvec_add(from, offset_vec)

			mvec_set(to, from)
			mvec_add(to, offset)

			local ray = World:raycast("ray", from, to, "slot_mask", slotmask)
			if not ray then
				mvec_set(from, to)

				mvec_set(to, from)
				mvec_add(to, floor_vec)

				ray = World:raycast("ray", from, to, "slot_mask", slotmask)
			end

			if ray then
				self:_spawn_effect(ray.position, ray.normal, ray.unit, ray.body, custom_params)
			end
		end
	end

	self._floor_ray = floor_ray
end

-- Helper function to spawn a fire patch
function EnvironmentFire:_spawn_effect(pos, normal, unit, body, custom_params)
	managers.fire:play_sound_and_effects(pos, normal, self._range, custom_params, self._molotov_damage_effect_table)

	local data = self._molotov_damage_effect_table[#self._molotov_damage_effect_table]
	data.body = alive(unit) and unit:anim_state_machine() and body
	data.body_initial_position = body and body:position()
	data.effect_initial_position = pos
	data.effect_current_position = mvec_copy(pos)
end

-- Optimize fire updating
function EnvironmentFire:update(unit, t, dt)
	if self._burn_duration <= 0 then
		if self._burn_duration_destroy <= 0 then
			self._unit:set_slot(0)
		else
			self._burn_duration_destroy = self._burn_duration_destroy - dt
			if not self._hiding then
				self._hiding = true
				for _, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
					World:effect_manager():fade_kill(damage_effect_entry.effect_id)
				end
				self._molotov_damage_effect_table = {}
			end
		end
	else
		self._burn_duration = self._burn_duration - dt
		self._burn_tick_counter = self._burn_tick_counter + dt

		for _, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
			if alive(damage_effect_entry.body) then
				local body_pos = damage_effect_entry.body:position()
				if mvec_dis_sq(body_pos, damage_effect_entry.effect_initial_position) >= 0.01 then
					mvec_sub(body_pos, damage_effect_entry.body_initial_position)

					local effect_new_location = damage_effect_entry.effect_current_position
					mvec_set(effect_new_location, damage_effect_entry.effect_initial_position)
					mvec_add(effect_new_location, body_pos)

					World:effect_manager():move(damage_effect_entry.effect_id, effect_new_location)
				end
			end
		end

		if self._burn_tick_period < self._burn_tick_counter then
			self:_do_damage()
		end
	end
end

-- Optimize this, no need to check every single fire effect, check from the initial fire origin
-- Since fire spreads equally from the center in all directions, and detect_and_give_dmg already checks for obstructions,
-- we can just use the general radius instead of checking every single fire effect individually
function EnvironmentFire:_do_damage()
	local slot_mask = managers.slot:get_mask("explosion_targets")
	local obstruction_slotmask = managers.slot:get_mask("molotov_raycasts")

	local center_pos = tmp_vec1
	mvec_set(center_pos, self._molotov_damage_effect_table[1].effect_current_position)
	mvec_add(center_pos, offset_vec)

	local player_pos = managers.player:player_unit() and managers.player:player_unit():position()
	if player_pos and mvec_dis_sq(center_pos, player_pos) <= self._damage_range ^ 2 then
		mvec_add(player_pos, offset_vec)

		local len = mvec_dir(tmp_vec2, player_pos, center_pos)
		mvec_mul(tmp_vec2, math.max(0, len - math.min(self._range, 100)))
		mvec_add(tmp_vec2, player_pos)

		if not World:raycast("ray", tmp_vec2, player_pos, "slot_mask", obstruction_slotmask) then
			managers.fire:give_local_player_dmg(center_pos, self._damage_range, self._player_damage)
		end
	end

	if Network:is_server() then
		managers.fire:detect_and_give_dmg({
			player_damage = 0,
			hit_pos = center_pos,
			range = self._range,
			damage_range = self._damage_range,
			collision_slotmask = slot_mask,
			damage = self._damage,
			user = self._user_unit,
			owner = alive(self._weapon_unit) and self._weapon_unit or self._unit,
			alert_radius = self._fire_alert_radius,
			dot_data = self._dot_data,
			is_molotov = self._is_molotov,
		})
	end

	self._burn_tick_counter = 0
end
