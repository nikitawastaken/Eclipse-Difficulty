-- Helper functions
function HuskCopBrain:on_suppressed(is_suppressed)
	self._suppressed = is_suppressed
end

function HuskCopBrain:is_suppressed()
	return self._suppressed
end

function HuskCopBrain:set_focus_enemy_unit(focus_enemy_unit)
	self._focus_enemy_unit = focus_enemy_unit or nil
end

function HuskCopBrain:get_focus_enemy_unit()
	return self._focus_enemy_unit
end

-- Additional is_custody_trade argument
function HuskCopBrain:on_trade(position, rotation, is_custody_trade)
	self._unit:network():send_to_host("unit_traded", position, rotation, is_custody_trade)
end
