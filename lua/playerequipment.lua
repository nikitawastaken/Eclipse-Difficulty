function PlayerEquipment:use_first_aid_kit()
	local ray = self:valid_shape_placement("first_aid_kit")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		PlayerStandard.say_line(self, "s12")
		managers.statistics:use_first_aid()

		local upgrade_lvl = managers.player:has_category_upgrade("first_aid_kit", "damage_reduction_upgrade") and 1 or 0
		local auto_recovery = managers.player:has_category_upgrade("first_aid_kit", "first_aid_kit_auto_recovery") and 1 or 0
		local hot_regen = managers.player:has_category_upgrade("first_aid_kit", "first_aid_kit_hot_regen") and 1 or 0
		local bits = Bitwise:lshift(auto_recovery, FirstAidKitBase.auto_recovery_shift)
			+ Bitwise:lshift(upgrade_lvl, FirstAidKitBase.upgrade_lvl_shift)
			+ Bitwise:lshift(hot_regen, FirstAidKitBase.hot_regen_shift)

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "FirstAidKitBase", pos, rot, bits)
		else
			local unit = FirstAidKitBase.spawn(pos, rot, bits, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

function PlayerEquipment:use_grenade_case()
	local ray = self:valid_shape_placement("grenade_crate")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw() - 180, 0, 0)

		managers.statistics:use_grenade_crate()

		local amount_upgrade_lvl = managers.player:upgrade_level("grenade_case", "amount_increase")

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "GrenadeCrateBase", pos, rot, amount_upgrade_lvl)
		else
			local unit = GrenadeCrateBase.spawn(pos, rot, amount_upgrade_lvl, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

function PlayerEquipment:use_grenade_crate()
	local ray = self:valid_shape_placement("grenade_crate")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		managers.statistics:use_grenade_crate()

		local amount_upgrade_lvl = managers.player:upgrade_level("grenade_crate", "amount_increase")

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "GrenadeCrateDeployableBase", pos, rot, amount_upgrade_lvl)
		else
			local unit = GrenadeCrateDeployableBase.spawn(pos, rot, amount_upgrade_lvl, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

local valid_shape_placement = PlayerEquipment.valid_shape_placement
function PlayerEquipment:valid_shape_placement(equipment_id, equipment_data, ...)
	local valid, ray = valid_shape_placement(self, equipment_id, equipment_data, ...)

	if valid and equipment_id == "grenade_case" then
		local rot = self._unit:movement():m_head_rot()
		rot = Rotation(rot:yaw() - 180, 0, 0)
		self._dummy_unit:set_rotation(rot)
	end

	return valid, ray
end
