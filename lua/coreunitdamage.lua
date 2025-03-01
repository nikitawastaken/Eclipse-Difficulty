-- Increase bulldozer armor health and increase planks durability (SH)
Hooks:PostHook(CoreBodyDamage, "init", "eclipse_init", function(self)
	if not self._body_element then
		return
	end

	if self._unit:character_damage() and self._unit:character_damage().IS_TANK then
		local tank_balance_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.character.tank_armor_balance_mul)
		local dmg_mul = tweak_data.character[self._unit:base()._tweak_table].armor_damage_mul

		if not dmg_mul then
			-- nothing
		elseif self._body_element._name:find("glass") then
			local glass_dmg_mul = math.min(2 * dmg_mul, 1)

			self._body_element._damage_multiplier = math.min(glass_dmg_mul / tank_balance_mul, 1) or self._body_element._damage_multiplier
		else
			local armor_dmg_mul = dmg_mul

			self._body_element._damage_multiplier = math.min(armor_dmg_mul / tank_balance_mul, 1) or self._body_element._damage_multiplier
		end
	elseif
		self._body_element._name == "held_body_middle"
		or self._body_element._name == "held_body_left"
		or self._body_element._name == "held_body_right"
		or self._body_element._name == "held_body_top"
	then
		local shield_balance_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.character.elite_shield_balance_mul)

		self._body_element._damage_multiplier = math.min(1 / shield_balance_mul, 1) or self._body_element._damage_multiplier
	elseif self._body_element._name == "planks_body" then
		self._body_element._damage_multiplier = 0.33
	end
end)
