Hooks:PostHook(CarryTweakData, "init", "eclipse_init", function(self)
	for _, bag_type in pairs(self.types) do
		bag_type.jump_modifier = 1
	end

	self.types.light.move_speed_modifier = 1
	self.types.light.throw_distance_multiplier = 1

	self.types.coke_light = deep_clone(self.types.light)

	self.types.medium.move_speed_modifier = 0.8
	self.types.medium.throw_distance_multiplier = 0.7

	self.types.heavy.move_speed_modifier = 0.6
	self.types.heavy.throw_distance_multiplier = 0.5

	self.types.being = deep_clone(self.types.heavy)
	self.types.slightly_heavy = deep_clone(self.types.heavy)

	self.types.very_heavy.move_speed_modifier = 0.3
	self.types.very_heavy.throw_distance_multiplier = 0.2

	self.types.slightly_very_heavy = deep_clone(self.types.very_heavy)
	self.types.mega_heavy = deep_clone(self.types.very_heavy)
end)
