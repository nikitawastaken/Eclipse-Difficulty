-- uppers cooldown
PlayerDamage._UPPERS_COOLDOWN = 120
local is_pro_job = Eclipse.utils.is_pro_job()

-- Pro-Jobs (one down modifier) don't reduce your downs anymore
Hooks:PreHook(PlayerDamage, "replenish", "eclipse_replenish", function(self)
	self._armor_broken_dodge = false
	if is_pro_job then
		self._lives_init = 4
	end
end)

-- Upgrade that heals you when you revive others
Hooks:PostHook(PlayerDamage, "init", "eclipse_init", function(self)
	if managers.player:has_category_upgrade("player", "action_revive_health_regen") then
		local function on_revive_interaction_success()
			self:restore_health_percentage(managers.player:upgrade_value("player", "action_revive_health_regen", 0))
		end

		self._listener_holder:add("on_revive_interaction_success", {
			"on_revive_interaction_success",
		}, on_revive_interaction_success)
	end
end)

-- Armor regen time depends on the armor you're wearing
function PlayerDamage:set_regenerate_timer_to_max()
	local mul = managers.player:body_armor_regen_multiplier(alive(self._unit) and self._unit:movement():current_state()._moving, self:health_ratio())
	self._regenerate_timer = managers.player:body_armor_value("regen_timer") * mul
	self._regenerate_timer = self._regenerate_timer * managers.player:upgrade_value("player", "armor_regen_time_mul", 1)
	self._regenerate_speed = self._regenerate_speed or 1
	self._current_state = self._update_regenerate_timer
end

