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

		if managers.player:max_following_hostages() < 1 or following_hostages and managers.player:max_following_hostages() <= table.size(following_hostages) then
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

	if self.tweak_data == "hostage_move" and managers.player:max_following_hostages() < 1 then -- can't move hostages if you don't have the skill to do so
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

-- Hostage resource trade interaction
Hooks:PreHook(IntimitateInteractionExt, "interact", "eclipse_carry_interact", function(self, player)
	if not self:can_interact(player) then
		return
	end

	if self._tweak_data.sound_event then
		player:sound():play(self._tweak_data.sound_event)
	end

	if self._unit:damage() and self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact")
	end

	if self.tweak_data == "hostage_trade" then
		self._unit:brain():on_trade(player:position(), player:rotation(), true, true)
		if not NetworkHelper:IsHost() then
			NetworkHelper:SendToHostChunk(
				"Eclipse_HuskCopBrain:on_trade",
				NetworkHelper:encode({
					unit_id = self._unit:id(),
					position = player:position(),
					rotation = player:rotation(),
					is_custody_trade = true,
				})
			)
		else
			NetworkHelper:SendToPeersChunk(
				"Eclipse_HuskCopBrain:on_trade2",
				NetworkHelper:encode({
					position = player:position(),
					rotation = player:rotation(),
					is_custody_trade = true,
				})
			)
		end

		if managers.blackmarket:equipped_mask().mask_id == tweak_data.achievement.relation_with_bulldozer.mask then
			managers.achievment:award_progress(tweak_data.achievement.relation_with_bulldozer.stat)
		end

		managers.statistics:trade({
			name = self._unit:base()._tweak_table,
		})
	elseif self.tweak_data == "hostage_trade_resources" then
		self._unit:brain():on_trade(player:position(), player:rotation(), true, false)
		if not NetworkHelper:IsHost() then
			NetworkHelper:SendToHostChunk(
				"Eclipse_HuskCopBrain:on_trade",
				NetworkHelper:encode({
					unit_id = self._unit:id(),
					position = player:position(),
					rotation = player:rotation(),
					is_custody_trade = false,
				})
			)
		else
			NetworkHelper:SendToPeersChunk(
				"Eclipse_HuskCopBrain:on_trade2",
				NetworkHelper:encode({
					position = player:position(),
					rotation = player:rotation(),
					is_custody_trade = false,
				})
			)
		end

		if managers.blackmarket:equipped_mask().mask_id == tweak_data.achievement.relation_with_bulldozer.mask then
			managers.achievment:award_progress(tweak_data.achievement.relation_with_bulldozer.stat)
		end

		managers.statistics:trade({
			name = self._unit:base()._tweak_table,
		})
	end
end)

-- Carry stacker start
Hooks:PostHook(IntimitateInteractionExt, "interact", "eclipse_int_interact_ext", function(self, player)
	local has_carry_stacker = managers.player:upgrade_value_nil("player", "carry_stacker")
	if self.tweak_data == "intimidate" then
		self._unit:brain():on_tied(player, false, not managers.player:has_category_upgrade("player", "civilians_dont_flee"))
	elseif self.tweak_data == "corpse_dispose" and has_carry_stacker then
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
-- Carry stacker end


-- Extra drill upgrades
function MissionDoorDeviceInteractionExt:server_place_mission_door_device(player, sender)
	local can_place = not self._unit:mission_door_device() or self._unit:mission_door_device():can_place()

	if sender then
		sender:result_place_mission_door_device(self._unit, can_place)
	else
		self:result_place_mission_door_device(can_place)
	end

	local network_session = managers.network:session()

	self:remove_interact()

	local is_saw = self._unit:base() and self._unit:base().is_saw
	local is_drill = self._unit:base() and self._unit:base().is_drill

	if is_saw or is_drill then
		local user_unit = nil

		if player and player:base() and not player:base().is_local_player then
			user_unit = player
		end

		local upgrades = Drill.get_upgrades(self._unit, user_unit)

		self._unit:base():set_skill_upgrades(upgrades)
		network_session:send_to_peers_synched("sync_drill_upgrades", self._unit, upgrades.auto_repair_level_1, upgrades.auto_repair_level_2, upgrades.speed_upgrade_level, upgrades.silent_drill, upgrades.reduced_alert, upgrades.electrocuting_drill)
	end

	if self._unit:damage() then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player
		})
	end

	network_session:send_to_peers_synched("sync_interacted", self._unit, -2, self.tweak_data, 1)
	self:set_active(false)
	self:check_for_upgrade()

	if self._unit:mission_door_device() then
		self._unit:mission_door_device():placed()
	end

	if self._tweak_data.sound_event then
		player:sound():play(self._tweak_data.sound_event)
	end

	return can_place
end