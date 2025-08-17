-- Apply default carry speed upgrade to bots
function TeamAIMovement:set_carry_speed_modifier(...)
	TeamAIMovement.super.set_carry_speed_modifier(self, ...)

	if self._carry_speed_modifier then
		local carry_upgrade = managers.player:upgrade_value("carry", "movement_speed_multiplier", 1)
		self._carry_speed_modifier = math.clamp(self._carry_speed_modifier * carry_upgrade, 0, 1)
	end
end

-- Properly load secondary weapons from factory IDs
function TeamAIMovement:add_weapons()
	if Network:is_server() then
		local char_name = self._ext_base._tweak_table
		local loadout = managers.criminals:get_loadout_for(char_name)
		local crafted = managers.blackmarket:get_crafted_category_slot("primaries", loadout.primary_slot)

		if crafted then
			self._unit:inventory():add_unit_by_factory_blueprint(loadout.primary, false, false, crafted.blueprint, crafted.cosmetics)
		elseif loadout.primary then
			self._unit:inventory():add_unit_by_factory_name(loadout.primary, false, false, nil, "")
		else
			local weapon = self._ext_base:default_weapon_name("primary")
			local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
		end

		local sec_weap_name = self._ext_base:default_weapon_name("secondary")
		local _ = sec_weap_name and self._unit:inventory():add_unit_by_factory_name(sec_weap_name, false, false, nil, "")
	else
		TeamAIMovement.super.add_weapons(self)
	end
end
