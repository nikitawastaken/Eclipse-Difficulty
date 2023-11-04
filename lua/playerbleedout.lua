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
