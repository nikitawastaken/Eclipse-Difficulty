Hooks:PostHook(CarryTweakData, "init", "eclipse_init", function(self)
	-- Heavy bags no longer reduce jump height
	for _, bag_type in pairs(self.types) do
		bag_type.move_speed_modifier = math.min(bag_type.move_speed_modifier + 0.15, 1)
		bag_type.jump_modifier = math.min(bag_type.jump_modifier + 0.25, 1)
	end

	-- Change the weight of specific loot types
	self.ranc_weapon.type = "medium"
end)
