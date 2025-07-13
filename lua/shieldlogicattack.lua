-- Only allow positioning when group is fully spawned
local _chk_request_action_walk_to_optimal_pos_original = ShieldLogicAttack._chk_request_action_walk_to_optimal_pos
function ShieldLogicAttack._chk_request_action_walk_to_optimal_pos(data, ...)
	if not data.group or data.group.has_spawned then
		_chk_request_action_walk_to_optimal_pos_original(data, ...)
	end
end

-- Stop walking action upon entering or leaving attack logic
Hooks:PreHook(ShieldLogicAttack, "enter", "sh_enter", function(data)
	CopLogicTravel.cancel_advance(data)
	
	-- elite shields do their unique bang sound when entering attack logic
	if not data.attack_sound_t or data.t - data.attack_sound_t > 40 then
		data.attack_sound_t = data.t
	
	if data.unit:base()._tweak_table == "city_shield" then	
		data.unit:sound():play("hos_shield_indication_sound_terminator_style", nil, true)
	else
		data.unit:sound():play("shield_identification", nil, true)
	end 
end
end)

Hooks:PreHook(ShieldLogicAttack, "exit", "sh_exit", function(data)
	ShieldLogicAttack._cancel_optimal_attempt(data, data.internal_data)
end)

-- Update logic more consistently
function ShieldLogicAttack.queue_update(data, my_data)
	CopLogicBase.queue_task(my_data, my_data.update_queue_id, ShieldLogicAttack.queued_update, data, data.t + 0.5, data.important and true)
end
