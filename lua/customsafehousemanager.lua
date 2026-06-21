function CustomSafehouseManager:unlocked()
	local plvl = managers.experience:current_level()
	local level_lock = tweak_data.safehouse_unlock_level or 50
	local is_not_level_locked = plvl >= level_lock
	return Global.mission_manager.has_played_tutorial and is_not_level_locked
end

-- Disable Safehouse raid native mechanic due it's purchasable heist now
function CustomSafehouseManager:is_being_raided()
	return false
end
