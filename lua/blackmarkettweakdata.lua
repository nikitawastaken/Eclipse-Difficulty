function BlackMarketTweakData:_init_deployables(tweak_data)
	self.deployables = {
		doctor_bag = {},
	}
	self.deployables.doctor_bag.name_id = "bm_equipment_doctor_bag"
	self.deployables.ammo_bag = {
		name_id = "bm_equipment_ammo_bag",
	}
	self.deployables.ecm_jammer = {
		name_id = "bm_equipment_ecm_jammer",
	}
	self.deployables.sentry_gun = {
		name_id = "bm_equipment_sentry_gun",
	}
	-- Remove silent sentry guns
	-- self.deployables.sentry_gun_silent = {
	-- 	name_id = "bm_equipment_sentry_gun_silent"
	-- }
	self.deployables.trip_mine = {
		name_id = "bm_equipment_trip_mine",
	}
	self.deployables.armor_kit = {
		name_id = "bm_equipment_armor_kit",
	}
	self.deployables.first_aid_kit = {
		name_id = "bm_equipment_first_aid_kit",
	}
	self.deployables.bodybags_bag = {
		name_id = "bm_equipment_bodybags_bag",
	}
	self.deployables.grenade_crate = {
		name_id = "bm_equipment_grenade_crate",
		dlc = "mxm",
		texture_bundle_folder = "mxm",
	}

	-- The grenade case as a deployable
	self.deployables.grenade_case = {
		name_id = "bm_equipment_grenade_case",
	}

	self:_add_desc_from_name_macro(self.deployables)
end
