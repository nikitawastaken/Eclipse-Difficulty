--! Potential fix to this being called multiple times
local env, grading
Hooks:PostHook(ClientNetworkSession, "notify_host_when_outfits_loaded", "eclipse_post_client_load", function()
	if Eclipse.current_environment and env ~= Eclipse.current_environment and grading ~= Eclipse.color_grading then
		Eclipse.utils.client_load_environment(tweak_data.levels[Eclipse.utils.level_id()], Eclipse.current_environment, Eclipse.color_grading)
	end
end)
