-- Improved Team AI following
-- From Super Serious Shooter
local _check_should_relocate_original = TeamAILogicIdle._check_should_relocate
function TeamAILogicIdle._check_should_relocate(data, my_data, objective, ...)
	local ub_follow_behavior = UsefulBots and UsefulBots.player_settings and UsefulBots:player_settings(objective.follow_unit).follow_behavior
	if ub_follow_behavior and ub_follow_behavior ~= 1 then
		return _check_should_relocate_original(data, my_data, objective, ...)
	end

	local follow_movement = objective.follow_unit:movement()
	if data.unit:raycast("ray", data.unit:movement():m_head_pos(), follow_movement:m_head_pos(), "slot_mask", data.visibility_slotmask, "report") then
		return true
	end

	local follow_pos = follow_movement:m_newest_pos()
	return math.abs(follow_pos.z - data.m_pos.z) > 200 or mvector3.distance_sq(follow_pos, data.m_pos) > 600 ^ 2
end

if UsefulBots then
	return
end

function TeamAILogicIdle.is_high_priority(unit_movement)
	if type(unit_movement._active_actions) ~= "table" then
		return false
	end

	for _, action in pairs(unit_movement._active_actions) do
		if type(action) == "table" and action._is_sabotaging_action then		
			return true
		end
	end
		
	return false
end

