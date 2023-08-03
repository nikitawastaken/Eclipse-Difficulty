-- fixes civilians not derendering on hosts end when they should
Hooks:PostHook(CivilianBase, "post_init", "eclipse_post_init", function(self)
	self._allow_invisible = true
end)
