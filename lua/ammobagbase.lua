-- bulletstorm overall lasts longer
AmmoBagBase._BULLET_STORM = {
	6,
	15,
}

-- Bulletstorm 60s duration fix
function AmmoBagBase:_take_ammo(unit)
	local taken = 0
	local inventory = unit:inventory()

	if inventory then
		for _, weapon in pairs(inventory:available_selections()) do
			local took = self:round_value(weapon.unit:base():add_ammo_from_bag(self._ammo_amount))
			taken = taken + took
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

-- Thanks Hoppip for this one too

-- Mark ammo bags for reinforce groups
Hooks:PostHook(AmmoBagBase, "setup", "eclipse_setup", function(self)
	self._deployed_nav_seg_id = managers.navigation:get_nav_seg_from_pos(self._unit:position(), true)
end)

Hooks:PostHook(AmmoBagBase, "update", "eclipse_update", function(self)
	if not managers.groupai:state():chk_deployable_nav_seg(self._deployed_nav_seg_id) and not self._empty then
		managers.groupai:state():add_deployable_reenforce(self:get_name_id(), self._unit, self._unit:position(), self._deployed_nav_seg_id)
	elseif self._empty then
		managers.groupai:state():remove_deployable_reenforce(self._unit, self._deployed_nav_seg_id)
	end
end)
