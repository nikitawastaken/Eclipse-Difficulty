Hooks:PostHook(CarryTweakData, "init", "eclipse_init", function(self)
	-- Heavy bags no longer reduce jump height
	for _, bag_type in pairs(self.types) do
		bag_type.move_speed_modifier = math.min(bag_type.move_speed_modifier + 0.15, 1)
		bag_type.jump_modifier = math.min(bag_type.jump_modifier + 0.25, 1)
	end

	-- Bag value fixes
	self.diamonds_dah.bag_value = "diamonds_dah"
	self.goat.bag_value = "goat"
	self.yayo.bag_value = "coke_pure"
	self.chas_artifact.bag_value = "chas_artifact"
	self.chas_teaset.bag_value = "chas_teaset"
	self.trai_printing_plates.bag_value = "trai_printing_plates"
	self.black_tablet.bag_value = "black_tablet"

	-- Change the weight of specific loot types
	self.ranc_weapon.type = "medium"
end)
