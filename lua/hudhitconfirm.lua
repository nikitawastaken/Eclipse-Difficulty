Hooks:PostHook(HUDHitConfirm, "init", "eclipse_hudhitconfirm_init", function(self)
	self._ff_confirm = self._hud_panel:bitmap({
		texture = "guis/textures/pd2/hitconfirm",
		name = "hit_confirm",
		halign = "center",
		visible = false,
		layer = 0,
		blend_mode = "add",
		valign = "center",
		color = Color.red,
	})

	self._ff_confirm:set_center(self._hud_panel:w() / 2, self._hud_panel:h() / 2)
end)

function HUDHitConfirm:on_ff_confirmed()
	self._ff_confirm:stop()
	self._ff_confirm:animate(callback(self, self, "_animate_show"), callback(self, self, "show_done"), 0.25, 1)
end
