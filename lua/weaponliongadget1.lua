-- Adapted from Krimzin's Simple Bipods mod
function WeaponLionGadget1:_shoot_bipod_rays()
	local camera = managers.player:player_unit():camera()
	local point_1 = camera:position()
	local point_2 = mvector3.copy(point_1)
	mvector3.add_scaled(point_2, camera:forward(), 70)
	local point_3 = mvector3.copy(point_2)
	mvector3.add_scaled(point_3, -camera:rotation():z(), 100)
	local mask = managers.slot:get_mask("world_geometry")
	local obstacle = self._unit:raycast("ray", point_1, point_2, "slot_mask", mask)
	local surface, success
	if obstacle then
		surface = nil
		success = false
	else
		surface = self._unit:raycast("ray", point_2, point_3, "slot_mask", mask)
		success = surface and surface.ray:angle(surface.normal) > 135
	end
	return point_1, point_2, point_3, obstacle, surface, success
end

function WeaponLionGadget1:_is_deployable()
	if self._is_npc or self:_is_in_blocked_deployable_state() then
		return false
	end

	local _, point_2, point_3, _, _, success = self:_shoot_bipod_rays()
	if success then
		self._from = point_2
		self._to = point_3
		return true
	else
		return false
	end
end

function WeaponLionGadget1:is_usable()
	return self._unit:raycast(self._from, self._to) and true or false
end

Hooks:PostHook(WeaponLionGadget1, "check_state", "eclipse_check_state", function(self)
	self._unit:set_extension_update_enabled(Idstring("base"), true)
end)
