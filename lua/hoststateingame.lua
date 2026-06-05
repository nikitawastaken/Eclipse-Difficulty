Hooks:PostHook(HostStateInGame, "on_peer_finished_loading", "eclipse_post_on_peer_finished_loading", function(_, _, peer)
	peer:send("eclipse_sync_environment", Eclipse.current_environment, Eclipse.color_grading)
end)
