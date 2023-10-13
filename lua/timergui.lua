-- Set an upper limit for how many times drills, saws, etc can randomly jam, based on their timers
Hooks:PreHook(TimerGui, "_set_jamming_values", "sh__set_jamming_values", function(self)
	if self._can_jam then
		self._jam_times = math.min(self._jam_times, math.ceil(self._timer / 60))
	end
end)

-- Skip next scheduled jam if it's going to happen very shortly after unjamming
Hooks:PostHook(TimerGui, "set_jammed", "sh_set_jammed", function(self, jammed)
	if not jammed and self._current_jam_timer and self._current_jam_timer < 5 / self:get_timer_multiplier() then
		self._current_jam_timer = table.remove(self._jamming_intervals, 1)
	end
end)
