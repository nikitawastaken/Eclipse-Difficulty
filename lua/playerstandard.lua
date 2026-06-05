local is_pro_job = Eclipse.utils.is_pro_job()
local mvec3_dis_sq = mvector3.distance_sq

-- Friendly Fire
local original_init = PlayerStandard.init
function PlayerStandard:init(unit)
	original_init(self, unit)

	if is_pro_job then
		self._slotmask_bullet_impact_targets = self._slotmask_bullet_impact_targets + 3
	else
		self._slotmask_bullet_impact_targets = managers.mutators:modify_value("PlayerStandard:init:melee_slot_mask", self._slotmask_bullet_impact_targets)
	end

	-- Make sure that new increased gravity is set
	self._unit:mover():set_gravity(Vector3(0, 0, tweak_data.player.gravity))

	self._standstill_damage_reduction_active = false
	self._sniper_shot_is_charged = false
	self._sniper_hell_sfx_played = false
	self._is_sidearm_pullout_damage_allowed = false
	local pm = managers.player
	local pickup_range_multiplier = 1

	-- Scavenger ACED: increase pickup range based on armor
	if pm:has_category_upgrade("player", "armor_pickup_range_bonus") then
		local armor_init = tweak_data.player.damage.ARMOR_INIT
		local base_max_armor = armor_init + pm:body_armor_value("armor") + pm:body_armor_skill_addend()
		local mul = pm:upgrade_value("player", "armor_pickup_range_bonus", 1)

		for i = 1, base_max_armor do
			pickup_range_multiplier = pickup_range_multiplier + mul
		end
	end

	self._pickup_area = 200 * pm:upgrade_value("player", "increased_pickup_area", 1) * pm:upgrade_value("player", "increased_pickup_area_gambler", 1) * pickup_range_multiplier
end

Hooks:PreHook(PlayerStandard, "update", "eclipse_update", function(self, t, dt)
	if self:full_steelsight() and not self._state_data.in_full_steelsight then
		self._state_data.in_full_steelsight = true
	end

	if self._state_data.in_full_steelsight and not self:in_steelsight() then
		self._state_data.in_full_steelsight = nil
	end
end)

-- Make it so that a player has to fully wait out the aiming animation to enter the steelsight stance (fix from Restoration Mod)
function PlayerStandard:full_steelsight()
	return self._state_data.in_steelsight and self._camera_unit:base():is_stance_done()
end

-- Increase player gravity to make movement less floaty
function PlayerStandard:_activate_mover(mover, velocity)
	self._unit:activate_mover(mover, velocity)

	if self._state_data.on_ladder then
		self._unit:mover():set_gravity(Vector3(0, 0, 0))
	else
		self._unit:mover():set_gravity(Vector3(0, 0, tweak_data.player.gravity))
	end

	if self._is_jumping then
		self._unit:mover():jump()
		self._unit:mover():set_velocity(velocity)
	end
end

function PlayerStandard:_end_action_ladder(t, input)
	if not self._state_data.on_ladder then
		return
	end

	self._state_data.on_ladder = false

	if self._unit:mover() then
		self._unit:mover():set_gravity(Vector3(0, 0, tweak_data.player.gravity))
	end

	self._unit:movement():on_exit_ladder()
end

function PlayerStandard:_stance_entered(unequipped)
	local stance_standard = tweak_data.player.stances.default[managers.player:current_state()] or tweak_data.player.stances.default.standard
	local head_stance = self._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
	local stance_id = nil
	local stance_mod = {
		translation = Vector3(0, 0, 0),
	}

	if not unequipped then
		stance_id = self._equipped_unit:base():get_stance_id()

		if self._state_data.in_steelsight and self._equipped_unit:base().stance_mod then
			stance_mod = self._equipped_unit:base():stance_mod() or stance_mod
		end
	end

	local stances = nil
	stances = (self:_is_meleeing() or self:_is_throwing_projectile()) and tweak_data.player.stances.default or tweak_data.player.stances[stance_id] or tweak_data.player.stances.default
	local misc_attribs = stances.standard
	misc_attribs = (not self:_is_using_bipod() or self:_is_throwing_projectile() or stances.bipod)
		and (self._state_data.in_steelsight and stances.steelsight or self._state_data.ducking and stances.crouched or stances.standard)
	local head_duration = tweak_data.player.TRANSITION_DURATION
	local head_duration_multiplier = 1
	local duration_multiplier = not self._state_data.in_full_steelsight and self._state_data.in_steelsight and 1 / self._equipped_unit:base():enter_steelsight_speed_multiplier() or 1 -- Make sure the ADS transition is over
	local duration = head_duration + (self._equipped_unit:base():transition_duration() or 0)

	if self._instant_stance_transition then
		self._instant_stance_transition = nil
		duration_multiplier = 0
	end

	local new_fov = self:get_zoom_fov(misc_attribs) + 0

	self._camera_unit:base():clbk_stance_entered(
		misc_attribs.shoulders,
		head_stance,
		misc_attribs.vel_overshot,
		new_fov,
		misc_attribs.shakers,
		stance_mod,
		duration_multiplier,
		duration,
		head_duration_multiplier,
		head_duration
	)
	managers.menu:set_mouse_sensitivity(self:in_steelsight())
end

function PlayerStandard:get_movement_state()
	if self._state_data.in_steelsight and self._state_data.in_full_steelsight then
		return self._moving and "moving_steelsight" or "steelsight"
	end

	if self._state_data.ducking then
		return self._moving and "moving_crouching" or "crouching"
	else
		return self._moving and "moving_standing" or "standing"
	end
end

function PlayerStandard:_get_swap_speed_multiplier()
	local multiplier = 1

	local weap_base = self._equipped_unit:base()
	local weapon_tweak_data = weap_base.weapon_tweak_data and weap_base:weapon_tweak_data() or tweak_data.weapon[weap_base:get_name_id()]

	multiplier = multiplier * weap_base:mobility_to_handling_mul()

	multiplier = multiplier * (weapon_tweak_data.swap_speed_multiplier or 1)

	multiplier = multiplier * managers.player:upgrade_value("weapon", "swap_speed_multiplier", 1)
	multiplier = multiplier * managers.player:upgrade_value("weapon", "passive_swap_speed_multiplier", 1)

	for _, category in ipairs(weapon_tweak_data.categories) do
		multiplier = multiplier * managers.player:upgrade_value(category, "swap_speed_multiplier", 1)
	end

	multiplier = multiplier * managers.player:upgrade_value("team", "crew_faster_swap", 1)

	if managers.player:has_activate_temporary_upgrade("temporary", "swap_weapon_faster") then
		multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "swap_weapon_faster", 1)
	end

	if managers.player:has_activate_temporary_upgrade("pistol", "empty_quickdraw") then
		multiplier = multiplier * managers.player:upgrade_value("pistol", "empty_quickdraw")[1]
	end

	multiplier = managers.modifiers:modify_value("PlayerStandard:GetSwapSpeedMultiplier", multiplier)
	multiplier = multiplier * managers.player:upgrade_value("weapon", "mrwi_swap_speed_multiplier", 1)

	return multiplier
end

