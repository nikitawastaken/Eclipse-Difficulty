-- disable leg hitboxes for shields
HuskCopBase.shield_tweak_names = {
	shield = true,
	phalanx_minion = true,
}

Hooks:PreHook(HuskCopBase, "post_init", "sh_post_init", function(self)
	if self.shield_tweak_names[self._tweak_table] then
		self.enable_leg_arm_hitbox = function() end
	end
end)

-- "Fuck clients apparently" (c) RedFlame
-- fixes cops on clients not derendering when they should
Hooks:PostHook(HuskCopBase, "post_init", "eclipse__post_init", function(self)
	self._allow_invisible = true
end)

-- fix yufu wang hitbox
Hooks:PostHook(HuskCopBase, "post_init", "hitbox_fix_post_init", function(self)
	if self._tweak_table == "triad_boss" then
		self._unit:body("head"--[[self._unit:character_damage()._head_body_name--]]):set_sphere_radius(16)
		self._unit:body("body"):set_sphere_radius(22)

		self._unit:body("rag_LeftArm"):set_enabled(true)
		self._unit:body("rag_LeftForeArm"):set_enabled(true)

		self._unit:body("rag_RightArm"):set_enabled(true)
		self._unit:body("rag_RightForeArm"):set_enabled(true)

		self._unit:body("rag_LeftArm"):set_sphere_radius(11)
		self._unit:body("rag_LeftForeArm"):set_sphere_radius(7)
		self._unit:body("rag_RightArm"):set_sphere_radius(11)
		self._unit:body("rag_RightForeArm"):set_sphere_radius(7)

		self._unit:body("rag_LeftUpLeg"):set_sphere_radius(10)
		self._unit:body("rag_LeftLeg"):set_sphere_radius(7)
		self._unit:body("rag_RightUpLeg"):set_sphere_radius(10)
		self._unit:body("rag_RightLeg"):set_sphere_radius(7)
	end
end)
