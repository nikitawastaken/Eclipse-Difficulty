function AmmoClip:_pickup(unit)
	if self._picked_up then
		return
	end

	local player_manager = managers.player
	local inventory = unit:inventory()
	local has_cable_tie_pickup = player_manager:has_category_upgrade("cable_tie", "pickup_chance")

	if not unit:character_damage():dead() and inventory then
		local picked_up = false

		if self._projectile_id then
			if managers.blackmarket:equipped_projectile() == self._projectile_id and not player_manager:got_max_grenades() then
				player_manager:add_grenade_amount(self._ammo_count or 1)

				picked_up = true
			end
		else
			local available_selections = {}

			for i, weapon in pairs(inventory:available_selections()) do
				if inventory:is_equipped(i) then
					table.insert(available_selections, 1, weapon)
				else
					table.insert(available_selections, weapon)
				end
			end

			local success, add_amount = nil

			for _, weapon in ipairs(available_selections) do
				if not self._weapon_category or self._weapon_category == weapon.unit:base():weapon_tweak_data().categories[1] then
					success, add_amount = weapon.unit:base():add_ammo(1, self._ammo_count)
					picked_up = success or picked_up

					if self._ammo_count then
						self._ammo_count = math.max(math.floor(self._ammo_count - add_amount), 0)
					end

					if picked_up and tweak_data.achievement.pickup_sticks and self._weapon_category == tweak_data.achievement.pickup_sticks.weapon_category then
						managers.achievment:award_progress(tweak_data.achievement.pickup_sticks.stat)
					end
				end
			end
		end

		if picked_up then
			self._picked_up = true

			if has_cable_tie_pickup then
				local rand = math.random()
				local chance = player_manager:upgrade_value("cable_tie", "pickup_chance", 0) or 0
				local amount = 1

				if rand <= chance and self._ammo_box then
					player_manager:add_cable_ties(amount)
				end
			end

			if not self._projectile_id and not self._weapon_category then
				if not unit:character_damage():is_downed() and player_manager:has_category_upgrade("player", "pickup_restore_health") then
					local health_to_restore = player_manager:upgrade_value("player", "pickup_restore_health", 0)
					local damage_ext = unit:character_damage()

					if not damage_ext:need_revive() and not damage_ext:dead() and not damage_ext:is_berserker() then
						damage_ext:restore_health(health_to_restore, true)
						unit:sound():play("pickup_ammo_health_boost", nil, true)
					end

					if player_manager:has_category_upgrade("player", "pickup_restore_team_health") then
						managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "pickup", health_to_restore)
					end
				end

				if player_manager:has_category_upgrade("player", "pickup_restore_team_ammo") then
					managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "pickup", AmmoClip.EVENT_IDS.bonnie_share_ammo)
				end
			elseif self._projectile_id then
				player_manager:register_grenade(managers.network:session():local_peer():id())
				managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "pickup", AmmoClip.EVENT_IDS.register_grenade)
			end

			if Network:is_client() then
				managers.network:session():send_to_host("sync_pickup", self._unit)
			end

			unit:sound():play(self._pickup_event or "pickup_ammo", nil, true)
			self:consume()

			if self._ammo_box then
				player_manager:send_message(Message.OnAmmoPickup, nil, unit)
			end

			return true
		end
	end

	return false
end

function AmmoClip:sync_net_event(event, peer)
	local player = managers.player:local_player()

	if not alive(player) or not player:character_damage() or player:character_damage():is_downed() or player:character_damage():dead() then
		return
	end
	Eclipse:log_chat("sync net event received, event: " .. event)

	if event == AmmoClip.EVENT_IDS.bonnie_share_ammo then
		Eclipse:log_chat("first ammo restore check passed")
		local inventory = player:inventory()

		if inventory then
			local picked_up = false

			for id, weapon in pairs(inventory:available_selections()) do
				picked_up = weapon.unit:base():add_ammo(tweak_data.upgrades.loose_ammo_give_team_ratio or 0.25) or picked_up
			end

			if picked_up then
				player:sound():play(self._pickup_event or "pickup_ammo", nil, true)

				for id, weapon in pairs(inventory:available_selections()) do
					managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
				end
				Eclipse:log_chat("client restored ammo")
			end
		end
	elseif event == AmmoClip.EVENT_IDS.register_grenade then
		if peer and not self._grenade_registered then
			managers.player:register_grenade(peer:id())

			self._grenade_registered = true
		end
	elseif event < AmmoClip.EVENT_IDS.bonnie_share_ammo then
		Eclipse:log_chat("first health restore check passed")
		local damage_ext = player:character_damage()

		if not damage_ext:need_revive() and not damage_ext:dead() and not damage_ext:is_berserker() then
			Eclipse:log_chat("playerstate checks passed")
			local health_to_restore = event * (tweak_data.upgrades.loose_health_give_team_ratio or 0.5)

			if damage_ext:restore_health(health_to_restore, true, true) then
				player:sound():play("pickup_ammo_health_boost", nil, true)
				Eclipse:log_chat("client restored health")
			end
		end
	end
end