function PlayerStandard:_get_max_walk_speed(t, force_run)
	local speed_tweak = self._tweak_data.movement.speed
	local movement_speed = speed_tweak.STANDARD_MAX
	local weap_base = self._equipped_unit:base()
	local speed_state = "walk"

	if self._state_data.in_steelsight and not managers.player:has_category_upgrade("player", "steelsight_normal_movement_speed") and not _G.IS_VR then
		movement_speed = speed_tweak.STANDARD_MAX * (weap_base:steelsight_move_speed_multiplier() or 1)
		speed_state = "steelsight"
	elseif self:on_ladder() then
		movement_speed = speed_tweak.CLIMBING_MAX
		speed_state = "climb"
	elseif self._state_data.ducking then
		movement_speed = speed_tweak.CROUCHING_MAX
		speed_state = "crouch"
	elseif self._state_data.in_air then
		movement_speed = speed_tweak.INAIR_MAX
		speed_state = nil
	elseif self._running or force_run then
		movement_speed = speed_tweak.RUNNING_MAX
		speed_state = "run"
	end

	movement_speed = managers.modifiers:modify_value("PlayerStandard:GetMaxWalkSpeed", movement_speed, self._state_data, speed_tweak)
	local morale_boost_bonus = self._ext_movement:morale_boost()
	local multiplier = managers.player:movement_speed_multiplier(speed_state, speed_state and morale_boost_bonus and morale_boost_bonus.move_speed_bonus, nil, self._ext_damage:health_ratio())
	multiplier = multiplier * (self._tweak_data.movement.multiplier[speed_state] or 1)
	local apply_weapon_penalty = true

	if self:_is_meleeing() then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		apply_weapon_penalty = not tweak_data.blackmarket.melee_weapons[melee_entry].stats.remove_weapon_movement_penalty
	end

	if alive(self._equipped_unit) and apply_weapon_penalty then
		multiplier = multiplier * self._equipped_unit:base():movement_penalty()
		multiplier = multiplier * managers.player:upgrade_value(self._equipped_unit:base():get_name_id(), "increased_movement_speed", 1)
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "increased_movement_speed") then
		multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "increased_movement_speed", 1)
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "copr_ability_new") then
		local out_of_health = self._unit:character_damage():health_ratio() + 0.01 < managers.player:body_armor_value("copr_static_damage_ratio")

		if out_of_health then
			multiplier = multiplier * managers.player:upgrade_value("player", "copr_out_of_health_move_slow", 1)
		end
	end

	if managers.player:has_category_upgrade("player", "sidearm_move_speed_multiplier") and weap_base:is_category("revolver", "pistol") then
		multiplier = multiplier * managers.player:upgrade_value("player", "sidearm_move_speed_multiplier", 1)
	end

	if self._slowdown_mul then
		multiplier = multiplier * self._slowdown_mul
	end

	local final_speed = movement_speed * multiplier
	self._cached_final_speed = self._cached_final_speed or 0

	if final_speed ~= self._cached_final_speed then
		self._cached_final_speed = final_speed

		self._ext_network:send("action_change_speed", final_speed)
	end

	return final_speed
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
					if
						params and params.no_reload
						or self:_is_using_bipod()
						or (tweak_data.weapon.weapon_settings.no_autoreload and not managers.player:has_category_upgrade("player", "can_autoreload"))
					then
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

						if self._overkill_all_weapons or weap_base:is_category("shotgun") then
							dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
						end

						local health_ratio = self._ext_damage:health_ratio()
						local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)

						if damage_health_ratio > 0 then
							local upgrade = self._damage_health_ratio_mul
							dmg_mul = dmg_mul * (1 + upgrade * damage_health_ratio)
						end

						if weap_base:is_category("revolver", "pistol") then
							if managers.player:has_activate_temporary_upgrade("temporary", "sidearm_pullout_damage_multiplier") then
								dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "sidearm_pullout_damage_multiplier", 1)
							end

							if managers.player:has_activate_temporary_upgrade("temporary", "sidearm_reload_damage_multiplier") then
								dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "sidearm_reload_damage_multiplier", 1)
							end
						end

						if managers.player:current_state() == "bleed_out" then
							dmg_mul = dmg_mul * managers.player:upgrade_value("player", "bleedout_damage_multiplier", 1)
						end

						dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "double_drop_damage_multiplier", 1)
						dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
						dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
						dmg_mul = dmg_mul * (1 + managers.player:get_property("snp_consecutive_headshots_mul", 0))
						dmg_mul = dmg_mul * (1 + managers.player:get_property("berserker_ranged_damage", 0))
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

						if self._sniper_shot_is_charged then
							self._state_data.snp_shot_charge_t = nil
							self._sniper_shot_is_charged = false
							managers.player:charged_shot_allowed(self._sniper_shot_is_charged)
						end

						-- if weap_base:is_category("revolver", "pistol") then
						-- 	if managers.player:has_activate_temporary_upgrade("temporary", "sidearm_pullout_damage_multiplier") then
						-- 		managers.player:deactivate_temporary_upgrade("temporary", "sidearm_pullout_damage_multiplier")
						-- 	end
						-- end

						local weap_tweak_data = weap_base.weapon_tweak_data and weap_base:weapon_tweak_data() or tweak_data.weapon[weap_base:get_name_id()]
						local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()

						if not params or not params.no_shake then
							local shake_tweak_data = weap_tweak_data.shake[fire_mode] or weap_tweak_data.shake
							local recoil_shake = math.map_range(recoil_multiplier, 0.5, 3, 0.8, 1.2)

							local on_hit_mul = false
							if fired and fired.rays then
								for _, ray in ipairs(fired.rays) do
									if ray and not table.empty(ray) then
										on_hit_mul = true

										break
									end
								end
							end

							local shake_multiplier = (on_hit_mul and shake_tweak_data["on_hit_multiplier"] or shake_tweak_data["fire_multiplier"]) * recoil_shake

							if self._state_data.in_steelsight then
								self._ext_camera:play_shaker("fire_weapon_kick_steelsight", shake_multiplier, 1, 0.15)
							else
								self._ext_camera:play_shaker("fire_weapon_kick", shake_multiplier, 1, 0.15)
							end

							self._ext_camera:play_shaker("fire_weapon_recoil", shake_multiplier)
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

						-- Modify starting here
						local kick_tweak_data = weap_tweak_data.kick[fire_mode] or weap_tweak_data.kick
						local kick_id = self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"

						if kick_tweak_data.on_hit and fired and fired.rays then
							for _, ray in ipairs(fired.rays) do
								if ray and not table.empty(ray) then
									kick_id = "on_hit"

									break
								end
							end
						end

						local up, down, left, right = unpack(kick_tweak_data[kick_id])

						local apply_spray = false
						local pattern_tweak_data, persist_pattern_tweak_data, recoil_recovery
						if fire_mode == "auto" and weap_tweak_data.spray then -- temporary spray check before we add it to all weapons
							pattern_tweak_data = weap_tweak_data.spray.pattern -- first part of spray pattern
							persist_pattern_tweak_data = weap_tweak_data.spray.persist_pattern -- second part of spray pattern (persist pattern)
							recoil_recovery = weap_tweak_data.recoil_recovery_timer
							apply_spray = true
						end

						if apply_spray and not _G.IS_VR then
							self._camera_unit:base():pattern_recoil_kick(pattern_tweak_data, persist_pattern_tweak_data, recoil_multiplier, recoil_recovery)
						else
							self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
						end
						-- End modification

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

	if managers.player:has_category_upgrade("player", "standstill_omniscience") then
		self:_update_standstill_omniscience(t, dt)
	end

	if managers.player:has_category_upgrade("snp", "charged_shot") then
		self:_update_sniper_shot_charge(t, dt)
	end

	if managers.player:has_category_upgrade("player", "stationary_damage_multiplier") then
		self:_update_standstill_resistance(t, dt)
	end

	self.RUN_AND_RELOAD = managers.player:has_category_upgrade("player", "run_and_reload")
		or self._equipped_unit and self._equipped_unit:base():is_category("shotgun") and managers.player:has_category_upgrade("shotgun", "run_and_reload")
end)

