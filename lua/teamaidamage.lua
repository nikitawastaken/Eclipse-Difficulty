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
