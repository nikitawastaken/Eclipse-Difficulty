function BaseInteractionExt:_get_timer()
	local modified_timer = self:_get_modified_timer()

	if modified_timer then
		return modified_timer
	end

	local multiplier = 1

	if self.tweak_data ~= "corpse_alarm_pager" then
		multiplier = multiplier * managers.player:crew_ability_upgrade_value("crew_interact", 1)
	end

	if self._tweak_data.upgrade_timer_multiplier then
		multiplier = multiplier * managers.player:upgrade_value(self._tweak_data.upgrade_timer_multiplier.category, self._tweak_data.upgrade_timer_multiplier.upgrade, 1)
	end

	if self._tweak_data.upgrade_timer_multipliers then
		for _, upgrade_timer_multiplier in pairs(self._tweak_data.upgrade_timer_multipliers) do
			multiplier = multiplier * managers.player:upgrade_value(upgrade_timer_multiplier.category, upgrade_timer_multiplier.upgrade, 1)
		end
	end

	multiplier = multiplier * managers.player:upgrade_value("player", "total_interaction_timer_multiplier", 1)

	return self:_timer_value() * multiplier * managers.player:toolset_value()
end

function IntimitateInteractionExt:_interact_blocked(player)
	if self.tweak_data == "corpse_dispose" then
		if managers.player:get_bags_carried() > 1 then
			return true
		end

		if managers.player:chk_body_bags_depleted() then
			return true, nil, "body_bag_limit_reached"
		end

		local has_upgrade = managers.player:has_category_upgrade("player", "corpse_dispose")

		if not has_upgrade then
			return true
		end

		return not managers.player:can_carry("person")
	elseif self.tweak_data == "hostage_convert" then
		return not managers.player:has_category_upgrade("player", "convert_enemies") or managers.player:chk_minion_limit_reached() or managers.groupai:state():whisper_mode()
	elseif self.tweak_data == "hostage_move" then
		if not self._unit:anim_data().tied then
			return true
		end

		local following_hostages = managers.groupai:state():get_following_hostages(player)

		if tweak_data.player.max_nr_following_hostages < 1 or following_hostages and tweak_data.player.max_nr_following_hostages <= table.size(following_hostages) then
			return true, nil, "hint_hostage_follow_limit"
		end
	elseif self.tweak_data == "hostage_stay" then
		return not self._unit:anim_data().stand or self._unit:anim_data().to_idle
	end
end

