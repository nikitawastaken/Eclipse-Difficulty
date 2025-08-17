-- Properly load secondary weapons from factory IDs
function HuskTeamAIMovement:add_weapons()
	local weapon = self._ext_base:default_weapon_name("primary")
	local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
	
	local sec_weap_name = self._ext_base:default_weapon_name("secondary")
	local _ = sec_weap_name and self._unit:inventory():add_unit_by_factory_name(sec_weap_name, false, false, nil, "")
end