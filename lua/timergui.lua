local level_id = Eclipse.utils.level_id()
local drill_unit_overrides = Eclipse:require("drill_unit_overrides")

Hooks:PostHook(TimerGui, "init", "eclipse_init", function(self, unit)
	local unit_override = drill_unit_overrides[level_id] and drill_unit_overrides[level_id][unit:name():key()]

	if unit_override then
		if unit_override.can_jam ~= nil then
			self:set_can_jam(unit_override.can_jam)
		end

		if unit_override.timer then
			self:set_override_timer(unit_override.timer)
		end
	end
end)

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
