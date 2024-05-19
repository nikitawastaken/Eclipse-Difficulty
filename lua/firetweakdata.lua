Hooks:PostHook(FireTweakData, "_init_dot_entries_fire", "eclipse__init_dot_entries_fire", function(self)
	-- incendiary
	self.dot_entries.fire.proj_fire_com.dot_damage = 30
	self.dot_entries.fire.proj_fire_com.dot_length = 5

	-- flamer dot (might just rework later)
	self.dot_entries.fire.weapon_flamethrower_mk2 = {
		dot_trigger_chance = 50,
		dot_damage = 7.5,
		dot_length = 1.1,
		dot_tick_period = 0.5,
		dot_trigger_max_distance = false,
	}
	self.dot_entries.fire.ammo_flamethrower_mk2_rare = deep_clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.ammo_flamethrower_mk2_welldone = deep_clone(self.dot_entries.fire.weapon_flamethrower_mk2)

	self.dot_entries.fire.weapon_system = deep_clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.weapon_system_low = deep_clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.weapon_system_high = deep_clone(self.dot_entries.fire.weapon_flamethrower_mk2)

	-- Dragon's Breath dot
	self.dot_entries.fire.ammo_dragons_breath_vh = {
		dot_trigger_chance = 1,
		dot_damage = 5,
		dot_length = 3,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.25,
	}

	self.dot_entries.fire.ammo_dragons_breath_h = {
		dot_trigger_chance = 0.85,
		dot_damage = 4,
		dot_length = 3,
		dot_trigger_max_distance = 2000,
		dot_tick_period = 0.25,
	}

	self.dot_entries.fire.ammo_dragons_breath = {
		dot_trigger_chance = 0.85,
		dot_damage = 3,
		dot_length = 3,
		dot_trigger_max_distance = 1750,
		dot_tick_period = 0.25,
	}

	self.dot_entries.fire.ammo_dragons_breath_l = {
		dot_trigger_chance = 0.7,
		dot_damage = 2,
		dot_length = 3,
		dot_trigger_max_distance = 1500,
		dot_tick_period = 0.25,
	}

	self.dot_entries.fire.ammo_dragons_breath_vl = {
		dot_trigger_chance = 0.7,
		dot_damage = 1,
		dot_length = 3,
		dot_trigger_max_distance = 1250,
		dot_tick_period = 0.25,
	}

	-- molo dot
	self.dot_entries.fire.proj_molotov_groundfire = {
		dot_trigger_chance = 1,
		dot_damage = 7.5,
		dot_length = 6,
		dot_trigger_max_distance = false,
		dot_tick_period = 0.25,
		is_molotov = true,
	}

	self.dot_entries.fire.proj_launcher_incendiary_groundfire = {
		dot_trigger_chance = 1,
		dot_damage = 7.5,
		dot_length = 6,
		dot_trigger_max_distance = false,
		dot_tick_period = 0.25,
		is_molotov = false,
	}

	self.dot_entries.fire.proj_launcher_incendiary_arbiter_groundfire = clone(self.dot_entries.fire.proj_launcher_incendiary_groundfire)
end)
