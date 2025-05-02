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

local old_blackmarket_manager_reload_time = BlackMarketManager.get_reload_time
function BlackMarketManager:get_reload_time(weapon_id)
	local result_empty, result_tactical = old_blackmarket_manager_reload_time(self, weapon_id)

	-- primitive error handling
	if type(result_empty) == "function" then
		return result_empty
	end

	-- Add custom reload time multipliers
	local mult = tweak_data.weapon[weapon_id].reload_speed_multiplier
	if mult then
		result_empty = result_empty / mult
		result_tactical = result_tactical / mult
	end

	return result_empty, result_tactical
end

function BlackMarketManager:damage_multiplier(name, categories, silencer, detection_risk, current_state, blueprint)
	local multiplier = 1

	if self:ignore_damage_upgrades(name, blueprint) then
		return multiplier
	end

	for _, category in ipairs(categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "damage_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:upgrade_value(name, "damage_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("player", "passive_damage_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "passive_damage_multiplier", 1)

	if silencer then
		multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "silencer_damage_multiplier", 1)
	end

	local detection_risk_damage_multiplier = managers.player:upgrade_value("player", "detection_risk_damage_multiplier")
	multiplier = multiplier - managers.player:get_value_from_risk_upgrade(detection_risk_damage_multiplier, detection_risk)

	if managers.player:has_category_upgrade("player", "overkill_health_to_damage_multiplier") then
		local damage_ratio = managers.player:upgrade_value("player", "overkill_health_to_damage_multiplier", 1) - 1
		multiplier = multiplier + damage_ratio
	end

	if current_state and not current_state:in_steelsight() then
		for _, category in ipairs(categories) do
			multiplier = multiplier + 1 - managers.player:upgrade_value(category, "hip_fire_damage_multiplier", 1)
		end
	end

	if blueprint and self:is_weapon_modified(managers.weapon_factory:get_factory_id_by_weapon_id(name), blueprint) then
		multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "modded_damage_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:get_property("trigger_happy", 1)

	multiplier = multiplier + 1 - (1 + managers.player:get_property("snp_consecutive_headshots_mul", 0))

	return self:_convert_add_to_mul(multiplier)
end
