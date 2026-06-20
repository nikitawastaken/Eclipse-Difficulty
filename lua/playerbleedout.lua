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

if UsefulBots then
	return
end

-- Stop bots from dropping light bags when going to revive a player
local on_rescue_SO_administered_original = PlayerBleedOut.on_rescue_SO_administered
function PlayerBleedOut:on_rescue_SO_administered(revive_SO_data, receiver_unit, ...)
	local movement = receiver_unit:movement()
	local had_bag = movement._carry_unit
	local move_speed_modifier = movement._carry_speed_modifier or 1

	on_rescue_SO_administered_original(self, revive_SO_data, receiver_unit, ...)

	if had_bag and move_speed_modifier > 0.75 and not movement:carrying_bag() then
		had_bag:carry_data():link_to(receiver_unit, false)
		movement:set_carrying_bag(had_bag)
	end
end