-- Prevent changing back to hostile stance if bot entered with combat stance
local enter_original = TeamAILogicAssault.enter
function TeamAILogicAssault.enter(data, ...)
	local movement = data.unit:movement()
	local set_stance = movement.set_stance
	movement.set_stance = function(self, ...)
		if self:stance_code() == 1 then
			return set_stance(self, ...)
		end
	end

	enter_original(data, ...)

	movement.set_stance = set_stance ~= getmetatable(movement).set_stance and set_stance or nil
end

if UsefulBots then
	return
end

-- Don't carry over "firing" variable, it has a chance to stopp bots from shooting
Hooks:PostHook(TeamAILogicAssault, "enter", "eclipse_enter", function (data)
	data.internal_data.firing = nil
end)

-- Fix attention unit reset
Hooks:PostHook(TeamAILogicAssault, "action_complete_clbk", "action_complete_clbk_ub", function (data, action)
	local my_data = data.internal_data
	if action:type() == "shoot" then
		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end

		if not data.unit:movement():chk_action_forbidden("action") then
			local mag_total, mag_remaining = data.unit:inventory():equipped_unit():base():ammo_info()
			if mag_remaining < mag_total ^ 0.75 then
				data.brain:action_request({
					body_part = 3,
					type = "reload"
				})
			end
		end
	end

	if not Keepers then
		TeamAILogicIdle._check_objective_pos(data)
	end
end)

function TeamAILogicAssault._chk_wants_to_take_cover(data, my_data)
	if not data.attention_obj or data.attention_obj.reaction < AIAttentionObject.REACT_COMBAT then
		return
	end
	
	if data.unit:movement()._should_stay then
		return
	end
	
	if data.unit:character_damage():health_ratio() < 0.5 then
		return true
	end
	
	if my_data.moving_to_cover then 
		return true
	end
	
	if data.attention_obj and data.attention_obj.dangerous_special then
		return true
	end
end
