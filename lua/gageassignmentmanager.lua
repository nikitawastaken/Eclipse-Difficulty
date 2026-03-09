Hooks:PostHook(GageAssignmentManager, "_give_rewards", "eclipse_give_rewards", function(self, assignment, ...)
	managers.custom_safehouse:add_coins(self._tweak_data:get_value(assignment, "coin_reward") or 1, TelemetryConst.economy_origin.mission_reward)
end)