function ConnectionNetworkHandler:finish_trade()
	if self._verify_gamestate(self._gamestate_filter.waiting_for_respawn) then
		game_state_machine:current_state():finish_trade()
	end
end

function ConnectionNetworkHandler:sync_assault_ponr(sender)
	local peer = self._verify_sender(sender)
	if not peer then
		return
	elseif not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) then
		return
	end

	managers.hud._hud_assault_corner:set_ponr_state()
end
