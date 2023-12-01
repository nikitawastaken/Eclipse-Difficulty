-- Friendly Fire
local original_init = PlayerStandard.init
function PlayerStandard:init(unit)
	original_init(self, unit)

	if Global.game_settings and Global.game_settings.one_down then
		self._slotmask_bullet_impact_targets = self._slotmask_bullet_impact_targets + 3
	else
		self._slotmask_bullet_impact_targets = managers.mutators:modify_value("PlayerStandard:init:melee_slot_mask", self._slotmask_bullet_impact_targets)
	end
end

-- Spray pattern implementation
-- Oh man! This is just like Counter-Strike!
function PlayerStandard:_check_action_primary_attack(t, input, params)
	local new_action, action_wanted = nil
	action_wanted = (not params or params.action_wanted == nil or params.action_wanted)
		and (input.btn_primary_attack_state or input.btn_primary_attack_release or self:is_shooting_count() or self:_is_charging_weapon())

	if action_wanted then
		local action_forbidden = nil

		if params and params.action_forbidden ~= nil then
			action_forbidden = params.action_forbidden
		elseif
			self:_is_reloading()
			or self:_changing_weapon()
			or self:_is_meleeing()
			or self._use_item_expire_t
			or self:_interacting()
			or self:_is_throwing_projectile()
			or self:_is_deploying_bipod()
			or self._menu_closed_fire_cooldown > 0
			or self:is_switching_stances()
		then
			action_forbidden = true
		else
			action_forbidden = false
		end

		if not action_forbidden then
			self._queue_reload_interupt = nil
			local start_shooting = false

			self._ext_inventory:equip_selected_primary(false)

			local weap_unit = self._equipped_unit

			if weap_unit then
				local weap_base = weap_unit:base()
				local fire_mode = weap_base:fire_mode()
				local fire_on_release = weap_base:fire_on_release()

				if weap_base:out_of_ammo() then
					if input.btn_primary_attack_press then
						weap_base:dryfire()
					end
				elseif weap_base.clip_empty and weap_base:clip_empty() then
					if params and params.no_reload or self:_is_using_bipod() then
						if input.btn_primary_attack_press then
							weap_base:dryfire()
						end

						weap_base:tweak_data_anim_stop("fire")
					else
						local fire_mode_func = self._primary_action_funcs.clip_empty[fire_mode]

						if not fire_mode_func or not fire_mode_func(self, t, input, params, weap_unit, weap_base) then
							fire_mode_func = self._primary_action_funcs.clip_empty.default

							if fire_mode_func then
								fire_mode_func(self, t, input, params, weap_unit, weap_base)
							end
						end

						new_action = self:_is_reloading()
					end
				elseif params and params.block_fire then
					-- Nothing
				elseif self._running and (params and params.no_running or weap_base.run_and_shoot_allowed and not weap_base:run_and_shoot_allowed()) then
					self:_interupt_action_running(t)
				else
					if not self._shooting then
						if weap_base:start_shooting_allowed() then
							local start = nil
							local start_fire_func = self._primary_action_get_value.chk_start_fire[fire_mode]

							if start_fire_func then
								start = start_fire_func(self, t, input, params, weap_unit, weap_base)
							else
								start_fire_func = self._primary_action_get_value.chk_start_fire.default

								if start_fire_func then
									start = start_fire_func(self, t, input, params, weap_unit, weap_base)
								end
							end

							if not params or not params.no_start_fire_on_release then
								start = start and not fire_on_release
								start = start or fire_on_release and input.btn_primary_attack_release
							end

							if start then
								weap_base:start_shooting()
								self._camera_unit:base():start_shooting()

								self._shooting = true
								self._shooting_t = t
								start_shooting = true
								local fire_mode_func = self._primary_action_funcs.start_fire[fire_mode]

								if not fire_mode_func or not fire_mode_func(self, t, input, params, weap_unit, weap_base) then
									fire_mode_func = self._primary_action_funcs.start_fire.default

									if fire_mode_func then
										fire_mode_func(self, t, input, params, weap_unit, weap_base)
									end
								end
							end
						elseif not params or not params.no_check_stop_shooting_early then
							self:_check_stop_shooting()

							return false
						end
					end

					local suppression_ratio = self._unit:character_damage():effective_suppression_ratio()
					local spread_mul = math.lerp(1, tweak_data.player.suppression.spread_mul, suppression_ratio)
					local autohit_mul = math.lerp(1, tweak_data.player.suppression.autohit_chance_mul, suppression_ratio)
					local suppression_mul = managers.blackmarket:threat_multiplier()
					local dmg_mul = 1
					local weapon_tweak_data = weap_base:weapon_tweak_data()
					local primary_category = weapon_tweak_data.categories[1]

					if not weapon_tweak_data.ignore_damage_multipliers then
						dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "dmg_multiplier_outnumbered", 1)

						if self._overkill_all_weapons or weap_base:is_category("shotgun", "saw") then
							dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
						end

						local health_ratio = self._ext_damage:health_ratio()
						local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)

						if damage_health_ratio > 0 then
							local upgrade = weap_base:is_category("saw") and self._damage_health_ratio_mul_melee or self._damage_health_ratio_mul
							dmg_mul = dmg_mul * (1 + upgrade * damage_health_ratio)
						end

						dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
						dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
					end

					local fired = nil
					local fired_func = self._primary_action_get_value.fired[fire_mode]

					if fired_func then
						fired = fired_func(self, t, input, params, weap_unit, weap_base, start_shooting, fire_on_release, dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
					else
						fired_func = self._primary_action_get_value.fired.default

						if fired_func then
							fired = fired_func(self, t, input, params, weap_unit, weap_base, start_shooting, fire_on_release, dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
						end
					end

					if (not params or not params.no_steelsight) and weap_base.manages_steelsight and weap_base:manages_steelsight() then
						if weap_base:wants_steelsight() and not self._state_data.in_steelsight then
							self:_start_action_steelsight(t)
						elseif not weap_base:wants_steelsight() and self._state_data.in_steelsight then
							self:_end_action_steelsight(t)
						end
					end

					local charging_weapon = weap_base:charging()

					if not self._state_data.charging_weapon and charging_weapon then
						self:_start_action_charging_weapon(t)
					elseif self._state_data.charging_weapon and not charging_weapon then
						self:_end_action_charging_weapon(t)
					end

					new_action = true

					if fired then
						if not params or not params.no_rumble then
							managers.rumble:play("weapon_fire")
						end

						local weap_tweak_data = weap_base.weapon_tweak_data and weap_base:weapon_tweak_data() or tweak_data.weapon[weap_base:get_name_id()]

						if not params or not params.no_shake then
							local shake_tweak_data = weap_tweak_data.shake[fire_mode] or weap_tweak_data.shake
							local shake_multiplier = shake_tweak_data[self._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier"]

							self._ext_camera:play_shaker("fire_weapon_rot", 1 * shake_multiplier)
							self._ext_camera:play_shaker("fire_weapon_kick", 1 * shake_multiplier, 1, 0.15)
						end

						weap_base:tweak_data_anim_stop("unequip")
						weap_base:tweak_data_anim_stop("equip")

						if
							(not params or not params.no_steelsight)
							and (not self._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()))
						then
							weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
						end

						if (not params or not params.no_recoil_anim_redirect) and not weap_tweak_data.no_recoil_anim_redirect then
							local fire_mode_func = self._primary_action_funcs.recoil_anim_redirect[fire_mode]

							if not fire_mode_func or not fire_mode_func(self, t, input, params, weap_unit, weap_base) then
								fire_mode_func = self._primary_action_funcs.recoil_anim_redirect.default

								if fire_mode_func then
									fire_mode_func(self, t, input, params, weap_unit, weap_base)
								end
							end
						end

						local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()

						-- Modify starting here
						local kick_tweak_data = weap_tweak_data.kick[fire_mode] or weap_tweak_data.kick
						local up, down, left, right = unpack(kick_tweak_data[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])

						local apply_spray = false
						if fire_mode == "auto" and weap_tweak_data.spray then -- temporary spray check before we add it to all weapons
							pattern_tweak_data = weap_tweak_data.spray.pattern -- first part of spray pattern
							persist_pattern_tweak_data = weap_tweak_data.spray.persist_pattern -- second part of spray pattern (persist pattern)
							recoil_recovery = weap_tweak_data.recoil_recovery_timer
							apply_spray = true
						end

						if apply_spray then
							self._camera_unit:base():pattern_recoil_kick(pattern_tweak_data, persist_pattern_tweak_data, recoil_multiplier, recoil_recovery)
						else
							self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
						end
						-- End modification

						self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)

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
								0,
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

						if (not params or not params.no_recharge_clbk) and weap_base.set_recharge_clbk then
							weap_base:set_recharge_clbk(callback(self, self, "weapon_recharge_clbk_listener"))
						end

						managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())

						if self._ext_network then
							local impact = not fired.hit_enemy
							local sync_blank_func = self._primary_action_funcs.sync_blank[fire_mode]

							if not sync_blank_func or not sync_blank_func(self, t, input, params, weap_unit, weap_base, impact) then
								sync_blank_func = self._primary_action_funcs.sync_blank.default

								if sync_blank_func then
									sync_blank_func(self, t, input, params, weap_unit, weap_base, impact)
								end
							end
						end

						local stop_volley_func = self._primary_action_get_value.check_stop_shooting_volley[fire_mode]

						if stop_volley_func then
							new_action = stop_volley_func(self, t, input, params, weap_unit, weap_base)
						else
							stop_volley_func = self._primary_action_get_value.check_stop_shooting_volley.default

							if stop_volley_func then
								new_action = stop_volley_func(self, t, input, params, weap_unit, weap_base)
							end
						end
					else
						local not_fired_func = self._primary_action_get_value.not_fired[fire_mode]

						if not_fired_func then
							new_action = not_fired_func(self, t, input, params, weap_unit, weap_base)
						else
							not_fired_func = self._primary_action_get_value.not_fired.default

							if not_fired_func then
								new_action = not_fired_func(self, t, input, params, weap_unit, weap_base)
							end
						end
					end
				end
			end
		elseif self:_is_reloading() and self._equipped_unit and self._equipped_unit:base():reload_interuptable() and input.btn_primary_attack_press then
			self._queue_reload_interupt = true
		end
	end

	self:_chk_action_stop_shooting(new_action)

	return new_action
