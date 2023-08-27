-- Add missing friendly fire check
TeamAIDamage.is_friendly_fire = PlayerDamage.is_friendly_fire

Hooks:PostHook(TeamAIDamage, "damage_bullet", "eclipse_teamai_damage_bullet", function(self, attack_data)
	if attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_hit_confirmed()
	end
end)
