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

-- Announce low health
Hooks:PostHook(TeamAIDamage, "_apply_damage", "eclipse_apply_damage", function(self)
	local t = TimerManager:game():time()
	if (not self._said_hurt_t or self._said_hurt_t + 10 < t) and self._health_ratio < 0.33 and not self:need_revive() and not self._unit:sound():speaking() then
		self._said_hurt_t = t
		self._unit:sound():say("g80x_plu", true, true)
	end
end)

-- Gradual health regeneration
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
		self._health = math.min(self._health + self._HEALTH_INIT * self._char_dmg_tweak.REGENERATE_RATIO, self._HEALTH_INIT)
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

-- Mark the Taser when tased
local damage_tase_original = TeamAIDamage.damage_tase
function TeamAIDamage:damage_tase(attack_data, ...)
	local result = damage_tase_original(self, attack_data, ...)

	if result and attack_data then
		local attacker = attack_data.attacker_unit
		if alive(attacker) and attacker:base() and attacker:base().has_tag and attacker:base():has_tag("taser") then
			attacker:contour():add("mark_enemy", true)
			local priority_shout = attacker:base():char_tweak().priority_shout
			if priority_shout then
				self._unit:sound():say(priority_shout .. "x_any", true)
			end

			self._assist_SO_id = "TeamAIDamage_assistance" .. tostring(self._unit:key())
			managers.groupai:state():add_special_objective(self._assist_SO_id, Eclipse.utils.team_ai_get_assist_SO(self._unit))
		end
	end

	return result
end

Hooks:PostHook(TeamAIDamage, "on_tase_ended", "eclipse_on_tase_ended", function(self)
	if self._assist_SO_id then
		managers.groupai:state():remove_special_objective(self._assist_SO_id)
		Eclipse.utils.team_ai_stop_assist_objective(self._unit)
		self._assist_SO_id = nil
	end
end)

-- Throw all your bags during bleedout
Hooks:PostHook(TeamAIDamage, "_check_bleed_out", "eclipse_ai_check_bleedout", function(self)
	if self._bleed_out and Network:is_server() then
		while self._unit:movement():carrying_bag() do
			self._unit:movement():throw_bag()
		end
	end
end)
