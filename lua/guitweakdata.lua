Hooks:PostHook(GuiTweakData, "init", "eclipse_init", function(self)
    self.buy_weapon_categories = {
        primaries = {
            {
                "assault_rifle"
            },
            {
                "shotgun"
            },
            {
                "lmg"
            },
            {
                "snp"
            },
            {
                "akimbo"
            },
            {
                "wpn_special"
            }
        },
        secondaries = {
            {
                "pistol"
            },
            {
                "smg"
            },
            {
                "shotgun"
            },
            {
                "snp"
            },
            {
                "wpn_special"
            }
        }
    }
    end)