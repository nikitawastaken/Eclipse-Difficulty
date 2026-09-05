Hooks:PostHook(FireTweakData, "init", "eclipse_init", function(self)
	for _, fire_type in pairs(self.dot_entries.fire) do
		fire_type.dot_damage = 3
		fire_type.dot_length = 6
		fire_type.dot_tick_period = 0.5
		fire_type.dot_trigger_max_distance = false
		fire_type.dot_grace_period = 1
	end

	self.dot_entries.fire.weapon_flamethrower_mk2.dot_damage = 2
	self.dot_entries.fire.weapon_flamethrower_mk2.dot_length = 3
	self.dot_entries.fire.weapon_flamethrower_mk2.dot_trigger_chance = 0.25

	self.dot_entries.fire.ammo_flamethrower_mk2_rare = clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.ammo_flamethrower_mk2_rare.dot_damage = 3

	self.dot_entries.fire.ammo_flamethrower_mk2_welldone = clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.ammo_flamethrower_mk2_welldone.dot_damage = 1

	self.dot_entries.fire.weapon_system = clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.ammo_system_high = clone(self.dot_entries.fire.ammo_flamethrower_mk2_rare)
	self.dot_entries.fire.ammo_system_low = clone(self.dot_entries.fire.ammo_flamethrower_mk2_welldone)

	self.dot_entries.fire.weapon_money = clone(self.dot_entries.fire.weapon_flamethrower_mk2)
	self.dot_entries.fire.weapon_money.dot_damage = 1
	self.dot_entries.fire.weapon_money.burn_sound_name = "no_sound"
	self.dot_entries.fire.weapon_money.fire_effect_variant = "endless_money"

	self.dot_entries.fire.weapon_kacchainsaw_flamethrower = clone(self.dot_entries.fire.weapon_flamethrower_mk2)

	self.dot_entries.fire.ammo_dragons_breath.dot_damage = 2
	self.dot_entries.fire.ammo_dragons_breath.dot_length = 3
	self.dot_entries.fire.ammo_dragons_breath.dot_trigger_chance = 0.15
	self.dot_entries.fire.ammo_dragons_breath.dot_trigger_max_distance = 3000

	self.dot_entries.fire.ammo_dragons_breath_light = clone(self.dot_entries.fire.ammo_dragons_breath)
	self.dot_entries.fire.ammo_dragons_breath_medium = clone(self.dot_entries.fire.ammo_dragons_breath)
	self.dot_entries.fire.ammo_dragons_breath_heavy = clone(self.dot_entries.fire.ammo_dragons_breath)

	self.dot_entries.fire.melee_spoon_gold.dot_damage = 2
	self.dot_entries.fire.melee_spoon_gold.dot_length = 3
	self.dot_entries.fire.melee_spoon_gold.dot_trigger_chance = 0.2

	self.dot_entries.fire.proj_fire_com.dot_damage = 4
	self.dot_entries.fire.proj_fire_com.dot_length = 2
	self.dot_entries.fire.proj_fire_com.dot_trigger_chance = 1

	self.dot_entries.fire.proj_molotov.dot_damage = 4
	self.dot_entries.fire.proj_molotov.dot_length = 10
	self.dot_entries.fire.proj_molotov.dot_trigger_chance = 1

	self.dot_entries.fire.proj_launcher_incendiary.dot_damage = 2
	self.dot_entries.fire.proj_launcher_incendiary.dot_trigger_chance = 1

	self.dot_entries.fire.proj_launcher_incendiary_arbiter.dot_damage = 2
	self.dot_entries.fire.proj_launcher_incendiary_arbiter.dot_trigger_chance = 1
	
	self.dot_entries.fire.proj_launcher_incendiary_light = clone(self.dot_entries.fire.proj_launcher_incendiary)
	self.dot_entries.fire.proj_launcher_incendiary_light.dot_damage = 2

	self.dot_entries.fire.proj_launcher_incendiary_heavy = clone(self.dot_entries.fire.proj_launcher_incendiary)
	self.dot_entries.fire.proj_launcher_incendiary_heavy.dot_damage = 4

	self.dot_entries.fire.cluster_incendiary = {
		dot_trigger_chance = 1,
		dot_damage = 1.5,
		dot_length = 4,
		dot_tick_period = 0.5,
		dot_trigger_max_distance = false,
	}
end)
