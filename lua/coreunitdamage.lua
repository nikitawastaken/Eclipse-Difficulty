-- Increase bulldozer armor health (SH)
Hooks:PostHook(CoreBodyDamage, "init", "sh_init", function (self)
	if self._body_element and self._unit:base() and self._unit:base().has_tag and (self._unit:base():has_tag("tank") or self._unit:base():has_tag("tank_elite")) then
		local face_player_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.character.tank_armor_balance_mul)
		if not CoreBodyDamage._tank_armor_multiplier then
			CoreBodyDamage._tank_armor_multiplier = 1 / face_player_mul
		end
		self._body_element._damage_multiplier = self._body_element._name:find("glass") or CoreBodyDamage._tank_armor_multiplier
	end
end)