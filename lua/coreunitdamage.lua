-- Increase bulldozer armor health and increase planks durability (SH)
Hooks:PostHook(CoreBodyDamage, "init", "eclipse_init", function(self)
	if self._unit:character_damage() and self._unit:character_damage().IS_TANK then
		local tank_balance_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.character.tank_armor_health_balance_mul)
		
		local armor_health = tweak_data.character[self._unit:base()._tweak_table].damage.armor_health

		if not armor_health then
			-- nothing
		elseif self._body_element._name == "body_helmet_plate" then
			self._endurance["explosion"]["_endurance"]["damage"] = armor_health * tank_balance_mul
		elseif self._body_element._name == "body_helmet_glass" then
			self._endurance["explosion"]["_endurance"]["damage"] = (armor_health / 2) * tank_balance_mul
		else
			self._endurance["explosion"]["_endurance"]["damage"] = (armor_health / 3) * tank_balance_mul
		end
	end
	
	if not self._body_element then
		return
	end

	if self._body_element._name == "held_body_middle" or self._body_element._name == "held_body_left" or self._body_element._name == "held_body_right" or self._body_element._name == "held_body_top" then
		local shield_balance_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.character.shield_health_balance_mul)

		self._body_element._damage_multiplier = math.min(1 / shield_balance_mul, 1) or self._body_element._damage_multiplier
	elseif self._body_element._name == "planks_body" then
		self._body_element._damage_multiplier = 0.4
	end
end)
