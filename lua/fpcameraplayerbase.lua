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
		local n = math.lerp(self._recoil_kick.current, self._recoil_kick.accumulated, math.min(1, 50 * dt))
		r_value = n - self._recoil_kick.current
		self._recoil_kick.current = n
	elseif self._recoil_wait then
		self._recoil_wait = self._recoil_wait - dt * 0.5
		if self._recoil_wait < 0 then
			self._recoil_wait = nil
		end
	elseif self._recoil_kick.to_reduce then
		self._recoil_kick.current = nil
		local n = math.lerp(self._recoil_kick.to_reduce, 0, math.min(1, 3 * dt))
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
		local n = math.lerp(self._recoil_kick.h.current, self._recoil_kick.h.accumulated, math.min(1, 50 * dt))
		r_value = n - self._recoil_kick.h.current
		self._recoil_kick.h.current = n
	elseif self._recoil_wait then
		self._recoil_wait = self._recoil_wait - dt * 0.5
		if self._recoil_wait < 0 then
			self._recoil_wait = nil
		end
	elseif self._recoil_kick.h.to_reduce then
		self._recoil_kick.h.current = nil
		local n = math.lerp(self._recoil_kick.h.to_reduce, 0, math.min(1, 2 * dt))
		r_value = -(self._recoil_kick.h.to_reduce - n)
		self._recoil_kick.h.to_reduce = n

		if self._recoil_kick.h.to_reduce == 0 then
			self._recoil_kick.h.to_reduce = nil
		end
	end

	return r_value
end

local bezier_values = {
	0,
	0.4,
	1,
	1,
}
--Improved ADS animations from Restoration Mod
Hooks:PostHook(FPCameraPlayerBase, "_update_stance", "eclipse_update_stance", function(self, t, dt)
	if self._shoulder_stance.transition then
		local trans_data = self._shoulder_stance.transition
		local elapsed_t = t - trans_data.start_t
		local player_state = managers.player:current_state()
		local equipped_weapon = self._parent_unit:inventory():equipped_unit()
		local is_akimbo = equipped_weapon and equipped_weapon:base() and equipped_weapon:base().AKIMBO
		local ignore_transition_styles = equipped_weapon and equipped_weapon:base() and equipped_weapon:base():weapon_tweak_data().ign_ts
		local in_full_steelsight = self._parent_movement_ext._current_state._state_data.in_full_steelsight

		if trans_data.duration < elapsed_t then
			mvector3.set(self._shoulder_stance.translation, trans_data.end_translation)

			self._shoulder_stance.rotation = trans_data.end_rotation
			self._shoulder_stance.transition = nil
			local in_steelsight = self._parent_movement_ext._current_state:in_steelsight()

			if in_steelsight and not self._steelsight_swap_state then
				self:_set_steelsight_swap_state(true)
			elseif not in_steelsight and self._steelsight_swap_state then
				self:_set_steelsight_swap_state(false)
			end
		else
			local progress = elapsed_t / trans_data.duration
			local progress_smooth = math.bezier(bezier_values, progress)
			local in_steelsight = self._parent_movement_ext._current_state:in_steelsight()
			if equipped_weapon and equipped_weapon:base() then
				local in_second_sight = equipped_weapon:base():is_second_sight_on()
				if in_second_sight and in_second_sight == true then
					self._shoulder_stance.was_in_second_sight = true
				end
			end
			local absolute_progress = nil

			if in_steelsight or self._shoulder_stance.was_in_steelsight then
				self._shoulder_stance.was_in_steelsight = true
				absolute_progress = (1 - trans_data.absolute_progress) * progress_smooth + trans_data.absolute_progress
			else
				absolute_progress = trans_data.absolute_progress * (1 - progress_smooth)
			end

			mvector3.lerp(self._shoulder_stance.translation, trans_data.start_translation, trans_data.end_translation, progress_smooth)

			self._shoulder_stance.rotation = trans_data.start_rotation:slerp(trans_data.end_rotation, progress_smooth)

			if not is_akimbo and not ignore_transition_styles then
				if player_state and player_state ~= "bipod" and trans_data.absolute_progress and not self._steelsight_swap_state then
					local prog = (1 - absolute_progress) * (dt * 100)
					if self._shoulder_stance.was_in_steelsight and not in_steelsight then
						self._shoulder_stance.was_in_steelsight = nil
						self._shoulder_stance.was_in_second_sight = nil
						prog = absolute_progress * (dt * 100)
						trans_data.start_translation = trans_data.start_translation + Vector3(1 * prog, 0.5 * prog, 1 * prog)
						trans_data.start_rotation = trans_data.start_rotation * Rotation(0 * prog, 0 * prog, 2.5 * prog)
					elseif in_steelsight and in_full_steelsight ~= true then
						trans_data.start_translation = trans_data.start_translation + Vector3(0.5 * prog, 0.5 * prog, -0.2 * prog)
						trans_data.start_rotation = trans_data.start_rotation * Rotation(0 * prog, 0 * prog, 1.25 * prog)
					end
				end
			end
		end
	end
end)

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
		self._persist_pattern_index = 1
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
		---Does not work well with current spray patterns, deprecated for now
		--[[ if math.abs(self._recoil_kick.h.accumulated) >= 7 and self._h_recoil_cushion == 0 then
			self._h_recoil_cushion = 3
			self._persist_pattern_back = -self._persist_pattern_back
		end ]]
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
