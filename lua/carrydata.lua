-- Only allow bag stealing if we aren't reenforce
local clbk_pickup_SO_verification_original = CarryData.clbk_pickup_SO_verification
function CarryData:clbk_pickup_SO_verification(candidate_unit, ...)
	local logic_data = candidate_unit:brain()._logic_data
	if not logic_data or not logic_data.objective or not logic_data.objective.grp_objective or logic_data.objective.grp_objective.type ~= "reenforce_area"  then
		return clbk_pickup_SO_verification_original(self, candidate_unit, ...)
	end
end