-- Sixth Sense overhaul: less harsh conditions for activation, ACED variant makes it work in loud and marks all enemies at once
function PlayerStandard:_update_standstill_omniscience(t, dt)
	local skill_data = managers.player:upgrade_value("player", "standstill_omniscience") or nil

	local action_forbidden = managers.player:current_state() == "civilian"
		or self:_interacting()
		or self:is_deploying()
		or self:_is_throwing_projectile()
		or self:_is_meleeing()
		or self:_on_zipline()
		or self._moving
		or self:running()
		or self:in_air()
		or self:shooting()

	if not skill_data or not skill_data.outside_of_whisper_mode and not managers.groupai:state():whisper_mode() or action_forbidden then
		if self._state_data.omniscience_t then
			self._state_data.omniscience_t = nil
		end

		return
	end

	self._state_data.omniscience_t = self._state_data.omniscience_t or t + skill_data.start_t

	if self._state_data.omniscience_t <= t then
		local sensed_targets = World:find_units_quick("sphere", self._unit:movement():m_pos(), skill_data.sense_radius, managers.slot:get_mask("trip_mine_targets"))

		for _, unit in ipairs(sensed_targets) do
			if alive(unit) and not unit:base():char_tweak().is_escort then
				self._state_data.omniscience_units_detected = self._state_data.omniscience_units_detected or {}

				if not self._state_data.omniscience_units_detected[unit:key()] or self._state_data.omniscience_units_detected[unit:key()] <= t then
					self._state_data.omniscience_units_detected[unit:key()] = t + skill_data.target_resense_t

					managers.game_play_central:auto_highlight_enemy(unit, true)

					if not skill_data.all_at_once then
						break
					end
				end
			end
		end

		self._state_data.omniscience_t = t + skill_data.interval_t
	end
end

-- Standstill damage multiplier upgrade
function PlayerStandard:_update_standstill_resistance(t, dt)
	local pm = managers.player
	local action_forbidden = not pm:has_category_upgrade("player", "stationary_damage_multiplier")
		or pm:current_state() == "civilian"
		or self._ext_movement:has_carry_restriction()
		or self._moving
		or self:running()
		or self:in_air()
		or self._state_data.ducking

	if not action_forbidden then
		self._standstill_damage_reduction_active = true
	else
		self._standstill_damage_reduction_active = false
	end

	pm:standstill_resistance_active(self._standstill_damage_reduction_active)
end

-- Sniper charged shot upgrade
function PlayerStandard:_update_sniper_shot_charge(t, dt)
	local pm = managers.player
	local is_sniper_rifle = self._equipped_unit:base():is_category("snp")
	local allowed_to_fire = self._sniper_shot_is_charged and self:in_steelsight() and is_sniper_rifle
	local action_forbidden = not is_sniper_rifle
		or pm:current_state() == "civilian"
		or self:is_deploying()
		or self:_changing_weapon()
		or self:_is_throwing_projectile()
		or self:_is_meleeing()
		or self:_on_zipline()
		or self:_interacting()
		or self:running()
		or not self:in_steelsight()
		or self:is_equipping()
		or self:shooting()
	local upgrade_value = pm:upgrade_value("snp", "charged_shot")

	if action_forbidden and not allowed_to_fire then
		if self._state_data.snp_shot_charge_t then
			self._state_data.snp_shot_charge_t = nil
		end

		self._sniper_shot_is_charged = false
		self._sniper_hell_sfx_played = false
		pm:charged_shot_allowed(self._sniper_shot_is_charged)
		return
	end

	self._state_data.snp_shot_charge_t = self._state_data.snp_shot_charge_t or t + upgrade_value.time_to_charge

	if self._sniper_shot_is_charged and not self._sniper_hell_sfx_played then
		local weap_base = self._equipped_unit:base()
		weap_base:play_sound("trip_mine_beep_armed") -- potentially replace the sound later but i think it's already nice(?)
		self._sniper_hell_sfx_played = true
	end

	if self._state_data.snp_shot_charge_t <= t then
		self._sniper_shot_is_charged = true

		pm:charged_shot_allowed(self._sniper_shot_is_charged)
	end
end

-- Melee & swap / throw while running
function PlayerStandard:_start_action_running(t)
	if self._slowdown_run_prevent then
		self._running_wanted = false

		return
	end

	if not self._move_dir then
		self._running_wanted = true

		return
	end

	if self:on_ladder() or self:_on_zipline() then
		return
	end

	if self._shooting and not self._equipped_unit:base():run_and_shoot_allowed() or self._use_item_expire_t or self._state_data.in_air or self:_is_charging_weapon() then
		self._running_wanted = true

		return
	end

	if self._state_data.ducking and not self:_can_stand() then
		self._running_wanted = true

		return
	end

	if self:_is_meleeing() and (managers.player and not managers.player:has_category_upgrade("player", "run_and_melee")) then
		self._running_wanted = true
		return
	end

	if (self:_changing_weapon() or self:_is_throwing_projectile()) and (managers.player and not managers.player:has_category_upgrade("player", "can_sprint_swap")) then
		self._running_wanted = true
		return
	end

	if not self:_can_run_directional() then
		return
	end

	self._running_wanted = false

	if managers.player:get_player_rule("no_run") then
		return
	end

	if not self._unit:movement():is_above_stamina_threshold() then
		return
	end

	if (not self._state_data.shake_player_start_running or not self._ext_camera:shaker():is_playing(self._state_data.shake_player_start_running)) and self._setting_use_headbob then
		self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running", 0.75)
	end

	self:set_running(true)

	self._end_running_expire_t = nil
	self._start_running_t = t
	self._play_stop_running_anim = nil

	if
		(not self:_is_reloading() or not self.RUN_AND_RELOAD) -- no sprint anim if run n' reload (unused)
		and (not self:_is_meleeing() or not managers.player:has_category_upgrade("player", "run_and_melee")) -- no sprint anim while meleeing
		and (not (self:_changing_weapon() or self:_is_throwing_projectile()) or not managers.player:has_category_upgrade("player", "can_sprint_swap")) -- no sprint anim while weapon swapping / masking up
	then
		if not self._equipped_unit:base():run_and_shoot_allowed() then
			self._ext_camera:play_redirect(self:get_animation("start_running"))
		else
			self._ext_camera:play_redirect(self:get_animation("idle"))
		end
	end

	if not self.RUN_AND_RELOAD then
		self:_interupt_action_reload(t)
	end

	self:_interupt_action_steelsight(t)
	self:_interupt_action_ducking(t)
end

function PlayerStandard:_start_action_unequip_weapon(t, data)
	local speed_multiplier = self:_get_swap_speed_multiplier()

	self._equipped_unit:base():tweak_data_anim_stop("equip")
	self._equipped_unit:base():tweak_data_anim_play("unequip", speed_multiplier)

	local tweak_data = self._equipped_unit:base():weapon_tweak_data()
	self._change_weapon_data = data
	self._unequip_weapon_expire_t = t + (tweak_data.timers.unequip or 0.5) / speed_multiplier

	if managers.player and not managers.player:has_category_upgrade("player", "can_sprint_swap") then
		self:_interupt_action_running(t)
	end
	self:_interupt_action_charging_weapon(t)

	-- selene: allow(unused_variable)
	local result = self._ext_camera:play_redirect(self:get_animation("unequip"), speed_multiplier)

	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self._ext_network:send("switch_weapon", speed_multiplier, 1)
end

