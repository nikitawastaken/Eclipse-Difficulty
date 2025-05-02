function FireManager:detect_and_give_dmg(params)
	local hit_pos = params.hit_pos
	local slotmask = params.collision_slotmask
	local user_unit = params.user
	local dmg = params.damage
	local player_dmg = params.player_damage or dmg
	local range = params.range
	local ignore_unit = params.ignore_unit
	local curve_pow = params.curve_pow
	local col_ray = params.col_ray
	local alert_filter = params.alert_filter or managers.groupai:state():get_unit_type_filter("civilians_enemies")
	local owner = params.owner
	local push_units = false
	local dot_data = params.dot_data
	local results = {}
	local is_molotov = params.is_molotov

	if params.push_units ~= nil then
		push_units = params.push_units
	end

	local player = managers.player:player_unit()

	if alive(player) and player_dmg ~= 0 then
		player:character_damage():damage_fire({
			variant = "fire",
			position = hit_pos,
			range = range,
			damage = player_dmg,
		})
	end

	local cast_c_class = alive(ignore_unit) and ignore_unit or World
	local bodies = cast_c_class:find_bodies("intersect", "sphere", hit_pos, range, slotmask)
	local splinters = {
		mvector3.copy(hit_pos),
	}
	local dirs = {
		Vector3(range, 0, 0),
		Vector3(-range, 0, 0),
		Vector3(0, range, 0),
		Vector3(0, -range, 0),
		Vector3(0, 0, range),
		Vector3(0, 0, -range),
	}
	local pos = Vector3()

	for _, dir in ipairs(dirs) do
		mvector3.set(pos, dir)
		mvector3.add(pos, hit_pos)

		local splinter_ray = cast_c_class:raycast("ray", hit_pos, pos, "slot_mask", slotmask)
		pos = (splinter_ray and splinter_ray.position or pos) - dir:normalized() * math.min(splinter_ray and splinter_ray.distance or 0, 10)
		local near_splinter = false

		for _, s_pos in ipairs(splinters) do
			if mvector3.distance_sq(pos, s_pos) < 900 then
				near_splinter = true

				break
			end
		end

		if not near_splinter then
			table.insert(splinters, mvector3.copy(pos))
		end
	end

	local count_cops = 0
	local count_gangsters = 0
	local count_civilians = 0
	local count_cop_kills = 0
	local count_gangster_kills = 0
	local count_civilian_kills = 0
	local characters_hit = {}
	local units_to_push = {}
	local hit_units = {}
	local ignore_units = {}

	if alive(ignore_unit) then
		table.insert(ignore_units, ignore_unit)
	end

	if not params.no_raycast_check_characters then
		for _, hit_body in ipairs(bodies) do
			local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_fire

			if character then
				table.insert(ignore_units, hit_body:unit())
			end
		end
	end

	local type = nil

	for _, hit_body in ipairs(bodies) do
		local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_fire
		local apply_dmg = hit_body:extension() and hit_body:extension().damage
		units_to_push[hit_body:unit():key()] = hit_body:unit()
		local dir, len, damage, ray_hit = nil

		if character and not characters_hit[hit_body:unit():key()] then
			if params.no_raycast_check_characters then
				ray_hit = true
				characters_hit[hit_body:unit():key()] = true
			else
				for i_splinter, s_pos in ipairs(splinters) do
					ray_hit = not World:raycast("ray", s_pos, hit_body:center_of_mass(), "slot_mask", slotmask, "ignore_unit", ignore_units, "report")

					if ray_hit then
						characters_hit[hit_body:unit():key()] = true

						break
					end
				end
			end

			if ray_hit then
				local hit_unit = hit_body:unit()

				if hit_unit:base() and hit_unit:base()._tweak_table and not hit_unit:character_damage():dead() then
					type = hit_unit:base()._tweak_table

					if CopDamage.is_civilian(type) then
						count_civilians = count_civilians + 1
					elseif CopDamage.is_gangster(type) then
						count_gangsters = count_gangsters + 1
					elseif type ~= "russian" and type ~= "german" and type ~= "spanish" and type ~= "american" and type ~= "jowi" then
						if type ~= "hoxton" then
							count_cops = count_cops + 1
						end
					end
				end
			end
		elseif apply_dmg or hit_body:dynamic() then
			ray_hit = not characters_hit[hit_body:unit():key()]
		end

		if ray_hit then
			dir = hit_body:center_of_mass()
			len = mvector3.direction(dir, hit_pos, dir)
			damage = dmg

			if apply_dmg then
				self:_apply_body_damage(true, hit_body, user_unit, dir, damage)
			end

			damage = math.max(damage, 1)
			local hit_unit = hit_body:unit()
			hit_units[hit_unit:key()] = hit_unit

			if character then
				local dead_before = hit_unit:character_damage():dead()
				local col_ray = {
					unit = hit_unit,
					position = hit_body:position(),
					ray = dir,
				}
				local action_data = {
					variant = "fire",
					damage = damage,
					attacker_unit = user_unit,
					weapon_unit = owner,
					col_ray = col_ray,
					is_molotov = is_molotov,
				}
				local t = TimerManager:game():time()
				local defense_data = hit_unit:character_damage():damage_fire(action_data)
				local dead_now = hit_unit:character_damage():dead()

				if not dead_before and hit_unit:base() and hit_unit:base()._tweak_table and dead_now then
					type = hit_unit:base()._tweak_table

					if CopDamage.is_civilian(type) then
						count_civilian_kills = count_civilian_kills + 1
					elseif CopDamage.is_gangster(type) then
						count_gangster_kills = count_gangster_kills + 1
					elseif type ~= "russian" and type ~= "german" and type ~= "spanish" then
						if type ~= "american" then
							count_cop_kills = count_cop_kills + 1
						end
					end
				end

				if dot_data and not dead_now and defense_data and defense_data ~= "friendly_fire" and hit_unit:character_damage().damage_dot then
					local damage_class = CoreSerialize.string_to_classtable(dot_data.damage_class)

					if damage_class then
						damage_class:start_dot_damage(col_ray, owner, dot_data, nil, user_unit, defense_data)
					else
						Application:error("[FireManager:detect_and_give_dmg] No '" .. tostring(dot_data.damage_class) .. "' class found for dot tweak with name '" .. tostring(dot_data.name) .. "'.")
					end
				end
			end
		end
	end

	if not params.no_alert then
		local alert_radius = params.alert_radius or 3000
		local alert_unit = user_unit

		if alive(alert_unit) and alert_unit:base() and alert_unit:base().thrower_unit then
			alert_unit = alert_unit:base():thrower_unit()
		end

		managers.groupai:state():propagate_alert({
			"fire",
			hit_pos,
			alert_radius,
			alert_filter,
			alert_unit,
		})
	end

	if push_units and push_units == true then
		managers.explosion:units_to_push(units_to_push, hit_pos, range)
	end

	if owner then
		results.count_cops = count_cops
		results.count_gangsters = count_gangsters
		results.count_civilians = count_civilians
		results.count_cop_kills = count_cop_kills
		results.count_gangster_kills = count_gangster_kills
		results.count_civilian_kills = count_civilian_kills
	end

	return hit_units, splinters, results
end
