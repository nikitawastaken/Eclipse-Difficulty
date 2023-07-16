-- Apply default carry speed upgrade to bots and make them always use forward speed
function CriminalActionWalk:_get_max_walk_speed()
	local speed = CriminalActionWalk.super._get_max_walk_speed(self)

	local carry_id = self._ext_movement:carry_id()
	if not carry_id then
		return speed
	end

	local carry_upgrade = managers.player:upgrade_value("carry", "movement_speed_multiplier", 1)
	local speed_modifier = math.clamp(tweak_data.carry.types[tweak_data.carry[carry_id].type].move_speed_modifier * carry_upgrade, 0, 1)

	speed = deep_clone(speed)
	for k, v in pairs(speed) do
		speed[k] = v * speed_modifier
	end

	return speed
end

function CriminalActionWalk:_get_current_max_walk_speed()
	local speed = CriminalActionWalk.super._get_current_max_walk_speed(self, "fwd")

	local carry_id = self._ext_movement:carry_id()
	if not carry_id then
		return speed
	end

	local carry_upgrade = managers.player:upgrade_value("carry", "movement_speed_multiplier", 1)
	local speed_modifier = math.clamp(tweak_data.carry.types[tweak_data.carry[carry_id].type].move_speed_modifier * carry_upgrade, 0, 1)

	return speed * speed_modifier
end