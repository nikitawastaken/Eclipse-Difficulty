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
