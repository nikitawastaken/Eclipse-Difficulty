function ConnectionNetworkHandler:sync_assault_ponr(sender)
	local peer = self._verify_sender(sender)
	if not peer then
		return
	elseif not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) then
		return
	end

	managers.hud._hud_assault_corner:set_ponr_state()
end
