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
	Eclipse.log("Sync environment rq sent with env name: " .. tostring(environment_name))
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) then
		Eclipse.log("Early return from env sync")
		return
	end

	Eclipse.log(environment_name)
	Eclipse.current_environment = environment_name or "default"
	Eclipse.utils.load_environment(tweak_data.levels[Eclipse.utils.level_id()], Eclipse.current_environment)
end
