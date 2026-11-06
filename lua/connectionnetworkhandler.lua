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

function ConnectionNetworkHandler:sync_trade_restore_resources(resource_trades_done, sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) or not alive(managers.player:player_unit()) then
		return
	end

	managers.trade:trade_restore_resources(resource_trades_done)
end

function ConnectionNetworkHandler:sync_damage_reduction_from_crewmate(sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame_playing) or not alive(managers.player:player_unit()) then
		return
	end

	managers.player:activate_temporary_upgrade("temporary", "damage_reduction_from_crewmate")
end

function ConnectionNetworkHandler:sync_register_strike(amount, reason, is_pager, sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	managers.groupai:state():register_strike(amount, reason, is_pager)
end

--Respond to environment sync request with environment info
function ConnectionNetworkHandler:eclipse_request_environment_info(sender)
	local peer = self._verify_sender(sender)
	if not peer or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	peer:send("eclipse_sync_environment", Eclipse.current_environment, Eclipse.color_grading)
end

--Use environment info to setup environment
function ConnectionNetworkHandler:eclipse_sync_environment(environment_name, color_grading, sender)
	if not self._verify_sender(sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	Eclipse.utils.client_load_environment(tweak_data.levels[Eclipse.utils.level_id()], environment_name, color_grading)
	Eclipse.current_environment = environment_name
	Eclipse.color_grading = color_grading
end
