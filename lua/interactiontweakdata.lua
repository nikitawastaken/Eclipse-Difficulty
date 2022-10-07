Hooks:PostHook(InteractionTweakData, "init", "eclipse_init", function (self)
    self.revive.timer = 4.5
    self.drill_upgrade.timer = 0
    self.lance_upgrade.timer = 0
    self.gen_int_saw_upgrade.timer = 0
end)