function ConnectionNetworkHandler:finish_trade()
	if not self._verify_gamestate(self._gamestate_filter.waiting_for_respawn) then
		return
	end

	managers.player:player_unit():character_damage():restore_lives(1)
end