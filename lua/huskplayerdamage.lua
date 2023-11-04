-- Friendly Fire
function HuskPlayerDamage:damage_bullet(attack_data)
	if managers.mutators:is_mutator_active(MutatorFriendlyFire) or Global.game_settings and Global.game_settings.one_down then
		self:_send_damage_to_owner(attack_data)
	end
end

function HuskPlayerDamage:damage_melee(attack_data)
	if managers.mutators:is_mutator_active(MutatorFriendlyFire) or Global.game_settings and Global.game_settings.one_down then
		self:_send_damage_to_owner(attack_data)
	end
end

function HuskPlayerDamage:damage_fire(attack_data)
	if managers.mutators:is_mutator_active(MutatorFriendlyFire) or Global.game_settings and Global.game_settings.one_down then
		attack_data.damage = attack_data.damage * 0.2

		self:_send_damage_to_owner(attack_data)
	end
end

function HuskPlayerDamage:_send_damage_to_owner(attack_data)
	local peer_id = managers.criminals:character_peer_id_by_unit(self._unit)
	local damage = math.min(20, attack_data.damage ^ 0.9)

	managers.network:session():send_to_peers("sync_friendly_fire_damage", peer_id, attack_data.attacker_unit, damage, attack_data.variant)

	if attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_ff_confirmed()
	end

	if managers.mutators:is_mutator_active(MutatorFriendlyFire) then
		managers.job:set_memory("trophy_flawless", true, false)
	end
end
