-- Health granularity prevents linear damage interpolation of AI against other AI from working
-- correctly and notably rounds up damage against enemies with a high HP pool even for player weapons.
-- Increasing the health granularity makes damage dealt more accurate to the actual weapon damage stats
CopDamage._HEALTH_GRANULARITY = 8192

function CopDamage:_send_melee_attack_result(attack_data, damage_percent, damage_effect_percent, hit_offset_height, variant, body_index)
	body_index = math.clamp(body_index, 0, 128)
	damage_percent = math.clamp(damage_percent, 0, self._HEALTH_GRANULARITY)
	damage_effect_percent = math.clamp(damage_effect_percent, 0, self._HEALTH_GRANULARITY)
	self._unit:network():send("damage_melee", attack_data.attacker_unit, damage_percent, damage_effect_percent, body_index, hit_offset_height, variant, self._dead and true or false)
end

-- Make enemy head hitbox size not egregiously large
Hooks:PostHook(CopDamage, "init", "eclipse_init", function(self)
	local is_dozer = self._unit:base()._tweak_table == "tank" or self._unit:base()._tweak_table == "tank_elite"
	local head_body = self._unit:body(self._head_body_name or "head")
	if head_body then
		head_body:set_sphere_radius(16)
	end

	if not is_dozer and managers.player:has_category_upgrade("weapon", "magnetizing_bullets") then
		if head_body then
			head_body:set_sphere_radius(25) -- yes it really is just a bigger head hitbox. such a cool description though, right?
		end
	end
end)

-- Fixed critical hit mul and additional crit damage upgrade
function CopDamage:roll_critical_hit(attack_data)
	if not self:can_be_critical(attack_data) or math.random() >= managers.player:critical_hit_chance() then
		return false, attack_data.damage
	end

	return true, attack_data.damage * (2 + managers.player:upgrade_value("weapon", "extra_crit_damage_mul", 0))
end