function PlayerDamage:damage_bullet(attack_data)
	if not self:_chk_can_take_dmg() then
		return
	end

	local damage_info = {
		result = {
			variant = "bullet",
			type = "hurt",
		},
		attacker_unit = attack_data.attacker_unit,
		attack_dir = attack_data.attacker_unit and attack_data.attacker_unit:movement():m_pos() - self._unit:movement():m_pos() or Vector3(1, 0, 0),
		pos = mvector3.copy(self._unit:movement():m_head_pos()),
	}
	local pm = managers.player
	local dmg_mul = pm:damage_reduction_skill_multiplier("bullet")
	attack_data.damage = attack_data.damage * dmg_mul
	attack_data.damage = managers.mutators:modify_value("PlayerDamage:TakeDamageBullet", attack_data.damage)
	attack_data.damage = managers.modifiers:modify_value("PlayerDamage:TakeDamageBullet", attack_data.damage, attack_data.attacker_unit:base()._tweak_table)

	if _G.IS_VR then
		local distance = mvector3.distance(self._unit:position(), attack_data.attacker_unit:position())

		if tweak_data.vr.long_range_damage_reduction_distance[1] < distance then
			local step = math.clamp(distance / tweak_data.vr.long_range_damage_reduction_distance[2], 0, 1)
			local mul = 1 - math.step(tweak_data.vr.long_range_damage_reduction[1], tweak_data.vr.long_range_damage_reduction[2], step)
			attack_data.damage = attack_data.damage * mul
		end
	end

	local damage_absorption = pm:damage_absorption()

	if damage_absorption > 0 then
		attack_data.damage = math.max(0, attack_data.damage - damage_absorption)
	end

	-- Eclipse:log_chat("damage received: " .. attack_data.damage * 10)

	self:copr_update_attack_data(attack_data)

	if self._god_mode then
		if attack_data.damage > 0 then
			self:_send_damage_drama(attack_data, attack_data.damage)
		end

		self:_call_listeners(damage_info)

		return
	elseif self._invulnerable or self._mission_damage_blockers.invulnerable then
		self:_call_listeners(damage_info)

		return
	elseif self:incapacitated() then
		return
	elseif self:is_friendly_fire(attack_data.attacker_unit) then
		return
	elseif self:_chk_dmg_too_soon(attack_data.damage) then
		return
	elseif self._unit:movement():current_state().immortal then
		return
	elseif self._revive_miss and math.random() < self._revive_miss then
		self:play_whizby(attack_data.col_ray.position)

		return
	end

	self._last_received_dmg = attack_data.damage
	self._next_allowed_dmg_t = Application:digest_value(pm:player_timer():time() + self._dmg_interval, true)
	local dodge_roll = math.random()
	local dodge_value = tweak_data.player.damage.DODGE_INIT or 0
	local armor_dodge_chance = pm:body_armor_value("dodge")
	local skill_dodge_chance = pm:skill_dodge_chance(self._unit:movement():running(), self._unit:movement():crouching(), self._unit:movement():zipline_unit())
	dodge_value = dodge_value + armor_dodge_chance + skill_dodge_chance

	-- Dodge while armor is broken
	if self._armor_broken_dodge then
		dodge_value = dodge_value + tweak_data.upgrades.values.player.armor_break_dodge[1]
	end

	if self._temporary_dodge_t and TimerManager:game():time() < self._temporary_dodge_t then
		dodge_value = dodge_value + self._temporary_dodge
	end

	local smoke_dodge = 0

	for _, smoke_screen in ipairs(managers.player._smoke_screen_effects or {}) do
		if smoke_screen:is_in_smoke(self._unit) then
			smoke_dodge = tweak_data.projectiles.smoke_screen_grenade.dodge_chance

			break
		end
	end

	dodge_value = 1 - (1 - dodge_value) * (1 - smoke_dodge)

	if dodge_roll < dodge_value then
		if attack_data.damage > 0 then
			self:_send_damage_drama(attack_data, 0)
		end

		self:_call_listeners(damage_info)
		self:play_whizby(attack_data.col_ray.position)
		self:_hit_direction(attack_data.attacker_unit:position(), attack_data.col_ray and attack_data.col_ray.ray or damage_info.attacK_dir)

		self._next_allowed_dmg_t = Application:digest_value(pm:player_timer():time() + self._dmg_interval, true)
		self._last_received_dmg = attack_data.damage

		managers.player:send_message(Message.OnPlayerDodge, nil, attack_data)

		return
	end

	if attack_data.attacker_unit:base()._tweak_table == "tank" then
		managers.achievment:set_script_data("dodge_this_fail", true)
	end

	if self:get_real_armor() > 0 then
		self._unit:sound():play("player_hit")
	else
		self._unit:sound():play("player_hit_permadamage")
	end

	-- Aimpunch
	local has_active_injector = managers.player:has_activate_temporary_upgrade("temporary", "chico_injector")
	local is_in_steelsight = self._unit:movement():current_state()._state_data.in_full_steelsight
	local shake_armor_multiplier = pm:body_armor_value("damage_shake")
		* (self:get_real_armor() > 0 and 1 or 1.25)
		* (is_in_steelsight and pm:upgrade_value("player", "steelsight_aimpunch_multiplier", 1) or 1)
	local gui_shake_number = tweak_data.gui.armor_damage_shake_base / shake_armor_multiplier
	gui_shake_number = gui_shake_number + pm:upgrade_value("player", "damage_shake_addend", 0)
	shake_armor_multiplier = tweak_data.gui.armor_damage_shake_base / gui_shake_number

	local shake_mul = math.clamp(attack_data.damage, 1, 12) * shake_armor_multiplier * (has_active_injector and 0.5 or 1)
	self._unit:camera():play_shaker("player_bullet_damage", shake_mul)

	-- On-hit stamina strip
	local stamina_strip_armor_multiplier = pm:body_armor_value("damage_shake")
		* (self:get_real_armor() > 0 and 1 or 1.25)
		* (is_in_steelsight and pm:upgrade_value("player", "steelsight_stamina_reduction_multiplier", 1) or 1)
		* (pm:is_wearing_a_ballistic_vest() and pm:upgrade_value("player", "bv_stamina_reduction_multiplier", 1) or 1)

	local stamina_mul = math.clamp(attack_data.damage, 1, 12) * stamina_strip_armor_multiplier * (has_active_injector and 0 or 1)
	self._unit:movement():subtract_stamina(stamina_mul)

	if not _G.IS_VR then
		managers.rumble:play("damage_bullet")
	end

	self:_hit_direction(attack_data.attacker_unit:position(), attack_data.col_ray and attack_data.col_ray.ray or damage_info.attacK_dir)
	pm:check_damage_carry(attack_data)

	attack_data.damage = managers.player:modify_value("damage_taken", attack_data.damage, attack_data)

	if self._bleed_out then
		self:_bleed_out_damage(attack_data)

		return
	end

	if not attack_data.ignore_suppression and not self:is_suppressed() then
		return
	end

	self:mutator_update_attack_data(attack_data)
	self:_check_chico_heal(attack_data)

	local armor_reduction_multiplier = 0

	if self:get_real_armor() <= 0 then
		armor_reduction_multiplier = 1
	end

	local health_subtracted = self:_calc_armor_damage(attack_data)

	-- crook ballistic vest ap rounds protection
	if attack_data.armor_piercing and not (pm:is_wearing_a_ballistic_vest() and pm:has_category_upgrade("player", "bv_ap_rnds_protection")) then
		attack_data.damage = attack_data.damage - health_subtracted
	else
		attack_data.damage = attack_data.damage * armor_reduction_multiplier
	end

	health_subtracted = health_subtracted + self:_calc_health_damage(attack_data)

	if not self._bleed_out and health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	elseif self._bleed_out then
		self:chk_queue_taunt_line(attack_data)
	end

	pm:send_message(Message.OnPlayerDamage, nil, attack_data)
	self:_call_listeners(damage_info)
