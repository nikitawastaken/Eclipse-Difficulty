Hooks:PostHook(ShotgunBase, "_update_stats_values", "eclipse__update_stats_values", function(self)
	local extra_pellets = managers.player:upgrade_value("shotgun", "extra_pellets", 0)
	if self._ammo_data then
		if self._ammo_data.rays ~= 1 then
			self._rays = self._rays + extra_pellets
		end
	end
end)

function ShotgunBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	local result = {
		hit_enemy = false,
		rays = {},
	}

	local damage = dmg_mul / self._rays

	for _ = 1, self._rays do
		local res = ShotgunBase.super._fire_raycast(self, user_unit, from_pos, direction, damage, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
		if res.hit_enemy then
			result.hit_enemy = true
		end
		table.list_append(result.rays, res.rays)
	end

	return result
end
