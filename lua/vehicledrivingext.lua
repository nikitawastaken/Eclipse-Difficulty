function VehicleDrivingExt:_find_unit_seat(unit)
	for _, seat in pairs(self._seats) do
		if alive(seat.occupant) and seat.occupant == unit then
			return seat
		end
	end
end

local clbk_drive_SO_verification_original = VehicleDrivingExt.clbk_drive_SO_verification
function VehicleDrivingExt:clbk_drive_SO_verification(seat, candidate_unit, ...)
	-- If bot was told to hold, don't enter
	if candidate_unit:movement()._should_stay then
		return
	end

	-- If vehicle is slower than bot running speed, don't enter
	if self._tweak_data.max_speed * (1000 / 60) < candidate_unit:base():char_tweak().move_speed.stand.run.cbt.fwd then
		return
	end

	-- If our follow unit is not in the vehicle don't enter
	local objective = candidate_unit:brain() and candidate_unit:brain():objective()
	if objective and objective.follow_unit and not self:_find_unit_seat(objective.follow_unit) then
		return
	end

	return clbk_drive_SO_verification_original(self, seat, candidate_unit, ...)
end