end

-- Grace period protects no matter the new potential damage but is shorter in general (sh)
function PlayerDamage:_chk_dmg_too_soon()
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	return managers.player:player_timer():time() < next_allowed_dmg_t
end

-- Add slightly longer grace period on armor break (repurposing Anarchist/Armorer damage timer) / Add a skill that gives you dodge while your armor is broken
local _calc_armor_damage_original = PlayerDamage._calc_armor_damage
function PlayerDamage:_calc_armor_damage(...)
	local had_armor = self:get_real_armor() > 0
	local health_subtracted = _calc_armor_damage_original(self, ...)

	if had_armor and self:get_real_armor() <= 0 then
		if health_subtracted > 0 and self._can_take_dmg_timer <= 0 then
			self._can_take_dmg_timer = self._dmg_interval + (tweak_data.player.damage.ARMOR_BREAK_MIN_DAMAGE_INTERVAL or 0.15)
		end
	end

	return health_subtracted
end

-- Add slightly longer grace period on dodge (repurposing Anarchist/Armorer damage timer)
Hooks:PostHook(PlayerDamage, "_send_damage_drama", "sh__send_damage_drama", function(self, _, health_subtracted)
	if health_subtracted == 0 and self._can_take_dmg_timer and self._can_take_dmg_timer <= 0 then
		self._can_take_dmg_timer = self._dmg_interval / 2
	end
end)

-- More dodge on armor break upgrade stuff
function PlayerDamage:set_armor(armor)
	if self._armor_change_blocked then
		return
	end

	self:_check_update_max_armor()

	armor = math.clamp(armor, 0, self:_max_armor())

	if self._armor then
		local current_armor = self:get_real_armor()
		local has_armor_dodge = managers.player:has_enabled_cooldown_upgrade("cooldown", "dodge_on_armor_break")

		if current_armor == 0 and armor ~= 0 then
			self:consume_armor_stored_health()

			if has_armor_dodge then
				self._armor_broken_dodge = false
				managers.player:disable_cooldown_upgrade("cooldown", "dodge_on_armor_break")
			end
		elseif current_armor ~= 0 and armor == 0 then
			if self._dire_need then
				local function clbk()
					return self:is_regenerating_armor()
				end

				managers.player:add_coroutine(PlayerAction.DireNeed, PlayerAction.DireNeed, clbk, managers.player:upgrade_value("player", "armor_depleted_stagger_shot", 0))
			end

			if has_armor_dodge then
				self._armor_broken_dodge = true
			end
		end
	end

	self._armor = Application:digest_value(armor, true)
end

