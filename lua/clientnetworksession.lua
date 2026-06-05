---Notably this will run client_load_environment multiple times!
---I have yet to find a way around this, but it's low impact
Hooks:PostHook(ClientNetworkSession, "notify_host_when_outfits_loaded", "eclipse_post_client_load", function()
	Eclipse.utils.client_load_environment(tweak_data.levels[Eclipse.utils.level_id()], Eclipse.current_environment, Eclipse.color_grading)
end)
