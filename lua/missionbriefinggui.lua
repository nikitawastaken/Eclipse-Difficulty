function DescriptionItem:init(panel, text, i, saved_descriptions)
	DescriptionItem.super.init(self, panel, text, i)

	if not managers.job:has_active_job() then
		return
	end

	local stage_data = managers.job:current_stage_data()
	local level_data = managers.job:current_level_data()
	local name_id = stage_data.name_id or level_data.name_id
	local briefing_id = managers.job:current_briefing_id()

	if managers.skirmish:is_skirmish() and not managers.skirmish:is_weekly_skirmish() then
		briefing_id = "heist_skm_random_briefing"
	end

	local title_text = self._panel:text({
		name = "title_text",
		y = 10,
		x = 10,
		text = managers.localization:to_upper_text(name_id),
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = tweak_data.screen_colors.text
	})
	local x, y, w, h = title_text:text_rect()

	title_text:set_size(w, h)
	title_text:set_position(math.round(title_text:x()), math.round(title_text:y()))

	local pro_text = nil

	if managers.job:is_current_job_professional() then
		pro_text = self._panel:text({
			name = "pro_text",
			blend_mode = "add",
			text = managers.localization:to_upper_text("cn_menu_pro_job"),
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.pro_color
		})
		local x, y, w, h = pro_text:text_rect()

		pro_text:set_size(w, h)
		pro_text:set_position(title_text:right() + 10, title_text:y())
	end

	self._scroll_panel = self._panel:panel({
		x = 10,
		y = title_text:bottom()
	})

	self._scroll_panel:grow(-self._scroll_panel:x() - 10, -self._scroll_panel:y())

	local desc_string = briefing_id and managers.localization:text(briefing_id) or ""
	local is_level_ghostable = managers.job:is_level_ghostable(managers.job:current_level_id()) and managers.groupai and managers.groupai:state():whisper_mode()

	if is_level_ghostable and Network:is_server() then
		if managers.job:is_level_ghostable_required(managers.job:current_level_id()) then
			desc_string = desc_string .. "\n\n" .. managers.localization:text("menu_ghostable_stage_required")
		else
			desc_string = desc_string .. "\n\n" .. managers.localization:text("menu_ghostable_stage")
		end
	end

	local desc_text = self._scroll_panel:text({
		name = "description_text",
		wrap = true,
		word_wrap = true,
		text = desc_string,
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		color = tweak_data.screen_colors.text
	})

	if saved_descriptions then
		local text = ""

		for i, text_id in ipairs(saved_descriptions) do
			text = text .. managers.localization:text(text_id) .. "\n"
		end

		desc_text:set_text(text)
	end

	self:_chk_add_scrolling()

	if managers.skirmish:is_weekly_skirmish() then
		managers.network:add_event_listener({}, "on_set_dropin", function ()
			self:add_description_text("\n##" .. managers.localization:text("menu_weekly_skirmish_dropin_warning") .. "##")
		end)
	end
end