-- rework poison cloud DOT
Hooks:PostHook(DOTTweakData, "init", "eclipse_init", function(self)
	self.dot_entries.poison.proj_gas_grenade_cloud.hurt_animation_chance = 1
	self.dot_entries.poison.proj_gas_grenade_cloud.dot_damage = 8
	self.dot_entries.poison.proj_gas_grenade_cloud.dot_tick_period = 2
	self.dot_entries.poison.proj_gas_grenade_cloud.dot_length = 10
	self.dot_entries.poison.proj_launcher_cloud.hurt_animation_chance = 0.3
	self.dot_entries.poison.proj_launcher_cloud.dot_damage = 4
	self.dot_entries.poison.proj_launcher_cloud.dot_tick_period = 2
	self.dot_entries.poison.proj_launcher_cloud.dot_length = 10
	self.dot_entries.poison.proj_launcher_arbiter_cloud.hurt_animation_chance = 0.3
	self.dot_entries.poison.proj_launcher_arbiter_cloud.dot_damage = 4
	self.dot_entries.poison.proj_launcher_arbiter_cloud.dot_tick_period = 2
	self.dot_entries.poison.proj_launcher_arbiter_cloud.dot_length = 10
end)
