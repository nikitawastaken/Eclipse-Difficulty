-- Tweak hostage rescue conditions
function CivilianLogicFlee.rescue_SO_verification(ignore_this, params, unit)
	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().rescue_hostages then
		return false
	end

	local data = params.logic_data
	if data.team.foes[unit:movement():team().id] then
		return false
	end

	local logic_data = unit:brain()._logic_data
	if not logic_data or not logic_data.tactics or logic_data.tactics.rescue then
		return true
	end
end

-- Workaround for civilians being unresponsive when intimidated
function CivilianLogicFlee._delayed_intimidate_clbk(ignore_this, params)
	local data = params[1]
	local amount = params[2]
	local aggressor_unit = params[3]
	local my_data = data.internal_data

	CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_intimidate_id)

	my_data.delayed_intimidate_id = nil

	if not alive(aggressor_unit) then
		return
	end

	CopLogicBase.identify_attention_obj_instant(data, aggressor_unit:key())

	if not CivilianLogicIdle.is_obstructed(data, aggressor_unit) then
		if not my_data.obstructed_t then
			my_data.obstructed_t = TimerManager:game():time()
		elseif TimerManager:game():time() >= my_data.obstructed_t + 1 then
			my_data.obstructed_t = nil
			data.unit:brain():action_request({
				clamp_to_graph = true,
				variant = "panic",
				body_part = 1,
				type = "act",
			})
		end
		return
	end

	data.unit:brain():set_objective({
		type = "surrender",
		amount = amount,
		aggressor_unit = aggressor_unit,
	})
end