function PlayerDamage:_calc_health_damage(attack_data)
	if attack_data.weapon_unit then
		local weap_base = alive(attack_data.weapon_unit) and attack_data.weapon_unit:base()
		local weap_tweak_data = weap_base and weap_base.weapon_tweak_data and weap_base:weapon_tweak_data()

		if weap_tweak_data and weap_tweak_data.slowdown_data then
			self:apply_slowdown(weap_tweak_data.slowdown_data)
		end
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "mrwi_health_invulnerable") then
		return 0
	end

	local health_subtracted = 0
	health_subtracted = self:get_real_health()

	self:change_health(-attack_data.damage)

	health_subtracted = health_subtracted - self:get_real_health()

	if managers.player:has_activate_temporary_upgrade("temporary", "copr_ability") and health_subtracted > 0 then
		local teammate_heal_level = managers.player:upgrade_level_nil("player", "copr_teammate_heal")

		if teammate_heal_level and self:get_real_health() > 0 then
			self._unit:network():send("copr_teammate_heal", teammate_heal_level)
		end
	end

	if self._has_mrwi_health_invulnerable then
		local health_threshold = self._mrwi_health_invulnerable_threshold or 0.5
		local is_cooling_down = managers.player:get_temporary_property("mrwi_health_invulnerable", false)

		-- Make <50%hp invuln upgrade not proc on armor hits
		if self:health_ratio() <= health_threshold and health_subtracted > 0 and not is_cooling_down then -- was it so hard to just add one more check, overkill?
			local cooldown_time = self._mrwi_health_invulnerable_cooldown or 10

			managers.player:activate_temporary_upgrade("temporary", "mrwi_health_invulnerable")
			managers.player:activate_temporary_property("mrwi_health_invulnerable", cooldown_time, true)
		end
	end

	local trigger_skills = table.contains({
		"bullet",
		"explosion",
		"melee",
		"delayed_tick",
	}, attack_data.variant)

	if self:get_real_health() == 0 and trigger_skills then
		self:_chk_cheat_death()
	end

	self:_damage_screen()
	self:_check_bleed_out(trigger_skills)
	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false),
	})
	self:_send_set_health()
	self:_set_health_effect()
	managers.statistics:health_subtracted(health_subtracted)

	return health_subtracted
end

function PlayerDamage:revive(silent)
	local was_bleedout = self._bleed_out

	if Application:digest_value(self._revives, false) == 0 then
		self._revive_health_multiplier = nil

		return
	end

	local arrested = self:arrested()

	managers.player:set_player_state("standard")
	managers.player:remove_copr_risen_cooldown()

	if not silent then
		PlayerStandard.say_line(self, "s05x_sin")
	end

	self._bleed_out = false
	self._incapacitated = nil
	self._downed_timer = nil
	self._downed_start_time = nil

	if not arrested then -- Change the extra revive health upgrades to be additive instead of multiplicative
		self:set_health(
			self:_max_health()
				* math.min(
					tweak_data.player.damage.REVIVE_HEALTH_STEPS[self._revive_health_i] + (self._revive_health_multiplier or 0) + managers.player:upgrade_value("player", "revived_health_regain", 0),
					1
				)
		)
		self:set_armor(self:_max_armor())

		self._revive_health_i = math.min(#tweak_data.player.damage.REVIVE_HEALTH_STEPS, self._revive_health_i + 1)
		self._revive_miss = 2
	end

	self:_regenerate_armor()
	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false),
	})
	self:_send_set_health()
	self:_set_health_effect()
	managers.hud:pd_stop_progress()

	self._revive_health_multiplier = nil

	self._listener_holder:call("on_revive")

	if managers.player:has_inactivate_temporary_upgrade("temporary", "revived_damage_resist") then
		managers.player:activate_temporary_upgrade("temporary", "revived_damage_resist")
	end

	if managers.player:has_inactivate_temporary_upgrade("temporary", "increased_movement_speed") then
		managers.player:activate_temporary_upgrade("temporary", "increased_movement_speed")
	end

	if managers.player:has_inactivate_temporary_upgrade("temporary", "swap_weapon_faster") then
		managers.player:activate_temporary_upgrade("temporary", "swap_weapon_faster")
	end

	if managers.player:has_inactivate_temporary_upgrade("temporary", "reload_weapon_faster") then
		managers.player:activate_temporary_upgrade("temporary", "reload_weapon_faster")
	end

	-- Fix fake downs progressing revive health and down timer steps
	if was_bleedout then
		self._down_time_i = self._down_time_i + 1
	else
		self._revive_health_i = math.max(self._revive_health_i - 1, 1)
	end

	local player_damage_tweak = tweak_data.player.damage
	self._down_time = math.max(
		player_damage_tweak.DOWNED_TIME_MIN,
		(player_damage_tweak.DOWNED_TIME + managers.player:upgrade_value("player", "increased_bleedout_timer", 0)) - player_damage_tweak.DOWNED_TIME_DEC * self._down_time_i
	)

	if MusicManager.set_volume_multiplier then
		managers.music:set_volume_multiplier("downed", 1, 1)
	end
end

