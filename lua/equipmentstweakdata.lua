Hooks:PostHook(EquipmentsTweakData, "init", "eclipse_init", function(self)
	self.first_aid_kit.quantity = { 8 }
	self.trip_mine.quantity = { 6, 4 }
	self.specials.cable_tie.quantity = 4

	self.grenade_case = {
		deploy_time = 2,
		use_function_name = "use_grenade_case",
		dummy_unit = "units/payday2/equipment/gen_equipment_grenade_case/gen_equipment_grenade_case_dummy_unit",
		text_id = "debug_equipment_grenade_case",
		icon = "equipment_ammo_bag",
		description_id = "des_ammo_bag",
		visual_style = "throwables_bag",
		quantity = {
			1
		}
	}
	self.max_amount.grenade_case = 2
	self.class_name_to_deployable_id.GrenadeCrateBase = "grenade_case"
end)
