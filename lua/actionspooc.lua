-- Force Cloakers to stand up before starting a charge attack
Hooks:PreHook(ActionSpooc, "init", "sh_init", function(self, action_desc, common_data)
	if not common_data.ext_anim.pose or not action_desc.flying_strike and common_data.ext_anim.pose ~= "stand" then
		StreamHeist:log("ActionSpooc started in wrong pose, playing stand state")
		common_data.ext_movement:play_state("std/stand/still/idle/look")
	end
end)

-- Fix endless Cloaker beatdown
function ActionSpooc:complete()
	return self._beating_end_t and self._beating_end_t < TimerManager:game():time() and (not self:is_flying_strike() or self._last_vel_z == 0)
end

-- Don't interrupt spooc action on target being tased
function ActionSpooc:_chk_target_invalid()
	if not self._target_unit then
		return true
	end

	if self._target_unit:base().is_local_player and not self._target_unit:movement():is_SPOOC_attack_allowed() then
		return true
	end

	if self._target_unit:movement():zipline_unit() then
		return true
	end

	local record = managers.groupai:state():criminal_record(self._target_unit:key())
	return not record or record.status == "disabled" or record.status == "dead"
end
