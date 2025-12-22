-- Tweak hostage rescue conditions
function CivilianLogicFlee.rescue_SO_verification(self, params, unit, ...)
	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().rescue_hostages then
		return false
	end

	local data = params.logic_data
	if data.team.foes[unit:movement():team().id] then
		return false
	end

	local logic_data = unit:brain()._logic_data
	if not logic_data or not logic_data.tactics or logic_data.tactics.rescue then
		return true
	end
end
