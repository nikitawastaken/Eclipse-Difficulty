HuskCopBase._run_unit_sequences = CopBase._run_unit_sequences
HuskCopBase.cloaker_light_RGB = CopBase.cloaker_light_RGB
HuskCopBase._set_cloaker_light_color = CopBase._set_cloaker_light_color

Hooks:PreHook(HuskCopBase, "post_init", "eclipse_pre_post_init", function(self)
	self:_run_unit_sequences()

	-- Always glow cloakers (like in PDTH)
	-- This should already be handled by networking, but may as well turn them on immediately for clients
	self:set_cloaker_goggles_on(true)

	self:_set_cloaker_light_color()
end)

-- "Fuck clients apparently" (c) RedFlame
-- fixes cops on clients not derendering when they should
Hooks:PostHook(HuskCopBase, "post_init", "eclipse_post_post_init", function(self)
	self._allow_invisible = true
end)
