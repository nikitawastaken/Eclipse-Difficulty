-- Fix endless Cloaker beatdown
function ActionSpooc:complete()
	return self._beating_end_t and self._beating_end_t < TimerManager:game():time() and (not self:is_flying_strike() or self._last_vel_z == 0)
end
