-- Logic to update how equipment appears on third-person models
function HuskPlayerMovement:check_visual_equipment()
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local deploy_data = managers.player:get_synced_deployable_equipment(peer_id)

	if deploy_data then
		self:set_visual_deployable_equipment(deploy_data.deployable, deploy_data.amount)
	end

	local carry_data = managers.player:get_synced_carry(peer_id)

	if #carry_data > 0 then
		self:set_visual_carry(carry_data[#carry_data].carry_id)
	end
end

function HuskPlayerMovement:set_visual_carry(carry_id)
	self._carry_id = carry_id

	if carry_id then
		if tweak_data.carry[carry_id].visual_unit_name then
			self:_create_carry_unit(tweak_data.carry[carry_id].visual_unit_name)

			return
		end

		local object_name = tweak_data.carry[carry_id].visual_object or "g_lootbag"
		self._current_visual_carry_object = self._unit:get_object(Idstring(object_name))

		self._current_visual_carry_object:set_visibility(true)
	elseif alive(self._current_visual_carry_object) then
		self._current_visual_carry_object:set_visibility(false)

		self._current_visual_carry_object = nil
	else
		self:_destroy_current_carry_unit()
	end
end