function PlayerStandard:_end_action_running(t)
	if not self._end_running_expire_t then
		local weap_base = self._equipped_unit:base()
		local sprint_exit_time = weap_base:weapon_tweak_data().sprint_exit_time or 0.4

		local speed_multiplier = 1
		speed_multiplier = speed_multiplier * weap_base:exit_run_speed_multiplier()
		speed_multiplier = speed_multiplier * managers.player:upgrade_value("player", "sprint_to_fire_multiplier", 1)

		self._end_running_expire_t = t + sprint_exit_time / speed_multiplier

		if
			not weap_base:run_and_shoot_allowed()
			and (not self:_is_reloading() or not self.RUN_AND_RELOAD) -- no sprint anim if run n' reload (unused)
			and (not self:_is_meleeing() or not managers.player:has_category_upgrade("player", "run_and_melee")) -- no sprint anim while meleeing
			and (not (self:_changing_weapon() or self:_is_throwing_projectile()) or not managers.player:has_category_upgrade("player", "can_sprint_swap")) -- no sprint anim while weapon swapping / masking up
		then
			self._ext_camera:play_redirect(self:get_animation("stop_running"), speed_multiplier)
		end
	end
end

-- input
function PlayerStandard:_start_action_throw_grenade(t, _)
	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	if managers.player and not managers.player:has_category_upgrade("player", "can_sprint_swap") then
		self:_interupt_action_running(t)
	end
	self:_interupt_action_charging_weapon(t)

	local equipped_grenade = managers.blackmarket:equipped_grenade()
	local projectile_tweak = tweak_data.blackmarket.projectiles[equipped_grenade]

	if self._projectile_global_value then
		self._camera_unit:anim_state_machine():set_global(self._projectile_global_value, 0)

		self._projectile_global_value = nil
	end

	if projectile_tweak.anim_global_param then
		self._projectile_global_value = projectile_tweak.anim_global_param

		self._camera_unit:anim_state_machine():set_global(self._projectile_global_value, 1)
	end

	local delay = self:_get_projectile_throw_offset()

	managers.network:session():send_to_peers_synched("play_distance_interact_redirect_delay", self._unit, "throw_grenade", delay)
	self._ext_camera:play_redirect(Idstring(projectile_tweak.animation or "throw_grenade"))

	local projectile_data = tweak_data.blackmarket.projectiles[equipped_grenade]
	self._state_data.throw_grenade_expire_t = t + (projectile_data.expire_t or 1.1)

	self:_stance_entered()
end

function PlayerStandard:_update_equip_weapon_timers(t, input)
	if self._unequip_weapon_expire_t and self._unequip_weapon_expire_t <= t then
		if self._change_weapon_data.unequip_callback and not self._change_weapon_data.unequip_callback() then
			return
		end

		if managers.player:has_category_upgrade("temporary", "sidearm_pullout_damage_multiplier") then
			local weapon_unit_base = managers.player:equipped_weapon_unit():base()
			local selection_index = weapon_unit_base and weapon_unit_base:selection_index() or 0

			if selection_index == 2 then
				self._is_sidearm_pullout_damage_allowed = true
			else
				self._is_sidearm_pullout_damage_allowed = false
			end
		end

		self._unequip_weapon_expire_t = nil

		if not self:_interacting() then
			self:_start_action_equip_weapon(t)
		end
	end

	if self._equip_weapon_expire_t and self._equip_weapon_expire_t <= t then
		self._equipping_mask = nil
		self._equip_weapon_expire_t = nil

		if input.btn_steelsight_state then
			self._steelsight_wanted = true
		end

		if self._running and not self._end_running_expire_t then
			if not self._equipped_unit:base():run_and_shoot_allowed() then
				self._ext_camera:play_redirect(self:get_animation("start_running"))
			else
				self._ext_camera:play_redirect(self:get_animation("idle"))
			end
		end

		-- sidearm pullout extra damage
		if
			self._is_sidearm_pullout_damage_allowed
			and managers.player:has_category_upgrade("temporary", "sidearm_pullout_damage_multiplier")
			and managers.player:equipped_weapon_unit():base():is_category("revolver", "pistol")
		then
			managers.player:activate_temporary_upgrade("temporary", "sidearm_pullout_damage_multiplier")
			self._is_sidearm_pullout_damage_allowed = false
		end

		TestAPIHelper.on_event("load_weapon")
		TestAPIHelper.on_event("mask_up")
	end
end

-- melee overhaul code
Hooks:PreHook(PlayerStandard, "_start_action_melee", "eclipse_pre_start_action_melee", function(self)
	self._state_data.melee_running_wanted = true and self._running and not self._end_running_expire_t
end)

Hooks:PostHook(PlayerStandard, "_start_action_melee", "eclipse_post_start_action_melee", function(self)
	if self._state_data.melee_running_wanted then
		self._running_wanted = true
	end

	self._state_data.melee_running_wanted = nil
end)

Hooks:PostHook(PlayerStandard, "_do_action_melee", "eclipse__do_action_melee", function(self, t)
	-- Faster reswing skill
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	self._state_data.melee_repeat_expire_t = t
		+ (
			math.min(tweak_data.blackmarket.melee_weapons[melee_entry].repeat_expire_t, tweak_data.blackmarket.melee_weapons[melee_entry].expire_t)
			* managers.player:upgrade_value("melee", "faster_reswing", 1)
		)
end)

Hooks:PreHook(PlayerStandard, "_update_melee_timers", "eclipse_update_melee_timers", function(self, t)
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
	if managers.player and managers.player:has_category_upgrade("player", "run_and_melee") then
		local running = self._running and not self._end_running_expire_t

		self:_interupt_action_running(t)

		if running then
			self._running_wanted = true
		end
	end
end)
-- End melee overhaul code

function PlayerManager.carry_blocked_by_cooldown()
	return false
end

function PlayerStandard:_update_network_jump(pos, is_exit)
	local mover = self._unit:mover()

	if self._is_jumping and (is_exit or not mover or mover:standing() and mover:velocity().z < 0 or mover:gravity().z == 0) then
		if not self._is_jump_middle_passed then
			self._is_jump_middle_passed = true
		end

		self._is_jumping = nil
	elseif self._send_jump_vec and not is_exit then
		if self._is_jumping and type(self._gnd_ray) ~= "boolean" then
			self._ext_network:send("action_walk_nav_point", self._gnd_ray and self._gnd_ray.position)
		end

		self._ext_network:send("action_jump", pos or self._pos, self._send_jump_vec)

		-- Record the jumping last jump velocity used for jumpthrows
		self._last_sent_jump_vec = self._send_jump_vec
		self._send_jump_vec = nil
		self._is_jumping = true
		self._is_jump_middle_passed = nil

		mvector3.set(self._last_sent_pos, pos or self._pos)
	elseif self._is_jumping and not self._is_jump_middle_passed and mover and mover:velocity().z < 0 then
		self._is_jump_middle_passed = true
	end
end

function PlayerStandard:remove_tweak_data(name)
	if not self._tweak_data_name then
		return
	end

	for i, id in pairs(self._tweak_data_name) do
		if id == name then
			self._tweak_data_name[i] = nil
			break
		end
	end
end

-- Grenade refund requires a specific amount of pickups instead of being chance based
function PlayerStandard:_find_pickups(t)
	local pickups = World:find_units_quick("sphere", self._unit:movement():m_pos(), self._pickup_area, self._slotmask_pickups)
	local grenade_tweak = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()]
	local may_find_grenade = not grenade_tweak.base_cooldown and managers.player:has_category_upgrade("player", "regain_throwable_from_ammo")

	for _, pickup in ipairs(pickups) do
		if pickup:pickup() and pickup:pickup():pickup(self._unit) then
			if may_find_grenade then
				local data = managers.player:upgrade_value("player", "regain_throwable_from_ammo", nil)

				if data and not managers.player:got_max_grenades() then
					managers.player:add_coroutine("regain_throwable_from_ammo", PlayerAction.FullyLoaded, managers.player, data.required_pickups)
				end
			end

			for id, weapon in pairs(self._unit:inventory():available_selections()) do
				managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
			end
		end
	end
