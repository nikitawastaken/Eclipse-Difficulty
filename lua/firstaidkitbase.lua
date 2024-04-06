-- faks give HoT regen on use
FirstAidKitBase.hot_regen_shift = 6
function FirstAidKitBase:setup(bits)
	local upgrade_lvl, auto_recovery, hot_regen = self:_get_upgrade_levels(bits)
	self._damage_reduction_upgrade = upgrade_lvl == 1
	self._hot_regen = false

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
				max_index = 3,
			}

			self._unit:set_extension_update_enabled(Idstring("base"), true)
		end
	end

	if hot_regen == 1 then
		self._hot_regen = true
	end

	if auto_recovery == 1 then
		self._min_distance = tweak_data.upgrades.values.first_aid_kit.first_aid_kit_auto_recovery[1]

		print("min distance ", self._min_distance)
		FirstAidKitBase.Add(self, self._unit:position(), self._min_distance)
	end
end

function FirstAidKitBase:_get_upgrade_levels(bits)
	local hot_regen = Bitwise:rshift(bits, FirstAidKitBase.hot_regen_shift)
	local auto_recovery = Bitwise:rshift(bits, FirstAidKitBase.auto_recovery_shift) % 2
	local upgrade_lvl = Bitwise:rshift(bits, FirstAidKitBase.upgrade_lvl_shift) % 2 ^ FirstAidKitBase.upgrade_lvl_shift

	return upgrade_lvl, auto_recovery, hot_regen
end

function FirstAidKitBase:take(unit)
	if self._empty then
		return
	end

	unit:character_damage():band_aid_health(self._hot_regen)

	if self._damage_reduction_upgrade then
		managers.player:activate_temporary_upgrade("temporary", "first_aid_damage_reduction")
	end

	if managers.network:session() then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", 2)
	end

	self:_set_empty()
end
