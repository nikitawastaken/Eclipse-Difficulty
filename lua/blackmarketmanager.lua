function BlackMarketManager:modify_damage_falloff(damage_falloff, custom_stats)

    if damage_falloff and custom_stats then
		for part_id, stats in pairs(custom_stats) do
			if stats.falloff_override then
				damage_falloff.optimal_distance = stats.falloff_override.optimal_distance or damage_falloff.optimal_distance
				damage_falloff.optimal_range = stats.falloff_override.optimal_range or damage_falloff.optimal_range
				damage_falloff.near_falloff = stats.falloff_override.near_falloff or damage_falloff.near_falloff
				damage_falloff.far_falloff = stats.falloff_override.far_falloff or damage_falloff.far_falloff
				damage_falloff.near_mul = stats.falloff_override.near_mul or damage_falloff.near_mul
				damage_falloff.far_mul = stats.falloff_override.far_mul or damage_falloff.far_mul
			end

			if stats.far_falloff_mul ~= nil then
				damage_falloff.far_falloff = damage_falloff.far_falloff * stats.far_falloff_mul
			end

			if stats.falloff_mul ~= nil then
				damage_falloff.optimal_distance = damage_falloff.optimal_distance * stats.falloff_mul
				damage_falloff.optimal_range = damage_falloff.optimal_range * stats.falloff_mul
				damage_falloff.near_falloff = damage_falloff.near_falloff * stats.falloff_mul
				damage_falloff.far_falloff = damage_falloff.far_falloff * stats.falloff_mul
			end

			if stats.near_damage_mul ~= nil then
				damage_falloff.near_mul = damage_falloff.near_mul * stats.near_damage_mul
			end

			if stats.far_damage_mul ~= nil then
				damage_falloff.far_mul = damage_falloff.far_mul * stats.far_damage_mul
			end

			if stats.falloff_damage_mul ~= nil then
				damage_falloff.near_mul = damage_falloff.near_mul * stats.falloff_damage_mul
				damage_falloff.far_mul = damage_falloff.far_mul * stats.falloff_damage_mul
			end

			if stats.damage_near_mul ~= nil then
				damage_falloff.optimal_range = damage_falloff.optimal_range * stats.damage_near_mul
			end

			if stats.damage_far_mul ~= nil then
				damage_falloff.far_falloff = damage_falloff.far_falloff * stats.damage_far_mul
			end

			if stats.optimal_range_mul ~= nil then
				damage_falloff.optimal_range = damage_falloff.optimal_range * stats.optimal_range_mul
			end

            -- Optimal Distance stuff
			if stats.optimal_distance_addend ~= nil then
				damage_falloff.optimal_distance = damage_falloff.optimal_distance + stats.optimal_distance_addend
			end
			if stats.near_falloff_addend ~= nil then
				damage_falloff.near_falloff = damage_falloff.near_falloff + stats.near_falloff_addend
			end
		end
	end
end


-- Uncouple melee knockdown from damage
Hooks:OverrideFunction(BlackMarketManager, "equipped_melee_weapon_damage_info", function (self, lerp_value)
	lerp_value = lerp_value or 0
	local melee_entry = self:equipped_melee_weapon()
	local stats = tweak_data.blackmarket.melee_weapons[melee_entry].stats
	local primary = self:equipped_primary()
	local bayonet_id = self:equipped_bayonet(primary.weapon_id)
	local player = managers.player:player_unit()

	local bayonet
	if bayonet_id and player:movement():current_state()._equipped_unit:base():selection_index() == 2 and melee_entry == "weapon" then
		stats = tweak_data.weapon.factory.parts[bayonet_id].stats
		bayonet = true
	end

	local dmg = math.lerp(stats.min_damage, stats.max_damage, lerp_value)
	local dmg_effect = (bayonet and dmg or 0.1) * math.lerp(stats.min_damage_effect, stats.max_damage_effect, lerp_value)

	return dmg, dmg_effect
end)