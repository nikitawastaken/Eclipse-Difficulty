function ConnectionNetworkHandler:send_chat_message(channel_id, message, sender)
	local peer = self._verify_sender(sender)

	if not peer then
		return
	end

	log("send_chat_message peer", peer, peer:id())
	managers.chat:receive_message_by_peer(channel_id, peer, message)
end
