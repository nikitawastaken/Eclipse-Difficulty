Hooks:Add("NetworkReceivedData", "EclipseAssaultInfo", function(sender, id, data)
	if id == "sync_assault_ponr" then
		managers.hud._hud_assault_corner:set_ponr_state()
	end
end)
