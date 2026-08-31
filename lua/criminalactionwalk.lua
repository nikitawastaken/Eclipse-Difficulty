-- Make it so that bots carrying additional bags with the Stacker ability cannot run
function CriminalActionWalk:init(action_desc, common_data)
	if common_data.ext_movement:carrying_additional_bags() then
		if action_desc.variant == "run" then
			action_desc.variant = "walk"
		end
	end

	return CriminalActionWalk.super.init(self, action_desc, common_data)
end

-- Make bots always use forward speed
function CriminalActionWalk:_get_current_max_walk_speed()
	return CriminalActionWalk.super._get_current_max_walk_speed(self, "fwd")
end
