function PoisonGasGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._detonated then
		return
	end

	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range
	local grenade_entry = self:projectile_entry()
	local tweak_entry = tweak_data.projectiles[grenade_entry]

	managers.player:spawn_poison_gas(pos, normal, tweak_entry, self._unit)
	self._unit:set_extension_update_enabled(Idstring("base"), false)
	
	World:effect_manager():spawn({
		effect = Idstring("effects/particles/explosions/explosion_smoke_grenade"),
		position = self._unit:position(),
		normal = self._unit:rotation():y()
	})
	self._unit:sound_source():set_position(pos)
	self._unit:sound_source():post_event("grenade_gas_explode")

	self._timer = nil
	self._detonated = true

	if Network:is_server() then
		if self._unit:id() ~= -1 and managers.network:session() then
			managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
		end
	end

	self:_handle_hiding_and_destroying(false, nil)
end

function PoisonGasGrenade:_detonate_on_client()
	if self._detonated then
		return
	end

	self:_detonate()
end