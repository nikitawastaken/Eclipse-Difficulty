local function linear_lerp(x, in_min, in_max, out_min, out_max)
	return Eclipse.utils.linear_lerp(x, in_min, in_max, out_min, out_max)
end

function PlayerStandardVR:_check_fire_per_weapon(t, pressed, held, released, weap_base, akimbo)
	local action_wanted = pressed or held or released
	action_wanted = action_wanted or self:is_shooting_count()
	action_wanted = action_wanted or self:_is_charging_weapon()

	if not action_wanted then
		return false
	end

	local new_action = false
	local start_shooting = false
	local fire_mode = weap_base:fire_mode()
	local fire_on_release = weap_base:fire_on_release()

	if weap_base:out_of_ammo() or self:_is_reloading() then
		if pressed then
			weap_base:dryfire()
		end
	elseif weap_base.clip_empty and weap_base:clip_empty() then
		if self:_interacting() then
			return false
		end

		local should_reload_immediately = self._equipped_unit:base().should_reload_immediately and self._equipped_unit:base():should_reload_immediately()

		if self:_is_using_bipod() or not managers.vr:get_setting("auto_reload") and not should_reload_immediately then
			if pressed then
				weap_base:dryfire()
			end

			weap_base:tweak_data_anim_stop("fire")
		elseif fire_mode == "single" then
			if pressed or should_reload_immediately then
				self:_start_action_reload_enter(t)
			end
		else
			new_action = true

			self:_start_action_reload_enter(t)
		end
	else
		if self._running and not self._equipped_unit:base():run_and_shoot_allowed() then
			self:_interupt_action_running(t)
		end

		if not self._shooting or not self._shooting_weapons or not self._shooting_weapons[akimbo and 2 or 1] then
			if not self._next_wall_check_t or self._next_wall_check_t < t then
				local wall_check_obj = tweak_data.vr.custom_wall_check[weap_base.name_id] and weap_base._unit:get_object(Idstring(tweak_data.vr.custom_wall_check[weap_base.name_id])) or weap_base:fire_object()
				self._shooting_forbidden = self._unit:hand():check_hand_through_wall(self._unit:hand():get_active_hand_id(akimbo and "akimbo" or "weapon"), wall_check_obj)
				local weapon_tweak = weap_base:weapon_tweak_data()
				local delay = weapon_tweak.auto and weapon_tweak.auto.fire_rate or tweak_data.vr.wall_check_delay
				self._next_wall_check_t = t + delay
			end

			if weap_base:start_shooting_allowed() and not self._shooting_forbidden then
				local start = fire_mode == "single" and pressed
				start = start or fire_mode == "auto" and held
				start = start or fire_mode == "burst" and pressed
				start = start or fire_mode == "volley" and pressed
				start = start and not fire_on_release
				start = start or fire_on_release and released

				if start then
					weap_base:start_shooting()
					self._camera_unit:base():start_shooting()

					self._shooting = true
					self._shooting_weapons = self._shooting_weapons or {}
					self._shooting_weapons[akimbo and 2 or 1] = weap_base
					self._shooting_t = t
					start_shooting = true

					if fire_mode == "auto" and (not weap_base.third_person_important or weap_base.third_person_important and not weap_base:third_person_important()) then
						self._ext_network:send("sync_start_auto_fire_sound", akimbo and 1 or 0)
					end
				end
			else
				return false
			end
		end

		local suppression_ratio = self._unit:character_damage():effective_suppression_ratio()
		local spread_mul = math.lerp(1, tweak_data.player.suppression.spread_mul, suppression_ratio)
		local autohit_mul = math.lerp(1, tweak_data.player.suppression.autohit_chance_mul, suppression_ratio)
		local suppression_mul = managers.blackmarket:threat_multiplier()
		local dmg_mul = managers.player:temporary_upgrade_value("temporary", "dmg_multiplier_outnumbered", 1)

		if managers.player:has_category_upgrade("player", "overkill_all_weapons") or weap_base:is_category("shotgun", "saw") then
			dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
		end

        if weap_base:is_category("revolver", "pistol") then
            if managers.player:has_activate_temporary_upgrade("temporary", "sidearm_pullout_damage_multiplier") then
                dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "sidearm_pullout_damage_multiplier", 1)
            end

            if managers.player:has_activate_temporary_upgrade("temporary", "sidearm_reload_damage_multiplier") then
                dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "sidearm_reload_damage_multiplier", 1)
            end
        end

		local health_ratio = self._ext_damage:health_ratio()
		local primary_category = weap_base:weapon_tweak_data().categories[1]
		local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)

		if damage_health_ratio > 0 then
			local upgrade_name = weap_base:is_category("saw") and "melee_damage_health_ratio_multiplier" or "damage_health_ratio_multiplier"
			local damage_ratio = damage_health_ratio
			dmg_mul = dmg_mul * (1 + managers.player:upgrade_value("player", upgrade_name, 0) * damage_ratio)
		end

		dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
		dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
		local fired = nil

		if fire_mode == "single" then
			if pressed and start_shooting then
				fired = weap_base:trigger_pressed(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
			elseif fire_on_release then
				if released then
					fired = weap_base:trigger_released(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)

					if fired then
						self:_start_action_reload_enter(t)
					end
				elseif held then
					weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
				end
			end
		elseif fire_mode == "burst" then
			fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
		elseif fire_mode == "volley" then
			if self._shooting then
				fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
			end
		elseif held then
			if not self._next_wall_check_t or self._next_wall_check_t < t then
				local wall_check_obj = tweak_data.vr.custom_wall_check[weap_base.name_id] and weap_base._unit:get_object(Idstring(tweak_data.vr.custom_wall_check[weap_base.name_id])) or weap_base:fire_object()
				self._shooting_forbidden = self._unit:hand():check_hand_through_wall(self._unit:hand():get_active_hand_id(akimbo and "akimbo" or "weapon"), wall_check_obj)
				self._next_wall_check_t = t + tweak_data.vr.wall_check_delay
			end

			if not self._shooting_forbidden then
				fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
			end
		end

		local charging_weapon = weap_base:charging() and not table.contains(weap_base:weapon_tweak_data().categories, "bow")

		if not self._state_data.charging_weapon and charging_weapon then
			self:_start_action_charging_weapon(t)
		elseif self._state_data.charging_weapon and not charging_weapon then
			self:_end_action_charging_weapon(t)
		end

		new_action = true

		if fired then
			local engine = self._unit:hand():get_active_hand_id(akimbo and "akimbo" or "weapon") == 1 and "right" or "left"

			managers.rumble:play("weapon_fire", nil, nil, {
				engine = engine
			})

			local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()
			local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
            local shake_tweak_data = weap_tweak_data.shake[fire_mode] or weap_tweak_data.shake
            local recoil_shake = linear_lerp(recoil_multiplier, 0.5, 3, 0.8, 1.2)
            local shake_multiplier = shake_tweak_data["fire_multiplier"] * recoil_shake

            if self._state_data.in_steelsight then
                self._ext_camera:play_shaker("fire_weapon_kick_steelsight", shake_multiplier, 1, 0.15)
            else
                self._ext_camera:play_shaker("fire_weapon_kick", shake_multiplier, 1, 0.15)
            end

            self._ext_camera:play_shaker("fire_weapon_recoil", 1 * shake_multiplier)

			self._ext_camera:play_shaker("fire_weapon_rot", 1 * shake_multiplier)
			self._ext_camera:play_shaker("fire_weapon_kick", 1 * shake_multiplier, 1, 0.15)
			weap_base:tweak_data_anim_stop("unequip")
			weap_base:tweak_data_anim_stop("equip")
			weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())

			if fire_mode == "single" and weap_base:get_name_id() ~= "saw" then
				if not self._state_data.in_steelsight then
					self._ext_camera:play_redirect(self:get_animation("recoil"), weap_base:fire_rate_multiplier())
				elseif weap_tweak_data.animations.recoil_steelsight then
					self._ext_camera:play_redirect(weap_base:is_second_sight_on() and self:get_animation("recoil") or self:get_animation("recoil_steelsight"), 1)
				end
			end

			local kick_tweak_data = weap_tweak_data.kick[fire_mode] or weap_tweak_data.kick
			local up, down, left, right = unpack(kick_tweak_data[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])

			self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
			self._unit:hand():apply_weapon_kick(weap_base._current_stats.recoil, akimbo)

			if self._shooting_t then
				local time_shooting = t - self._shooting_t
				local achievement_data = tweak_data.achievement.never_let_you_go

				if achievement_data and weap_base:get_name_id() == achievement_data.weapon_id and achievement_data.timer <= time_shooting then
					managers.achievment:award(achievement_data.award)

					self._shooting_t = nil
				end
			end

			if managers.player:has_category_upgrade(primary_category, "stacking_hit_damage_multiplier") then
				self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
				self._state_data.stacking_dmg_mul[primary_category] = self._state_data.stacking_dmg_mul[primary_category] or {
					nil,
					0
				}
				local stack = self._state_data.stacking_dmg_mul[primary_category]

				if fired.hit_enemy then
					stack[1] = t + managers.player:upgrade_value(primary_category, "stacking_hit_expire_t", 1)
					stack[2] = math.min(stack[2] + 1, tweak_data.upgrades.max_weapon_dmg_mul_stacks or 5)
				else
					stack[1] = nil
					stack[2] = 0
				end
			end

			if weap_base.set_recharge_clbk then
				weap_base:set_recharge_clbk(callback(self, self, "weapon_recharge_clbk_listener"))
			end

			managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())

			local impact = not fired.hit_enemy

			if weap_base.third_person_important and weap_base:third_person_important() then
				self._ext_network:send("shot_blank_reliable", impact, akimbo and 1 or 0)
			elseif fire_mode ~= "auto" or (weap_base.akimbo or akimbo) and not weap_base:weapon_tweak_data().allow_akimbo_autofire then
				self._ext_network:send("shot_blank", impact, akimbo and 1 or 0)
			end

			if fire_mode == "volley" then
				self:_check_stop_shooting()
			end
		elseif fire_mode == "single" or self._shooting_forbidden then
			new_action = false
		elseif fire_mode == "burst" then
			if weap_base:shooting_count() == 0 then
				new_action = false
			end
		elseif fire_mode == "volley" then
			new_action = self:_is_charging_weapon()
		end
	end

	if new_action then
		local rot = Rotation(weap_base._unit:rotation():y(), math.UP)
		local yaw = rot:yaw() % 360

		if yaw < 0 then
			yaw = 360 - yaw
		end

		yaw = math.floor(255 * yaw / 360)
		local pitch = math.clamp(rot:pitch(), -85, 85) + 85
		pitch = math.floor(127 * pitch / 170)

		self._unit:camera():set_timed_locked_look_dir(t + 1, yaw, pitch)
	end

	return new_action
end