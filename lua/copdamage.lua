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
	local head_body = self._unit:body(self._head_body_name or "head")
	if head_body then
		head_body:set_sphere_radius(18)
	end

	if self._head_gear_decal_mesh then
		local mesh_name_idstr = Idstring(self._head_gear_decal_mesh)
		self._unit:decal_surface(mesh_name_idstr):set_mesh_material(mesh_name_idstr, Idstring("helmet"))
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

-- Always remove contours on death
Hooks:PostHook(CopDamage, "_on_death", "eclipse_on_death", function(self)
	local contour = self._unit.contour and self._unit:contour()
	if not contour or not contour._contour_list then
		return
	end

	while contour._contour_list and #contour._contour_list > 0 do
		local t = contour._contour_list[1].type
		contour:_remove(1)
		contour:apply_to_linked("remove", t)
	end

	if contour._update_enabled then
		contour:_chk_update_state()
	end
end)

-- Add visor shatter effects
Hooks:OverrideFunction(CopDamage, "_spawn_head_gadget", function(self, params)
	if not self._head_gear or self._head_gear_spawned then
		return
	end

	self:hide_head_gear()

	if self._head_gear_play_effect then
		local effect_table = {
			effect = Idstring(self._head_gear_play_effect),
			position = params.position,
			normal = params.dir or nil,
			rotation = not params.dir and params.rotation or nil,
		}

		World:effect_manager():spawn(effect_table)
	end

	local visor_sequence = "break_visor"

	if self._unit:damage() and self._unit:damage():has_sequence(visor_sequence) then
		self._unit:damage():run_sequence_simple(visor_sequence)
	end

	if self._head_gear_play_sound then
		unit:sound():play(self._head_gear_play_sound)
	end

	local unit = World:spawn_unit(Idstring(self._head_gear), params.position, params.rotation)

	if unit:slot() ~= 18 then
		debug_pause_unit(unit, "[CopDamage:_spawn_head_gadget] Head gadget unit is in the wrong slot (" .. tostring(unit:slot()) .. "), should be slot 18.", unit, self._unit)
		unit:set_slot(18)
	end

	if not params.skip_push then
		local dir = math.UP - params.dir / 2
		dir = dir:spread(25)
		local body = unit:body(0)

		body:push_at(body:mass(), dir * math.lerp(300, 650, math.random()), unit:position() + Vector3(math.rand(1), math.rand(1), math.rand(1)))
	end

	self._head_gear_spawned = true
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
	local is_tank = is_cop and self._unit:base():has_tag("tank")
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

		if head then
			managers.player:on_headshot_dealt()
		end

		if tweak_data.achievement.cavity.melee_type == attack_data.name_id and not CopDamage.is_civilian(self._unit:base()._tweak_table) then
			managers.achievment:award(tweak_data.achievement.cavity.award)
		end
	end

	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local melee_headshot_mul = tweak_data.blackmarket.melee_weapons[melee_entry].stats.headshot_damage_mul or 1

	if not (self._char_tweak.ignore_melee_headshot or self._char_tweak.ignore_headshot) and not self._damage_reduction_multiplier and head then
		if self._char_tweak.headshot_dmg_mul then
			damage = damage * self._char_tweak.headshot_dmg_mul * melee_headshot_mul
		else
			damage = self._health * 10
		end
	end

	damage = damage * (self._marked_dmg_mul or 1)

	if self._unit:movement():cool() then
		damage = self._HEALTH_INIT
	end

	attack_data.headshot = head
	local damage_effect = attack_data.damage_effect

	if self._health <= damage then
		if head then
			self:_spawn_head_gadget({
				position = attack_data.col_ray.body:position(),
				rotation = attack_data.col_ray.body:rotation(),
				dir = attack_data.col_ray.ray,
			})
		end
	end

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

-- Revert headshot multipliers for fire damage
local damage_fire_original = CopDamage.damage_fire
function CopDamage:damage_fire(attack_data, ...)
	local head_body_name = self._head_body_name
	self._head_body_name = nil
	local result = damage_fire_original(self, attack_data, ...)
	self._head_body_name = head_body_name
	return result
end

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

-- Fix synced melee damage ignoring medic heal
local sync_damage_melee_original = CopDamage.sync_damage_melee
function CopDamage:sync_damage_melee(attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death, ...)
	if death or variant ~= 7 then
		return sync_damage_melee_original(self, attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death, ...)
	end

	local attack_data = {
		variant = "healed",
		attacker_unit = attacker_unit,
		damage = damage_percent * self._HEALTH_INIT_PRECENT,
		is_synced = true,
		pos = self._unit:position(),
		result = {
			variant = "melee",
			type = "healed",
		},
	}

	self:do_medic_heal()

	if attacker_unit then
		attack_data.attack_dir = self._unit:position() - attacker_unit:position()
		mvector3.normalize(attack_data.attack_dir)
		attack_data.name_id = attacker_unit:inventory() and attacker_unit:inventory():get_melee_weapon_id()
	else
		attack_data.attack_dir = -self._unit:rotation():y()
	end

	mvector3.set_z(attack_data.pos, attack_data.pos.z + math.random() * 180)

	if not self._no_blood then
		local from = Vector3(0, 0, hit_offset_height)
		mvector3.add(from, self._unit:movement():m_pos())
		managers.game_play_central:sync_play_impact_flesh(from, attack_data.attack_dir)
	end

	self:_send_sync_melee_attack_result(attack_data, hit_offset_height)
	self:_on_damage_received(attack_data)
end
