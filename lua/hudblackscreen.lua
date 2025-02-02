function HUDBlackScreen:_set_job_data()
	if not managers.job:has_active_job() then
		return
	end

	local job_panel = self._blackscreen_panel:panel({
		y = 0,
		name = "job_panel",
		halign = "grow",
		visible = true,
		layer = 1,
		valign = "grow"
	})
	local risk_panel = job_panel:panel({})
	local last_risk_level = nil
	local blackscreen_risk_textures = tweak_data.gui.blackscreen_risk_textures

	for i = 1, managers.job:current_difficulty_stars() do
		local difficulty_name = tweak_data.difficulties[i + 2]
		local texture = blackscreen_risk_textures[difficulty_name] or "guis/textures/pd2/risklevel_blackscreen"
		last_risk_level = risk_panel:bitmap({
			texture = texture,
			color = (Eclipse.utils.is_pro_job() and tweak_data.screen_colors.one_down) or tweak_data.screen_colors.risk
		})

		last_risk_level:move((i - 1) * last_risk_level:w(), 0)
	end

	if last_risk_level then
		risk_panel:set_size(last_risk_level:right(), last_risk_level:bottom())
		risk_panel:set_center(job_panel:w() / 2, job_panel:h() / 2)
		risk_panel:set_position(math.round(risk_panel:x()), math.round(risk_panel:y()))
	else
		risk_panel:set_size(64, 64)
		risk_panel:set_center_x(job_panel:w() / 2)
		risk_panel:set_bottom(job_panel:h() / 2)
		risk_panel:set_position(math.round(risk_panel:x()), math.round(risk_panel:y()))
	end

	local risk_text = job_panel:text({
		vertical = "bottom",
		align = "center",
		text = managers.localization:to_upper_text(tweak_data.difficulty_name_id),
		font = tweak_data.menu.pd2_large_font,
		font_size = tweak_data.menu.pd2_small_large_size,
		color = (Eclipse.utils.is_pro_job() and tweak_data.screen_colors.one_down) or tweak_data.screen_colors.risk
	})

	risk_text:set_bottom(risk_panel:top())
	risk_text:set_center_x(risk_panel:center_x())
end