Hooks:PostHook(DOTTweakData, "init", "eclipse_init", function(self)
	for _, poison_type in pairs(self.dot_entries.poison) do
		poison_type.dot_damage = 2.4
		poison_type.dot_length = 6
		poison_type.dot_tick_period = 0.5
	end

	self.dot_entries.poison.ammo_proj_bow.damage_class = "ProjectilesPoisonBulletBase"
	self.dot_entries.poison.ammo_proj_bow.hurt_animation_chance = 1 / 2

	self.dot_entries.poison.ammo_proj_crossbow = clone(self.dot_entries.poison.ammo_proj_bow)
	self.dot_entries.poison.ammo_proj_arblast = clone(self.dot_entries.poison.ammo_proj_bow)
	self.dot_entries.poison.ammo_proj_frankish = clone(self.dot_entries.poison.ammo_proj_bow)
	self.dot_entries.poison.ammo_proj_long = clone(self.dot_entries.poison.ammo_proj_bow)
	self.dot_entries.poison.ammo_proj_ecp = clone(self.dot_entries.poison.ammo_proj_bow)
	self.dot_entries.poison.ammo_proj_elastic = clone(self.dot_entries.poison.ammo_proj_bow)

	self.dot_entries.poison.ammo_rip.dot_damage = 1.2
	self.dot_entries.poison.ammo_rip.hurt_animation_chance = 1 / 4
	self.dot_entries.poison.ammo_rip.use_weapon_damage_falloff = true

	self.dot_entries.poison.ammo_rip_light = deep_clone(self.dot_entries.poison.ammo_rip)
	self.dot_entries.poison.ammo_rip_light.dot_damage = 0.8

	self.dot_entries.poison.ammo_rip_medium = deep_clone(self.dot_entries.poison.ammo_rip)

	self.dot_entries.poison.ammo_rip_heavy = deep_clone(self.dot_entries.poison.ammo_rip)
	self.dot_entries.poison.ammo_rip_heavy.dot_damage = 1.6

	self.dot_entries.poison.proj_gas_grenade_cloud.dot_damage = 1.6
	self.dot_entries.poison.proj_gas_grenade_cloud.dot_length = 15
	self.dot_entries.poison.proj_gas_grenade_cloud.hurt_animation_chance = 1 / 5
	self.dot_entries.poison.proj_gas_grenade_cloud.apply_hurt_once = true

	self.dot_entries.poison.proj_launcher_poison = deep_clone(self.dot_entries.poison.proj_gas_grenade_cloud)
	self.dot_entries.poison.proj_launcher_poison.dot_damage = 0.8
	self.dot_entries.poison.proj_launcher_poison.hurt_animation_chance = 1 / 10

	self.dot_entries.poison.proj_launcher_poison_light = deep_clone(self.dot_entries.poison.proj_launcher_poison)
	self.dot_entries.poison.proj_launcher_poison_light.dot_damage = 0.4

	self.dot_entries.poison.proj_launcher_poison_medium = deep_clone(self.dot_entries.poison.proj_launcher_poison)

	self.dot_entries.poison.proj_launcher_poison_heavy = deep_clone(self.dot_entries.poison.proj_launcher_poison)
	self.dot_entries.poison.proj_launcher_poison_heavy.dot_damage = 1.2

	self.dot_entries.poison.melee_cqc.dot_damage = 7.2
	self.dot_entries.poison.melee_cqc.dot_length = 2
	self.dot_entries.poison.melee_cqc.hurt_animation_chance = 4 / 5

	self.dot_entries.poison.melee_fear = deep_clone(self.dot_entries.poison.melee_cqc)
	self.dot_entries.poison.melee_piggy_hammer = deep_clone(self.dot_entries.poison.melee_cqc)
end)
