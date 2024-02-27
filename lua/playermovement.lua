Hooks:PostHook(PlayerMovement, "init", "eclipse_init", function(self)
	if managers.player:has_category_upgrade("player", "morale_boost") or managers.player:has_category_upgrade("cooldown", "long_dis_revive") then
		self._rally_skill_data.range_sq = 490000
	end
end)

function PlayerMovement:on_SPOOCed(enemy_unit)
	if self._unit:character_damage()._god_mode or self._unit:character_damage():get_mission_blocker("invulnerable") then
		return
	end

	if
		self._current_state_name == "standard"
		or self._current_state_name == "carry"
		or self._current_state_name == "bleed_out"
		or self._current_state_name == "tased"
		or self._current_state_name == "bipod"
	then
		local state = "incapacitated"
		state = managers.modifiers:modify_value("PlayerMovement:OnSpooked", state)

		managers.achievment:award(tweak_data.achievement.finally.award)
		self._unit:sound():play("player_hit")

		alivePlayers = 0
		for _, criminal in pairs(managers.groupai:state():all_char_criminals()) do
            if not criminal.unit:movement():downed() then
                alivePlayers = alivePlayers + 1
            end
        end

		if alivePlayers == 1 then -- if you're the last man standing, cloaker kicks deal a portion of your max health in damage instead
			local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
			local spooc_kick_damage = self._unit:character_damage():_max_health() / ((diff_i == 6 and 2) or 4)
			self._unit:camera()._damage_bullet_shake_multiplier = 50

			self._unit:character_damage():change_health(-spooc_kick_damage)
			self._unit:camera():play_shaker("player_bullet_damage_knock_out", 1)
		else
			managers.player:set_player_state(state)
		end

		return true
	end
end
