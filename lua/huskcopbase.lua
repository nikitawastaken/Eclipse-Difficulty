HuskCopBase._run_unit_sequences = CopBase._run_unit_sequences

Hooks:PreHook(HuskCopBase, "post_init", "eclipse_post_init", function(self)
	self:_run_unit_sequences()
end)

-- "Fuck clients apparently" (c) RedFlame
-- fixes cops on clients not derendering when they should
Hooks:PostHook(HuskCopBase, "post_init", "eclipse__post_init", function(self)
	self._allow_invisible = true
end)
