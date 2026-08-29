function PlayerBleedOut:_check_change_weapon(...)
	if managers.player:has_category_upgrade("player", "swap_weapon_when_downed") then
		return PlayerBleedOut.super._check_change_weapon(self, ...)
	end

	return false
end

function PlayerBleedOut:_check_action_equip(...)
	if managers.player:has_category_upgrade("player", "swap_weapon_when_downed") then
		return PlayerBleedOut.super._check_action_equip(self, ...)
	end

	return false
end

local exit_original = PlayerBleedOut.exit
function PlayerBleedOut:exit(...)
	local exit_data = exit_original(self, ...)

	exit_data.equip_weapon = nil

	return exit_data
end

-- Stop bots from dropping light bags when going to revive a player
function PlayerBleedOut:on_rescue_SO_administered(revive_SO_data, receiver_unit)
	revive_SO_data.rescuer = receiver_unit
	revive_SO_data.SO_id = nil

	local movement = receiver_unit:movement()
	local move_speed_modifier = movement._carry_speed_modifier or 1

	if movement:carrying_bag() and move_speed_modifier < tweak_data.team_ai.rescue_throw_bag_threshold then
		movement:throw_bag()
	end
end
