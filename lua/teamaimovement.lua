-- Apply default carry speed upgrade to bots
function TeamAIMovement:set_carry_speed_modifier(...)
	TeamAIMovement.super.set_carry_speed_modifier(self, ...)

	if self._carry_speed_modifier then
		local carry_upgrade = managers.player:upgrade_value("carry", "movement_speed_multiplier", 1)
		self._carry_speed_modifier = math.clamp(self._carry_speed_modifier * carry_upgrade, 0, 1)
	end
end
