--[[
-- Welcome message when you launch this mod 1st time
Hooks:PostHook(MenuMainState, "at_enter", "at_enter_eclipse_1st_time", function (self,old_state)
if Eclipse.settings.welcome_message then
	Eclipse.settings.welcome_message = false
	io.save_as_json(Eclipse.settings, Eclipse.save_path)
	local welcome_message = {
		focus_button = 1,
		texture = "guis/textures/mod_logo",
		title = "eclipse_1st_time_title",
		text = "eclipse_1st_time_desc"
	}

	local node1 = {
		text = managers.localization:text("eclipse_1st_time_confirm")
	}
	
	welcome_message.button_list = {
		node1
	}

	managers.menu:show_video_message_dialog(welcome_message)
end
end)
--]]