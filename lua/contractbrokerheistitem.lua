local padding = 10

local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

function ContractBrokerHeistItem:init(parent_panel, job_data, idx)
	self._parent = parent_panel
	self._job_data = job_data
	local job_tweak = tweak_data.narrative:job_data(job_data.job_id)
	local contact = job_tweak.contact
	local contact_tweak = tweak_data.narrative.contacts[contact]
	local narrative = tweak_data.narrative:job_data(job_data.job_id)
	self._panel = parent_panel:panel({
		halign = "grow",
		layer = 10,
		h = 90,
		x = 0,
		valign = "top",
		y = 90 * (idx - 1)
	})
	self._background = self._panel:rect({
		blend_mode = "add",
		alpha = 0.4,
		halign = "grow",
		layer = -1,
		valign = "grow",
		y = padding,
		h = self._panel:h() - padding,
		color = job_data.enabled and tweak_data.screen_colors.button_stage_3 or tweak_data.screen_colors.important_1
	})

	self._background:set_visible(false)

	local img_size = self._panel:h() - padding
	self._image_panel = self._panel:panel({
		halign = "left",
		layer = 1,
		x = 0,
		valign = "top",
		y = padding,
		w = img_size * 1.7777777777777777,
		h = img_size
	})
	local has_image = false

	if job_tweak.contract_visuals and job_tweak.contract_visuals.preview_image then
		local data = job_tweak.contract_visuals.preview_image
		local path, rect = nil

		if data.id then
			path = "guis/dlcs/" .. (data.folder or "bro") .. "/textures/pd2/crimenet/" .. data.id
			rect = data.rect
		elseif data.icon then
			path, rect = tweak_data.hud_icons:get_icon_data(data.icon)
		end

		if path and DB:has(Idstring("texture"), path) then
			self._image_panel:bitmap({
				valign = "scale",
				layer = 2,
				blend_mode = "add",
				halign = "scale",
				texture = path,
				texture_rect = rect,
				w = self._image_panel:w(),
				h = self._image_panel:h(),
				color = narrative.professional and Color(255, 255, 100, 70) / 255 or Color.white
			})

			self._image = self._image_panel:rect({
				alpha = 1,
				layer = 1,
				color = Color.black
			})
			has_image = true
		end
	end

	if not has_image then
		local color = Color.red
		local error_message = "Missing Preview Image"

		self._image_panel:rect({
			alpha = 0.4,
			layer = 1,
			color = color
		})
		self._image_panel:text({
			vertical = "center",
			wrap = true,
			align = "center",
			word_wrap = true,
			layer = 2,
			text = error_message,
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size
		})
		BoxGuiObject:new(self._image_panel:panel({
			layer = 100
		}), {
			sides = {
				1,
				1,
				1,
				1
			}
		})
	end

	local job_name = self._panel:text({
		layer = 1,
		vertical = "top",
		align = "left",
		halign = "left",
		valign = "top",
		text = managers.localization:to_upper_text(job_tweak.name_id),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size,
		color = job_data.enabled and tweak_data.screen_colors.text or tweak_data.screen_colors.important_1
	})

	make_fine_text(job_name)
	job_name:set_left(self._image_panel:right() + padding * 2)
	job_name:set_top(self._panel:h() * 0.4 + padding * 0.5)
	
	local cy = job_name:bottom() + 8
	local sx = self._image_panel:right() + padding * 2
	for i = 1, 10 do
		local x = sx + (i - 1) * 18
		local star_data = { 
			texture = "guis/textures/pd2/mission_briefing/difficulty_icons", 
			texture_rect = {0, 33, 32, 32}, 
			w = 16, 
			h = 16, 
			color = tweak_data.screen_colors.text, 
			alpha = 1 
		}
		local star = self._panel:bitmap( star_data )
		star:set_x(x)
		star:set_center_y(math.round(cy))
		star:set_color(managers.crimenet:stars_color(i, math.ceil(narrative.jc/10), narrative.professional and 1 or 0))
	end
	
	local contact_name = self._panel:text({
		alpha = 0.8,
		vertical = "top",
		layer = 1,
		align = "left",
		halign = "left",
		valign = "top",
		text = managers.localization:to_upper_text(contact_tweak.name_id),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size * 0.9,
		color = tweak_data.screen_colors.text
	})

	make_fine_text(contact_name)
	contact_name:set_left(job_name:left())
	contact_name:set_bottom(job_name:top())

	local dlc_name, dlc_color = self:get_dlc_name_and_color(job_tweak)
	local dlc_name = self._panel:text({
		alpha = 1,
		vertical = "top",
		layer = 1,
		align = "left",
		halign = "left",
		valign = "top",
		text = dlc_name,
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size * 0.9,
		color = dlc_color
	})

	make_fine_text(dlc_name)
	dlc_name:set_left(contact_name:right() + 5)
	dlc_name:set_bottom(job_name:top())
	
	local pro_name = self._panel:text({
		alpha = 1,
		vertical = "top",
		layer = 1,
		align = "left",
		halign = "left",
		valign = "top",
		visible = false,
		text = managers.localization:to_upper_text("cn_menu_pro_job"),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size * 0.9,
		color = tweak_data.screen_colors.pro_color
	})

	make_fine_text(pro_name)
	if job_tweak.dlc then
		pro_name:set_left(dlc_name:right() + 5)
	else
		pro_name:set_left(contact_name:right() + 5)
	end
	pro_name:set_bottom(job_name:top())
	pro_name:set_visible(narrative.professional)
	
	if job_data.is_new then
		local new_name = self._panel:text({
			alpha = 1,
			vertical = "top",
			layer = 1,
			align = "left",
			halign = "left",
			valign = "top",
			text = managers.localization:to_upper_text("menu_new"),
			font = tweak_data.menu.pd2_medium_font,
			font_size = tweak_data.menu.pd2_medium_font_size * 0.9,
			color = Color(255, 105, 254, 59) / 255
		})

		make_fine_text(new_name)
		new_name:set_left((dlc_name:text() ~= "" and dlc_name or contact_name):right() + 5)
		new_name:set_bottom(job_name:top())
	end

	local last_played = self._panel:text({
		alpha = 0.7,
		vertical = "top",
		layer = 1,
		align = "right",
		halign = "right",
		valign = "top",
		text = self:get_last_played_text(),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size * 0.8,
		color = tweak_data.screen_colors.text
	})

	make_fine_text(last_played)
	last_played:set_right(self._panel:right() - padding)
	last_played:set_bottom(job_name:top())

	local icons_panel = self._panel:panel({
		valign = "top",
		halign = "right",
		h = job_name:h(),
		w = self._panel:w() * 0.3
	})

	icons_panel:set_right(self._panel:right() - padding)
	icons_panel:set_top(job_name:top())

	local icon_size = icons_panel:h()
	local last_icon = nil
	self._favourite = icons_panel:bitmap({
		texture = "guis/dlcs/bro/textures/pd2/favourite",
		halign = "right",
		alpha = 0.8,
		valign = "top",
		color = Color.white,
		w = icon_size,
		h = icon_size
	})

	self._favourite:set_right(icons_panel:w())

	last_icon = self._favourite
	local day_text = icons_panel:text({
		layer = 1,
		vertical = "bottom",
		align = "right",
		halign = "right",
		valign = "top",
		text = self:get_heist_day_text(),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size * 0.9,
		color = tweak_data.screen_colors.text
	})

	make_fine_text(day_text)
	day_text:set_right(last_icon:left() - 5)
	day_text:set_bottom(icons_panel:h())

	last_icon = day_text
	local length_icon = icons_panel:text({
		layer = 1,
		vertical = "bottom",
		align = "right",
		halign = "right",
		valign = "top",
		text = self:get_heist_day_icon(),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size * 0.8,
		color = tweak_data.screen_colors.text
	})

	make_fine_text(length_icon)
	length_icon:set_right(last_icon:left() - padding)
	length_icon:set_top(2)

	last_icon = length_icon

	if self:is_stealthable() then
		local stealth = icons_panel:text({
			layer = 1,
			vertical = "top",
			align = "right",
			halign = "right",
			valign = "top",
			text = managers.localization:get_default_macro("BTN_GHOST"),
			font = tweak_data.menu.pd2_medium_font,
			font_size = tweak_data.menu.pd2_medium_font_size,
			color = tweak_data.screen_colors.text
		})

		make_fine_text(stealth)
		stealth:set_right(last_icon:left() - padding)

		last_icon = stealth
	end

	self:refresh()
end