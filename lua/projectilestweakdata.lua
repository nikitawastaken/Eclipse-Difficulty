local initproj_orig = BlackMarketTweakData._init_projectiles
function BlackMarketTweakData:_init_projectiles(tweak_data)
    initproj_orig(self, tweak_data)
    
    -- 45s injector cooldown
    self.projectiles.chico_injector.base_cooldown = 45
    -- 16s flask cooldown
    self.projectiles.damage_control.base_cooldown = 16
end