-- Tweak hostage rescue conditions
function CopLogicIntimidated.rescue_SO_verification(ignore_this, data, unit, ...)
	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().rescue_hostages then
		return false
	end

	if data.team.foes[unit:movement():team().id] then
		return false
	end

	local objective = unit:brain():objective()
	if not objective or objective.type == "free" or not objective.area then
		return true
	end

	local nav_seg = data.unit:movement():nav_tracker():nav_segment()
	if objective.area.nav_segs[nav_seg] or unit:movement():nav_tracker():nav_segment() == nav_seg then
		return true
	end

	if unit:movement():nav_tracker():nav_segment() == nav_seg then
		return managers.groupai:state()._rescue_allowed
	end
end