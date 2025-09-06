function GamePlayCentralManager:do_shotgun_push(unit, hit_pos, dir, distance, attacker)
	if self:get_shotgun_push_range() < distance or not managers.player:has_category_upgrade("shotgun", "enemy_push") then
		return
	end

	if unit:id() > 0 then
		managers.network:session():send_to_peers("sync_shotgun_push", unit, hit_pos, dir, distance, attacker)
	end

	self:_do_shotgun_push(unit, hit_pos, dir, distance, attacker)
end