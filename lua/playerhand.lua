function PlayerHand:set_carry(carry, skip_hand)
	self._carry = carry

	if carry then
		managers.hud:belt():set_state("bag", skip_hand and "default" or "active")

		if not skip_hand then
			local carry_data = managers.player:get_my_carry_data()
			local carry_id = carry_data[#carry_data].carry_id
			local unit_name = tweak_data.carry[carry_id].unit

			if unit_name then
				unit_name = string.match(unit_name, "/([^/]*)$")
				unit_name = "units/pd2_dlc_vr/equipment/" .. unit_name .. "_vr"
			else
				unit_name = "units/pd2_dlc_vr/equipment/gen_pku_lootbag_vr"
			end

			local hand_id = self._unit_movement_ext:current_state()._interact_hand or self:interaction_ids()[1]
			local hand_unit = self:hand_unit(hand_id)
			local unit = World:spawn_unit(Idstring(unit_name), hand_unit:position(), hand_unit:rotation() * Rotation(0, 0, -90))

			self:_set_hand_state(hand_id, "item", {
				body = "hinge_body_1",
				type = "bag",
				unit = unit,
				offset = Vector3(0, 15, 0),
				prompt = {
					text_id = "hud_instruct_throw_bag",
					btn_macros = {
						BTN_USE_ITEM = "use_item_vr",
					},
				},
			})
		end
	else
		managers.hud:belt():set_state("bag", "inactive")

		local bag_hand = self:get_active_hand_id("bag")

		if bag_hand then
			self:_change_hand_to_default(bag_hand)
		end
	end
end
