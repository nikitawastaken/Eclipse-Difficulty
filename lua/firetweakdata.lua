Hooks:PostHook(FireTweakData, "init", "eclipse_init", function(self)
	for _, fire_type in pairs(self.dot_entries.fire) do
		fire_type.dot_damage = 3
		fire_type.dot_length = 4
		fire_type.dot_tick_period = 0.25
		fire_type.dot_trigger_max_distance = false
	end

	local trigger_chance_flamethrower = 0.15
	local trigger_chance_molotov = 0.25

	self.dot_entries.fire.default_fire.dot_trigger_chance = 1

	self.dot_entries.fire.weapon_flamethrower_mk2.dot_trigger_chance = trigger_chance_flamethrower

	self.dot_entries.fire.ammo_flamethrower_mk2_rare = clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.ammo_flamethrower_mk2_rare.dot_damage = 4

	self.dot_entries.fire.ammo_flamethrower_mk2_welldone = clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.ammo_flamethrower_mk2_welldone.dot_damage = 2

	self.dot_entries.fire.ammo_dragons_breath.dot_damage = 2
	self.dot_entries.fire.ammo_dragons_breath.dot_length = 3
	self.dot_entries.fire.ammo_dragons_breath.dot_trigger_chance = 1 / 5
	self.dot_entries.fire.ammo_dragons_breath.dot_trigger_max_distance = 1200

	self.dot_entries.fire.ammo_dragons_breath_light = clone(self.dot_entries.fire.ammo_dragons_breath)
	self.dot_entries.fire.ammo_dragons_breath_light.dot_damage = 2
	self.dot_entries.fire.ammo_dragons_breath_light.dot_trigger_max_distance = 1200

	self.dot_entries.fire.ammo_dragons_breath_medium = clone(self.dot_entries.fire.ammo_dragons_breath)
	self.dot_entries.fire.ammo_dragons_breath_medium.dot_damage = 3
	self.dot_entries.fire.ammo_dragons_breath_medium.dot_trigger_max_distance = 1600

	self.dot_entries.fire.ammo_dragons_breath_heavy = clone(self.dot_entries.fire.ammo_dragons_breath)
	self.dot_entries.fire.ammo_dragons_breath_heavy.dot_damage = 4
	self.dot_entries.fire.ammo_dragons_breath_heavy.dot_trigger_max_distance = 2000

	self.dot_entries.fire.weapon_system.dot_trigger_chance = trigger_chance_flamethrower

	self.dot_entries.fire.ammo_system_high = clone(self.dot_entries.fire.weapon_system)
	self.dot_entries.fire.ammo_system_high.dot_damage = 4

	self.dot_entries.fire.ammo_system_low = clone(self.dot_entries.fire.weapon_system)
	self.dot_entries.fire.ammo_system_low.dot_damage = 2

	self.dot_entries.fire.weapon_money.burn_sound_name = "no_sound"
	self.dot_entries.fire.weapon_money.fire_effect_variant = "endless_money"
	self.dot_entries.fire.weapon_money.dot_trigger_chance = trigger_chance_flamethrower

	self.dot_entries.fire.weapon_kacchainsaw_flamethrower.dot_trigger_chance = trigger_chance_flamethrower

	self.dot_entries.fire.weapon_money.dot_trigger_chance = trigger_chance_flamethrower

	self.dot_entries.fire.melee_spoon_gold.dot_trigger_chance = 0.4

	self.dot_entries.fire.proj_fire_com.dot_trigger_chance = 1

	self.dot_entries.fire.proj_molotov.dot_damage = 4
	self.dot_entries.fire.proj_molotov.dot_length = 6
	self.dot_entries.fire.proj_molotov.is_molotov = true
	self.dot_entries.fire.proj_molotov.dot_trigger_chance = trigger_chance_molotov

	self.dot_entries.fire.proj_molotov_groundfire.is_molotov = true

	self.dot_entries.fire.proj_launcher_incendiary.dot_damage = 2
	self.dot_entries.fire.proj_launcher_incendiary.dot_length = 4
	self.dot_entries.fire.proj_launcher_incendiary.dot_trigger_chance = trigger_chance_molotov

	self.dot_entries.fire.proj_launcher_incendiary_light = clone(self.dot_entries.fire.proj_launcher_incendiary)
	self.dot_entries.fire.proj_launcher_incendiary_light.dot_damage = 2
	self.dot_entries.fire.proj_launcher_incendiary_light.dot_length = 4

	self.dot_entries.fire.proj_launcher_incendiary_medium = clone(self.dot_entries.fire.proj_launcher_incendiary)
	self.dot_entries.fire.proj_launcher_incendiary_medium.dot_damage = 3
	self.dot_entries.fire.proj_launcher_incendiary_medium.dot_length = 5

	self.dot_entries.fire.proj_launcher_incendiary_heavy = clone(self.dot_entries.fire.proj_launcher_incendiary)
	self.dot_entries.fire.proj_launcher_incendiary_heavy.dot_damage = 4
	self.dot_entries.fire.proj_launcher_incendiary_heavy.dot_length = 6
end)