end

function PlayerStandard:_start_action_intimidate(t, secondary)
	if not self._intimidate_t or tweak_data.player.movement_state.interaction_delay < t - self._intimidate_t then
		local skip_alert = managers.groupai:state():whisper_mode()
		local voice_type, plural, prime_target = self:_get_unit_intimidation_action(not secondary, not secondary, true, false, true, nil, nil, nil, secondary)

		if
			prime_target
			and prime_target.unit
			and prime_target.unit.base
			and (prime_target.unit:base().unintimidateable or prime_target.unit:anim_data() and prime_target.unit:anim_data().unintimidateable)
		then
			return
		end

		local interact_type, sound_name = nil
		local sound_suffix = plural and "plu" or "sin"

		if voice_type == "stop" then
			interact_type = "cmd_stop"
			sound_name = self._shout_down_t and t < self._shout_down_t + 2 and self._last_shout_down_target == prime_target.unit and "f02b_sin" or "f02x_" .. sound_suffix
			self._shout_down_t = t
			self._last_shout_down_target = prime_target.unit
		elseif voice_type == "stop_cop" then
			interact_type = "cmd_stop"
			sound_name = "l01x_" .. sound_suffix
		elseif voice_type == "mark_cop" or voice_type == "mark_cop_quiet" then
			interact_type = "cmd_point"

			if voice_type == "mark_cop_quiet" then
				sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].silent_priority_shout .. "_any"
			else
				sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].priority_shout .. "x_any"
				sound_name = managers.modifiers:modify_value("PlayerStandart:_start_action_intimidate", sound_name, prime_target.unit)
			end

			if self._highlight_special_mul then
				local contour_ext = prime_target.unit:contour()

				if contour_ext then
					contour_ext:add(managers.player:get_contour_for_marked_enemy(), true, self._highlight_special_mul)
				end
			end
		elseif voice_type == "down" then
			interact_type = "cmd_down"
			sound_name = self._shout_down_t and t < self._shout_down_t + 2 and self._last_shout_down_target == prime_target.unit and "f02b_sin" or "f02x_" .. sound_suffix
			self._shout_down_t = t
			self._last_shout_down_target = prime_target.unit
		elseif voice_type == "down_cop" then
			interact_type = "cmd_down"
			sound_name = "l02x_" .. sound_suffix
		elseif voice_type == "cuff_cop" then
			interact_type = "cmd_point"
			sound_name = "l03x_" .. sound_suffix
		elseif voice_type == "down_stay" then
			interact_type = "cmd_point"

			if self._shout_down_t and t < self._shout_down_t + 2 then
				sound_name = "f03b_any"
				interact_type = "cmd_point"
			else
				sound_name = "f03a_" .. sound_suffix
				interact_type = "cmd_down"
			end
		elseif voice_type == "come" then
			interact_type = "cmd_come"
			local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)

			if static_data then
				local character_code = static_data.ssuffix
				sound_name = "f21" .. character_code .. "_sin"
			else
				sound_name = "f38_any"
			end
		elseif voice_type == "revive" then
			interact_type = "cmd_get_up"
			local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)

			if not static_data then
				return
			end

			local character_code = static_data.ssuffix
			sound_name = "f36x_any"

			if math.random() < self._ext_movement:rally_skill_data().revive_chance then
				prime_target.unit:interaction():interact(self._unit)
			end

			self._ext_movement:rally_skill_data().morale_boost_delay_t = managers.player:player_timer():time() + (self._ext_movement:rally_skill_data().morale_boost_cooldown_t or 3.5)
		elseif voice_type == "boost" then
			interact_type = "cmd_gogo"
			local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)

			if not static_data then
				return
			end

			local character_code = static_data.ssuffix
			sound_name = "g18"
			self._ext_movement:rally_skill_data().morale_boost_delay_t = managers.player:player_timer():time() + (self._ext_movement:rally_skill_data().morale_boost_cooldown_t or 3.5)
		elseif voice_type == "escort" then
			interact_type = "cmd_point"
			sound_name = "f41_" .. sound_suffix
		elseif voice_type == "escort_keep" or voice_type == "escort_go" then
			interact_type = "cmd_point"
			sound_name = "f40_any"
		elseif voice_type == "bridge_codeword" then
			sound_name = "bri_14"
			interact_type = "cmd_point"
		elseif voice_type == "bridge_chair" then
			sound_name = "bri_29"
			interact_type = "cmd_point"
		elseif voice_type == "undercover_interrogate" then
			sound_name = "f46x_any"
			interact_type = "cmd_point"
		elseif voice_type == "undercover_escort" then
			sound_name = "f41_any"
			interact_type = "cmd_point"
		elseif voice_type == "mark_camera" then
			sound_name = "f39_any"
			interact_type = "cmd_point"

			prime_target.unit:contour():add("mark_unit", true, self._highlight_special_mul)
		elseif voice_type == "mark_turret" then
			sound_name = "f44x_any"
			interact_type = "cmd_point"
			local contour_ext = prime_target.unit:contour()

			if contour_ext then
				local type = prime_target.unit:base().get_type and prime_target.unit:base():get_type()

				prime_target.unit:contour():add(managers.player:get_contour_for_marked_enemy(type), true, self._highlight_special_mul)
			end
		elseif voice_type == "ai_stay" then
			sound_name = "f48x_any"
			interact_type = "cmd_stop"
		end

		self:_do_action_intimidate(t, interact_type, sound_name, skip_alert)
	end
end

-- Increase interaction speed when inspired
function PlayerStandard:_get_interaction_speed()
	local dt = managers.player:player_timer():delta_time()

	local morale_boost_bonus = self._ext_movement:morale_boost()
	if morale_boost_bonus then
		dt = dt * morale_boost_bonus.move_speed_bonus
	end

	return dt
end

-- Talking always makes noise, affected by less noise upgrade
function PlayerStandard:say_line(sound_name, skip_alert)
	self._unit:sound():say(sound_name, true, false)

	skip_alert = false -- always make noise

	if not skip_alert then
		local alert_rad = tweak_data.player.speak_alert_size or 500
		alert_rad = alert_rad * managers.player:upgrade_value("player", "less_noise_multiplier", 1)
		local new_alert = {
			"vo_cbt",
			self._unit:movement():m_head_pos(),
			alert_rad,
			self._unit:movement():SO_access(),
			self._unit,
		}

		managers.groupai:state():propagate_alert(new_alert)
	end
end

-- Sprinting always makes noise, affected by less noise upgrade
Hooks:PreHook(PlayerStandard, "_update_movement", "eclipse_update_movement", function(self, t)
	local cur_pos = pos_new or self._pos
	local move_dis = mvector3.distance_sq(cur_pos, self._last_sent_pos)
	if not self:_on_zipline() and (move_dis > 22500 or move_dis > 400 and (t - self._last_sent_pos_t > 1.5 or not pos_new)) then
		self._ext_network:send("action_walk_nav_point", cur_pos)
		mvector3.set(self._last_sent_pos, cur_pos)
		self._last_sent_pos_t = t
		if self._move_dir and self._running and not self._state_data.ducking and not managers.groupai:state():enemy_weapons_hot() then
			local alert_epicenter = mvector3.copy(self._last_sent_pos)
			mvector3.set_z(alert_epicenter, alert_epicenter.z + 150)
			local alert_rad = (tweak_data.player.running_alert_size or 400) * mvector3.length(self._move_dir)
			--	alert_rad = alert_rad * managers.player:upgrade_value("player", "less_noise_multiplier", 1)
			local new_alert = {
				"footstep",
				alert_epicenter,
				alert_rad,
				managers.groupai:state():get_unit_type_filter("civilians_enemies"),
				self._unit,
			}
			managers.groupai:state():propagate_alert(new_alert)
		end
	end
end)

