-- Remove some dodgy code for forced group spawns, forcing spawn groups has been fixed in GroupAIStateBesiege:force_spawn_group
Hooks:OverrideFunction(ElementSpawnEnemyGroup, "on_executed", function (self, instigator)
	if not self._values.enabled then
		return
	end

	self:_check_spawn_points()

	if #self._spawn_points > 0 then
		if self._group_data.spawn_type == "group" then
			local spawn_group_data = managers.groupai:state():create_spawn_group(self._id, self, self._spawn_points)
			managers.groupai:state():force_spawn_group(spawn_group_data, self._values.preferred_spawn_groups)
		elseif self._group_data.spawn_type == "group_guaranteed" then
			local spawn_group_data = managers.groupai:state():create_spawn_group(self._id, self, self._spawn_points)
			managers.groupai:state():force_spawn_group(spawn_group_data, self._values.preferred_spawn_groups, true)
		else
			for i = 1, self:get_random_table_value(self._group_data.amount) do
				local element = self._spawn_points[self:_get_spawn_point(i)]
				element:produce({
					team = self._values.team
				})
			end
		end
	end

	ElementSpawnEnemyGroup.super.on_executed(self, instigator)
end)

-- Necessary for the custom spawngroup implementation
local groupsOLD = {
	"tac_shield_wall_charge",
	"FBI_spoocs",
	"tac_tazer_charge",
	"tac_tazer_flanking",
	"tac_shield_wall",
	"tac_swat_rifle_flank",
	"tac_shield_wall_ranged",
	"tac_bull_rush"
}

local twat_captain = {
	Phalanx = true,
	single_spooc = true
}

Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "eclipse__finalize_values", function(self)	
	if self._values.preferred_spawn_groups and #self._values.preferred_spawn_groups == #groupsOLD and table.contains_all(self._values.preferred_spawn_groups, groupsOLD) then
		self._values.preferred_spawn_groups = {}
		for name,_ in pairs(tweak_data.group_ai.enemy_spawn_groups) do
			if not table.contains(self._values.preferred_spawn_groups, name) and not twat_captain[name] then
				table.insert(self._values.preferred_spawn_groups, name)
			end
		end
	end
end)