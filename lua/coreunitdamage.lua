-- Increase bulldozer armor health and increase planks durability (SH)
Hooks:PostHook(CoreBodyDamage, "init", "sh_init", function(self)
	if not self._body_element then
		return
	end

	if self._unit:base() and self._unit:base().has_tag and (self._unit:base():has_tag("tank") or self._unit:base():has_tag("tank_elite")) then
		local face_player_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.character.tank_armor_balance_mul)
		if not CoreBodyDamage._tank_armor_multiplier then
			CoreBodyDamage._tank_armor_multiplier = 1 / face_player_mul
		end
		self._body_element._damage_multiplier = self._body_element._name:find("glass") or CoreBodyDamage._tank_armor_multiplier
	elseif self._body_element._name == "planks_body" then
		self._body_element._damage_multiplier = 0.33
	end
end)
