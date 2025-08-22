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
		"cs_defend_init",
		"cs_defend_light",
		"cs_defend_heavy",
		"cs_stealth_init",
		"cs_stealth_light",
		"cs_stealth_heavy",
		"cs_cops",
		"cs_swats",
		"cs_heavies",
		"fbi_defend_init",
		"fbi_defend_light",
		"fbi_defend_heavy",
		"fbi_stealth_init",
		"fbi_stealth_light",
		"fbi_stealth_heavy",
		"fbi_swats",
		"fbi_heavies",
		"elite_sniper",
		"elite_defend_light",
		"elite_defend_heavy",
		"elite_swats",
		"elite_heavies",
	},
	tac_shield_wall = {
		"cs_shield",
		"fbi_shield",
		"elite_shield",
	},
	tac_tazer_flanking = {
		"cs_taser",
		"fbi_taser",
		"elite_taser",
	},
	FBI_spoocs = {
		"fbi_cloaker",
	},
	tac_bull_rush = {
		"cs_bulldozer",
		"fbi_bulldozer",
		"elite_bulldozer",
		"elite_bulldozer_shield",
	},
}
ElementSpawnEnemyGroup.group_mapping.tac_swat_rifle_flank = ElementSpawnEnemyGroup.group_mapping.tac_swat_rifle
ElementSpawnEnemyGroup.group_mapping.tac_shield_wall_ranged = ElementSpawnEnemyGroup.group_mapping.tac_shield_wall
ElementSpawnEnemyGroup.group_mapping.tac_shield_wall_charge = ElementSpawnEnemyGroup.group_mapping.tac_shield_wall
ElementSpawnEnemyGroup.group_mapping.tac_tazer_charge = ElementSpawnEnemyGroup.group_mapping.tac_tazer_flanking

Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "eclipse_finalize_values", function(self)
	if not self._values.preferred_spawn_groups then
		return
	end

	local assault_state = managers.groupai:state_name() or "besiege"
	local spawn_cooldown = managers.groupai:state():_get_difficulty_dependent_value(tweak_data.group_ai[assault_state].assault.spawnrate)

	self._values.interval = math.max(2 * spawn_cooldown, self._values.interval)
	for _, id in pairs(self._values.elements) do
		local spawn_point = self:get_mission_element(id)
		if spawn_point and spawn_point._values.spawn_action then
			self._values.interval = math.max(4 * spawn_cooldown, self._values.interval)
			break
		end
	end

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