local tmp_vec = Vector3()
local _get_priority_attention_original = TeamAILogicIdle._get_priority_attention
function TeamAILogicIdle._get_priority_attention(data, attention_objects, reaction_func, ...)
	reaction_func = reaction_func or TeamAILogicBase._chk_reaction_to_attention_object

	local best_target, best_target_priority, best_target_reaction = nil, 0, nil
	local REACT_SHOOT = data.cool and AIAttentionObject.REACT_SURPRISED or AIAttentionObject.REACT_SHOOT
	local my_team = data.unit:movement():team()
	local not_assisting = data.name ~= "travel" or not data.objective or data.objective.type ~= "revive" and not data.objective.assist_unit
	local can_intimidate = data.unit:base().upgrade_level and data.unit:base():upgrade_level("player", "intimidate_enemies")
	local get_shoot_falloff = (data.unit:movement()._actions.shoot or CopActionShoot)._get_shoot_falloff

	-- following player data
	local follow_head_pos, follow_look_vec
	if alive(data._latest_followeap_unit) then
		local follow_movement = data._latest_followeap_unit:movement()
		follow_head_pos = follow_movement:m_head_pos()
		follow_look_vec = follow_movement:m_head_rot():y()
	end

	-- equipped weapon data
	local weap_unit = data.unit:inventory():equipped_unit()
	local weap_tweak = alive(weap_unit) and weap_unit:base():weapon_tweak_data()
	local weap_usage = weap_tweak and data.char_tweak.weapon[weap_tweak.usage]

	for _, attention_data in pairs(attention_objects) do
		local att_unit = attention_data.unit
		if not attention_data.identified or not alive(att_unit) then
			-- Skip
		elseif attention_data.pause_expire_t then
			if data.t > attention_data.pause_expire_t then
				attention_data.pause_expire_t = nil
			end
		elseif attention_data.stare_expire_t and data.t > attention_data.stare_expire_t then
			if attention_data.settings.pause then
				attention_data.stare_expire_t = nil
				attention_data.pause_expire_t = data.t + math.rand(attention_data.settings.pause[1], attention_data.settings.pause[2])
			end
		else
			-- attention unit data
			local att_base = att_unit:base()
			local att_damage = att_unit:character_damage()
			local att_movement = att_unit:movement()
			if att_base and att_damage and not att_damage:dead() and att_movement and att_movement.team and my_team.foes[att_movement:team().id] then
				local att_tweak_table = att_base._tweak_table
				local att_tweak = attention_data.char_tweak or att_tweak_table and tweak_data.character[att_tweak_table] or {}
				local att_anim = att_unit.anim_data and att_unit:anim_data() or {}

				local distance = attention_data.dis
				local reaction = reaction_func(data, attention_data, not CopLogicAttack._can_move(data)) or AIAttentionObject.REACT_CHECK
				attention_data.aimed_at = TeamAILogicIdle.chk_am_i_aimed_at(data, attention_data, attention_data.aimed_at and 0.95 or 0.985)

				local has_alerted = attention_data.alert_t and data.t - attention_data.alert_t < 3
				local has_damaged = attention_data.dmg_t and data.t - attention_data.dmg_t < 3
				local been_marked = attention_data.mark_t and data.t - attention_data.mark_t < 10
				local is_tied = att_anim.hands_tied
				local is_special = attention_data.is_very_dangerous or att_tweak.priority_shout
				local is_carrying_bag = att_movement:carrying_bag()
				local high_priority = TeamAILogicIdle.is_high_priority(att_movement)
				local invulnerable = att_damage._invulnerable or att_damage._immortal and att_damage._health <= 1 or (att_damage._health_ratio or 0) <= (att_damage._lower_health_percentage_limit or -1)

				-- use the dmg multiplier of the given distance as priority
				local valid_target = false
				local target_priority

				target_priority = math.max(0, 1 - distance / 3000)

				-- fine tune target priority
				if att_unit:in_slot(data.enemy_slotmask) and not is_tied and attention_data.verified then
					local logic_data = att_unit:brain()._logic_data or {}
					local should_intimidate = can_intimidate and not high_priority and TeamAILogicIdle.is_valid_intimidation_target(att_unit, att_tweak, att_anim, att_damage, data, distance)
					local is_being_intimdated = logic_data.surrender_window and logic_data.surrender_window.window_expire_t > data.t - 1
					local marked_contour = att_unit:contour() and att_unit:contour():find_id_match("^mark_enemy")
					local marked_by_player = marked_contour and (marked_contour ~= "mark_enemy" or not been_marked)
					
					-- check for reaction changes
					if should_intimidate then
						reaction = AIAttentionObject.REACT_ARREST
					elseif is_being_intimdated then
						reaction = math.min(AIAttentionObject.REACT_AIM, reaction)
					elseif high_priority or is_special or has_damaged or marked_contour then
						reaction = math.max(REACT_SHOOT, reaction)
					end

					-- get target priority multipliers
					if should_intimidate then
						target_priority = target_priority * 2
					end

					if high_priority then
						target_priority = target_priority * 2
					end

					if marked_by_player then
						target_priority = target_priority * 1.5
					end					
					
					local attacking_player = logic_data.attention_obj and alive(logic_data.attention_obj.unit) and logic_data.attention_obj.is_human_player and logic_data.attention_obj.verified
					if attacking_player then
						target_priority = target_priority * 1.2

						local player_interacting = logic_data.attention_obj.is_local_player and logic_data.attention_obj.unit:movement():current_state():_interacting() or logic_data.attention_obj.unit:movement()._interaction_tweak
						if player_interacting then
							target_priority = target_priority * 1.5
						end

						local is_sniper = att_unit:base():has_tag("sniper") or att_unit:base():has_tag("marksman")
						if is_sniper then
							target_priority = target_priority * 2
						end
						
						local att_player_damage = logic_data.attention_obj.unit:character_damage()
						
						local player_suppressed = att_player_damage and att_player_damage:is_suppressed()
						if player_suppressed then
							target_priority = target_priority * 1.1

						end
						
						local player_low_health = att_player_damage and att_player_damage:health_ratio() < 0.33
						if player_low_health then
							target_priority = target_priority * 1.3
						end
					end
					
					-- if we have a revive objective and target priority isn't high, ignore the enemy
					valid_target = (not invulnerable or should_intimidate or is_being_intimdated) and (not_assisting or target_priority >= 1)

					if valid_target then
						-- give a slight boost to priority if this is our current target (to avoid switching targets too much if the other one is still alive and visible)
						if data.attention_obj == attention_data then
							target_priority = target_priority * 1.2
						end
										
						-- slightly boost priority of enemies that damaged us
						if has_damaged then
							target_priority = target_priority * 1.1
						end
	
						-- target turrets but with a much lower attention weight
						if att_base.sentry_gun then
							target_priority = target_priority * 0.2
						end
						
						-- reduce priority if we would hit a shield
						if TeamAILogicIdle._ignore_shield(data.unit, attention_data) then
							target_priority = target_priority * 0.01
						end

						-- reduce priority if someone is trying to intimidate, but we are not
						if not should_intimidate and is_being_intimdated then
							target_priority = target_priority * 0.01
						end

						-- prioritise enemies who are carrying bags
						if is_carrying_bag then
							target_priority = target_priority * 1.5
						end
		
						-- prefer shooting enemies the player is not aiming at
						if follow_head_pos then
							local att_head_pos = att_movement:m_head_pos()
							if not World:raycast("ray", follow_head_pos, att_head_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision", "report") then
								mvector3.direction(tmp_vec, follow_head_pos, att_head_pos)
								target_priority = target_priority * math.lerp(1.5, 1, math.max(0, follow_look_vec:dot(tmp_vec)))
								target_priority = target_priority * math.map_range(follow_look_vec:dot(tmp_vec), -1, 1, 1.5, 1)
							end
						end

						if att_base._shiny_effect and reaction >= REACT_SHOOT then
							target_priority = target_priority * 0.01
							reaction = AIAttentionObject.REACT_AIM
						end
					end
				elseif (has_alerted or has_damaged) and not_assisting and distance < 1500 and not invulnerable or high_priority then
					valid_target = true
					reaction = math.min(reaction, AIAttentionObject.REACT_AIM)
					target_priority = target_priority * 0.01
				end

				if valid_target and target_priority > best_target_priority then
					best_target = attention_data
					best_target_priority = target_priority
					best_target_reaction = reaction
				end
			end
		end
	end
	return best_target, 3 / math.max(best_target_priority, 0.1), best_target_reaction
end

-- Stop bots from dropping light bags when going to revive a player and stop them immediately on being told to hold position
local on_long_dis_interacted_original = TeamAILogicIdle.on_long_dis_interacted
function TeamAILogicIdle.on_long_dis_interacted(data, other_unit, secondary, ...)
	if data.brain._current_logic_name == "disabled" then
		return
	end

	local movement = data.unit:movement()
	local had_bag = movement._carry_unit
	local move_speed_modifier = movement._carry_speed_modifier or 1

	if data.objective and data.objective.type == "revive" then
		if data.objective.follow_unit == other_unit and had_bag and move_speed_modifier < 1 then
			data.unit:movement():throw_bag()
		end
		return
	elseif not secondary and data.objective and (data.objective.secure_trigger or data.objective.pickup_carry_unit) then
		if data._latest_follow_unit == other_unit then
			data.secure_bag_data[other_unit:key()] = {}
		end
	end

	if not Keepers and secondary then
		local tracker = other_unit:movement():nav_tracker()
		movement:set_should_stay(true, tracker:lost() and tracker:field_position() or tracker:position())
			
		return
	end

	on_long_dis_interacted_original(data, other_unit, secondary, ...)

	local objective_type = data.objective and data.objective.type
	if objective_type == "revive" and had_bag and move_speed_modifier > 0.75 and not movement:carrying_bag() then
		had_bag:carry_data():link_to(data.unit, false)
		movement:set_carrying_bag(had_bag)
	end
end

function TeamAILogicIdle._check_objective_pos(data)
	if data.path_fail_t and data.t - data.path_fail_t < 6 then
		return
	end

	local objective = data.objective
	if not objective or objective.type ~= "defend_area" or not objective.in_place then
		return
	end

	if objective.pos then
		if math.abs(data.m_pos.x - objective.pos.x) < 10 and math.abs(data.m_pos.y - objective.pos.y) < 10 then
			return
		end
	elseif objective.nav_seg == data.unit:movement():nav_tracker():nav_segment() then
		return
	end

	objective.in_place = false
	objective.path_data = nil
	TeamAILogicBase._exit(data.unit, "travel")
end

if not Keepers then
	Hooks:PostHook(TeamAILogicIdle, "action_complete_clbk", "action_complete_clbk_ub", TeamAILogicIdle._check_objective_pos)
end

-- Enter assault logic on new objective if appropriate
Hooks:OverrideFunction(TeamAILogicIdle, "on_new_objective", function(data, old_objective)
	TeamAILogicBase.on_new_objective(data, old_objective)

	local objective = data.objective
	local my_data = data.internal_data
	if not my_data.exiting then
		local exit_logic = false
		if objective and (objective.nav_seg or objective.follow_unit) and not objective.in_place then
			if data._ignore_first_travel_order then
				data._ignore_first_travel_order = nil
			elseif data.cool or objective.called or objective.type ~= "follow" or TeamAILogicIdle._check_should_relocate(data, my_data, objective) then
				CopLogicBase._exit(data.unit, "travel")
			elseif data.name == "travel" then
				exit_logic = true
			end
		else
			exit_logic = true
		end

		if exit_logic then
			local obj_type = objective and objective.type
			local obj_stance = objective and objective.stance
			local idle = data.cool or obj_stance == "ntl" or obj_type == "revive" or obj_type == "throw_bag" or obj_type == "act"
			CopLogicBase._exit(data.unit, idle and "idle" or "assault")
		end
	end

	if objective and objective.stance then
		data.unit:movement():set_cool(objective.stance == "ntl")
	end

	if old_objective and old_objective.fail_clbk then
		old_objective.fail_clbk(data.unit)
	end
end)