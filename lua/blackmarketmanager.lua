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