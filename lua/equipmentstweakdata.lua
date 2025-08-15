Hooks:PostHook(EquipmentsTweakData, "init", "eclipse_init", function(self)
	self.first_aid_kit.quantity = { 8 }
	self.trip_mine.quantity = { 6, 4 }
	self.specials.cable_tie.quantity = 4
end)