end

-- No more sixth sense
Hooks:OverrideFunction(PlayerStandard, "_update_omniscience", function(self, ...)
	return
end)

-- Don't update sixth sense anymore and add sprint reload upgrade to shotguns
Hooks:OverrideFunction(PlayerStandard, "update", function(self, t, dt)
	PlayerMovementState.update(self, t, dt)
	self:_calculate_standard_variables(t, dt)
	self:_update_ground_ray()
	self:_update_fwd_ray()
	self:_update_check_actions(t, dt)

	if self._menu_closed_fire_cooldown > 0 then
		self._menu_closed_fire_cooldown = self._menu_closed_fire_cooldown - dt
	end

	self:_update_movement(t, dt)
	self:_upd_nav_data()
	managers.hud:_update_crosshair_offset(t, dt)
	self:_upd_stance_switch_delay(t, dt)
	self.RUN_AND_RELOAD = managers.player:has_category_upgrade("player", "run_and_reload")
		or self._equipped_unit and self._equipped_unit:base():is_category("shotgun") and managers.player:has_category_upgrade("shotgun", "run_and_reload")
end)

-- Melee while running
-- Code from melee overhaul
Hooks:PostHook(PlayerStandard, "_start_action_running", "eclipse_start_action_running", function(self, t)
	if managers.player and managers.player:has_category_upgrade("player", "run_and_melee_eclipse") then
		if not self._move_dir then
			self._running_wanted = true
			return
		end

		if self:on_ladder() or self:_on_zipline() then
			return
		end

		if
			self._shooting and not managers.player.RUN_AND_SHOOT
			or self:_changing_weapon()
			or self._use_item_expire_t
			or self._state_data.in_air
			or self:_is_throwing_projectile()
			or self:_is_charging_weapon()
		then
			self._running_wanted = true
			return
		end

		if self._state_data.ducking and not self:_can_stand() then
			self._running_wanted = true
			return
		end

		if not self:_can_run_directional() then
			return
		end

		if not self:_is_meleeing() and self._camera_unit:base()._melee_item_units then
			self._running_wanted = true
			return
		end

		self._running_wanted = false

		if managers.player:get_player_rule("no_run") then
			return
		end

		if not self._unit:movement():is_above_stamina_threshold() then
			return
		end

		if (not self._state_data.shake_player_start_running or not self._ext_camera:shaker():is_playing(self._state_data.shake_player_start_running)) and managers.user:get_setting("use_headbob") then
			self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running", 0.75)
		end

		self:set_running(true)

		self._end_running_expire_t = nil
		self._start_running_t = t

		if not self.RUN_AND_RELOAD then
			self:_interupt_action_reload(t)
		end

		self:_interupt_action_steelsight(t)
		self:_interupt_action_ducking(t)
	end
end)

