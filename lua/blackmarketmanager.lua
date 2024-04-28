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
Hooks:OverrideFunction(BlackMarketManager, "equipped_melee_weapon_damage_info", function(self, lerp_value)
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

function BlackMarketManager:accuracy_addend(name, categories, spread_index, silencer, current_state, fire_mode, blueprint, is_moving, is_single_shot)
	local addend = 0

	if spread_index then
		local index = spread_index
		index = index + managers.player:upgrade_value("player", "weapon_accuracy_increase", 0)

		for _, category in ipairs(categories) do
			index = index + managers.player:upgrade_value(category, "spread_index_addend", 0)

			if current_state and current_state._moving then
				index = index + managers.player:upgrade_value(category, "move_spread_index_addend", 0)
			end
		end

		if managers.player:has_team_category_upgrade("weapon", "spread_index_addend") then
			index = index + managers.player:team_upgrade_value("weapon", "spread_index_addend", 0)
		end

		if silencer then
			index = index + managers.player:upgrade_value("weapon", "silencer_spread_index_addend", 0)

			for _, category in ipairs(categories) do
				index = index + managers.player:upgrade_value(category, "silencer_spread_index_addend", 0)
			end
		end

		if fire_mode == "single" and table.contains_any(tweak_data.upgrades.sharpshooter_categories, categories) then
			index = index + managers.player:upgrade_value("weapon", "single_spread_index_addend", 0)
		elseif fire_mode == "auto" then
			index = index + managers.player:upgrade_value("weapon", "auto_spread_index_addend", 0)
		end

		local spread_tweak = tweak_data.weapon.stats.spread
		index = math.clamp(index, 1, #spread_tweak)
		spread_index = math.clamp(spread_index, 1, #spread_tweak)

		if index ~= spread_index then
			local diff = spread_tweak[index] - spread_tweak[spread_index]
			addend = addend + diff
		end
	end

	return addend
end

function BlackMarketManager:fire_rate_multiplier(name, categories, silencer, detection_risk, current_state, blueprint)
	local multiplier = 1
	multiplier = multiplier + 1 - managers.player:upgrade_value(name, "fire_rate_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "fire_rate_multiplier", 1)

	if silencer then
		multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "silencer_fire_rate_multiplier", 1)
	end

	for _, category in ipairs(categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "fire_rate_multiplier", 1)
	end

	return self:_convert_add_to_mul(multiplier)
end
