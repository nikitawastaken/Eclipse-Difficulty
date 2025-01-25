local initproj_orig = BlackMarketTweakData._init_projectiles
function BlackMarketTweakData:_init_projectiles(tweak_data)
	initproj_orig(self, tweak_data)

	-- 45s injector cooldown
	self.projectiles.chico_injector.base_cooldown = 45
	-- 16s flask cooldown
	self.projectiles.damage_control.base_cooldown = 16

	-- remove retarded anticheat
	self.projectiles.rocket_ray_frag.time_cheat = nil
	self.projectiles.launcher_frag_m32.time_cheat = nil

	-- grenade amounts
	self.projectiles.frag.max_amount = 3
	self.projectiles.frag_com.max_amount = 3
	self.projectiles.dada_com.max_amount = 3
	self.projectiles.dynamite.max_amount = 3
	self.projectiles.concussion.max_amount = 3
	self.projectiles.fir_com.max_amount = 3
	self.projectiles.molotov.max_amount = 3
	self.projectiles.poison_gas_grenade.max_amount = 3
	self.projectiles.wpn_gre_electric.max_amount = 3

	-- Add missing projectile variants
	self.projectiles.launcher_frag_m79 = deep_clone(self.projectiles.launcher_frag)
	self.projectiles.launcher_frag_m79.weapon_id = "gre_m79"
	table.insert(self._projectiles_index, "launcher_frag_m79")

	self.projectiles.launcher_incendiary_m79 = deep_clone(self.projectiles.launcher_incendiary)
	self.projectiles.launcher_incendiary_m79.weapon_id = "gre_m79"
	table.insert(self._projectiles_index, "launcher_incendiary_m79")

	self.projectiles.launcher_electric_m79 = deep_clone(self.projectiles.launcher_electric)
	self.projectiles.launcher_electric_m79.weapon_id = "gre_m79"
	table.insert(self._projectiles_index, "launcher_electric_m79")

	self.projectiles.launcher_poison_m79 = deep_clone(self.projectiles.launcher_poison)
	self.projectiles.launcher_poison_m79.weapon_id = "gre_m79"
	table.insert(self._projectiles_index, "launcher_poison_m79")

	self.projectiles.launcher_poison_ms3gl = deep_clone(self.projectiles.launcher_poison)
	self.projectiles.launcher_poison_ms3gl.weapon_id = "msg3gl"
	table.insert(self._projectiles_index, "launcher_poison_ms3gl")
end