function PlayerStandard:_end_action_running(t)
	if not self._end_running_expire_t then
		local speed_multiplier = self._equipped_unit:base():exit_run_speed_multiplier()
		self._end_running_expire_t = t + 0.4 / speed_multiplier
		local stop_running = not self._equipped_unit:base():run_and_shoot_allowed() and (not self.RUN_AND_RELOAD or not self:_is_reloading())

		if not self:_is_meleeing() and stop_running then
			self._ext_camera:play_redirect(self:get_animation("stop_running"), speed_multiplier)
		end
	end
end

Hooks:PreHook(PlayerStandard, "_start_action_melee", "eclipse_pre_start_action_melee", function(self, t, input, instant)
	self._state_data.melee_running_wanted = true and self._running and not self._end_running_expire_t
end)

Hooks:PostHook(PlayerStandard, "_start_action_melee", "eclipse_post_start_action_melee", function(self, t, input, instant)
	if self._state_data.melee_running_wanted then
		self._running_wanted = true
	end

	self._state_data.melee_running_wanted = nil
end)

Hooks:PreHook(PlayerStandard, "_update_melee_timers", "eclipse_update_melee_timers", function(self, t, input)
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local instant = tweak_data.blackmarket.melee_weapons[melee_entry].instant

	if not instant and not self._state_data.melee_repeat_expire_t and self._state_data.melee_expire_t and t >= self._state_data.melee_expire_t then
		if self._running and not self._end_running_expire_t then
			if not self:_is_reloading() or not self.RUN_AND_RELOAD then
				if not self._equipped_unit:base():run_and_shoot_allowed() and not self._state_data.meleeing then
					self._ext_camera:play_redirect(self:get_animation("start_running"))
				else
					if not self._state_data.meleeing then
						self._ext_camera:play_redirect(self:get_animation("idle"))
					end
				end
			end
		end
	end

	if instant and self._state_data.melee_expire_t and t >= self._state_data.melee_expire_t then
		if self._running and not self._end_running_expire_t then
			if not self:_is_reloading() or not self.RUN_AND_RELOAD then
				if not self._equipped_unit:base():run_and_shoot_allowed() and not self._state_data.meleeing then
					self._ext_camera:play_redirect(self:get_animation("start_running"))
				else
					if not self._state_data.meleeing then
						self._ext_camera:play_redirect(self:get_animation("idle"))
					end
				end
			end
		end
	end
end)

Hooks:PostHook(PlayerStandard, "_interupt_action_melee", "eclipse_interupt_action_melee", function(self, t)
	if managers.player and managers.player:has_category_upgrade("player", "run_and_melee_eclipse") then
		local running = self._running and not self._end_running_expire_t

		self:_interupt_action_running(t)

		if running then
			self._running_wanted = true
		end
	end
end)
-- End melee overhaul code

-- no interaction cooldown, credit goes to chibibowa
local old_check_use = PlayerStandard._check_use_item

function PlayerStandard:_check_use_item(t, input)
	if input.btn_use_item_release and self._throw_time and t and t < self._throw_time then
		managers.player:drop_carry()
		self._throw_time = nil
		return true
	else
		return old_check_use(self, t, input)
	end
end

function PlayerManager.carry_blocked_by_cooldown()
	return false
end