-- have to overwrite the whole function just to add a single damage multiplier for berserker :sob:
function PlayerStandard:_do_melee_damage(t, bayonet_melee, melee_hit_ray, melee_entry, hand_id)
	melee_entry = melee_entry or managers.blackmarket:equipped_melee_weapon()
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
	local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0
	local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)

	self._ext_camera:play_shaker(table.random(PlayerStandard._MELEE_VARS), math.max(0.3, charge_lerp_value))

	local sphere_cast_radius = 20
	local col_ray = nil

	if melee_hit_ray then
		col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
	else
		col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius)
	end

	if col_ray and alive(col_ray.unit) then
		local damage, damage_effect = managers.blackmarket:equipped_melee_weapon_damage_info(charge_lerp_value)
		local damage_effect_mul = math.max(
			managers.player:upgrade_value("player", "melee_knockdown_mul", 1),
			managers.player:upgrade_value(self._equipped_unit:base():weapon_tweak_data().categories and self._equipped_unit:base():weapon_tweak_data().categories[1], "melee_knockdown_mul", 1)
		)
		damage = damage * managers.player:get_melee_dmg_multiplier()
		damage_effect = damage_effect * damage_effect_mul
		col_ray.sphere_cast_radius = sphere_cast_radius
		local hit_unit = col_ray.unit

		if hit_unit:character_damage() then
			if bayonet_melee then
				self._unit:sound():play("fairbairn_hit_body", nil, false)
			else
				local hit_sfx = "hit_body"

				if hit_unit:character_damage() and hit_unit:character_damage().melee_hit_sfx then
					hit_sfx = hit_unit:character_damage():melee_hit_sfx()
				end

				self:_play_melee_sound(melee_entry, hit_sfx, self._melee_attack_var)
			end

			if not hit_unit:character_damage()._no_blood then
				managers.game_play_central:play_impact_flesh({
					col_ray = col_ray,
				})
				managers.game_play_central:play_impact_sound_and_effects({
					no_decal = true,
					no_sound = true,
					col_ray = col_ray,
				})
			end

			self._camera_unit:base():play_anim_melee_item("hit_body")
		else
			if self._on_melee_restart_drill and hit_unit:base() and (hit_unit:base().is_drill or hit_unit:base().is_saw) then
				hit_unit:base():on_melee_hit(managers.network:session():local_peer():id())
			end

			if bayonet_melee then
				self._unit:sound():play("knife_hit_gen", nil, false)
			else
				self:_play_melee_sound(melee_entry, "hit_gen", self._melee_attack_var)
			end

			self._camera_unit:base():play_anim_melee_item("hit_gen")
			managers.game_play_central:play_impact_sound_and_effects({
				no_decal = true,
				no_sound = true,
				col_ray = col_ray,
				effect = Idstring("effects/payday2/particles/impacts/fallback_impact_pd2"),
			})
		end

		local custom_data = nil

		if _G.IS_VR and hand_id then
			custom_data = {
				engine = hand_id == 1 and "right" or "left",
			}
		end

		managers.rumble:play("melee_hit", nil, nil, custom_data)
		managers.game_play_central:physics_push(col_ray)

		local character_unit, shield_knock = nil
		local can_shield_knock = managers.player:has_category_upgrade("player", "shield_knock")

		if can_shield_knock and hit_unit:in_slot(8) and alive(hit_unit:parent()) and not hit_unit:parent():character_damage():is_immune_to_shield_knockback() then
			shield_knock = true
			character_unit = hit_unit:parent()
		end

		character_unit = character_unit or hit_unit

		if character_unit:character_damage() and character_unit:character_damage().damage_melee then
			local dmg_multiplier = 1

			if not managers.enemy:is_civilian(character_unit) and not managers.groupai:state():is_enemy_special(character_unit) then
				dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "non_special_melee_multiplier", 1)
			else
				dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_damage_multiplier", 1)
			end

			-- Berserker melee damage bonus
			dmg_multiplier = dmg_multiplier * (1 + managers.player:get_property("berserker_melee_damage", 0))

			dmg_multiplier = dmg_multiplier
				* managers.player:upgrade_value("player", "melee_" .. tostring(tweak_data.blackmarket.melee_weapons[melee_entry].stats.weapon_type) .. "_damage_multiplier", 1)

			if character_unit:base() and character_unit:base().char_tweak and character_unit:base():char_tweak().priority_shout then
				dmg_multiplier = dmg_multiplier * (tweak_data.blackmarket.melee_weapons[melee_entry].stats.special_damage_multiplier or 1)
			end

			if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
				self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
				self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
					nil,
					0,
				}
				local stack = self._state_data.stacking_dmg_mul.melee

				if stack[1] and t < stack[1] then
					dmg_multiplier = dmg_multiplier * (1 + managers.player:upgrade_value("melee", "stacking_hit_damage_multiplier", 0) * stack[2])
				else
					stack[2] = 0
				end
			end

			local health_ratio = self._ext_damage:health_ratio()
			local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, "melee")

			if damage_health_ratio > 0 then
				dmg_multiplier = dmg_multiplier * (1 + self._damage_health_ratio_mul_melee * damage_health_ratio)
			end

			dmg_multiplier = dmg_multiplier * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
			local target_dead = character_unit:character_damage().dead and not character_unit:character_damage():dead()
			local target_hostile = managers.enemy:is_enemy(character_unit) and not tweak_data.character[character_unit:base()._tweak_table].is_escort and character_unit:brain():is_hostile()
			local life_leach_available = managers.player:has_category_upgrade("temporary", "melee_life_leech") and not managers.player:has_activate_temporary_upgrade("temporary", "melee_life_leech")

			if target_dead and target_hostile and life_leach_available then
				managers.player:activate_temporary_upgrade("temporary", "melee_life_leech")
				self._unit:character_damage():restore_health(managers.player:temporary_upgrade_value("temporary", "melee_life_leech", 1))
			end

			local action_data = {
				variant = "melee",
			}

			if _G.IS_VR and melee_entry == "weapon" and not bayonet_melee then
				dmg_multiplier = 0.1
			end

			action_data.damage = shield_knock and 0 or damage * dmg_multiplier
			action_data.damage_effect = damage_effect
			action_data.attacker_unit = self._unit
			action_data.col_ray = col_ray

			if shield_knock then
				action_data.shield_knock = can_shield_knock
			end

			action_data.name_id = melee_entry
			action_data.charge_lerp_value = charge_lerp_value

			if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
				self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
				self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
					nil,
					0,
				}
				local stack = self._state_data.stacking_dmg_mul.melee

				if character_unit:character_damage().dead and not character_unit:character_damage():dead() then
					stack[1] = t + managers.player:upgrade_value("melee", "stacking_hit_expire_t", 1)
					stack[2] = math.min(stack[2] + 1, tweak_data.upgrades.max_melee_weapon_dmg_mul_stacks or 5)
				else
					stack[1] = nil
					stack[2] = 0
				end
			end

			local defense_data = character_unit:character_damage():damage_melee(action_data)

			self:_check_melee_special_damage(col_ray, character_unit, defense_data, melee_entry)
			self:_perform_sync_melee_damage(hit_unit, col_ray, action_data.damage)

			return defense_data
		else
			self:_perform_sync_melee_damage(hit_unit, col_ray, damage)
		end
	end

	if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
		self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
		self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
			nil,
			0,
		}
		local stack = self._state_data.stacking_dmg_mul.melee
		stack[1] = nil
		stack[2] = 0
	end

	return col_ray