-- Proper fall damage that scales based on height
function PlayerDamage:damage_fall(data)
	local player_tweak = tweak_data.player

	local damage_info = {
		result = {
			variant = "fall",
			type = "hurt",
		},
	}
	local is_free_falling = self._unit:movement():current_state_name() == "jerry1"

	if self._god_mode and not is_free_falling or self._invulnerable or self._mission_damage_blockers.invulnerable then
		self:_call_listeners(damage_info)

		return
	elseif self:incapacitated() then
		return
	elseif self._unit:movement():current_state().immortal then
		return
	elseif self._mission_damage_blockers.damage_fall_disabled then
		return
	end

	local height_limit = 400
	local death_limit = 630

	if data.height < height_limit then
		return
	end

	local die = death_limit < data.height

	self._unit:sound():play("player_hit")
	managers.environment_controller:hit_feedback_down()
	managers.hud:on_hit_direction(Vector3(0, 0, -1), die and HUDHitDirection.DAMAGE_TYPES.HEALTH or HUDHitDirection.DAMAGE_TYPES.ARMOUR, 0)

	if self._bleed_out and not is_free_falling then
		return
	end

	local fall_damage_ramp
	local fall_multiplier = player_tweak.fall_health_damage
	if die then
		managers.player:force_end_copr_ability()

		self._check_berserker_done = false

		self:set_health(0)

		if is_free_falling then
			self._revives = Application:digest_value(1, true)

			self:_send_set_revives()
		end
	else
		fall_damage_ramp = math.clamp((data.height - height_limit) / (death_limit - height_limit), 0.5, 1)

		fall_multiplier = fall_multiplier * fall_damage_ramp * (self:get_real_armor() > 0 and 0.75 or 1)
		fall_multiplier = fall_multiplier * managers.player:upgrade_value("player", "fall_damage_multiplier", 1) * managers.player:upgrade_value("player", "fall_damage_multiplier_cat", 1)

		local fall_damage = self:_max_health() * fall_multiplier

		self:change_health(-fall_damage)
		self._unit:camera():play_shaker("player_fall_damage", 1 * fall_multiplier)
	end

	if die or fall_multiplier > 0 then
		local alert_rad = (player_tweak.fall_damage_alert_size or 500) * managers.player:upgrade_value("player", "fall_damage_noise_multiplier", 1)
		local new_alert = {
			"vo_cbt",
			self._unit:movement():m_head_pos(),
			alert_rad,
			self._unit:movement():SO_access(),
			self._unit,
		}

		managers.groupai:state():propagate_alert(new_alert)
	end

	self._bleed_out_blocked_by_movement_state = nil

	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false),
	})
	self:_send_set_health()
	self:_set_health_effect()
	self:_damage_screen()
	self:_check_bleed_out(nil, true)
	self:_call_listeners(damage_info)

	return true
end

-- Tear gas damage slowly scales when the player is exposed to it and goes through armor
local damage_killzone_original = PlayerDamage.damage_killzone
function PlayerDamage:damage_killzone(attack_data, ...)
	if attack_data.variant ~= "teargas" then
		return damage_killzone_original(self, attack_data, ...)
	end

	local damage_info = {
		result = {
			variant = "killzone",
			type = "hurt",
		},
	}

	if self._god_mode or self._invulnerable or self._mission_damage_blockers.invulnerable then
		self:_call_listeners(damage_info)
		return
	elseif self:is_downed() or self._unit:movement():current_state().immortal then
		self._last_teargas_hit_t = nil
		return
	end

	local t = managers.player:player_timer():time()
	if not self._last_teargas_hit_t or self._last_teargas_hit_t + 4 < t then
		self._teargas_damage_ramp = -0.1
	else
		self._teargas_damage_ramp = math.min(self._teargas_damage_ramp + 0.1, 1)
	end

	self._last_teargas_hit_t = t

	self._unit:sound():play("player_hit")

	self:_hit_direction(attack_data.col_ray.origin, attack_data.col_ray.ray)

	if self._bleed_out then
		return
	end

	self:apply_slowdown({
		id = "teargas",
		duration = 1,
		prevents_running = true,
	})

	attack_data.damage = managers.player:modify_value("damage_taken", self:_max_health() * attack_data.damage, attack_data) * math.max(0, self._teargas_damage_ramp)

	self:mutator_update_attack_data(attack_data)
	self:_check_chico_heal(attack_data)

	if managers.player:has_category_upgrade("player", "gas_mask") then
		local armor_reduction_multiplier = 0

		if self:get_real_armor() <= 0 then
			armor_reduction_multiplier = 1
		end

		local health_subtracted = self:_calc_armor_damage(attack_data)
		attack_data.damage = attack_data.damage * armor_reduction_multiplier
		health_subtracted = health_subtracted + self:_calc_health_damage(attack_data)
	else
		self:_calc_health_damage(attack_data)
	end

	self:_call_listeners(damage_info)
