-- No outlines mutator setting (hide teammate HUD panels)
Hooks:PostHook(HUDTeammate, "add_panel", "add_panel_mutator_no_outlines", function (self)
	if managers.mutators:modify_value("HUDTeammate:NoOutlines", false) then
		local teammate_panel = self._panel
		local main_player = self._main_player
		if not main_player then
			teammate_panel:set_visible(false)
		end
	end
end)