Hooks:PostHook(ShotgunBase, "_update_stats_values", "eclipse__update_stats_values", function(self)
	local extra_pellets = managers.player:upgrade_value("shotgun", "extra_pellets", 0)
	if self._ammo_data then
		if self._ammo_data.rays ~= 1 then
			self._rays = self._rays + extra_pellets
		end
	end
end)
