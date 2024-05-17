-- No cloaker camera tilt
function FPCameraPlayerBase:clbk_aim_assist(col_ray) end

-- if the player is in vr, don't do any further changes
if _G.IS_VR then
	return
end

Hooks:PostHook(FPCameraPlayerBase, "stop_shooting", "ssr_stop_shooting", function(self)
	self._recoil_kick.to_reduce = self._recoil_kick.last or 0
	self._recoil_kick.h.to_reduce = self._recoil_kick.h.last or 0
end)

function FPCameraPlayerBase:recoil_kick(up, down, left, right)
	local v = math.lerp(up, down, math.random())
	self._recoil_kick.accumulated = (self._recoil_kick.accumulated or 0) + v
	self._recoil_kick.last = v
	local h = math.lerp(left, right, math.random())
	self._recoil_kick.h.accumulated = (self._recoil_kick.h.accumulated or 0) + h
	self._recoil_kick.h.last = h
end

function FPCameraPlayerBase:_vertical_recoil_kick(t, dt)
	if managers.player:current_state() == "bipod" then
		self:break_recoil()
		return 0
	end

	local r_value = 0
	if self._recoil_kick.current and self._episilon < self._recoil_kick.accumulated - self._recoil_kick.current then
		local n = math.step(self._recoil_kick.current, self._recoil_kick.accumulated, 50 * dt)
		r_value = n - self._recoil_kick.current
		self._recoil_kick.current = n
	elseif self._recoil_wait then
		self._recoil_wait = self._recoil_wait - dt * 0.5
		if self._recoil_wait < 0 then
			self._recoil_wait = nil
		end
	elseif self._recoil_kick.to_reduce then
		self._recoil_kick.current = nil
		local n = math.lerp(self._recoil_kick.to_reduce, 0, 3 * dt)
		r_value = -(self._recoil_kick.to_reduce - n)
		self._recoil_kick.to_reduce = n

		if self._recoil_kick.to_reduce == 0 then
			self._recoil_kick.to_reduce = nil
		end
	end

	return r_value
end

function FPCameraPlayerBase:_horizonatal_recoil_kick(t, dt)
	if managers.player:current_state() == "bipod" then
		return 0
	end

	local r_value = 0
	if self._recoil_kick.h.current and self._episilon < math.abs(self._recoil_kick.h.accumulated - self._recoil_kick.h.current) then
		local n = math.step(self._recoil_kick.h.current, self._recoil_kick.h.accumulated, 50 * dt)
		r_value = n - self._recoil_kick.h.current
		self._recoil_kick.h.current = n
	elseif self._recoil_wait then
		self._recoil_wait = self._recoil_wait - dt * 0.5
		if self._recoil_wait < 0 then
			self._recoil_wait = nil
		end
	elseif self._recoil_kick.h.to_reduce then
		self._recoil_kick.h.current = nil
		local n = math.lerp(self._recoil_kick.h.to_reduce, 0, 2 * dt)
		r_value = -(self._recoil_kick.h.to_reduce - n)
		self._recoil_kick.h.to_reduce = n

		if self._recoil_kick.h.to_reduce == 0 then
			self._recoil_kick.h.to_reduce = nil
		end
	end

	return r_value
end

-- Spray pattern implementation
Hooks:PostHook(FPCameraPlayerBase, "init", "spray_init", function(self)
	-- Some fields to initialize
	self._recoil_recovery_t = 0
	self._pattern_index = 1
	self._persist_pattern_index = 1
	self._persist_pattern_back = 1
	self._h_recoil_cushion = 0
end)

Hooks:PostHook(FPCameraPlayerBase, "update", "spray_update", function(self, unit, t, dt)
	-- Count the time since the player last shot
	if self._recoil_recovery_t > 0 then
		self._recoil_recovery_t = self._recoil_recovery_t - dt
	end
end)

function FPCameraPlayerBase:pattern_recoil_kick(pattern, persist_pattern, recoil_multiplier, recoil_recovery)
	-- set this to 0 so that the recoil from normal weapons doesn't bleed into spray patterned ones
	self._recoil_kick.last = 0
	self._recoil_kick.h.last = 0

	-- If the player hasn't shot in 1/3rd of second reset the recoil pattern
	if self._recoil_recovery_t <= 0 then
		self._pattern_index = 1
	end
	self._recoil_recovery_t = recoil_recovery
	-- Stability affects spray patterns
	-- Bruteforce way but idc
	-- Do the first part of the spray pattern
	if self._pattern_index <= #pattern then
		local v = math.lerp(pattern[self._pattern_index].up * recoil_multiplier, pattern[self._pattern_index].down * recoil_multiplier, math.random())
		self._recoil_kick.accumulated = (self._recoil_kick.accumulated or 0) + v

		local h = math.lerp(pattern[self._pattern_index].left * recoil_multiplier, pattern[self._pattern_index].right * recoil_multiplier, math.random())
		self._recoil_kick.h.accumulated = (self._recoil_kick.h.accumulated or 0) + h

		self._pattern_index = self._pattern_index + 1
	else -- Second part of the spray pattern (persist pattern)
		if self._persist_pattern_index >= #persist_pattern then
			self._persist_pattern_index = 1
		end
		-- Reverse horizontal spray after a threshold
		-- Add a cushion in case the recoil gets stuck too far in one direction
		if math.abs(self._recoil_kick.h.accumulated) >= 7 and self._h_recoil_cushion == 0 then
			self._h_recoil_cushion = 3
			self._persist_pattern_back = -self._persist_pattern_back
		end
		local v = math.lerp(persist_pattern[self._persist_pattern_index].up * recoil_multiplier, persist_pattern[self._persist_pattern_index].down * recoil_multiplier, math.random())
		self._recoil_kick.accumulated = (self._recoil_kick.accumulated or 0) + v

		local h = math.lerp(persist_pattern[self._persist_pattern_index].left * recoil_multiplier, persist_pattern[self._persist_pattern_index].right * recoil_multiplier, math.random())
		self._recoil_kick.h.accumulated = (self._recoil_kick.h.accumulated or 0) + h * self._persist_pattern_back

		self._persist_pattern_index = self._persist_pattern_index + 1
		if self._h_recoil_cushion ~= 0 then
			self._h_recoil_cushion = self._h_recoil_cushion - 1
		end
	end

	self._recoil_kick.ret = 0
	self._recoil_kick.h.ret = 0
end
