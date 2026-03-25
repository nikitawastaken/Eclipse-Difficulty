-- Stop shooting when entering arrest logic
Hooks:PostHook(CopLogicArrest, "enter", "sh_enter", function(data)
	data.unit:movement():set_allow_fire(false)
end)

-- Security Camera Rework by Hoppip
local _upd_enemy_detection_original = CopLogicArrest._upd_enemy_detection
function CopLogicArrest._upd_enemy_detection(data, ...)
	if not data.forced_police_call_attention or managers.groupai:state():enemy_weapons_hot() or managers.groupai:state():is_police_called() then
		return _upd_enemy_detection_original(data, ...)
	end

	local my_data = data.internal_data
	if not my_data.calling_the_police and not data.unit:movement():chk_action_forbidden("action") then
		CopLogicArrest._call_the_police(data, my_data, true)
	end
end

local on_new_objective_original = CopLogicArrest.on_new_objective
function CopLogicArrest.on_new_objective(data, ...)
	if not data.forced_police_call_attention or managers.groupai:state():enemy_weapons_hot() then
		return on_new_objective_original(data, ...)
	end
end

