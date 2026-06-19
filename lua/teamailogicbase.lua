if UsefulBots then
	return
end

function TeamAILogicBase.force_attention(data, my_data, unit)
	if data.cool then
		return
	end

	local logic_supports_shooting = data.name == "assault" or data.name == "travel"
	if not logic_supports_shooting and not data.logic.is_available_for_assignment(data) then
		return
	end

	local att_obj_data = TeamAILogicBase.identify_attention_obj_instant(data, unit:key())
	if not att_obj_data then
		return
	end

	TeamAILogicBase._upd_attention_obj_detection(data, AIAttentionObject.REACT_SHOOT, nil)

	local new_attention = TeamAILogicIdle._get_priority_attention(data, data.detected_attention_objects, nil)
	if not new_attention or new_attention.u_key ~= att_obj_data.u_key then
		return
	end

	local is_new = data.attention_obj ~= new_attention
	TeamAILogicBase._set_attention_obj(data, new_attention, AIAttentionObject.REACT_SHOOT)

	if not logic_supports_shooting then
		if data.objective and data.objective.type == "act" then
			data.objective_failed_clbk(data.unit, data.objective)
		end
		TeamAILogicBase._exit(data.unit, "assault")
	end

	if is_new then
		CopLogicAttack._chk_request_action_turn_to_enemy(data, my_data, data.m_pos, new_attention.m_pos)
	end
	TeamAILogicAssault._upd_aim(data, my_data)
end


-- Wait before switching to idle
function TeamAILogicBase._get_logic_state_from_reaction(data, reaction)
	local state = (not reaction or reaction <= AIAttentionObject.REACT_SCARED) and "idle" or "assault"

	if state == "assault" then
		data.last_assault_state_t = data.t
	elseif data.last_assault_state_t and data.t < data.last_assault_state_t + (data.objective and data.objective.type == "defend_area" and 10 or 5) then
		state = "assault"
	end

	return state
end