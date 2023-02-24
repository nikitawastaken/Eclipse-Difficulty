-- Make medics require line of sight to heal and optimize function
Hooks:OverrideFunction(EnemyManager, "get_nearby_medic", function (self, unit)
	if self:is_civilian(unit) then
		return
	end

	local medics = managers.groupai:state()._special_units.medic
	if not medics then
		return
	end

	local radius_sq = tweak_data.medic.radius ^ 2
	local unit_pos = unit:movement():m_head_pos()
	local unit_data = self._enemy_data.unit_data
	local vision_slot_mask = managers.slot:get_mask("AI_visibility")

	local function is_valid(medic)
		if not medic or medic.unit == unit then
			return false
		end

		local anim_data = medic.unit:anim_data()
		if anim_data.hurt or anim_data.act then
			return false
		end

		local medic_pos = medic.unit:movement():m_head_pos()
		if mvector3.distance_sq(medic_pos, unit_pos) > radius_sq then
			return false
		end

		return not World:raycast("ray", unit_pos, medic_pos, "slot_mask", vision_slot_mask, "report")
	end

	for u_key, _ in pairs(medics) do
		local medic = unit_data[u_key]
		if is_valid(medic) then
			return medic.unit
		end
	end
end)