end

local function set_hos(self)
	self._ext_network:send("set_stance", 2, false, false)
end

local function set_cbt(self)
	self._ext_network:send("set_stance", 3, false, false)
end

Hooks:PostHook(PlayerStandard, "_enter", "_enter_hos", set_hos)
Hooks:PostHook(PlayerStandard, "_start_action_steelsight", "_start_action_steelsight_hos", set_cbt)
Hooks:PostHook(PlayerStandard, "_end_action_steelsight", "_end_action_steelsight_hos", set_hos)
Hooks:PostHook(PlayerStandard, "set_running", "set_running_hos", set_hos)

-- Ranged revive inspire rework
function PlayerStandard:_get_intimidation_action(prime_target, char_table, amount, primary_only, detect_only, secondary)
	local voice_type, new_action, plural = nil
	local unit_type_enemy = 0
	local unit_type_civilian = 1
	local unit_type_teammate = 2
	local unit_type_camera = 3
	local unit_type_turret = 4
	local is_whisper_mode = managers.groupai:state():whisper_mode()

	if prime_target then
		if prime_target.unit_type == unit_type_teammate then
			local is_human_player, record = nil

			if not detect_only then
				record = managers.groupai:state():all_criminals()[prime_target.unit:key()]

				if record.ai then
					if not prime_target.unit:brain():player_ignore() then
						prime_target.unit:movement():set_cool(false)
						prime_target.unit:brain():on_long_dis_interacted(0, self._unit, secondary)
					end
				else
					is_human_player = true
				end
			end

			local amount = 0

			if not secondary then
				local current_state_name = self._unit:movement():current_state_name()

				if current_state_name ~= "arrested" and current_state_name ~= "bleed_out" and current_state_name ~= "fatal" and current_state_name ~= "incapacitated" then
					local rally_skill_data = self._ext_movement:rally_skill_data()

					if rally_skill_data and mvec3_dis_sq(self._pos, record.m_pos) < rally_skill_data.range_sq then
						local needs_revive, is_arrested = nil

						if prime_target.unit:base().is_husk_player then
							is_arrested = prime_target.unit:movement():current_state_name() == "arrested"
							needs_revive = prime_target.unit:interaction():active() and prime_target.unit:movement():need_revive() and not is_arrested
						else
							is_arrested = prime_target.unit:character_damage():arrested()
							needs_revive = prime_target.unit:character_damage():need_revive()
						end

						if needs_revive then
							if managers.player:has_enabled_cooldown_upgrade("cooldown", "long_dis_revive") then
								voice_type = "revive"

								if rally_skill_data.charges > 0 then
									managers.player:player_unit():movement():set_inspire_charges(rally_skill_data.charges - 1)
								else
									managers.player:player_unit():movement():set_inspire_charges(tweak_data.upgrades.values.init_inspire_charges - 1)
								end
							elseif rally_skill_data.charges > 0 then
								voice_type = "revive"

								managers.player:player_unit():movement():set_inspire_charges(rally_skill_data.charges - 1)
							end
						elseif
							is_human_player
							and not is_arrested
							and not needs_revive
							and rally_skill_data.morale_boost_delay_t
							and rally_skill_data.morale_boost_delay_t < managers.player:player_timer():time()
						then
							voice_type = "boost"
							amount = 1
						end
					end
				end
			end

			if is_human_player then
				prime_target.unit:network():send_to_unit({
					"long_dis_interaction",
					prime_target.unit,
					amount,
					self._unit,
					secondary or false,
				})
			end

			voice_type = voice_type or secondary and "ai_stay" or "come"
			plural = false
		else
			local prime_target_key = prime_target.unit:key()

			if prime_target.unit_type == unit_type_enemy then
				plural = false

				if prime_target.unit:anim_data().hands_back then
					voice_type = "cuff_cop"
				elseif prime_target.unit:anim_data().surrender then
					voice_type = "down_cop"
				elseif is_whisper_mode and prime_target.unit:movement():cool() and prime_target.unit:base():char_tweak().silent_priority_shout then
					voice_type = "mark_cop_quiet"
				elseif prime_target.unit:base():char_tweak().priority_shout then
					voice_type = "mark_cop"
				else
					voice_type = "stop_cop"
				end
			elseif prime_target.unit_type == unit_type_camera then
				plural = false
				voice_type = "mark_camera"
			elseif prime_target.unit_type == unit_type_turret then
				plural = false
				voice_type = "mark_turret"
			elseif prime_target.unit:base():char_tweak().is_escort then
				plural = false
				local e_guy = prime_target.unit

				if e_guy:anim_data().move or e_guy:anim_data().standing_hesitant then
					voice_type = "escort_keep"
				elseif e_guy:anim_data().panic then
					voice_type = "escort_go"
				else
					voice_type = prime_target.unit:base():char_tweak().speech_escort or "escort"
				end
			else
				if prime_target.unit:anim_data().drop then
					voice_type = "down_stay"
				elseif prime_target.unit:anim_data().tied or prime_target.unit:movement():stance_name() == "cbt" then
					voice_type = "come"
				elseif prime_target.unit:anim_data().move then
					voice_type = "stop"
				else
					voice_type = "down"
				end

				local num_affected = 0

				if voice_type ~= "come" then
					for _, char in pairs(char_table) do
						if char.unit_type == unit_type_civilian then
							if voice_type == "stop" and char.unit:anim_data().move then
								num_affected = num_affected + 1
							elseif voice_type == "down_stay" and char.unit:anim_data().drop then
								num_affected = num_affected + 1
							elseif voice_type == "down" and not char.unit:anim_data().move and not char.unit:anim_data().drop then
								num_affected = num_affected + 1
							end

							if num_affected > 1 then
								break
							end
						end
					end
				end

				if num_affected > 1 then
					plural = true
				else
					plural = false
				end
			end

			if detect_only then
				voice_type = "come"
			else
				local max_inv_wgt = 0

				for _, char in pairs(char_table) do
					if max_inv_wgt < char.inv_wgt then
						max_inv_wgt = char.inv_wgt
					end
				end

				if max_inv_wgt < 1 then
					max_inv_wgt = 1
				end

				amount = amount or tweak_data.player.long_dis_interaction.intimidate_strength
				local amount_civ = amount * managers.player:upgrade_value("player", "civ_intimidation_mul", 1) * managers.player:team_upgrade_value("player", "civ_intimidation_mul", 1)

				for _, char in pairs(char_table) do
					if char.unit_type ~= unit_type_camera and char.unit_type ~= unit_type_teammate and (not is_whisper_mode or not char.unit:movement():cool()) then
						local int_amount = char.unit_type == unit_type_civilian and amount_civ or amount

						if prime_target_key == char.unit:key() then
							voice_type = char.unit:brain():on_intimidated(int_amount, self._unit) or voice_type
						elseif not primary_only and char.unit_type ~= unit_type_enemy then
							char.unit:brain():on_intimidated(int_amount * char.inv_wgt / max_inv_wgt, self._unit)
						end
					end
				end
			end
		end
	end

	return voice_type, plural, prime_target
end