end

-- Make most healing fixed instead of % of max health
-- is_static
function PlayerDamage:restore_health(health_restored, _, chk_health_ratio)
	if chk_health_ratio and managers.player:is_damage_health_ratio_active(self:health_ratio()) then
		return false
	end

	return self:change_health(health_restored * self._healing_reduction)
end

-- A separate function for % based healing
-- is_static
function PlayerDamage:restore_health_percentage(health_restored, _, chk_health_ratio)
	if chk_health_ratio and managers.player:is_damage_health_ratio_active(self:health_ratio()) then
		return false
	end
	local max_health = self:_max_health()

	return self:change_health(max_health * health_restored * self._healing_reduction)
end

-- lower the on-kill godmode length for leech
function PlayerDamage:on_copr_killshot()
	self._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + 0.45, true)
	self._last_received_dmg = self:_max_health()
end

-- FAKs only heal a small portion but then heal you over time
function PlayerDamage:band_aid_health(hot_regen)
	if managers.platform:presence() == "Playing" and (self:arrested() or self:need_revive()) then
		return
	end

	self:restore_health(tweak_data.upgrades.values.first_aid_kit.heal_amount)
	if hot_regen then
		managers.player:activate_temporary_upgrade("temporary", "first_aid_health_regen")
	end

	self._said_hurt = false
end

-- Fix Anarchist regen not triggering HUD armor update for clients
Hooks:PostHook(PlayerDamage, "change_armor", "eclipse_change_armor", function(self, change)
	if change > 0 and self:armor_ratio() < 1 then
		self:_send_set_armor()
	end
end)

-- Friendly Fire
function PlayerDamage:is_friendly_fire(unit)
	local attacker_mov_ext = alive(unit) and unit:movement()

	if not attacker_mov_ext or not attacker_mov_ext.team or not attacker_mov_ext.friendly_fire then
		return false
	end

	local my_team = self._unit:movement():team()
	local attacker_team = attacker_mov_ext:team()

	if attacker_team ~= my_team and attacker_mov_ext:friendly_fire() then
		return false
	end
	local attacked_by_foe = attacker_team and my_team and my_team.foes[attacker_team.id]
	local friendly_fire_mutator_active = managers.mutators:modify_value("PlayerDamage:FriendlyFire", friendly_fire_mutator_active) == false
	if not attacked_by_foe then
		if is_pro_job or friendly_fire_mutator_active then
			return false
		end
		return true
	end
	return false
end

-- On demand down restore
function PlayerDamage:restore_lives(lives_restored)
	self._revives =
		Application:digest_value(math.min(self._lives_init + managers.player:upgrade_value("player", "additional_lives", 0), Application:digest_value(self._revives, false) + lives_restored), true)
	self._revive_health_i = math.max(self._revive_health_i - lives_restored, 1)
	self._down_time_i = math.max(self._down_time_i - lives_restored, 0)
	self._down_time = math.max(
		tweak_data.player.damage.DOWNED_TIME_MIN,
		(tweak_data.player.damage.DOWNED_TIME + managers.player:upgrade_value("player", "increased_bleedout_timer", 0)) - tweak_data.player.damage.DOWNED_TIME_DEC * self._down_time_i
	)

	if self._revives == self._lives_init + managers.player:upgrade_value("player", "additional_lives", 0) then
		self:_send_set_revives(true)
	else
		self:_send_set_revives()
	end

	-- Eclipse:log_chat("Revive restored, current revives counter: " .. Application:digest_value(self._revives, false) ..
	-- 				"\ncurrent revive_health counter: " .. self._revive_health_i ..
	-- 				"\ncurrent down_time counter: " .. self._down_time_i ..
	-- 				"\ncurrent revive_health: " .. tweak_data.player.damage.REVIVE_HEALTH_STEPS[self._revive_health_i] ..
	-- 				"\ncurrent down_time: " .. self._down_time
	-- )

	managers.environment_controller:set_last_life(false)
