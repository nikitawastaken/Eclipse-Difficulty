-- "Fuck clients apparently" (c) RedFlame
-- fixes cops on clients not derendering when they should
Hooks:PostHook(HuskCopBase, "post_init", "eclipse__post_init", function(self)
    self._allow_invisible = true
end)