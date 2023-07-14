if Network:is_client() then
	return
end

-- Tweak bag stealing conditions
function CarryData:clbk_pickup_SO_verification(unit)
	if not self._steal_SO_data or not self._steal_SO_data.SO_id then
		return
	end

	-- Less likely to steal bags during assault
	if not managers.groupai:state()._rescue_allowed and math.random() < 0.3 then
		return
	end

	if unit:movement():cool() then
		return
	end

	if not unit:base():char_tweak().steal_loot then
		return
	end

	local objective = unit:brain():objective()
	if not objective or objective.type == "free" or not objective.area then
		return true
	end

	if objective.grp_objective and objective.grp_objective.type == "reenforce_area" then
		return
	end

	local nav_seg = unit:movement():nav_tracker():nav_segment()
	if self._steal_SO_data.pickup_area.nav_segs[nav_seg] or objective.area == self._steal_SO_data.pickup_area then
		return true
	end
end

-- Fix zipline trying to copy non existing bag attention data
Hooks:OverrideFunction(CarryData, "set_zipline_unit", function(self, zipline_unit)
	self._zipline_unit = zipline_unit
	self:_set_expire_enabled(not self._zipline_unit)

	if managers.groupai:state():enemy_weapons_hot() then
		return
	end

	if self._zipline_unit and self._zipline_unit:zipline():ai_ignores_bag() then
		local attention_data = self._unit:attention() and self._unit:attention():attention_data()
		if attention_data then
			self._saved_attention_data = deep_clone(attention_data)
			for attention_id, _ in pairs(self._saved_attention_data) do
				self._unit:attention():remove_attention(attention_id)
			end
		end
	elseif not self._zipline_unit and self._saved_attention_data then
		for _, attention_data in pairs(self._saved_attention_data) do
			self._unit:attention():add_attention(attention_data)
		end
		self._saved_attention_data = nil
	end
end)
