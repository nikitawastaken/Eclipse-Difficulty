-- Increase bulldozer armor health (SH)
Hooks:PostHook(CoreBodyDamage, "init", "sh_init", function (self)
	if self._body_element and self._unit:base() and self._unit:base().has_tag and self._unit:base():has_tag("tank") then
		self.tank_face_balance_mul = {3, 4, 5, 6}
		local face_player_mul = managers.groupai:state():_get_balancing_multiplier(self.tank_face_balance_mul)
		if not CoreBodyDamage._tank_armor_multiplier then
			CoreBodyDamage._tank_armor_multiplier = 1 / face_player_mul
			CoreBodyDamage._tank_glass_multiplier = 1 / (face_player_mul * 2 / 3)
		end
		self._body_element._damage_multiplier = self._body_element._name:find("glass") and CoreBodyDamage._tank_glass_multiplier or CoreBodyDamage._tank_armor_multiplier
	end
end)