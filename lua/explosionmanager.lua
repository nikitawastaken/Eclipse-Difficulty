-- Make shields reduce explosion damage if blocked from the front
-- Also added some minor code optimization
local hit_dir = Vector3()
local shield_slot_mask = World:make_slot_mask(8)
local criminal_names = table.list_to_set(CriminalsManager.character_names())
Hooks:OverrideFunction(ExplosionManager, "_damage_characters", function(self, detect_results, params, variant, damage_func_name)
	local user_unit = params.user
	local owner = params.owner
	local damage = params.damage
	local hit_pos = params.hit_pos
	local col_ray = params.col_ray
	local range = params.range
	local curve_pow = params.curve_pow
	local verify_callback = params.verify_callback
	local ignite_character = params.ignite_character
	damage_func_name = damage_func_name or "damage_explosion"
	local counts = {
		cops = {
			kills = 0,
			hits = 0,
		},
		gangsters = {
			kills = 0,
			hits = 0,
		},
		civilians = {
			kills = 0,
			hits = 0,
		},
		criminals = {
			kills = 0,
			hits = 0,
		},
	}

	local function get_first_body_hit(bodies_hit)
		for _, hit_body in ipairs(bodies_hit or {}) do
			if alive(hit_body) then
				return hit_body
			end
		end
	end

	local hit_body, hit_body_pos, len, can_damage, tweak_table, count_table
	local do_self_damage = not alive(user_unit) or not user_unit:base() or not user_unit:base()._tweak_table
	for key, unit in pairs(detect_results.characters_hit) do
		hit_body = get_first_body_hit(detect_results.bodies_hit[key])
		hit_body_pos = hit_body and hit_body:center_of_mass() or alive(unit) and unit:position()
		len = mvector3.direction(hit_dir, hit_pos, hit_body_pos)
		can_damage = (do_self_damage or user_unit ~= unit) and (not verify_callback or verify_callback(unit))

		if alive(unit) and can_damage then
			if unit:character_damage()[damage_func_name] then
				local action_data = {
					variant = variant or "explosion",
					attacker_unit = user_unit,
					weapon_unit = owner,
					col_ray = col_ray or {
						position = hit_body_pos,
						ray = hit_dir,
					},
					ignite_character = ignite_character,
				}

				if damage > 0 then
					action_data.damage = math.max(damage * (math.clamp(1 - len / range, 0, 1) ^ curve_pow), 1)
					-- Check for a shield blocking direct los to the explosion impact and reduce damage if the explosion is in front of it
					local shield_block = World:raycast("ray", hit_pos, hit_body_pos, "slot_mask", shield_slot_mask)
					local shield_unit = shield_block and shield_block.unit
					if alive(shield_unit) and alive(shield_unit:parent()) and mvector3.dot(shield_unit:rotation():y(), hit_dir) < -0.5 then
						local char_tweak = shield_unit:base() and shield_unit:base()._tweak_table and tweak_data.character[shield_unit:base()._tweak_table]

						action_data.damage = action_data.damage * (char_tweak and char_tweak.shield_explosion_damage_mul or 1)
					end
				else
					action_data.damage = 0
				end

				unit:character_damage()[damage_func_name](unit:character_damage(), action_data)
			end
		end

		tweak_table = alive(unit) and unit:base() and unit:base()._tweak_table
		if tweak_table then
			if criminal_names[CriminalsManager.convert_new_to_old_character_workname(tweak_table)] then
				count_table = counts.criminals
			elseif CopDamage.is_civilian(tweak_table) then
				count_table = counts.civilians
			elseif CopDamage.is_gangster(tweak_table) then
				count_table = counts.gangsters
			else
				count_table = counts.cops
			end

			count_table.hits = count_table.hits + 1

			if unit:character_damage():dead() then
				count_table.kills = count_table.kills + 1
			end
		end
	end

	local results = {
		count_cops = counts.cops.hits,
		count_gangsters = counts.gangsters.hits,
		count_civilians = counts.civilians.hits,
		count_criminals = counts.criminals.hits,
		count_cop_kills = counts.cops.kills,
		count_gangster_kills = counts.gangsters.kills,
		count_civilian_kills = counts.civilians.kills,
		count_criminal_kills = counts.criminals.kills,
	}

	return results
end)
