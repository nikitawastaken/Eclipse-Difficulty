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
		"cs_stealth_light",
		"cs_stealth_heavy",
		"cs_cops_init",
		"cs_swats_ranged",
		"cs_swats_charge",
		"cs_heavies_ranged",
		"cs_heavies_charge",
		"fbi_defend_init",
		"fbi_defend_light",
		"fbi_defend_heavy",
		"fbi_stealth_light",
		"fbi_stealth_heavy",
		"fbi_swats_ranged",
		"fbi_swats_charge",
		"fbi_heavies_ranged",
		"fbi_heavies_charge",
		"elite_defend_light",
		"elite_defend_heavy",
		"elite_swats_ranged",
		"elite_swats_charge",
		"elite_heavies_ranged",
		"elite_heavies_charge",
	},
	tac_shield_wall = {
		"cs_shield_ranged",
		"cs_shield_charge",
		"fbi_shield_ranged",
		"fbi_shield_charge",
		"elite_shield_ranged",
		"elite_shield_charge",
	},
	tac_tazer_flanking = {
		"cs_taser_flank",
		"cs_taser_charge",
		"fbi_taser_flank",
		"fbi_taser_charge",
		"elite_taser_takedown",
		"elite_taser_flank",
		"elite_taser_charge",
	},
	FBI_spoocs = {
		"fbi_cloaker_charge",
		"fbi_cloaker_hide",
	},
	tac_bull_rush = {
		"cs_bulldozer_charge",
		"fbi_bulldozer_charge",
		"elite_bulldozer_shield",
		"elite_bulldozer_takedown",
		"elite_bulldozer_charge",
	},
}
ElementSpawnEnemyGroup.group_mapping.tac_swat_rifle_flank = ElementSpawnEnemyGroup.group_mapping.tac_swat_rifle
ElementSpawnEnemyGroup.group_mapping.tac_shield_wall_ranged = ElementSpawnEnemyGroup.group_mapping.tac_shield_wall
ElementSpawnEnemyGroup.group_mapping.tac_shield_wall_charge = ElementSpawnEnemyGroup.group_mapping.tac_shield_wall
ElementSpawnEnemyGroup.group_mapping.tac_tazer_charge = ElementSpawnEnemyGroup.group_mapping.tac_tazer_flanking

Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "sh__finalize_values", function(self)
	if not self._values.preferred_spawn_groups then
		return
	end

	if self._values.interval == 0 then
		for _, id in pairs(self._values.elements) do
			local spawn_point = self:get_mission_element(id)
			if spawn_point and spawn_point._values.spawn_action then
				self._values.interval = 5
				break
			end
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
