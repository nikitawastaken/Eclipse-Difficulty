local level_id = Eclipse.utils.level_id()

TimerGui.drill_unit_overrides = Eclipse:require("drill_unit_overrides")

function TimerGui:_get_drill_unit_override()
	local drill_unit_overrides = self.drill_unit_overrides[level_id]
	if not drill_unit_overrides then
		return
	end

	local function get_override(unit)
		return drill_unit_overrides[unit:unit_data().unit_id] or drill_unit_overrides[unit:name():key()]
	end

	local mission_door_device_ext = self._unit:mission_door_device()
	if not mission_door_device_ext then
		return get_override(self._unit)
	end

	local parent_door = mission_door_device_ext._parent_door
	local override = alive(parent_door) and get_override(parent_door)
	if not override then
		return
	end

	for typ, device in pairs(parent_door:base()._devices) do
		if override[typ] then
			for i, data in ipairs(device.units) do
				if data.unit == self._unit then
					return override[typ][i]
				end
			end
		end
	end
end

function TimerGui:_check_drill_unit_override()
	if self._checked_drill_unit_override then
		return
	end

	self._checked_drill_unit_override = true

	local unit_override = self:_get_drill_unit_override()
	self._unit_override = unit_override
	if unit_override then
		if unit_override.can_jam ~= nil then
			self:set_can_jam(unit_override.can_jam)
		end

		if unit_override.jam_times ~= nil then
			self:set_jam_times(unit_override.jam_times)
		end

		if unit_override.timer then
			self:set_override_timer(unit_override.timer)
		end
	end
end

Hooks:PreHook(TimerGui, "start", "eclipse_start", TimerGui._check_drill_unit_override)

-- Skip next scheduled jam if it's going to happen very shortly after unjamming
Hooks:PostHook(TimerGui, "set_jammed", "sh_set_jammed", function(self, jammed)
	if not jammed and self._current_jam_timer and self._current_jam_timer < 5 / self:get_timer_multiplier() then
		self._current_jam_timer = table.remove(self._jamming_intervals, 1)
	end
end)

function TimerGui:_get_jammed_times()
	if not self._can_jam then
		return 0
	end

	local jammed_times
	if self._jam_times_tbl then
		local times = self._jam_times_tbl.is_balance_mul and managers.groupai:state():_get_balancing_multiplier(self._jam_times_tbl, self._jam_times_tbl.team_ai_balance_mul_weight)
			or self._jam_times_tbl
		if type(times) == "table" then
			local min, max = math.min_max(unpack(times))
			jammed_times = math.random(math.round(min), math.round(max))
		else
			jammed_times = math.random(times)
		end
	else
		jammed_times = math.random(self._jam_times)
	end

	-- Modified SHAI tweak here, ignores drills with overrides
	-- Set an upper limit for how many times drills, saws, etc can randomly jam, based on their timers
	if not (self._unit_override and self._unit_override.jam_times) then
		jammed_times = math.min(self._jam_times, math.ceil(self._timer / 60))
	end

	return jammed_times
end

Hooks:OverrideFunction(TimerGui, "_set_jamming_values", function(self)
	local jammed_times = self:_get_jammed_times()
	if jammed_times == 0 then
		return
	end

	self._jamming_intervals = {}
	local interval = self._timer / jammed_times
	for i = 1, jammed_times do
		local start = interval / 2
		self._jamming_intervals[i] = start + math.rand(start / 1.25)
	end

	self._current_jam_timer = table.remove(self._jamming_intervals, 1)
end)

-- Remove arbitrary amount > 0 requirement, so a drill can be set to never naturally jam but still be sabotaged
-- No OverrideFunction as `amount` can be a table now
function TimerGui:set_jam_times(amount)
	if not self._can_jam then
		Eclipse:warn_console("Tried to set jam times on a drill that cannot jam")
		return
	end

	if type(amount) == "table" then
		self._jam_times_tbl = amount
		local amt = amount[#amount]
		if type(amt) == "table" then
			local _, max = math.min_max(unpack(amt))
			self._jam_times = math.round(max)
		else
			self._jam_times = amt
		end
	else
		self._jam_times = amount
	end
end
