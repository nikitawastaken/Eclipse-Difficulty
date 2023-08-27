Hooks:PostHook(HuskTeamAIDamage, "damage_bullet", "eclipse_husk_teamai_damage_bullet", function(self, attack_data)
    if attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end
end)

Hooks:PostHook(HuskTeamAIDamage, "damage_melee", "eclipse_husk_teamai_damage_melee", function(self, attack_data)
    if attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end
end)

Hooks:PostHook(HuskTeamAIDamage, "damage_fire", "eclipse_husk_teamai_damage_fire", function(self, attack_data)
    if attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end
end)