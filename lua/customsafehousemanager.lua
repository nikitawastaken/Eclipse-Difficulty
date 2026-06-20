function CustomSafehouseManager:unlocked()
	local plvl = managers.experience:current_level()
	local level_lock = tweak_data.safehouse_unlock_level or 25
	local is_not_level_locked = plvl >= level_lock
	return Global.mission_manager.has_played_tutorial and is_not_level_locked
end