-- fuck this shit, i have to overwrite the whole function because of one single variable (this is still part of reworking inspire aced)
function PlayerStandard:_get_unit_intimidation_action(
	intimidate_enemies,
	intimidate_civilians,
	intimidate_teammates,
	only_special_enemies,
	intimidate_escorts,
	intimidation_amount,
	primary_only,
	detect_only,
	secondary
)
	local char_table = {}
	local unit_type_enemy = 0
	local unit_type_civilian = 1
	local unit_type_teammate = 2
	local unit_type_camera = 3
	local unit_type_turret = 4
	local cam_fwd = self._ext_camera:forward()
	local my_head_pos = self._ext_movement:m_head_pos()

	if _G.IS_VR then
		local hand_unit = self._unit:hand():hand_unit(self._interact_hand)

		if hand_unit:raycast("ray", hand_unit:position(), my_head_pos, "slot_mask", 1) then
			return
		end

		cam_fwd = hand_unit:rotation():y()
		my_head_pos = hand_unit:position()
	end

	local spotting_mul = managers.player:upgrade_value("player", "marked_distance_mul", 1)
	local range_mul = managers.player:upgrade_value("player", "intimidate_range_mul", 1) * managers.player:upgrade_value("player", "passive_intimidate_range_mul", 1)
	local intimidate_range_escort = tweak_data.player.long_dis_interaction.intimidate_range_escorts
	local intimidate_range_civ = tweak_data.player.long_dis_interaction.intimidate_range_civilians * range_mul
	local intimidate_range_ene = tweak_data.player.long_dis_interaction.intimidate_range_enemies * range_mul
	local highlight_range = tweak_data.player.long_dis_interaction.highlight_range * range_mul * spotting_mul
	local intimidate_range_teammates = tweak_data.player.long_dis_interaction.intimidate_range_teammates
	local is_whisper_mode = managers.groupai:state():whisper_mode()
	local special_area_param = {
		45,
		15,
	}

	if intimidate_enemies then
		local my_foes = self._unit:movement():team().foes
		local highlight_range_sq = highlight_range * highlight_range

		for u_key, u_data in pairs(managers.enemy:all_enemies()) do
			if
				my_foes[u_data.unit:movement():team().id]
				and not u_data.unit:anim_data().hands_tied
				and not u_data.unit:anim_data().long_dis_interact_disabled
				and (not u_data.unit:character_damage() or not u_data.unit:character_damage():dead())
				and (not only_special_enemies or u_data.char_tweak.priority_shout)
			then
				if is_whisper_mode then
					if u_data.unit:movement():cool() then
						if u_data.char_tweak.silent_priority_shout then
							self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, highlight_range, false, false, 0.01, my_head_pos, cam_fwd)
						end
					elseif u_data.char_tweak.priority_shout then
						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, highlight_range, false, special_area_param, 200, my_head_pos, cam_fwd)
					elseif u_data.char_tweak.surrender and not u_data.char_tweak.surrender.impossible then
						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, intimidate_range_ene, false, false, 100, my_head_pos, cam_fwd, nil, "ai_vision mover")
					end
				elseif u_data.char_tweak.priority_shout then
					local area_param = special_area_param
					local range = highlight_range

					if u_data.unit:base():has_tag("sniper") and highlight_range_sq < mvec3_dis_sq(self._pos, u_data.m_pos) then
						area_param = {
							15,
							5,
						}
						range = nil
					end

					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, range, false, area_param, 200, my_head_pos, cam_fwd)
				elseif u_data.char_tweak.surrender and not u_data.char_tweak.surrender.impossible then
					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, intimidate_range_ene, false, false, 100, my_head_pos, cam_fwd, nil, "ai_vision mover")
				end
			end
		end
	end

	if intimidate_civilians then
		for u_key, u_data in pairs(managers.enemy:all_civilians()) do
			if
				alive(u_data.unit)
				and (u_data.unit:in_slot(21) or not u_data.unit:anim_data().drop and u_data.unit:in_slot(22))
				and not u_data.unit:movement():cool()
				and not u_data.unit:anim_data().long_dis_interact_disabled
			then
				local is_escort = u_data.char_tweak.is_escort

				if (not is_escort or intimidate_escorts) and (is_escort or not u_data.unit:anim_data().drop or not u_data.unit:anim_data().tied) then
					local dist = is_escort and intimidate_range_escort or intimidate_range_civ
					local prio = is_escort and 100000 or 0.001

					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_civilian, dist, false, false, prio, my_head_pos, cam_fwd)
				end
			end
		end
	end

	if intimidate_teammates and not managers.groupai:state():whisper_mode() and self._ext_movement:rally_skill_data() ~= nil then
		local rally_skill_data = self._ext_movement:rally_skill_data()
		local can_long_dis_revive = not secondary and rally_skill_data and rally_skill_data.long_dis_revive and managers.player:has_enabled_cooldown_upgrade("cooldown", "long_dis_revive")	or rally_skill_data.charges > 0

		for u_key, u_data in pairs(managers.groupai:state():all_char_criminals()) do
			if u_key ~= self._unit:key() then
				local added = nil

				if can_long_dis_revive then
					local needs_revive = nil

					if u_data.unit:base().is_husk_player then
						needs_revive = u_data.unit:interaction():active() and u_data.unit:movement():need_revive() and u_data.unit:movement():current_state_name() ~= "arrested"
					elseif not u_data.is_deployable then
						needs_revive = u_data.unit:character_damage():need_revive()
					end

					if needs_revive and mvec3_dis_sq(self._pos, u_data.m_pos) < rally_skill_data.range_sq then
						added = true

						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, nil, true, true, 100000, my_head_pos, cam_fwd)
					end
				end

				if
					not added
					and (not secondary or u_data.ai and not u_data.unit:movement():should_stay())
					and not u_data.is_deployable
					and not u_data.unit:movement():downed()
					and not u_data.unit:anim_data().long_dis_interact_disabled
				then
					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, intimidate_range_teammates, true, not secondary, 0.01, my_head_pos, cam_fwd)
				end
			end
		end
	end

	if intimidate_enemies and intimidate_teammates then
		for u_key, u_data in pairs(managers.enemy:all_enemies()) do
			local is_escort = u_data.char_tweak.is_escort

			if
				(not is_escort or intimidate_escorts)
				and not u_data.unit:movement():cool()
				and not u_data.unit:anim_data().long_dis_interact_disabled
				and u_data.unit:movement():team()
				and u_data.unit:movement():team().id == "criminal1"
			then
				local dist = is_escort and intimidate_range_escort or intimidate_range_civ
				local prio = is_escort and 100000 or 0.001

				self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_civilian, dist, false, false, prio, my_head_pos, cam_fwd)
			end
		end
	end

	if intimidate_enemies then
		if managers.groupai:state():whisper_mode() then
			local dist = tweak_data.player.long_dis_interaction.highlight_range_cameras * range_mul * spotting_mul

			for _, unit in ipairs(SecurityCamera.cameras) do
				if
					alive(unit)
					and unit:enabled()
					and not unit:base():destroyed()
					and (unit:base().is_friendly or unit:interaction() and unit:interaction():active() and not unit:interaction():disabled())
				then
					self:_add_unit_to_char_table(char_table, unit, unit_type_camera, dist, false, false, 0.0001, my_head_pos, cam_fwd, {
						unit,
					})
				end
			end
		end

		for u_key, unit in pairs(managers.groupai:state():turrets()) do
			if alive(unit) and not unit:character_damage():dead() and unit:movement():team().foes[self._ext_movement:team().id] then
				self:_add_unit_to_char_table(char_table, unit, unit_type_turret, highlight_range, false, special_area_param, 150, my_head_pos, cam_fwd, {
					unit,
				})
			end
		end
	end

	local prime_target = self:_get_interaction_target(char_table, my_head_pos, cam_fwd, secondary)

	return self:_get_intimidation_action(prime_target, char_table, intimidation_amount, primary_only, detect_only, secondary)
end
