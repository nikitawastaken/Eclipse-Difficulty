-- not much of this is different from the vanilla code
-- i just repurposed the autorevive upgrade for down restoration
function FirstAidKitBase:setup(bits)
    local upgrade_lvl, down_restore = self:_get_upgrade_levels(bits)
    self._damage_reduction_upgrade = upgrade_lvl == 1
    self._down_restore = false

    if Network:is_server() then
        local from_pos = self._unit:position() + self._unit:rotation():z() * 10
        local to_pos = self._unit:position() + self._unit:rotation():z() * -10
        local ray = self._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))

        if ray then
            self._attached_data = {
                body = ray.body,
                position = ray.body:position(),
                rotation = ray.body:rotation(),
                index = 1,
                max_index = 3
            }

            self._unit:set_extension_update_enabled(Idstring("base"), true)
        end
    end

    if down_restore == 1 then
        self._down_restore = true
    end
end

function FirstAidKitBase:_get_upgrade_levels(bits)
	local down_restore = Bitwise:rshift(bits, FirstAidKitBase.auto_recovery_shift)
	local upgrade_lvl = Bitwise:rshift(bits, FirstAidKitBase.upgrade_lvl_shift) % 2^FirstAidKitBase.upgrade_lvl_shift

	return upgrade_lvl, down_restore
end

function FirstAidKitBase:take(unit)
	if self._empty then
		return
	end

    local down_restore = self._down_restore

	unit:character_damage():band_aid_health(down_restore)

	if self._damage_reduction_upgrade then
		managers.player:activate_temporary_upgrade("temporary", "first_aid_damage_reduction")
	end

	if managers.network:session() then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", 2)
	end

	self:_set_empty()
end