-- Tweak bag stealing conditions
function CarryData:clbk_pickup_SO_verification(unit)
	if not self._steal_SO_data or not self._steal_SO_data.SO_id then
		return
	end

	-- Less likely to steal bags during assault
	if not managers.groupai:state()._rescue_allowed and math.random() < 0.3 then
		return
	end

	if unit:movement():cool() then
		return
	end

	if not unit:base():char_tweak().steal_loot then
		return
	end

	local objective = unit:brain():objective()
	if not objective or objective.type == "free" or not objective.area then
		return true
	end

	if objective.grp_objective and objective.grp_objective.type == "reenforce_area" then
		return
	end

	local nav_seg = unit:movement():nav_tracker():nav_segment()
	if self._steal_SO_data.pickup_area.nav_segs[nav_seg] or objective.area == self._steal_SO_data.pickup_area then
		return true
	end
end