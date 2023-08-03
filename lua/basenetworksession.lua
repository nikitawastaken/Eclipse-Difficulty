Hooks:PostHook(BaseNetworkSession, "spawn_players", "eclipse_spawn_players", function()
	if managers.mission._instant_start_ponr then
		managers.groupai:set_state("ponr")
		managers.groupai:state():on_police_called("default")
		managers.groupai:state():set_difficulty(1)
	end
end)

Hooks:Add("NetworkReceivedData", "EclipseAssaultInfo", function(sender, id, data)
    if id == "sync_assault_ponr" then
        managers.hud._hud_assault_corner:set_ponr_state()
    end
end)
