function PlayerTurret:_check_action_primary_attack(t, input)
	local new_action = nil
	local weap_base = self._turret_unit:base()
	local weapon_tweak_data = weap_base:weapon_tweak_data()

	if weap_base:clip_empty() then
		if input.btn_primary_attack_press then
			weap_base:dryfire()
		end

		self:_check_stop_shooting()

		return false
	end

	if input.btn_primary_attack_state and not self._shooting then
		if not weap_base:start_shooting_allowed() then
			self:_check_stop_shooting()

			return false
		end

		self:_check_start_shooting()
	end

	if input.btn_primary_attack_state then
		local suppression_ratio = self._ext_damage:effective_suppression_ratio()
		local spread_mul = math.lerp(1, tweak_data.player.suppression.spread_mul, suppression_ratio)
		local autohit_mul = math.lerp(1, tweak_data.player.suppression.autohit_chance_mul, suppression_ratio)
		local suppression_mul = managers.blackmarket:threat_multiplier()
		local dmg_mul = 1
		local primary_category = weapon_tweak_data.categories[1]

		if not weapon_tweak_data.ignore_damage_multipliers then
			dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "dmg_multiplier_outnumbered", 1)

			if managers.player:has_category_upgrade("player", "overkill_all_weapons") or weap_base:is_category("shotgun", "saw") then
				dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
			end

			local health_ratio = self._ext_damage:health_ratio()
			local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)

			if damage_health_ratio > 0 then
				local upgrade_name = weap_base:is_category("saw") and "melee_damage_health_ratio_multiplier" or "damage_health_ratio_multiplier"
				local damage_ratio = damage_health_ratio
				dmg_mul = dmg_mul * (1 + managers.player:upgrade_value("player", upgrade_name, 0) * damage_ratio)
			end

			dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
			dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
		end

		local fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
		new_action = true

		if fired then
			managers.rumble:play("weapon_fire")
			local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()

			local shake_tweak_data = weap_tweak_data.shake[fire_mode] or weap_tweak_data.shake
			local recoil_shake = linear_lerp(recoil_multiplier, 0.5, 3, 0.8, 1.2)
			local shake_multiplier = shake_tweak_data["fire_multiplier"] * recoil_shake

			if self._state_data.in_steelsight then
				self._ext_camera:play_shaker("fire_weapon_kick_steelsight", shake_multiplier, 1, 0.15)
			else
				self._ext_camera:play_shaker("fire_weapon_kick", shake_multiplier, 1, 0.15)
			end

			self._ext_camera:play_shaker("fire_weapon_recoil", 1 * shake_multiplier)

			if weapon_tweak_data.kick then
				recoil_multiplier = recoil_multiplier * 10
				local up, down, left, right = unpack(weapon_tweak_data.kick[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])

				self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
			end

			managers.hud:set_ammo_amount(2, weap_base:ammo_info())
			self._turret_unit:network():send("shot_player_turret", not fired.hit_enemy)
			weap_base:tweak_data_anim_stop("unequip")
			weap_base:tweak_data_anim_stop("equip")
			weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
		end
	end

	if not new_action then
		self:_check_stop_shooting()
	end

	return new_action
end