-- Make these functions check that the attacker unit is a player (to make sure NPC vs NPC melee doesn't crash)
local _dismember_condition_original = CopDamage._dismember_condition
function CopDamage:_dismember_condition(attack_data, ...)
	if alive(attack_data.attacker_unit) and attack_data.attacker_unit:base().is_local_player then
		return _dismember_condition_original(self, attack_data, ...)
	end
end

local _sync_dismember_original = CopDamage._sync_dismember
function CopDamage:_sync_dismember(attacker_unit, ...)
	if alive(attacker_unit) and attacker_unit:base().is_husk_player then
		return _sync_dismember_original(self, attacker_unit, ...)
	end
end

-- Additional suppression on hit
Hooks:PreHook(CopDamage, "_on_damage_received", "sh__on_damage_received", function(self, damage_info)
	self:build_suppression(4 * damage_info.damage / self._HEALTH_INIT, nil)
end)

-- Give flamethrowers a damage multiplier against dozers
Hooks:PreHook(CopDamage, "damage_fire", "eclipse_damage_fire", function(self, attack_data)
	if self._unit:base()._tweak_table == "tank" then
		attack_data.damage = attack_data.damage * 2.5
	end
end)

-- Counter strike aced stuns dozers
local mvec_1 = Vector3()
local mvec_2 = Vector3()
Hooks:OverrideFunction(CopDamage, "damage_melee", function(self, attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return "friendly_fire"
	end

	if self:chk_immune_to_attacker(attack_data.attacker_unit) then
		return
	end

	local result = nil
	local is_civlian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local is_gangster = CopDamage.is_gangster(self._unit:base()._tweak_table)
	local is_cop = not is_civlian and not is_gangster
	local is_tank = is_cop and (self._unit:base()._tweak_table == "tank" or self._unit:base()._tweak_table == "tank_elite")
	local has_tank_knockdown = managers.player:has_enabled_cooldown_upgrade("cooldown", "counter_strike_eclipse")
	local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
	local damage = attack_data.damage

	if attack_data.attacker_unit and attack_data.attacker_unit == managers.player:player_unit() then
		local critical_hit, crit_damage = self:roll_critical_hit(attack_data, damage)

		if critical_hit then
			managers.hud:on_crit_confirmed()

			damage = crit_damage
			attack_data.critical_hit = true
		else
			managers.hud:on_hit_confirmed()
		end

		if tweak_data.achievement.cavity.melee_type == attack_data.name_id and not CopDamage.is_civilian(self._unit:base()._tweak_table) then
			managers.achievment:award(tweak_data.achievement.cavity.award)
		end
	end

	damage = damage * (self._marked_dmg_mul or 1)

	if self._unit:movement():cool() then
		damage = self._HEALTH_INIT
	end

	local damage_effect = attack_data.damage_effect
	local damage_effect_percent = 1
	damage = self:_apply_damage_reduction(damage)
	damage = math.clamp(damage, self._HEALTH_INIT_PRECENT, self._HEALTH_INIT)
	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)
	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	if self._immortal then
		damage = math.min(damage, self._health - 1)
	end

	if self._health <= damage then
		if self:check_medic_heal() then
			result = {
				type = "healed",
				variant = attack_data.variant,
			}
		else
			damage_effect_percent = 1
			attack_data.damage = self._health
			result = {
				type = "death",
				variant = attack_data.variant,
			}

			self:die(attack_data)
			self:chk_killshot(attack_data.attacker_unit, "melee")
		end
	else
		attack_data.damage = damage
		damage_effect = math.clamp(damage_effect, self._HEALTH_INIT_PRECENT, self._HEALTH_INIT)
		damage_effect_percent = math.ceil(damage_effect / self._HEALTH_INIT_PRECENT)
		damage_effect_percent = math.clamp(damage_effect_percent, 1, self._HEALTH_GRANULARITY)
		local result_type = attack_data.shield_knock and self._char_tweak.damage.shield_knocked and "shield_knock"
			or attack_data.variant == "counter_tased" and "counter_tased"
			or attack_data.variant == "taser_tased" and "taser_tased"
			or attack_data.variant == "counter_spooc" and "expl_hurt"
			or self:get_damage_type(damage_effect_percent, "melee")
			or "fire_hurt"
		-- If the player has counter strike aced and the target is a dozer, stun them
		if is_tank and has_tank_knockdown then
			result_type = "expl_hurt"
			managers.player:disable_cooldown_upgrade("cooldown", "counter_strike_eclipse")
		end
		result = {
			type = result_type,
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	local dismember_victim = false
	local snatch_pager = false

	if result.type == "death" then
		if self:_dismember_condition(attack_data) then
			self:_dismember_body_part(attack_data)

			dismember_victim = true
		end

		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			head_shot = head,
			weapon_unit = attack_data.weapon_unit,
			name_id = attack_data.name_id,
			variant = attack_data.variant,
		}

		managers.statistics:killed_by_anyone(data)

		if attack_data.attacker_unit == managers.player:player_unit() then
			self:_comment_death(attack_data.attacker_unit, self._unit)
			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if not is_civlian and managers.groupai:state():whisper_mode() and managers.blackmarket:equipped_mask().mask_id == tweak_data.achievement.cant_hear_you_scream.mask then
				managers.achievment:award_progress(tweak_data.achievement.cant_hear_you_scream.stat)
			end

			mvector3.set(mvec_1, self._unit:position())
			mvector3.subtract(mvec_1, attack_data.attacker_unit:position())
			mvector3.normalize(mvec_1)
			mvector3.set(mvec_2, self._unit:rotation():y())

			local from_behind = mvector3.dot(mvec_1, mvec_2) >= 0

			if is_cop and Global.game_settings.level_id == "nightclub" and attack_data.name_id and attack_data.name_id == "fists" then
				managers.achievment:award_progress(tweak_data.achievement.final_rule.stat)
			end

			if is_civlian then
				managers.money:civilian_killed()
			elseif math.rand(1) < managers.player:upgrade_value("player", "melee_kill_snatch_pager_chance", 0) then
				snatch_pager = true
				self._unit:unit_data().has_alarm_pager = false
			end
		end
	end

	self:_check_melee_achievements(attack_data)

	local hit_offset_height = math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)
	local variant = nil

	if result.type == "shield_knock" then
		variant = 1
	elseif result.type == "counter_tased" then
		variant = 2
	elseif result.type == "expl_hurt" then
		variant = 4
	elseif snatch_pager then
		variant = 3
	elseif result.type == "taser_tased" then
		variant = 5
	elseif dismember_victim then
		variant = 6
	elseif result.type == "healed" then
		variant = 7
	else
		variant = 0
	end

	local body_index = self._unit:get_body_index(attack_data.col_ray.body:name())

	self:_send_melee_attack_result(attack_data, damage_percent, damage_effect_percent, hit_offset_height, variant, body_index)
	self:_on_damage_received(attack_data)

	return result
end)

-- Disable impact sounds and blood effects for stuns
local damage_explosion = CopDamage.damage_explosion
function CopDamage:damage_explosion(attack_data, ...)
	local no_blood = self._no_blood
	self._no_blood = attack_data.variant == "stun"

	local result = damage_explosion(self, attack_data, ...)

	self._no_blood = no_blood

	return result
end

local sync_damage_explosion = CopDamage.sync_damage_explosion
function CopDamage:sync_damage_explosion(attacker_unit, damage_percent, i_attack_variant, ...)
	local no_blood = self._no_blood
	self._no_blood = CopDamage._ATTACK_VARIANTS[i_attack_variant] == "stun"

	local result = sync_damage_explosion(self, attacker_unit, damage_percent, i_attack_variant, ...)

	self._no_blood = no_blood

	return result
end
