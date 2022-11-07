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
