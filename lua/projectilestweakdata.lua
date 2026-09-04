Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "eclipse__init_projectiles", function(self, tweak_data)
	-- Tweak cooldowns
	self.projectiles.chico_injector.base_cooldown = 45 -- Kingpin Injector
	self.projectiles.damage_control.base_cooldown = 16 -- Stoic Hip Flask

	-- Remove the projectile anti-cheat
	for k, v in pairs(self.projectiles) do
		v.time_cheat = nil
	end

	-- Set projectile amounts
	self.projectiles.frag.max_amount = 3
	self.projectiles.frag_com.max_amount = 3
	self.projectiles.dada_com.max_amount = 3
	self.projectiles.dynamite.max_amount = 3
	self.projectiles.concussion.max_amount = 3
	self.projectiles.fir_com.max_amount = 3
	self.projectiles.molotov.max_amount = 3
	self.projectiles.poison_gas_grenade.max_amount = 3
	self.projectiles.wpn_gre_electric.max_amount = 3

	-- Set projectile throwing speeds
	self.projectiles.wpn_prj_four.throw_speed_mul = 4 / 3
	self.projectiles.wpn_prj_hur.throw_speed_mul = 4 / 3
	self.projectiles.wpn_prj_target.throw_speed_mul = 4 / 3
			
	-- Give all hand grenades the community frag grenade's throw animation
	self.projectiles.frag.animation = self.projectiles.frag_com.animation
	self.projectiles.fir_com.animation = self.projectiles.frag_com.animation
	self.projectiles.concussion.animation = self.projectiles.frag_com.animation
	self.projectiles.wpn_gre_electric.animation = self.projectiles.frag_com.animation
	self.projectiles.poison_gas_grenade.animation = self.projectiles.frag_com.animation -- ditto
	self.projectiles.sticky_grenade.animation = self.projectiles.frag_com.animation

	-- Increase the Laser Chronometer's fire rate but decrease the damage (higher ammo consumption)
	self.projectiles.laser_watch.reuse_expire_t = self.projectiles.laser_watch.reuse_expire_t / 2

	-- Increase the Flashbang's expire_t to match other grenades
	self.projectiles.concussion.expire_t = self.projectiles.frag_com.expire_t

	-- Give Sicario's Smoke Grenade a sound when smoke is ready to use (like any cd-based throwables have)
	self.projectiles.smoke_screen_grenade.sounds = { cooldown = "perkdeck_cooldown_over" }

	-- Different trails for projectiles/throwables
	local trail_gas = "effects/particles/weapons/grenade_trail_gas"
	local trail_electric = "effects/particles/weapons/grenade_trail_electric"
	local trail_dynamite = "effects/particles/weapons/grenade_trail_dynamite"
	local trail_incendiary = "effects/particles/weapons/grenade_trail_incendiary"

	self.projectiles.poison_gas_grenade.add_trail_effect = trail_gas
	self.projectiles.wpn_gre_electric.add_trail_effect = trail_electric
	self.projectiles.dynamite.add_trail_effect = trail_dynamite
	self.projectiles.molotov.add_trail_effect = trail_dynamite
	self.projectiles.smoke_screen_grenade.add_trail_effect = "effects/particles/weapons/grenade_trail_sicario_smoke"

	self.projectiles.launcher_incendiary.add_trail_effect = trail_incendiary
	self.projectiles.launcher_incendiary_m32.add_trail_effect = trail_incendiary
	self.projectiles.launcher_incendiary_china.add_trail_effect = trail_incendiary
	self.projectiles.launcher_incendiary_arbiter.add_trail_effect = trail_incendiary
	self.projectiles.launcher_incendiary_slap.add_trail_effect = trail_incendiary
	self.projectiles.launcher_incendiary_ms3gl.add_trail_effect = trail_incendiary

	self.projectiles.launcher_electric.add_trail_effect = trail_electric
	self.projectiles.launcher_electric_m32.add_trail_effect = trail_electric
	self.projectiles.launcher_electric_china.add_trail_effect = trail_electric
	self.projectiles.launcher_electric_slap.add_trail_effect = trail_electric
	self.projectiles.launcher_electric_arbiter.add_trail_effect = trail_electric
	self.projectiles.underbarrel_electric.add_trail_effect = trail_electric
	self.projectiles.underbarrel_electric_groza.add_trail_effect = trail_electric
	self.projectiles.launcher_electric_ms3gl.add_trail_effect = trail_electric

	self.projectiles.launcher_poison.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_ms3gl_conversion.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_gre_m79.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_m32.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_groza.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_china.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_arbiter.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_slap.add_trail_effect = trail_gas
	self.projectiles.launcher_poison_contraband.add_trail_effect = trail_gas

	-- Add a non-poison tipped Dart Gun dart
	self.projectiles.dart_arrow = deep_clone(self.projectiles.dart_poison)
	self.projectiles.dart_arrow.unit = "units/pd2_dlc_esp/weapons/wpn_prj_dart_arrow/wpn_prj_dart_arrow"
	self.projectiles.dart_arrow.local_unit = "units/pd2_dlc_esp/weapons/wpn_prj_dart_arrow/wpn_prj_dart_arrow_local"
	table.insert(self._projectiles_index, "dart_arrow")

	-- Cluster Grenades for the Carpet Bombing skill
	self.projectiles.cluster = {
		name_id = "bm_grenade_cluster",
		unit = "units/payday2/weapons/wpn_gre_cluster/wpn_gre_cluster",
		unit_dummy = "units/payday2/weapons/wpn_gre_cluster/wpn_gre_cluster_husk",
		no_cheat_count = true,
		is_a_grenade = true,
		is_explosive = true,
	}

	table.insert(self._projectiles_index, "cluster")

	self.projectiles.cluster_incendiary = {
		name_id = "bm_grenade_cluster_incendiary",
		unit = "units/payday2/weapons/wpn_gre_cluster/wpn_gre_cluster_incendiary",
		unit_dummy = "units/payday2/weapons/wpn_gre_cluster/wpn_gre_cluster_incendiary_husk",
		impact_detonation = true,
		no_cheat_count = true,
		is_a_grenade = true,
		is_explosive = true,
	}

	table.insert(self._projectiles_index, "cluster_incendiary")
end)
