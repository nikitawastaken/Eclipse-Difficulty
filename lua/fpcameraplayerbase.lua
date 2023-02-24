-- No cloaker camera tilt
function FPCameraPlayerBase:clbk_aim_assist(col_ray)
end

-- static recoil that actually feels good
function FPCameraPlayerBase:stop_shooting(wait)
	self._recoil_kick.to_reduce = self._recoil_kick.ret or 0
	self._recoil_kick.h.to_reduce = self._recoil_kick.h.ret or 0
	self._recoil_wait = wait or 0
end

function FPCameraPlayerBase:recoil_kick(up, down, left, right)
	if math.abs(self._recoil_kick.accumulated) < 2000 then
		local v = math.lerp(up, down, math.random())
		self._recoil_kick.accumulated = (self._recoil_kick.accumulated or 0) + v
		self._recoil_kick.ret = v
	end

	local h = math.lerp(left, right, math.random())
	self._recoil_kick.h.accumulated = (self._recoil_kick.h.accumulated or 0) + h
	self._recoil_kick.h.ret = h
end


-- Spray pattern implementation
Hooks:PostHook(FPCameraPlayerBase, "init", "spray_init",
function(self)
    -- Some fields to initialize
    self._recoil_recovery_t = 0
    self._pattern_index = 1
    self._persist_pattern_index = 1
    self._persist_pattern_back = 1
    self._h_recoil_cushion = 0
end)
Hooks:PostHook(FPCameraPlayerBase, "update", "spray_update",
function(self, unit, t, dt)
    -- Count the time since the player last shot
    if self._recoil_recovery_t > 0 then
        self._recoil_recovery_t = self._recoil_recovery_t - dt
    end
end)
function FPCameraPlayerBase:pattern_recoil_kick(pattern, persist_pattern, recoil_multiplier, recoil_recovery)
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