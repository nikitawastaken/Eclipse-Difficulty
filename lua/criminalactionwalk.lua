-- Make bots always use forward speed
function CriminalActionWalk:_get_current_max_walk_speed()
	return CriminalActionWalk.super._get_current_max_walk_speed(self, "fwd")
end
