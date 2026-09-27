local mvec_add = mvector3.add
local mvec_dir = mvector3.direction
local mvec_mul = mvector3.multiply
local mvec_set = mvector3.set
local mvec_set_z = mvector3.set_z
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local offset_vec = Vector3(0, 0, 30)

-- Remove splinter calculation (not really needed for fire) and optimize function
Hooks:OverrideFunction(FireManager, "detect_and_give_dmg", function(self, params)
	local hit_pos = params.hit_pos
	local slotmask = params.collision_slotmask
	local user_unit = params.user
	local dmg = params.damage
	local player_dmg = params.player_damage or dmg
	local range = params.range
	local damage_range = params.damage_range or range
	local alert_filter = params.alert_filter or managers.groupai:state():get_unit_type_filter("civilians_enemies")
	local owner = params.owner
	local dot_data = params.dot_data
	local alert_radius = params.alert_radius or 3000
	local is_molotov = params.is_molotov
	local obstruction_slotmask = managers.slot:get_mask("molotov_raycasts")
	local count_cops = 0
	local count_gangsters = 0
	local count_civilians = 0
	local count_cop_kills = 0
	local count_gangster_kills = 0
	local count_civilian_kills = 0
	local results = {}
	local characters_hit = {}
	local hit_units = {}
	local splinters = {
		hit_pos,
	}

	local player = managers.player:player_unit()
	if alive(player) and player_dmg ~= 0 then
		player:character_damage():damage_fire({
			variant = "fire",
			position = hit_pos,
			range = damage_range,
			damage = player_dmg,
		})
	end

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

	mvec_set(tmp_vec1, hit_pos)
	mvec_set(tmp_vec2, hit_pos)
	mvec_set_z(tmp_vec1, tmp_vec1.z - damage_range)
	mvec_set_z(tmp_vec2, tmp_vec2.z + range)
	local bodies = World:find_bodies("intersect", "cylinder", tmp_vec1, tmp_vec2, damage_range, slotmask)

	local dir, hit_pos_clamped = tmp_vec1, tmp_vec2
	local do_self_damage = not alive(user_unit) or not user_unit:base() or not user_unit:base()._tweak_table
	for _, hit_body in pairs(bodies) do
		local hit_unit = hit_body:unit()
		local hit_unit_key = hit_unit:key()
		local character = not characters_hit[hit_unit_key] and hit_unit:character_damage() and hit_unit:character_damage().damage_fire
		local apply_dmg = hit_body:extension() and hit_body:extension().damage

		if (character or apply_dmg) and (do_self_damage or hit_unit ~= user_unit) then
			local body_pos = hit_body:center_of_mass()
			mvec_add(body_pos, offset_vec)
			local len = mvec_dir(dir, body_pos, hit_pos)
			mvec_set(hit_pos_clamped, dir)
			mvec_mul(hit_pos_clamped, math.max(0, len - math.min(range, 100)))
			mvec_add(hit_pos_clamped, body_pos)
			mvec_set_z(hit_pos_clamped, hit_pos.z)

			if not World:raycast("ray", body_pos, hit_pos_clamped, "slot_mask", obstruction_slotmask, "report") then
				hit_units[hit_unit_key] = hit_unit

				if apply_dmg then
					self:_apply_body_damage(true, hit_body, user_unit, dir, dmg)
				end

				if character then
					characters_hit[hit_unit_key] = true

					if hit_unit:base() and hit_unit:base()._tweak_table and not hit_unit:character_damage():dead() then
						local tweak_id = hit_unit:base()._tweak_table
						if CopDamage.is_civilian(tweak_id) then
							count_civilians = count_civilians + 1
						elseif CopDamage.is_gangster(tweak_id) then
							count_gangsters = count_gangsters + 1
						elseif managers.enemy:is_enemy(hit_unit) then
							count_cops = count_cops + 1
						end
					end

					local dead_before = hit_unit:character_damage():dead()
					local col_ray = {
						unit = hit_unit,
						position = hit_body:position(),
						ray = dir,
					}
					local defense_data = hit_unit:character_damage():damage_fire({
						variant = "fire",
						damage = math.max(dmg, 1),
						attacker_unit = user_unit,
						weapon_unit = owner,
						col_ray = col_ray,
						is_molotov = is_molotov,
					})
					local dead_now = hit_unit:character_damage():dead()

					if not dead_before and hit_unit:base() and hit_unit:base()._tweak_table and dead_now then
						local tweak_id = hit_unit:base()._tweak_table
						if CopDamage.is_civilian(tweak_id) then
							count_civilian_kills = count_civilian_kills + 1
						elseif CopDamage.is_gangster(tweak_id) then
							count_gangster_kills = count_gangster_kills + 1
						elseif managers.enemy:is_enemy(hit_unit) then
							count_cop_kills = count_cop_kills + 1
						end
					end

					if dot_data and not dead_now and defense_data and defense_data ~= "friendly_fire" and hit_unit:character_damage().damage_dot then
						local damage_class = CoreSerialize.string_to_classtable(dot_data.damage_class)
						if damage_class then
							damage_class:start_dot_damage(col_ray, owner, dot_data, nil, user_unit, defense_data)
						end
					end
				end
			end
		end
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
end)
