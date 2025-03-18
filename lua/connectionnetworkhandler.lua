function ConnectionNetworkHandler:finish_trade()
	if self._verify_gamestate(self._gamestate_filter.waiting_for_respawn) then
		return
	end

	managers.player:player_unit():character_damage():restore_lives(1)

	managers.hud:show_hint( { text = managers.localization:text("hint_trade_down_restored") } )
end