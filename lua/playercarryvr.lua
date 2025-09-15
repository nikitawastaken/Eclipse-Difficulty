function PlayerCarryVR:_can_run()
	local can_run = true
	for _, name in pairs(self._tweak_data_name) do
		if tweak_data.carry.types[name] and not tweak_data.carry.types[name].can_run then
			can_run = false
			break
		end
	end

	return can_run or managers.player:has_category_upgrade("carry", "movement_penalty_nullifier")
end

function PlayerCarryVR:_check_use_item(t, input)
	if not input.btn_throw_bag_press then
		return PlayerStandard._check_use_item(self, t, input)
	end

	managers.player:drop_carry()
	managers.player:player_unit():movement():current_state():set_throwing_projectile(self._unit:hand():get_active_hand_id("bag"))
	return true
end
