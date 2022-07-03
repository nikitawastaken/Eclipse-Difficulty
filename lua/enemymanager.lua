-- Make medics require line of sight to heal and optimize function
Hooks:OverrideFunction(EnemyManager, "get_nearby_medic", function (self, unit)
	if self:is_civilian(unit) then
		return
	end

	local gstate = managers.groupai:state()
	local medics = gstate._special_units.medic
	if not medics then
		return
	end

	local radius_sq = tweak_data.medic.radius ^ 2
	local unit_pos = unit:movement():m_head_pos()
	local unit_data = self._enemy_data.unit_data
	for u_key, _ in pairs(medics) do
		local medic = unit_data[u_key]
		if medic and unit ~= medic.unit and mvector3.distance_sq(medic.m_pos, unit_pos) <= radius_sq and not World:raycast("ray", unit_pos, medic.unit:movement():m_head_pos(), "slot_mask", managers.slot:get_mask("AI_visibility"), "report") then
			return medic.unit
		end
	end
end)
