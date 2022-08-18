Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "eclipse__update_stats_values", function(self)
	self._optimal_distance = 0
	self._optimal_range = 0
end)

function NewRaycastWeaponBase:movement_penalty()
	if managers.player:has_category_upgrade("player", "no_movement_penalty") then return 1
	else return self._movement_penalty or 1
	end
end