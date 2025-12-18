-- Helper functions
function HuskCopBrain:on_suppressed(is_suppressed)
	self._suppressed = is_suppressed
end

function HuskCopBrain:is_suppressed()
	return self._suppressed
end

-- Additional is_custody_trade argument
function HuskCopBrain:on_trade(position, rotation, is_custody_trade)
	self._unit:network():send_to_host("unit_traded", position, rotation, is_custody_trade)
end
