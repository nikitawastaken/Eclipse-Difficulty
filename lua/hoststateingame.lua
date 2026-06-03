function HostStateInGame:on_join_auth_received(data, auth_ticket, sender)
	print("[HostStateInGame:on_join_auth_received] auth ticket received")

	local new_peer = data.session:chk_peer_already_in(sender)
	local my_user_id = data.local_peer:user_id() or ""

	if not new_peer then
		self:_send_request_denied(sender, HostNetworkSession.JOIN_REPLY.FAILED_CONNECT, my_user_id)

		return
	end

	if not new_peer:begin_ticket_session(auth_ticket) then
		self:_send_request_denied(sender, 8, my_user_id)
		data.session:remove_peer(new_peer, new_peer:id(), "auth_fail")

		return
	end

	local level_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
	local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	local job_id_index = 0
	local job_stage = 0
	local alternative_job_stage = 0
	local interupt_job_stage_level_index = 0

	if managers.job:has_active_job() then
		job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
		job_stage = managers.job:current_stage()
		alternative_job_stage = managers.job:alternative_stage() or 0
		local interupt_stage_level = managers.job:interupt_stage()
		interupt_job_stage_level_index = interupt_stage_level and tweak_data.levels:get_index_from_level_id(interupt_stage_level) or 0
	end

	local server_xuid = ""
	local new_peer_id = new_peer:id()
	local params = {
		HostNetworkSession.JOIN_REPLY.OK,
		new_peer_id,
		new_peer:character(),
		level_index,
		difficulty_index,
		Global.game_settings.one_down,
		self.STATE_INDEX,
		data.local_peer:character(),
		my_user_id,
		Global.game_settings.mission,
		job_id_index,
		job_stage,
		alternative_job_stage,
		interupt_job_stage_level_index,
		server_xuid,
		Eclipse.current_environment,
	}

	new_peer:send("join_request_reply", unpack(params))
	new_peer:send("set_loading_state", false, data.session:load_counter())
	managers.vote:sync_server_kick_option(new_peer)
	data.session:send_ok_to_load_level()
	self:on_handshake_confirmation(data, new_peer, 1)

	self._new_peers[new_peer_id] = true
end
