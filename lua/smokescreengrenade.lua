function SmokeScreenGrenade:set_thrower_unit(unit, ...)
	SmokeScreenGrenade.super.set_thrower_unit(self, unit, ...)

	self._has_armor_bonus = self._thrower_unit:base():upgrade_value("player", "smoke_grenade_no_armor_suppression")
	self._has_dodge_bonus = self._thrower_unit:base():upgrade_value("player", "smoke_grenade_dodge_buff")
	self._linger_bonus = self._thrower_unit:base():upgrade_value("player", "smoke_grenade_lingering_effect") or 0
end

-- selene: allow(unused_variable)
function SmokeScreenGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
	end

	managers.player:spawn_smoke_screen(pos, normal, self._unit, self._has_armor_bonus, self._has_dodge_bonus, self._linger_bonus)

	if Network:is_server() then
		managers.groupai:state():propagate_alert({
			"explosion",
			pos,
			range,
			managers.groupai:state("civilian_enemies"),
			self._unit,
		})
	end
end
