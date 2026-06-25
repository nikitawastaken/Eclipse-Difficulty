-- Tweak bag stealing conditions
function CarryData:clbk_pickup_SO_verification(unit)
	if not self._steal_SO_data or not self._steal_SO_data.SO_id then
		return false
	end

	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().steal_loot then
		return false
	end

	local objective = unit:brain():objective()
	if objective and objective.grp_objective and objective.grp_objective.type == "reenforce_area" then
		return false
	end

	local logic_data = unit:brain()._logic_data
	if not logic_data or not logic_data.tactics or logic_data.tactics.rescue then
		return true
	end
end

-- Make enemies run with stolen bags instead of crouchwalking
Hooks:PostHook(CarryData, "_chk_register_steal_SO", "eclipse__chk_register_steal_SO", function(self)
	if self._steal_SO_data and not self._steal_SO_data.secure_pos then
		self:_unregister_steal_SO()
	end
	
	if self._steal_SO_data and self._steal_SO_data.pickup_objective and self._steal_SO_data.pickup_objective.followup_objective then
		self._steal_SO_data.pickup_objective.followup_objective.pose = "stand"
	end
end)

if not Network:is_server() then
	return
end

CarryData.ub_loot = {}

Hooks:PostHook(CarryData, "set_carry_id", "set_carry_id_ub", function (self, carry_id, is_init)
	if not is_init then
		CarryData.ub_loot[self._unit:key()] = self._unit
	end
end)

Hooks:PreHook(CarryData, "destroy", "destroy_ub", function (self)
	CarryData.ub_loot[self._unit:key()] = nil
end)

Hooks:PostHook(CarryData, "link_to", "link_to_ub", function (self)
	if self._linked_to then
		CarryData.ub_loot[self._unit:key()] = nil
		self._ub_throw_params = nil
	end
end)

Hooks:PostHook(CarryData, "unlink", "unlink_ub", function (self)
	CarryData.ub_loot[self._unit:key()] = self._unit
end)

Hooks:PostHook(CarryData, "set_zipline_unit", "set_zipline_unit_ub", function (self, zipline_unit)
	CarryData.ub_loot[self._unit:key()] = not zipline_unit and self._unit or nil
end)

-- Should not be possible, yet somehow it was for some people
Hooks:PostHook(CarryData, "_chk_register_steal_SO", "_chk_register_steal_SO_ub", function (self)
	if self._steal_SO_data and not self._steal_SO_data.secure_pos then
		self:_unregister_steal_SO()
	end
end)