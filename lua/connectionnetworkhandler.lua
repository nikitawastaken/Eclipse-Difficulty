function ConnectionNetworkHandler:sync_assault_ponr(sender)
	local peer = self._verify_sender(sender)
	if not peer then
		return
	elseif not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) then
		return
	end

	if managers.hud._hud_assault_corner.set_ponr_state then
		managers.hud._hud_assault_corner:set_ponr_state()
	end
end

function ConnectionNetworkHandler:sync_trade_restore_resources(sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) or not alive(managers.player:player_unit()) then
		return
	end

	managers.trade:trade_restore_resources()
end

function ConnectionNetworkHandler:sync_damage_reduction_from_crewmate(sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) or not alive(managers.player:player_unit()) then
		return
	end

	managers.player:activate_temporary_upgrade("temporary", "damage_reduction_from_crewmate")
end

function ConnectionNetworkHandler:eclipse_sync_environment(environment_name, sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) or not alive(managers.player:player_unit()) then
		return
	end

	Eclipse:log_chat("Set environment to: " .. environment_name)
	Eclipse.current_environment = environment_name or "default"
end
