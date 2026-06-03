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

function ConnectionNetworkHandler:join_request_reply(
	reply_id,
	my_peer_id,
	my_character,
	level_index,
	difficulty_index,
	one_down,
	state,
	server_character,
	user_id,
	mission,
	job_id_index,
	job_stage,
	alternative_job_stage,
	interupt_job_stage_level_index,
	xuid,
	env_string,
	sender
)
	if not self._verify_in_client_session() or not managers.network:session() or not managers.network:session().on_join_request_reply then
		return
	end

	managers.network:session():on_join_request_reply(
		reply_id,
		my_peer_id,
		my_character,
		level_index,
		difficulty_index,
		one_down,
		state,
		server_character,
		user_id,
		mission,
		job_id_index,
		job_stage,
		alternative_job_stage,
		interupt_job_stage_level_index,
		xuid,
		env_string,
		sender
	)
end
