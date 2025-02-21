-- Add missing friendly fire check
TeamAIDamage.is_friendly_fire = PlayerDamage.is_friendly_fire

Hooks:PostHook(TeamAIDamage, "damage_bullet", "eclipse_teamai_damage_bullet", function(self, attack_data)
	if not self:is_friendly_fire(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end
end)

Hooks:PostHook(TeamAIDamage, "damage_melee", "eclipse_teamai_damage_melee", function(self, attack_data)
	if not self:is_friendly_fire(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end
end)

Hooks:PostHook(TeamAIDamage, "damage_fire", "eclipse_teamai_damage_fire", function(self, attack_data)
	if not self:is_friendly_fire(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end
end)

Hooks:OverrideFunction(TeamAIDamage, "_regenerated", function(self)
	if self._bleed_out or self._fatal then
		self._health = self._HEALTH_INIT
		self._health_ratio = 1

		self._bleed_out = nil
		self._bleed_death_t = nil
		self._bleed_out_health = nil
		self._fatal = nil

		self._regenerate_t = nil
	else
		self._health = math.min(self._health + (self._char_dmg_tweak.HEALTH_REGEN or self._HEALTH_INIT * 0.1), self._HEALTH_INIT)
		self._health_ratio = self._health / self._HEALTH_INIT

		if self._health_ratio < 1 then
			self._regenerate_t = TimerManager:game():time() + self._char_dmg_tweak.REGENERATE_TIME
		end
	end

	self._bleed_out_paused_count = 0
	self._to_dead_t = nil
	self._to_dead_remaining_t = nil

	self:_clear_damage_transition_callbacks()
end)
