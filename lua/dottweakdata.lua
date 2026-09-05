Hooks:PostHook(DOTTweakData, "init", "eclipse_init", function(self)
	for _, poison_type in pairs(self.dot_entries.poison) do
		poison_type.dot_damage = 3
		poison_type.dot_length = 6
		poison_type.dot_tick_period = 0.5
		poison_type.dot_grace_period = 1
	end

	self.dot_entries.poison.ammo_rip.dot_damage = 2
	self.dot_entries.poison.ammo_rip.hurt_animation_chance = 1 / 5
	self.dot_entries.poison.ammo_rip.use_weapon_damage_falloff = true

	self.dot_entries.poison.ammo_rip_light = deep_clone(self.dot_entries.poison.ammo_rip)
	self.dot_entries.poison.ammo_rip_medium = deep_clone(self.dot_entries.poison.ammo_rip)
	self.dot_entries.poison.ammo_rip_heavy = deep_clone(self.dot_entries.poison.ammo_rip)

	self.dot_entries.poison.proj_gas_grenade_cloud.dot_damage = 1
	self.dot_entries.poison.proj_gas_grenade_cloud.dot_length = 20
	self.dot_entries.poison.proj_gas_grenade_cloud.hurt_animation_chance = 0.15
	self.dot_entries.poison.proj_gas_grenade_cloud.apply_hurt_once = true

	self.dot_entries.poison.proj_launcher_poison = deep_clone(self.dot_entries.poison.proj_gas_grenade_cloud)
	self.dot_entries.poison.proj_launcher_poison.dot_damage = 0.5
	self.dot_entries.poison.proj_launcher_poison.hurt_animation_chance = 0.1

	self.dot_entries.poison.proj_launcher_poison_light = deep_clone(self.dot_entries.poison.proj_launcher_poison)
	self.dot_entries.poison.proj_launcher_poison_light.dot_damage = 0.5

	self.dot_entries.poison.proj_launcher_poison_heavy = deep_clone(self.dot_entries.poison.proj_launcher_poison)
	self.dot_entries.poison.proj_launcher_poison_heavy.dot_damage = 1

	self.dot_entries.poison.melee_cqc.dot_damage = 5
	self.dot_entries.poison.melee_cqc.dot_length = 1
	self.dot_entries.poison.melee_cqc.hurt_animation_chance = 0.75

	self.dot_entries.poison.melee_fear = deep_clone(self.dot_entries.poison.melee_cqc)
	self.dot_entries.poison.melee_piggy_hammer = deep_clone(self.dot_entries.poison.melee_cqc)
end)
