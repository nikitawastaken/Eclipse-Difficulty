local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))

	return x, y, w, h
end

function HUDStageEndScreen:init(hud, workspace)
	self._backdrop = MenuBackdropGUI:new(workspace)

	if not _G.IS_VR then
		self._backdrop:create_black_borders()
	end

	self._hud = hud
	self._workspace = workspace
	self._singleplayer = Global.game_settings.single_player
	local bg_font = tweak_data.menu.pd2_massive_font
	local title_font = tweak_data.menu.pd2_large_font
	local content_font = tweak_data.menu.pd2_medium_font
	local small_font = tweak_data.menu.pd2_small_font
	local bg_font_size = tweak_data.menu.pd2_massive_font_size
	local title_font_size = tweak_data.menu.pd2_large_font_size
	local content_font_size = tweak_data.menu.pd2_medium_font_size
	local small_font_size = tweak_data.menu.pd2_small_font_size
	local massive_font = bg_font
	local large_font = title_font
	local medium_font = content_font
	local massive_font_size = bg_font_size
	local large_font_size = title_font_size
	local medium_font_size = content_font_size
	self._background_layer_safe = self._backdrop:get_new_background_layer()
	self._background_layer_full = self._backdrop:get_new_background_layer()
	self._foreground_layer_safe = self._backdrop:get_new_foreground_layer()
	self._foreground_layer_full = self._backdrop:get_new_foreground_layer()

	self._backdrop:set_panel_to_saferect(self._background_layer_safe)
	self._backdrop:set_panel_to_saferect(self._foreground_layer_safe)

	if managers.job:has_active_job() then
		local current_contact_data = managers.job:current_contact_data()
		local contact_gui = current_contact_data and self._background_layer_full:gui(current_contact_data.assets_gui, {
			empty = true,
		})
		local contact_pattern = contact_gui and contact_gui:has_script() and contact_gui:script().pattern

		if contact_pattern then
			self._backdrop:set_pattern(contact_pattern)
		end
	end

	local padding_y = 0
	self._paygrade_panel = self._background_layer_safe:panel({
		w = 210,
		h = 70,
		y = padding_y,
	})
	local pg_text = self._foreground_layer_safe:text({
		name = "pg_text",
		vertical = "center",
		h = 32,
		align = "right",
		text = utf8.to_upper(managers.localization:text("menu_risk")),
		y = padding_y,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text,
	})
	local _, _, w, h = pg_text:text_rect()

	pg_text:set_size(w, h)

	local job_stars = managers.job:has_active_job() and managers.job:current_job_stars() or 1
	local job_and_difficulty_stars = managers.job:has_active_job() and managers.job:current_job_and_difficulty_stars() or 1
	local difficulty_stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
	local risk_color = ((Eclipse.utils.is_pro_job() and tweak_data.screen_colors.one_down) or tweak_data.screen_colors.risk)
	local risks = {
		"risk_swat",
		"risk_easy_wish",
		"risk_murder_squad",
		"risk_sm_wish",
	}

	local panel_w = 0
	local panel_h = 0
	local x = 0
	local y = 0

	for i, name in ipairs(risks) do
		local texture, rect = tweak_data.hud_icons:get_icon_data(name)
		local active = i <= difficulty_stars
		local color = active and risk_color or tweak_data.screen_colors.text
		local alpha = active and 1 or 0.25
		local risk = self._paygrade_panel:bitmap({
			y = 0,
			x = 0,
			name = name,
			texture = texture,
			texture_rect = rect,
			alpha = alpha,
			color = color,
		})

		risk:set_position(x, y)

		x = x + risk:w() + 0
		panel_w = math.max(panel_w, risk:right())
		panel_h = math.max(panel_h, risk:h())
	end

	pg_text:set_color(risk_color)
	self._paygrade_panel:set_h(panel_h)
	self._paygrade_panel:set_w(panel_w)
	self._paygrade_panel:set_right(self._background_layer_safe:w())
	pg_text:set_right(self._paygrade_panel:left())
	pg_text:set_center_y(self._paygrade_panel:center_y())
	pg_text:set_y(math.round(pg_text:y()))

	if managers.skirmish:is_skirmish() then
		self._paygrade_panel:set_visible(false)
		pg_text:set_visible(false)

		local min, max = managers.skirmish:wave_range()
		local wave_range_text = self._foreground_layer_safe:text({
			name = "wave_range",
			vertical = "center",
			h = 32,
			align = "right",
			text = managers.localization:to_upper_text("menu_skirmish_wave_range", {
				min = min,
				max = max,
			}),
			y = padding_y,
			font_size = content_font_size,
			font = content_font,
			color = tweak_data.screen_colors.skirmish_color,
		})

		managers.hud:make_fine_text(wave_range_text)
		wave_range_text:set_right(self._background_layer_safe:w())
	end

	self._stage_name = managers.job:current_level_id() and managers.localization:to_upper_text(tweak_data.levels[managers.job:current_level_id()].name_id) or ""

	if managers.skirmish:is_skirmish() then
		if managers.skirmish:is_weekly_skirmish() then
			self._stage_name = managers.localization:to_upper_text("menu_weekly_skirmish")
		else
			self._stage_name = managers.localization:to_upper_text("menu_skirmish")
		end
	end

	self._foreground_layer_safe:text({
		name = "stage_text",
		vertical = "center",
		align = "left",
		text = self._stage_name,
		h = title_font_size,
		font_size = title_font_size,
		font = title_font,
		color = tweak_data.screen_colors.text,
	})

	local bg_text = self._background_layer_full:text({
		name = "stage_text",
		vertical = "top",
		alpha = 0.4,
		align = "left",
		text = self._stage_name,
		h = bg_font_size,
		font_size = bg_font_size,
		font = bg_font,
		color = tweak_data.screen_colors.button_stage_3,
	})

	bg_text:set_world_center_y(self._foreground_layer_safe:child("stage_text"):world_center_y())
	bg_text:set_world_x(self._foreground_layer_safe:child("stage_text"):world_x())
	bg_text:move(-13, 9)
	self._backdrop:animate_bg_text(bg_text)

	self._coins_backpanel = self._background_layer_safe:panel({
		name = "coins_backpanel",
		y = 70,
		w = self._background_layer_safe:w() / 2 - 10,
		h = self._background_layer_safe:h() / 2,
	})
	self._coins_forepanel = self._foreground_layer_safe:panel({
		name = "coins_forepanel",
		y = 70,
		w = self._foreground_layer_safe:w() / 2 - 10,
		h = self._foreground_layer_safe:h() / 2,
	})
	local level_progress_text = self._coins_forepanel:text({
		vertical = "top",
		name = "coin_progress_text",
		align = "left",
		y = 10,
		x = 10,
		text = managers.localization:to_upper_text("menu_es_coins_progress"),
		h = content_font_size + 2,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text,
	})
	local _, _, lw, lh = level_progress_text:text_rect()

	level_progress_text:set_size(lw, lh)

	local coins_bg_circle = self._coins_backpanel:bitmap({
		texture = "guis/textures/pd2/endscreen/exp_ring",
		name = "bg_progress_circle",
		alpha = 0.6,
		blend_mode = "normal",
		h = self._coins_backpanel:h() - content_font_size,
		w = self._coins_backpanel:h() - content_font_size,
		y = content_font_size,
		color = Color.black,
	})
	self._coins_circle = self._coins_backpanel:bitmap({
		texture = "guis/textures/pd2/endscreen/exp_ring",
		name = "progress_circle",
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1,
		h = self._coins_backpanel:h() - content_font_size,
		w = self._coins_backpanel:h() - content_font_size,
		y = content_font_size,
		color = Color(0, 1, 1),
	})
	self._coins_text = self._coins_forepanel:text({
		name = "coins_text",
		vertical = "center",
		align = "center",
		text = "",
		font_size = bg_font_size,
		font = bg_font,
		h = self._coins_backpanel:h() - content_font_size,
		w = self._coins_backpanel:h() - content_font_size,
		y = content_font_size,
		color = tweak_data.screen_colors.text,
	})
	self._coins_box = BoxGuiObject:new(self._coins_backpanel, {
		sides = {
			1,
			1,
			1,
			1,
		},
	})
	self._lp_backpanel = self._background_layer_safe:panel({
		name = "lp_backpanel",
		y = 70,
		w = self._background_layer_safe:w() / 2 - 10,
		h = self._background_layer_safe:h() / 2,
	})
	self._lp_forepanel = self._foreground_layer_safe:panel({
		name = "lp_forepanel",
		y = 70,
		w = self._foreground_layer_safe:w() / 2 - 10,
		h = self._foreground_layer_safe:h() / 2,
	})
	local level_progress_text = self._lp_forepanel:text({
		vertical = "top",
		name = "level_progress_text",
		align = "left",
		y = 10,
		x = 10,
		text = managers.localization:to_upper_text("menu_es_level_progress"),
		h = content_font_size + 2,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text,
	})
	local _, _, lw, lh = level_progress_text:text_rect()

	level_progress_text:set_size(lw, lh)

	local lp_bg_circle = self._lp_backpanel:bitmap({
		texture = "guis/textures/pd2/endscreen/exp_ring",
		name = "bg_progress_circle",
		alpha = 0.6,
		blend_mode = "normal",
		h = self._lp_backpanel:h() - content_font_size,
		w = self._lp_backpanel:h() - content_font_size,
		y = content_font_size,
		color = Color.black,
	})
	self._prestige_lp_circle = self._lp_backpanel:bitmap({
		texture = "guis/textures/pd2/exp_ring_purple",
		name = "bg_infamy_progress_circle",
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = -1,
		x = lp_bg_circle:x(),
		y = lp_bg_circle:y(),
		h = lp_bg_circle:h(),
		w = lp_bg_circle:w(),
		color = Color(0, 1, 1),
	})
	self._lp_circle = self._lp_backpanel:bitmap({
		texture = "guis/textures/pd2/endscreen/exp_ring",
		name = "progress_circle",
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1,
		h = self._lp_backpanel:h() - content_font_size,
		w = self._lp_backpanel:h() - content_font_size,
		y = content_font_size,
		color = Color(0, 1, 1),
	})
	self._lp_text = self._lp_forepanel:text({
		name = "level_text",
		vertical = "center",
		align = "center",
		text = "",
		font_size = bg_font_size,
		font = bg_font,
		h = self._lp_backpanel:h() - content_font_size,
		w = self._lp_backpanel:h() - content_font_size,
		y = content_font_size,
		color = tweak_data.screen_colors.text,
	})
	self._lp_curr_xp = self._lp_forepanel:text({
		vertical = "top",
		name = "current_xp",
		align = "left",
		text = managers.localization:to_upper_text("menu_es_current_xp"),
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_xp_gained = self._lp_forepanel:text({
		vertical = "top",
		name = "xp_gained",
		align = "left",
		text = managers.localization:to_upper_text("menu_es_xp_gained"),
		h = content_font_size,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_next_level = self._lp_forepanel:text({
		vertical = "top",
		name = "next_level",
		align = "left",
		text = managers.localization:to_upper_text("menu_es_next_level"),
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_skill_points = self._lp_forepanel:text({
		vertical = "top",
		name = "skill_points",
		align = "left",
		text = managers.localization:to_upper_text("menu_es_skill_points_gained"),
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_xp_curr = self._lp_forepanel:text({
		text = "",
		vertical = "top",
		name = "c_xp",
		align = "left",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_xp_gain = self._lp_forepanel:text({
		text = "",
		vertical = "top",
		name = "xp_g",
		align = "left",
		h = content_font_size,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_xp_nl = self._lp_forepanel:text({
		text = "",
		vertical = "top",
		name = "xp_nl",
		align = "left",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})
	self._lp_sp_gain = self._lp_forepanel:text({
		text = "0",
		vertical = "center",
		name = "sp_g",
		align = "left",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})
	local _, _, cw, ch = self._lp_curr_xp:text_rect()
	local _, _, gw, gh = self._lp_xp_gained:text_rect()
	local _, _, nw, nh = self._lp_next_level:text_rect()
	local _, _, sw, sh = self._lp_skill_points:text_rect()
	ch = ch - 2
	nh = nh - 2
	sh = sh - 2
	local w = math.ceil(math.max(cw, gw, nw, sw)) + 20
	local squeeze_more_pixels = false

	if w > 170 then
		squeeze_more_pixels = true
	end

	self._num_skill_points_gained = 0
	self._lp_sp_info = self._lp_forepanel:text({
		vertical = "top",
		name = "sp_info",
		wrap = true,
		align = "left",
		word_wrap = true,
		text = managers.localization:text("menu_es_skill_points_info", {
			SKILL_MENU = managers.localization:to_upper_text("menu_skilltree"),
		}),
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
	})

	self._lp_sp_info:grow(-self._lp_circle:right() - 10, 0)

	local _, _, iw, ih = self._lp_sp_info:text_rect()

	self._lp_sp_info:set_h(ih)
	self._lp_sp_info:set_leftbottom(self._lp_circle:right() + 0, self._lp_forepanel:h() - 10)

	local w = self._lp_forepanel:w() - self._lp_sp_info:x() - 90
	local number_text_x = self._lp_sp_info:left() + w

	self._lp_skill_points:set_size(sw, sh)
	self._lp_skill_points:set_left(self._lp_sp_info:left())
	self._lp_skill_points:set_bottom(self._lp_sp_info:top())
	self._lp_sp_gain:set_left(number_text_x)
	self._lp_sp_gain:set_top(self._lp_skill_points:top())
	self._lp_sp_gain:set_size(self._lp_forepanel:w() - self._lp_sp_gain:left() - 10, sh)
	self._lp_next_level:set_size(nw, nh)
	self._lp_next_level:set_left(self._lp_sp_info:left())
	self._lp_next_level:set_bottom(self._lp_skill_points:top())
	self._lp_xp_nl:set_left(number_text_x)
	self._lp_xp_nl:set_top(self._lp_next_level:top())
	self._lp_xp_nl:set_size(self._lp_forepanel:w() - self._lp_xp_nl:left() - 10, nh)
	self._lp_curr_xp:set_size(cw, ch)
	self._lp_curr_xp:set_left(self._lp_sp_info:left())
	self._lp_curr_xp:set_bottom(self._lp_next_level:top())
	self._lp_xp_curr:set_left(number_text_x)
	self._lp_xp_curr:set_top(self._lp_curr_xp:top())
	self._lp_xp_curr:set_size(self._lp_forepanel:w() - self._lp_xp_curr:left() - 10, ch)
	self._lp_xp_gained:set_size(gw, gh)
	self._lp_xp_gained:set_left(self._lp_curr_xp:left())
	self._lp_xp_gained:set_bottom(self._lp_curr_xp:top())
	self._lp_xp_gain:set_left(number_text_x)
	self._lp_xp_gain:set_top(self._lp_xp_gained:top())
	self._lp_xp_gain:set_size(self._lp_forepanel:w() - self._lp_xp_gain:left() - 10, gh)
	self._lp_xp_gained:set_bottom(math.round(self._lp_forepanel:h() / 2))
	self._lp_curr_xp:set_top(self._lp_xp_gained:bottom())
	self._lp_next_level:set_top(self._lp_curr_xp:bottom())
	self._lp_skill_points:set_top(self._lp_next_level:bottom())
	self._lp_sp_info:set_top(self._lp_skill_points:bottom())
	self._lp_xp_gain:set_top(self._lp_xp_gained:top())
	self._lp_xp_curr:set_top(self._lp_curr_xp:top())
	self._lp_xp_nl:set_top(self._lp_next_level:top())
	self._lp_sp_gain:set_top(self._lp_skill_points:top())

	if squeeze_more_pixels then
		lp_bg_circle:move(-20, 0)
		self._lp_circle:move(-20, 0)
		self._prestige_lp_circle:move(-20, 0)
		self._lp_text:move(-20, 0)
		self._lp_curr_xp:move(-30, 0)
		self._lp_xp_gained:move(-30, 0)
		self._lp_next_level:move(-30, 0)
		self._lp_skill_points:move(-30, 0)
		self._lp_sp_info:move(-30, 0)
	end

	self._box = BoxGuiObject:new(self._lp_backpanel, {
		sides = {
			1,
			1,
			1,
			1,
		},
	})

	WalletGuiObject.set_wallet(self._foreground_layer_safe)
	WalletGuiObject.hide_wallet()

	self._package_forepanel = self._foreground_layer_safe:panel({
		alpha = 1,
		name = "package_forepanel",
		y = 70,
		w = self._foreground_layer_safe:w() / 2 - 10,
		h = self._foreground_layer_safe:h() / 2 - 70 - 10,
	})

	self._package_forepanel:set_right(self._foreground_layer_safe:w())
	self._package_forepanel:text({
		text = "",
		name = "title_text",
		y = 10,
		x = 10,
		font = content_font,
		font_size = content_font_size,
	})

	local package_box_panel = self._foreground_layer_safe:panel()

	package_box_panel:set_shape(self._package_forepanel:shape())
	package_box_panel:set_layer(self._package_forepanel:layer())

	self._package_box = BoxGuiObject:new(package_box_panel, {
		sides = {
			1,
			1,
			1,
			1,
		},
	})
	self._package_items = {}

	self:clear_stage()

	if self._data then
		self:start_experience_gain()
	end

	for i, child in ipairs(self._lp_forepanel:children()) do
		if child.text then
			local text = child:text()

			child:set_text(string.gsub(text, ":", ""))
		end
	end

	local skip_panel = self._foreground_layer_safe:panel({
		name = "skip_forepanel",
		y = 70,
		w = self._foreground_layer_safe:w() / 2 - 10,
		h = self._foreground_layer_safe:h() / 2,
	})
	local macros = {
		BTN_SPEED = managers.localization:btn_macro("menu_challenge_claim", true),
	}

	if not managers.menu:is_pc_controller() then
		macros.BTN_SPEED = managers.localization:get_default_macro("BTN_SWITCH_WEAPON")
	end

	self._skip_text = skip_panel:text({
		name = "skip_text",
		visible = false,
		alpha = 0.5,
		font = small_font,
		font_size = small_font_size,
		text = managers.localization:to_upper_text("menu_stageendscreen_speed_up", macros),
	})

	make_fine_text(self._skip_text)
	self._skip_text:set_right(skip_panel:w() - 10)
	self._skip_text:set_bottom(skip_panel:h() - 10)
end