end

function PlayerDamage:_regenerated(from_medic_bag)
	self:set_health(self:_max_health())
	self:_send_set_health()
	self:_set_health_effect()

	self._said_hurt = false

	-- Medic bags restore only one down
	if from_medic_bag then
		self:restore_lives(1)
	else
		self._revives = Application:digest_value(self._lives_init + managers.player:upgrade_value("player", "additional_lives", 0), true)
		self._revive_health_i = 1
		self._down_time_i = 0
		self._down_time = tweak_data.player.damage.DOWNED_TIME + managers.player:upgrade_value("player", "increased_bleedout_timer", 0) -- an upgrade that increases bleedout timer
		self:_send_set_revives(true)
	end

	managers.environment_controller:set_last_life(false)
end

-- Hitman self-revive chance increase
function PlayerDamage:_chk_cheat_death(ignore_reduce_revive)
	local can_revive = (Application:digest_value(self._revives, false) > 1 or ignore_reduce_revive) and not self._check_berserker_done

	if can_revive and managers.player:has_category_upgrade("player", "cheat_death_chance") then
		local r = math.rand(1)
		local self_revive_chance = managers.player:upgrade_value("player", "cheat_death_chance", 0) + managers.player:get_property("chain_headshot_cheat_death", 0)

		if r <= self_revive_chance then
			self._auto_revive_timer = 1
			managers.player:remove_property("chain_headshot_cheat_death")
		end
	end

	if can_revive and not self._auto_revive_timer then
		local mutator = nil

		if managers.mutators:is_mutator_active(MutatorPiggyRevenge) then
			mutator = managers.mutators:get_mutator(MutatorPiggyRevenge)
		end

		if mutator and mutator.auto_revive_timer then
			self._auto_revive_timer = mutator:auto_revive_timer()
		end
	end
end

function PlayerDamage:_upd_suppression(t, dt)
	-- crook's ballistic vests block suppression
	if managers.player:is_wearing_a_ballistic_vest() and managers.player:has_category_upgrade("player", "bv_no_armor_suppression") then
		return
	end

	-- sicario's smoke screen blocks suppression
	for _, smoke_screen in ipairs(managers.player:smoke_screens()) do
		if smoke_screen:is_in_smoke(managers.player:player_unit()) and smoke_screen:armor_bonus() then
			return
		end
	end

	local data = self._supperssion_data

	if data.value then
		if data.decay_start_t < t then
			data.value = data.value - dt

			if data.value <= 0 then
				data.value = nil
				data.decay_start_t = nil

				managers.environment_controller:set_suppression_value(0, 0)
			end
		elseif data.value == tweak_data.player.suppression.max_value and self._regenerate_timer then
			self._listener_holder:call("suppression_max")
		end

		if data.value then
			managers.environment_controller:set_suppression_value(self:effective_suppression_ratio(), self:suppression_ratio())
		end
	end
end

-- On-armor-regen upgrades
function PlayerDamage:_regenerate_armor(no_sound)
	if self._unit:sound() and not no_sound then
		self._unit:sound():play("shield_full_indicator")
	end

	self._regenerate_speed = nil

	if self:get_real_armor() <= 0 then
		-- Cooldown temporary damage reduction on armor regen
		if managers.player:has_enabled_cooldown_upgrade("cooldown", "damage_multiplier_on_armor_regen") and managers.player:has_category_upgrade("temporary", "armor_regen_damage_multiplier") then
			managers.player:activate_temporary_upgrade("temporary", "armor_regen_damage_multiplier")
			managers.player:disable_cooldown_upgrade("cooldown", "damage_multiplier_on_armor_regen")
		end

		-- Cooldown health regen on armor regen
		if managers.player:has_enabled_cooldown_upgrade("cooldown", "health_regen_on_armor_regen") then
			local health_to_restore = tweak_data.upgrades.values.player.armor_regen_health_regen[1]

			self:restore_health(health_to_restore)
			managers.player:disable_cooldown_upgrade("cooldown", "health_regen_on_armor_regen")
		end
	end

	self:set_armor(self:_max_armor())
	self:_send_set_armor()

	self._current_state = nil
end
