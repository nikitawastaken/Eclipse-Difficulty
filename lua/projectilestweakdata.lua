local initproj_orig = BlackMarketTweakData._init_projectiles
function BlackMarketTweakData:_init_projectiles(tweak_data)
	initproj_orig(self, tweak_data)

	-- 45s injector cooldown
	self.projectiles.chico_injector.base_cooldown = 45
	-- 16s flask cooldown
	self.projectiles.damage_control.base_cooldown = 16

	-- Remove the projectile anti-cheat
	for k, v in pairs(self.projectiles) do
		v.time_cheat = nil
	end

	-- Set grenade amounts
	self.projectiles.frag.max_amount = 3
	self.projectiles.frag_com.max_amount = 3
	self.projectiles.dada_com.max_amount = 3
	self.projectiles.dynamite.max_amount = 3
	self.projectiles.concussion.max_amount = 3
	self.projectiles.fir_com.max_amount = 3
	self.projectiles.molotov.max_amount = 3
	self.projectiles.poison_gas_grenade.max_amount = 3
	self.projectiles.wpn_gre_electric.max_amount = 3

	-- Give all hand grenades the community frag grenade's throw animation
	self.projectiles.frag.animation = self.projectiles.frag_com.animation
	self.projectiles.fir_com.animation = self.projectiles.frag_com.animation
	self.projectiles.concussion.animation = self.projectiles.frag_com.animation
	self.projectiles.wpn_gre_electric.animation = self.projectiles.frag_com.animation
	self.projectiles.poison_gas_grenade.animation = self.projectiles.frag_com.animation -- ditto
	self.projectiles.sticky_grenade.animation = self.projectiles.frag_com.animation

	-- Increase Flashbang expire_t and repeat_expire_t to match other grenades
	self.projectiles.concussion.expire_t = self.projectiles.frag_com.expire_t

	-- Give Sicario's Smoke Grenade a sound when smoke is ready to use (like any cd-based throwables have)
	self.projectiles.smoke_screen_grenade.sounds = { cooldown = "perkdeck_cooldown_over" }

	-- Different trails for projectiles/throwables
	self.projectiles.poison_gas_grenade.add_trail_effect = "effects/particles/weapons/projectile_trail_green"

	-- Add a non-poison tipped Dart Gun dart
	self.projectiles.dart_arrow = deep_clone(self.projectiles.dart_poison)
	self.projectiles.dart_arrow.unit = "units/pd2_dlc_esp/weapons/wpn_prj_dart_arrow/wpn_prj_dart_arrow"
	self.projectiles.dart_arrow.local_unit = "units/pd2_dlc_esp/weapons/wpn_prj_dart_arrow/wpn_prj_dart_arrow_local"
	table.insert(self._projectiles_index, "dart_arrow")
		
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
end
