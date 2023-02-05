-- Only allow hostage rescue if it's part of our tactics (or if we don't have any tactics to allow scripted cop/security spawns to rescue hostages)
local rescue_SO_verification_original = CivilianLogicFlee.rescue_SO_verification
function CivilianLogicFlee.rescue_SO_verification(ignore_this, params, unit, ...)
	local logic_data = unit:brain()._logic_data
	if not logic_data or not logic_data.tactics or logic_data.tactics.rescue_hostages or logic_data.objective and logic_data.objective.grp_objective and logic_data.objective.grp_objective.type == "recon_area" then
		return rescue_SO_verification_original(ignore_this, params, unit, ...)
	end
end