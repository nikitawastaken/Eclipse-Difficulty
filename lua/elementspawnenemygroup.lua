-- Remove some dodgy code for forced group spawns, forcing spawn groups has been fixed in GroupAIStateBesiege:force_spawn_group
Hooks:OverrideFunction(ElementSpawnEnemyGroup, "on_executed", function(self, instigator)
	if not self._values.enabled then
		return
	end

	self:_check_spawn_points()

	if #self._spawn_points > 0 then
		local spawn_type = self._group_data.spawn_type
		if spawn_type == "group" or spawn_type == "group_guaranteed" then
			local spawn_group_data = managers.groupai:state():create_spawn_group(self._id, self, self._spawn_points)
			managers.groupai:state():force_spawn_group(spawn_group_data, self._values.preferred_spawn_groups, spawn_type == "group_guaranteed")
		else
			for i = 1, self:get_random_table_value(self._group_data.amount) do
				local element = self._spawn_points[self:_get_spawn_point(i)]
				element:produce({
					team = self._values.team,
				})
			end
		end
	end

	ElementSpawnEnemyGroup.super.on_executed(self, instigator)
end)

-- Update preferred spawn groups to contain new groups and add intervals to groups with special spawn actions
ElementSpawnEnemyGroup.group_mapping = {
	tac_swat_rifle = {
		"cs_reenforce_init",
		"cs_reenforce_light",
		"cs_reenforce_heavy",
		"cs_recon_init",
		"cs_recon_light",
		"cs_recon_heavy",
		"cs_assault_init",
		"cs_assault_light",
		"cs_assault_heavy",
		"fbi_reenforce_init",
		"fbi_reenforce_light",
		"fbi_reenforce_heavy",
		"fbi_recon_init",
		"fbi_recon_light",
		"fbi_recon_heavy",
		"fbi_assault_light",
		"fbi_assault_heavy",
		"elite_assault_marksman",
		"elite_reenforce_light",
		"elite_reenforce_heavy",
		"elite_assault_light",
		"elite_assault_heavy",
	},
	tac_shield_wall = {
		"cs_assault_shield",
		"fbi_assault_shield",
		"elite_assault_shield",
	},
	tac_tazer_flanking = {
		"cs_assault_taser",
		"fbi_assault_taser",
		"elite_assault_taser",
	},
	FBI_spoocs = {
		"fbi_assault_spooc",
	},
	tac_bull_rush = {
		"cs_assault_tank",
		"fbi_assault_tank",
		"elite_assault_tank",
	},
}
ElementSpawnEnemyGroup.group_mapping.tac_swat_rifle_flank = ElementSpawnEnemyGroup.group_mapping.tac_swat_rifle
ElementSpawnEnemyGroup.group_mapping.tac_shield_wall_ranged = ElementSpawnEnemyGroup.group_mapping.tac_shield_wall
ElementSpawnEnemyGroup.group_mapping.tac_shield_wall_charge = ElementSpawnEnemyGroup.group_mapping.tac_shield_wall
ElementSpawnEnemyGroup.group_mapping.tac_tazer_charge = ElementSpawnEnemyGroup.group_mapping.tac_tazer_flanking

ElementSpawnEnemyGroup._values_meta = {
	__index = function(t, k)
		if k == "interval" then
			local interval = rawget(t, "interval_reference") or 0
			local balance_mul = rawget(t, "interval_balance_mul")
			if balance_mul then
				local balance_mul_weight = tweak_data.group_ai.team_ai_balance_mul_weights.spawn_group_interval
				return interval * managers.groupai:state():_get_balancing_multiplier(balance_mul, balance_mul_weight)
			end
			return interval
		end
	end,
}
Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "eclipse_finalize_values", function(self)
	if not self._values.preferred_spawn_groups then
		return
	end

	self._values.interval_reference = math.max(tweak_data.group_ai.min_spawn_group_interval, self._values.interval)
	self._values.interval = nil
	setmetatable(self._values, ElementSpawnEnemyGroup._values_meta)

	local new_groups = {}
	for _, initial_group in pairs(self._values.preferred_spawn_groups) do
		local mapping = self.group_mapping[initial_group]
		if mapping then
			for _, added_group in pairs(mapping) do
				new_groups[added_group] = true
			end
		else
			new_groups[initial_group] = true
		end
	end

	self._values.preferred_spawn_groups = table.map_keys(new_groups)
end)

Hooks:PostHook(ElementSpawnEnemyGroup, "_chk_spawn_group_references", "eclipse__chk_spawn_group_references", function(self, preferred_groups)
	local function check_references(tbl)
		local ref_chk
		for group_id, group_data in pairs(tbl) do
			ref_chk = group_data.spawn_point_chk_ref
			if ref_chk then
				for _, group_type in ipairs(preferred_groups) do
					if ref_chk[group_type] then
						table.insert(preferred_groups, group_id)
						break
					end
				end
			end
		end
	end

	for _, timed_data in pairs(tweak_data.group_ai.timed_enemy_spawn_groups or {}) do
		check_references(timed_data.group_data or {})
	end
end)
