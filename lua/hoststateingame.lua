Hooks:PostHook(HostStateInGame, "on_handshake_confirmation", "eclipse_post_handshake_confirm", function(self, _, peer)
	Eclipse:log_chat("sending env sync request with env: " .. Eclipse.current_environment)
	managers.network:session():send_to_peer(peer, "eclipse_sync_environment", Eclipse.current_environment)
end)
