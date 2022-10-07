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
	self.projectiles.frag.max_amount = 5
    self.projectiles.frag_com.max_amount = 5
    self.projectiles.dada_com.max_amount = 5
    self.projectiles.dynamite.max_amount = 5
    self.projectiles.concussion.max_amount = 5
    self.projectiles.fir_com.max_amount = 5
    self.projectiles.molotov.max_amount = 5
    self.projectiles.poison_gas_grenade.max_amount = 5
    self.projectiles.wpn_gre_electric.max_amount = 5
end
