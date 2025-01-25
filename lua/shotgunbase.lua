Hooks:PostHook(ShotgunBase, "_update_stats_values", "eclipse__update_stats_values", function(self)
	local extra_pellets = managers.player:upgrade_value("shotgun", "extra_pellets", 0)
	if self._ammo_data then
		if self._ammo_data.rays ~= 1 then
			self._rays = self._rays + extra_pellets
		end
	end
end)

function ShotgunBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, ...)
	local result = {
		hit_enemy = false,
		rays = {},
	}

	for _ = 1, self._rays do
		local res = ShotgunBase.super._fire_raycast(self, user_unit, from_pos, direction, ...)
		result.hit_enemy = result.hit_enemy or res.hit_enemy
		table.list_append(result.rays, res.rays)
	end

	return result
end
