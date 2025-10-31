Hooks:PostHook(PlayerMovement, "init", "eclipse_init", function(self)
	if managers.player:has_category_upgrade("player", "morale_boost") or managers.player:has_category_upgrade("cooldown", "long_dis_revive") then
		self._rally_skill_data.range_sq = 490000
	end

	self._underdog_skill_data.has_dodge = managers.player:has_category_upgrade("temporary", "dodge_outnumbered")
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

		local alivePlayers = 0
		for _, criminal in pairs(managers.groupai:state():all_char_criminals()) do
			if not criminal.unit:movement():downed() then
				alivePlayers = alivePlayers + 1
			end
		end

		if alivePlayers == 1 then -- if you're the last man standing, cloaker kicks deal a portion of your max health in damage instead
			local spooc_kick_damage = self._unit:character_damage():_max_health() * (enemy_unit:base():char_tweak().spooc_kick_damage or 0.25)
			local spooc_kick_push = self._m_fwd:with_z(0.1):normalized() * 1000
			self._unit:character_damage():change_health(-spooc_kick_damage)

			local effect = "melee_hit_spooc_var" .. math.random(1, 2)

			self._unit:camera():play_shaker(effect, 1)
			self._unit:movement():push(spooc_kick_push)
		else
			managers.player:set_player_state(state)
		end

		return true
	end
end

-- DnC on-crouch stamina regen increase
function PlayerMovement:add_stamina(value)
	self:_change_stamina(
		math.abs(value)
			* managers.player:upgrade_value("player", "stamina_regen_multiplier", 1)
			* (self._state_data.ducking and managers.player:upgrade_value("player", "stamina_regen_multiplier_crouched", 1) or 1)
	)
end

-- Hitman outnumbered dodge
function PlayerMovement:_upd_underdog_skill(t)
	local data = self._underdog_skill_data

	if not self._attackers or not data.has_dodge or data.has_dmg_dampener and not data.has_dmg_mul and not data.has_dmg_dampener_close or t < self._underdog_skill_data.chk_t then
		return
	end

	local my_pos = self._m_pos
	local max_guys_to_check = data.nr_enemies
	local nr_guys = 0
	local activated = nil

	for u_key, attacker_unit in pairs(self._attackers) do
		if not alive(attacker_unit) then
			self._attackers[u_key] = nil

			return
		end

		local attacker_pos = attacker_unit:movement():m_pos()
		local dis_sq = mvector3.distance_sq(attacker_pos, my_pos)

		if dis_sq < data.max_dis_sq and math.abs(attacker_pos.z - my_pos.z) < data.max_vert_dis then
			nr_guys = nr_guys + 1

			if max_guys_to_check <= nr_guys then
				break
			end
		end
	end

	if data.nr_enemies <= nr_guys then
		activated = true

		if data.has_dmg_mul then
			managers.player:activate_temporary_upgrade("temporary", "dmg_multiplier_outnumbered")
		end

		if data.has_dmg_dampener then
			managers.player:activate_temporary_upgrade("temporary", "dmg_dampener_outnumbered")
			managers.player:activate_temporary_upgrade("temporary", "dmg_dampener_outnumbered_strong")
		end

		if data.has_dodge then
			managers.player:activate_temporary_upgrade("temporary", "dodge_outnumbered")
		end
	end

	if data.has_dmg_dampener_close and nr_guys >= 1 then
		managers.player:activate_temporary_upgrade("temporary", "dmg_dampener_close_contact")
	end

	data.chk_t = t + (activated and data.chk_interval_active or data.chk_interval_inactive)
end
