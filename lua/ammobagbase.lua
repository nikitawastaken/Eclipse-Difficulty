-- Firestorm timer
AmmoBagBase._BULLET_STORM = {
	30,
	30,
}

-- Bulletstorm 60s duration fix
-- Weapons can be set to take more ammo for a full refill, but they shouldn't get increased Bulletstorm durations
-- `taken` is used for Bulletstorm durations
function AmmoBagBase:_take_ammo(unit)
	local taken = 0
	local inventory = unit:inventory()

	if inventory then
		for _, weapon in pairs(inventory:available_selections()) do
			local took, ammo_bag_consumption_mul = weapon.unit:base():add_ammo_from_bag(self._ammo_amount)
			took = self:round_value(took)
			taken = taken + took / (ammo_bag_consumption_mul or 1)
			self._ammo_amount = self:round_value(self._ammo_amount - took)

			if self._ammo_amount <= 0 then
				return taken
			end
		end
	end

	return taken
end

Hooks:PreHook(AmmoBagBase, "_set_empty", "eclipse__set_empty", function(self)
	managers.network:session():send_to_peers_synched("sync_ammo_bag_ammo_taken", self._unit, self._max_ammo_amount + 1)
end)

Hooks:PostHook(AmmoBagBase, "_set_empty", "eclipse__set_empty", function(self)
	-- Unregister the deployable for voice lines and reinforce
	managers.groupai:state():unregister_deployable(self._unit:key())
end)

-- Thanks Hoppip for this one too

function AmmoBagBase.spawn(pos, rot, ammo_upgrade_lvl, peer_id, bullet_storm_level, auto_reload)
	local unit_name = "units/payday2/equipment/gen_equipment_ammobag/gen_equipment_ammobag"
	local unit = World:spawn_unit(Idstring(unit_name), pos, rot)

	managers.network:session():send_to_peers_synched("sync_ammo_bag_setup", unit, ammo_upgrade_lvl, auto_reload or false, peer_id or 0, bullet_storm_level or 0)
	unit:base():setup(ammo_upgrade_lvl, bullet_storm_level, auto_reload)

	return unit
end

function AmmoBagBase:sync_setup(ammo_upgrade_lvl, peer_id, bullet_storm_level, auto_reload)
	if self._validate_clbk_id then
		managers.enemy:remove_delayed_clbk(self._validate_clbk_id)

		self._validate_clbk_id = nil
	end

	managers.player:verify_equipment(peer_id, "ammo_bag")
	self:setup(ammo_upgrade_lvl, bullet_storm_level, auto_reload)
end

function AmmoBagBase:setup(ammo_upgrade_lvl, bullet_storm_level, auto_reload)
	self._bullet_storm_level = bullet_storm_level
	self._ammo_amount = tweak_data.upgrades.ammo_bag_base + managers.player:upgrade_value_by_level("ammo_bag", "ammo_increase", ammo_upgrade_lvl)
	self._auto_reload = auto_reload

	self:_set_visual_stage()

	if Network:is_server() and self._is_attachable then
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

	-- Register the deployable for voice lines and reinforce
	local nav_seg_id = managers.navigation:get_nav_seg_from_pos(self._unit:position(), true)
	local area = managers.groupai:state():get_area_from_nav_seg_id(nav_seg_id)

	managers.groupai:state():register_deployable(self._unit, area, self:get_name_id())
end

function AmmoBagBase:take_ammo(unit)
	if self._empty then
		return false, false
	end

	local taken = self:_take_ammo(unit)

	if taken > 0 then
		unit:sound():play("pickup_ammo")
		managers.network:session():send_to_peers_synched("sync_ammo_bag_ammo_taken", self._unit, taken)
	end

	if self._ammo_amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end

	local bullet_storm = false

	if self._bullet_storm_level and self._bullet_storm_level > 0 then
		bullet_storm = self._BULLET_STORM[self._bullet_storm_level] * taken

		print("[BULLETSTORM] bullet_storm", bullet_storm, " - take ", taken)
	end

	return taken > 0, bullet_storm, self._auto_reload
end
