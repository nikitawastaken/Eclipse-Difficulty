-- lib\units\weapons\grenades\poisongasgrenade

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

	self._timer = nil
	self._detonated = true

	if Network:is_server() then
		local slot_mask = managers.slot:get_mask("explosion_targets")
		local hit_units, splinters = managers.explosion:detect_and_give_dmg({
			player_damage = 0,
			hit_pos = pos,
			range = range,
			collision_slotmask = slot_mask,
			curve_pow = self._curve_pow,
			damage = self._damage,
			ignore_unit = self._unit,
			alert_radius = self._alert_radius,
			user = self:thrower_unit() or self._unit,
			owner = self._unit
		})
		
		-- this should make it so only host gets the tear gas detonated and then syncs it to clients
		-- it probably behaves this way as client but i want to be safe with multiple mod users
		-- if it works like shit then just move it out of is_server
		managers.groupai:state():detonate_cs_grenade(pos, normal, math.max(1, 48 / 3), true)
													--grenade position, grenade position, gas duration, detonate with delay or instantly (boolean value)

		managers.explosion:give_local_player_dmg(pos, range, self._player_damage)
		managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)

		if self._unit:id() ~= -1 then
			managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
		end
	end

	--managers.groupai:state():detonate_cs_grenade(self._grenade_m_pos, m_pos, (poison_grenade.poison_gas_duration / 5))
	--self:detonate_cs_grenade(detonate_pos, mvec_cpy(grenade_user.m_pos), tweak_data.group_ai.cs_grenade_lifetime or 10)

	
	self:_handle_hiding_and_destroying(false, nil)
end