function BaseInteractionExt:can_interact(player)
	if self._host_only and not Network:is_server() then
		return false
	end

	if self._disabled then
		return false
	end

	if self.tweak_data == "hostage_move" and tweak_data.player.max_nr_following_hostages < 1 then -- can't move hostages if you don't have the skill to do so
		return false
	end

	if not self:_has_required_upgrade(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if not self:_has_required_deployable() then
		return false
	end

	if not self:_is_in_required_state(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if self._tweak_data.special_equipment_block and managers.player:has_special_equipment(self._tweak_data.special_equipment_block) then
		return false
	end

	if not self._tweak_data.special_equipment or self._tweak_data.dont_need_equipment then
		return true
	end

	return managers.player:has_special_equipment(self._tweak_data.special_equipment)
end

-- Carry stacker start
Hooks:PostHook(IntimitateInteractionExt, "interact", "eclipse_int_interact_ext", function(self, player)
	local has_carry_stacker = managers.player:upgrade_value_nil("player", "carry_stacker")
	if self.tweak_data == "corpse_dispose" and has_carry_stacker then
		if managers.player:get_bags_carried() < 2 then
			player:movement():set_carry_restriction(false)
		end
	end
end)

Hooks:PostHook(CarryInteractionExt, "interact", "eclipse_carry_interact", function(self, player)
	local has_carry_stacker = managers.player:upgrade_value_nil("player", "carry_stacker")
	if has_carry_stacker then
		if managers.player:get_bags_carried() < 2 then
			if Network:is_client() then
				player:movement():set_carry_restriction(false)
			end
		end
	end
end)

function CarryInteractionExt:_interact_blocked(player)
	local silent_block = managers.player:carry_blocked_by_cooldown() or self._unit:carry_data():is_attached_to_zipline_unit()

	local has_carry_stacker = managers.player:upgrade_value_nil("player", "carry_stacker")
	local can_carry_stack = has_carry_stacker and (managers.player:get_bags_carried() < 2)
	if silent_block then
		return true, silent_block
	end
	if can_carry_stack then
		return false
	elseif managers.player:is_carrying() then
		return true, silent_block
	end

	return false
end

function CarryInteractionExt:can_select(player)
	if managers.player:carry_blocked_by_cooldown() or self._unit:carry_data():is_attached_to_zipline_unit() then
		return false
	end

	local has_carry_stacker = managers.player:upgrade_value_nil("player", "carry_stacker")
	local can_carry_stack = has_carry_stacker and (managers.player:get_bags_carried() < 2)
	if not can_carry_stack and managers.player:is_carrying() then
		return false
	end

	return CarryInteractionExt.super.can_select(self, player)
end

function DrivingInteractionExt:can_interact(player)
	local can_interact = DrivingInteractionExt.super.can_interact(self, player)
	local can_enter_with_carry = false

	if managers.player:is_carrying() then
		local carry_list = managers.player:get_my_carry_data()

		if carry_list and carry_list[1] then
			local carry_data = carry_list[1]
			local carry_tweak_data = tweak_data.carry[carry_data.carry_id]
			local skip_exit_secure = carry_tweak_data and carry_tweak_data.skip_exit_secure
			local vehicle_ext = self._unit and self._unit:vehicle_driving()
			local secure_carry_on_enter = vehicle_ext and vehicle_ext.secure_carry_on_enter
			can_enter_with_carry = secure_carry_on_enter and not skip_exit_secure
		end

		if carry_list and carry_list[2] then
			local carry_data = carry_list[2]
			local carry_tweak_data = tweak_data.carry[carry_data.carry_id]
			local skip_exit_secure = carry_tweak_data and carry_tweak_data.skip_exit_secure
			local vehicle_ext = self._unit and self._unit:vehicle_driving()
			local secure_carry_on_enter = vehicle_ext and vehicle_ext.secure_carry_on_enter
			can_enter_with_carry = can_enter_with_carry or (secure_carry_on_enter and not skip_exit_secure)
		end
	end

	if can_interact and managers.player:is_berserker() and self._action ~= VehicleDrivingExt.INTERACT_LOOT and self._action ~= VehicleDrivingExt.INTERACT_TRUNK then
		can_interact = false

		managers.hud:show_hint({
			time = 2,
			text = managers.localization:text("hud_vehicle_no_enter_berserker"),
		})
	elseif can_interact and managers.player:is_carrying() and not can_enter_with_carry then
		if self._action == VehicleDrivingExt.INTERACT_ENTER or self._action == VehicleDrivingExt.INTERACT_DRIVE then
			can_interact = false

			managers.hud:show_hint({
				time = 3,
				text = managers.localization:text("hud_vehicle_no_enter_carry"),
			})
		elseif self._action == VehicleDrivingExt.INTERACT_LOOT then
			can_interact = false
		end
	end

	return can_interact
end

function DrivingInteractionExt:interact(player, locator)
	if locator == nil then
		return false
	end

	DrivingInteractionExt.super.super.interact(self, player)

	local vehicle_ext = self._unit:vehicle_driving()
	local success = false
	local action = vehicle_ext:get_action_for_interaction(player:position(), locator)

	if action == VehicleDrivingExt.INTERACT_ENTER or action == VehicleDrivingExt.INTERACT_DRIVE then
		success = managers.player:enter_vehicle(self._unit, locator)
	elseif action == VehicleDrivingExt.INTERACT_LOOT then
		success = vehicle_ext:give_vehicle_loot_to_player(managers.network:session():local_peer():id())
	elseif action == VehicleDrivingExt.INTERACT_REPAIR then
		vehicle_ext:repair_vehicle()
	elseif action == VehicleDrivingExt.INTERACT_TRUNK then
		vehicle_ext:interact_trunk()
	end

	return success
end
-- Cary stacker end
