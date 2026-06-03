Hooks:PostHook(HostStateInGame, "on_handshake_confirmation", "eclipse_post_handshake_confirm", function(self, _, peer)
	peer:send("eclipse_sync_environment", Eclipse.current_environment)
end)
