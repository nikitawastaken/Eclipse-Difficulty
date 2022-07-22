Hooks:PostHook(NewFlamethrowerBase, "setup_default", "eclipse_setup_default", function(self)
    if Global.game_settings and Global.game_settings.one_down then self._bullet_slotmask = self._bullet_slotmask + 3 end
end)