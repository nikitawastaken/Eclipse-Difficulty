-- Make civilians get down more consistently
-- If we have shouted at them and that shout would intimidate but not make them drop, run the function again after a short delay
Hooks:PostHook(CivilianLogicSurrender, "_delayed_intimidate_clbk", "sh__delayed_intimidate_clbk", function (ignore_this, params)
	local data = params[1]
	if data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	local anim_data = data.unit:anim_data()
	if anim_data.drop or anim_data.halt then
		return
	end

	-- Set amount to 0 for automatic consecutive calls
	params[2] = 0

	local my_data = data.internal_data
	my_data.delayed_intimidate_id = "intimidate" .. tostring(data.unit:key())
	CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_intimidate_id, callback(CivilianLogicSurrender, CivilianLogicSurrender, "_delayed_intimidate_clbk", params), TimerManager:game():time() + 0.1 + math.random() * 0.4)
end)