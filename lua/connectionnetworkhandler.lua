function ConnectionNetworkHandler:finish_trade(is_recon_over, resource_trade)
	if self._verify_gamestate(self._gamestate_filter.waiting_for_respawn) and not resource_trade then
		game_state_machine:current_state():finish_trade()
	else
		-- Do not do a resource trade if someone is in civilian mode or is in custody
		local ingame_has_inv = table.filter(self._gamestate_filter.any_ingame_playing, function(k, _)
			if table.contains({ "ingame_waiting_for_respawn", "ingame_waiting_for_spawn_allowed", "ingame_civilian" }, k) then
				return false
			end
			return true
		end)
		if self._verify_gamestate(ingame_has_inv) and resource_trade then
			game_state_machine:current_state():finish_resource_trade(is_recon_over)
		end
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
