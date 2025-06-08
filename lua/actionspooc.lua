-- Allow Cloakers to dodge while charging
local _upd_sprint_original = ActionSpooc._upd_sprint
function ActionSpooc:_upd_sprint(t, ...)
    if self._ext_anim.dodge then
        return CopActionDodge.update(self, t)
    elseif not self._next_dodge_check_t then
        self._ext_movement:play_redirect("stand")
		
		local spooc_dodge_check_t = self._unit:base():char_tweak().spooc_attack_dodge_timeout or { 0.5, 1 }
		
        self._next_dodge_check_t = t + math.rand(spooc_dodge_check_t[1], spooc_dodge_check_t[2])
    end

    if self._next_dodge_check_t < t then
        self._next_dodge_check_t = nil

        local redir_res = self._ext_movement:play_redirect("dodge_roll")
        if not redir_res then
            return
        end

        self._side = table.random({ "r", "l", "fwd" })
        self._direction = mvector3.copy(self._ext_movement:m_fwd())

        if self._side ~= "fwd" then
            mvector3.cross(self._direction, self._direction, math.UP)
            if self._side == "l" then
                mvector3.negate(self._direction)
            end
            mvector3.lerp(self._direction, self._direction, self._ext_movement:m_fwd(), 0.5)
        end

        self._ids_base = Idstring("base")
        CopActionDodge._determine_rotation_transition(self)

        self._machine:set_speed(redir_res, 2)
        self._machine:set_parameter(redir_res, self._side, 1)
        return
    end

    return _upd_sprint_original(self, t, ...)
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