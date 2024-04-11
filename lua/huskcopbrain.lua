-- Fix untied cops getting the wrong slots
local sync_net_event_original = HuskCopBrain.sync_net_event
function HuskCopBrain:sync_net_event(event_id, ...)
	if not self._dead and event_id == self._NET_EVENTS.surrender_cop_untied then
		self._is_hostage = false
		self._unit:base():set_slot(self._unit, self._converted and 16 or 12)
	else
		return sync_net_event_original(self, event_id, ...)
	end
end