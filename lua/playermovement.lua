Hooks:PostHook(PlayerMovement, "init", "eclipse_init", function(self)
	if managers.player:has_category_upgrade("player", "morale_boost") or managers.player:has_category_upgrade("cooldown", "long_dis_revive") then
		self._rally_skill_data.range_sq = 490000
	end
end)
