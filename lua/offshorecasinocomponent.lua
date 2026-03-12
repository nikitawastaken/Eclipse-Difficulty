if type(MenuGuiItem) == "nil" then
	local is_win32 = SystemInfo:platform() == Idstring("WIN32")
	local NOT_WIN_32 = not is_win32
	local medium_font = tweak_data.menu.pd2_medium_font
	local medium_font_size = tweak_data.menu.pd2_medium_font_size
	local small_font = tweak_data.menu.pd2_small_font
	local small_font_size = tweak_data.menu.pd2_small_font_size
	MenuGuiItem = MenuGuiItem or class()

	function MenuGuiItem:init()
		self._selected = false
	end

	function MenuGuiItem:refresh() end

	function MenuGuiItem:inside() end

	function MenuGuiItem:is_selected()
		return self._selected
	end

	function MenuGuiItem:set_selected(selected, play_sound)
		if self._selected ~= selected then
			self._selected = selected

			self:refresh()

			if self._selected and play_sound ~= false then
				managers.menu_component:post_event("highlight")
			end
		end
	end

	function MenuGuiItem:is_active()
		return self._active
	end

	function MenuGuiItem:set_active(active, play_sound)
		if self._active ~= active then
			self._active = active

			self:refresh()
		end
	end

	function MenuGuiItem:trigger()
		managers.menu_component:post_event("menu_enter")
		self:refresh()
	end

	function MenuGuiItem:flash() end
end

if type(CrimeSpreeButton) == "nil" then
	CrimeSpreeButton = CrimeSpreeButton or class(MenuGuiItem)
	CrimeSpreeButton._type = "CrimeSpreeButton"

	function CrimeSpreeButton:init(parent, font, font_size)
		self._w = 0.35
		self._color = tweak_data.screen_colors.button_stage_3
		self._selected_color = tweak_data.screen_colors.button_stage_2
		self._links = {}
		self._panel = parent:panel({
			layer = 1000,
			x = parent:w() * (1 - self._w) - 10,
			w = parent:w() * self._w,
			h = font_size or tweak_data.menu.pd2_medium_font_size,
		})

		self._panel:set_bottom(parent:h())

		self._text = self._panel:text({
			y = 0,
			blend_mode = "add",
			align = "right",
			text = "",
			halign = "right",
			x = 0,
			layer = 1,
			color = self._color,
			font = font or tweak_data.menu.pd2_medium_font,
			font_size = font_size or tweak_data.menu.pd2_medium_font_size,
		})
		self._highlight = self._panel:rect({
			blend_mode = "add",
			alpha = 0.2,
			valign = "scale",
			halign = "scale",
			layer = 10,
			color = self._color,
		})

		self:refresh()
	end

	function CrimeSpreeButton:refresh()
		self._highlight:set_visible(self:is_selected())
		self._highlight:set_color(self:is_selected() and self._selected_color or self._color)
		self._text:set_color(self:is_selected() and self._selected_color or self._color)
	end

	function CrimeSpreeButton:panel()
		return self._panel
	end

	function CrimeSpreeButton:inside(x, y)
		return self._panel:inside(x, y)
	end

	function CrimeSpreeButton:callback()
		return self._callback
	end

	function CrimeSpreeButton:set_callback(clbk)
		self._callback = clbk
	end

	function CrimeSpreeButton:set_button(btn)
		self._btn = btn
	end

	function CrimeSpreeButton:set_text(text)
		local prefix = not managers.menu:is_pc_controller() and self._btn and managers.localization:get_default_macro(self._btn) or ""

		self._text:set_text(prefix .. text)
	end

	function CrimeSpreeButton:get_link(dir)
		return self._links[dir]
	end

	function CrimeSpreeButton:set_link(dir, item)
		self._links[dir] = item
	end

	function CrimeSpreeButton:update(t, dt) end

	function CrimeSpreeButton:shrink_wrap_button(w_padding, h_padding)
		local _, _, w, h = self._text:text_rect()

		self._panel:set_size(w + (w_padding or 0), h + (h_padding or 0))
	end
end

OffshoreCasinoComponent = OffshoreCasinoComponent or class(MenuGuiComponentGeneric)
OffshoreCasinoComponent.menu_nodes = {
	start_menu = "crime_spree_lobby",
	mission_end_menu = "main",
}
local padding = 10
local card_size = 180

local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

function OffshoreCasinoComponent:init(ws, fullscreen_ws, node)
	self._ws = ws
	self._fullscreen_ws = fullscreen_ws
	self._init_layer = self._ws:panel():layer()
	self._fullscreen_panel = self._fullscreen_ws:panel():panel({})
	self._buttons = {}
	self._node = node

	self._backdrop = MenuBackdropGUI:new(self._fullscreen_ws)
	self._baselayer_two = self._backdrop:get_new_base_layer()

	if not self._video then
		self._video = self._baselayer_two:video({
			blend_mode = "add",
			speed = 1,
			loop = false,
			alpha = 0.2,
			video = "movies/lootdrop" .. tostring(math.random(8)),
		})

		managers.video:add_video(self._video)
	end

	if tostring(managers.music.jukebox_menu_track) ~= "nil" then
		managers.music:post_event("stop_all_music")
		managers.music:post_event(managers.music:jukebox_menu_track("heistfinish"))
	else
		managers.music:stop()
		managers.music:post_event("music_loot_drop")
	end

	self._node:parameters().block_back = true
	self:_setup()
end

function OffshoreCasinoComponent:close()
	if alive(self._panel) then
		self._ws:panel():remove(self._panel)
	end

	if alive(self._text_header) then
		self._ws:panel():remove(self._text_header)
	end

	if alive(self._fullscreen_panel) then
		self._fullscreen_ws:panel():remove(self._fullscreen_panel)
	end

	if self._video then
		managers.video:remove_video(self._video)
		self._video:parent():remove(self._video)

		self._video = nil
	end

	self._backdrop:close()
	self._backdrop = nil

	if tostring(managers.music.jukebox_menu_track) ~= "nil" then
		managers.music:post_event("stop_all_music")
		managers.music:post_event(managers.music:jukebox_menu_track("mainmenu"))
	else
		managers.music:stop()
		managers.music:post_event("menu_music")
	end

	managers.menu:active_menu().logic:refresh_node()
	managers.menu_component:post_event("count_1_finished")
end

function OffshoreCasinoComponent:generate_loot_drops(casino_data)
	self._generated_loot_drops = {}

	if casino_data.bet == "sell_items" then
		self._selling_items = true
		self._loot_drops_coroutine = managers.lootdrop:sell_stashed_items(casino_data, self._generated_loot_drops)
	else
		self._loot_drops_coroutine = managers.lootdrop:new_make_casino_drop(casino_data, self._generated_loot_drops)
	end
end

function OffshoreCasinoComponent:_setup()
	local casino_data = self._node:parameters().menu_component_data or {}
	self:generate_loot_drops(casino_data)

	MenuCallbackHandler:save_progress()

	local parent = self._ws:panel()

	if alive(self._panel) then
		parent:remove(self._panel)
	end

	self._panel = self._ws:panel():panel({
		layer = 51,
	})
	self._fullscreen_panel = self._fullscreen_ws:panel():panel({
		layer = 50,
	})

	local blur = self._panel:bitmap({
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		w = self._panel:w(),
		h = self._panel:h(),
		layer = -2,
	})

	local function func(o)
		local start_blur = 0

		over(0.6, function(p)
			o:set_alpha(math.lerp(start_blur, 1, p))
		end)
	end

	blur:animate(func)
	self._panel:set_w(800)
	self._panel:set_h(500)
	self._panel:set_center_x(parent:center_x())
	self._panel:set_center_y(parent:center_y())
	self._panel:rect({
		alpha = 0.75,
		layer = -1,
		color = Color.black,
	})

	self._text_header = self._ws:panel():text({
		vertical = "top",
		align = "left",
		layer = 51,
		text = managers.localization:to_upper_text("menu_l_lootscreen"),
		font_size = tweak_data.menu.pd2_large_font_size,
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.text,
	})
	local x, y, w, h = self._text_header:text_rect()

	self._text_header:set_size(self._panel:w(), h)
	self._text_header:set_left(self._panel:left())
	self._text_header:set_bottom(self._panel:top())
	BoxGuiObject:new(self._panel, {
		sides = {
			1,
			1,
			1,
			1,
		},
	})

	local progress_bar_h = 24
	self._progress_panel = self._panel:panel({
		layer = 10,
		w = self._panel:w() * 0.8,
		h = progress_bar_h + tweak_data.menu.pd2_medium_font_size,
	})

	self._progress_panel:set_center_x(self._panel:w() * 0.5)
	self._progress_panel:set_center_y(self._panel:h() * 0.5)
	self._progress_panel:text({
		vertical = "top",
		align = "left",
		text = managers.localization:to_upper_text(casino_data.bet == "sell_items" and "menu_generating_sells" or "menu_cs_generating_rewards"),
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = tweak_data.screen_colors.text,
	})

	self._progress_text = self._progress_panel:text({
		text = "",
		vertical = "top",
		align = "right",
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = tweak_data.screen_colors.text,
	})
	local progress_bar_panel = self._progress_panel:panel({
		h = progress_bar_h,
	})

	progress_bar_panel:set_bottom(self._progress_panel:h())
	BoxGuiObject:new(
		progress_bar_panel:panel({
			layer = 100,
		}),
		{
			sides = {
				1,
				1,
				1,
				1,
			},
		}
	)

	self._progress_bar = progress_bar_panel:rect({
		alpha = 0.8,
		blend_mode = "add",
		color = tweak_data.screen_colors.button_stage_2,
	})
end

function OffshoreCasinoComponent:_setup_gui()
	self._progress_panel:animate(callback(self, self, "fade_out"), 0.5, 0)

	local panel_w = math.floor(self._panel:w() / 3)
	self._rewards_panel = self._panel:panel({})
end

function OffshoreCasinoComponent:mouse_wheel_up(x, y)
	if self._list_scroll then
		return self._list_scroll:scroll(x, y, 1)
	end
end

function OffshoreCasinoComponent:mouse_wheel_down(x, y)
	if self._list_scroll then
		return self._list_scroll:scroll(x, y, -1)
	end
end

function OffshoreCasinoComponent:confirm_pressed()
	if self._selected_item and self._selected_item:callback() then
		self._selected_item:callback()()
	end
end

function OffshoreCasinoComponent:mouse_moved(o, x, y)
	if not managers.menu:is_pc_controller() then
		return
	end

	local used, pointer = nil
	self._selected_item = nil

	if self._list_scroll then
		self._list_scroll._over_scroll_bar = self._list_scroll._scroll_bar:visible() and self._list_scroll._scroll_bar:inside(x, y)
		self._list_scroll._over_arrow_up = alive(self._list_scroll:panel():child("scroll_up_indicator_arrow")) and self._list_scroll:panel():child("scroll_up_indicator_arrow"):inside(x, y)
		self._list_scroll._over_arrow_down = alive(self._list_scroll:panel():child("scroll_down_indicator_arrow")) and self._list_scroll:panel():child("scroll_down_indicator_arrow"):inside(x, y)
		self._list_scroll._current_y = self._list_scroll._current_y or y

		used, pointer = self._list_scroll:mouse_moved(nil, x, y)
	end

	for idx, btn in ipairs(self._buttons) do
		btn:set_selected(btn:inside(x, y))

		if btn:is_selected() then
			self._selected_item = btn
			pointer = "link"
			used = true
		end
	end

	return used, pointer
end

function OffshoreCasinoComponent:mouse_pressed(o, button, x, y)
	if self._list_scroll then
		if self._list_scroll._over_scroll_bar then
			self._list_scroll._grabbed_scroll_bar = true
			self._list_scroll._current_y = y

			return true
		elseif self._list_scroll._over_arrow_up then
			self._list_scroll._pressing_arrow_up = true
			return true
		elseif self._list_scroll._over_arrow_down then
			self._list_scroll._pressing_arrow_down = true
			return true
		end
	end

	for idx, btn in ipairs(self._buttons) do
		if btn:is_selected() and btn:callback() then
			btn:callback()()

			return true
		end
	end
end

function OffshoreCasinoComponent:mouse_released(o, button, x, y)
	if self._list_scroll then
		self._list_scroll._grabbed_scroll_bar = false
		self._list_scroll._pressing_arrow_down = false
		self._list_scroll._pressing_arrow_up = false
	end
end

function OffshoreCasinoComponent:_close_rewards()
	managers.menu:back()
end

function OffshoreCasinoComponent:create_card(panel, icon, size)
	local rotation = math.rand(-10, 10)
	local texture, rect, coords = tweak_data.hud_icons:get_icon_data(icon or "downcard_overkill_deck")
	local upcard = panel:bitmap({
		name = "upcard",
		halign = "scale",
		valign = "scale",
		layer = 20,
		texture = texture,
		w = math.round(0.7111111111111111 * size),
		h = size,
	})

	upcard:set_rotation(rotation)
	upcard:set_center_x(panel:w() * 0.5)
	upcard:set_y(panel:w() * 0.5 - upcard:w() * 0.5)
	upcard:hide()

	if coords then
		local tl = Vector3(coords[1][1], coords[1][2], 0)
		local tr = Vector3(coords[2][1], coords[2][2], 0)
		local bl = Vector3(coords[3][1], coords[3][2], 0)
		local br = Vector3(coords[4][1], coords[4][2], 0)

		upcard:set_texture_coordinates(tl, tr, bl, br)
	else
		upcard:set_texture_rect(unpack(rect))
	end

	return upcard
end

function OffshoreCasinoComponent:get_reward_icon(reward)
	local rewards = {
		{
			id = "experience",
			always_show = true,
			max_cards = 10,
			card_inc = 200000,
			name_id = "menu_challenge_xp_drop",
			icon = "upcard_xp",
			amount = 20000,
		},
		{
			id = "cash",
			max_cards = 10,
			cash_string = "$",
			card_inc = 4000000,
			name_id = "menu_challenge_cash_drop",
			icon = "upcard_cash",
			always_show = true,
			amount = 400000,
		},
		{
			id = "loot_drop",
			max_cards = 5,
			card_inc = 5,
			name_id = "menu_challenge_loot_drop",
			icon = "upcard_random",
			amount = 0.2,
		},
	}

	for _, data in ipairs(rewards) do
		if data.id == reward then
			return data.icon
		end
	end

	return "downcard_overkill_deck"
end

function OffshoreCasinoComponent:_add_item_textures(lootdrop_data, panel)
	local item_id = lootdrop_data.item_entry
	local category = lootdrop_data.type_items

	if category == "weapon_mods" or category == "weapon_bonus" then
		category = "mods"
	end

	if category == "mask_colors" then
		local color = panel:bitmap({
			texture = "guis/dlcs/mcu/textures/pd2/blackmarket/icons/mask_color/mask_color_icon",
			layer = 0,
			x = panel:h() / 6,
			y = panel:h() / 6,
			w = panel:h() / 1.5,
			h = panel:h() / 1.5,
			color = tweak_data.blackmarket.mask_colors[item_id].color,
		})
	elseif category == "colors" then
		local colors = tweak_data.blackmarket.colors[item_id].colors
		local bg = panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/icons/colors/color_bg",
			layer = 1,
			w = panel:h(),
			h = panel:h(),
		})
		local c1 = panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/icons/colors/color_01",
			layer = 0,
			w = panel:h(),
			h = panel:h(),
		})
		local c2 = panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/icons/colors/color_02",
			layer = 0,
			w = panel:h(),
			h = panel:h(),
		})

		c1:set_color(colors[1])
		c2:set_color(colors[2])
	else
		local texture_loaded_clbk = callback(self, self, "_texture_loaded_clbk", {
			panel = panel,
			is_pattern = category == "textures" and true or false,
		})
		local texture_path = nil

		if category == "textures" then
			texture_path = tweak_data.blackmarket.textures[item_id].texture
		elseif category == "cash" then
			texture_path = "guis/textures/pd2/blackmarket/cash_drop"
		elseif category == "xp" then
			texture_path = "guis/textures/pd2/blackmarket/xp_drop"
		elseif category == "safes" then
			local td = tweak_data.economy[category] and tweak_data.economy[category][item_id]

			if td then
				local guis_catalog = "guis/"
				local bundle_folder = td.texture_bundle_folder

				if bundle_folder then
					guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
				end

				local path = category .. "/"
				texture_path = guis_catalog .. path .. item_id
			else
				texture_path = "guis/dlcs/cash/safes/default/safes/default_01"
			end
		elseif category == "drills" then
			local td = tweak_data.economy[category] and tweak_data.economy[category][item_id]

			if td then
				local guis_catalog = "guis/"
				local bundle_folder = td.texture_bundle_folder

				if bundle_folder then
					guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
				end

				local path = category .. "/"
				texture_path = guis_catalog .. path .. item_id
			else
				texture_path = "guis/dlcs/cash/safes/default/drills/default_01"
			end
		else
			local guis_catalog = "guis/"
			local tweak_data_category = category == "mods" and "weapon_mods" or category
			local guis_id = item_id

			if tweak_data.blackmarket[tweak_data_category] and tweak_data.blackmarket[tweak_data_category][item_id] and tweak_data.blackmarket[tweak_data_category][item_id].guis_id then
				guis_id = tweak_data.blackmarket[tweak_data_category][item_id].guis_id
			end

			local bundle_folder = tweak_data.blackmarket[tweak_data_category]
				and tweak_data.blackmarket[tweak_data_category][guis_id]
				and tweak_data.blackmarket[tweak_data_category][guis_id].texture_bundle_folder

			if bundle_folder then
				guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
			end

			texture_path = guis_catalog .. "textures/pd2/blackmarket/icons/" .. tostring(category) .. "/" .. tostring(guis_id)
		end

		Application:debug("Requesting Texture", texture_path)

		if DB:has(Idstring("texture"), texture_path) then
			TextureCache:request(texture_path, "NORMAL", texture_loaded_clbk, 100)
		else
			Application:error("[HUDLootScreen]", "Texture not in DB", texture_path)
			panel:rect({
				color = Color.red,
			})
		end
	end
end

function OffshoreCasinoComponent:_texture_loaded_clbk(params, texture_idstring)
	if not alive(self._loot_panel) then
		TextureCache:unretrieve(texture_idstring)

		return
	end

	local is_pattern = params.is_pattern
	local panel = params.panel
	local item = panel:bitmap({
		blend_mode = "normal",
		texture = texture_idstring,
	})

	if is_pattern then
		item:set_render_template(Idstring("VertexColorTexturedPatterns"))
	end

	TextureCache:unretrieve(texture_idstring)

	local texture_width = item:texture_width()
	local texture_height = item:texture_height()
	local panel_width = panel:w()
	local panel_height = panel:h()

	if texture_width == 0 or texture_height == 0 or panel_width == 0 or panel_height == 0 then
		Application:error("HUDLootScreen:texture_loaded_clbk():", texture_idstring)
		Application:debug("HUDLootScreen:", "texture_width " .. texture_width, "texture_height " .. texture_height, "panel_width " .. panel_width, "panel_height " .. panel_height)
		panel:remove(item)

		local rect = panel:rect({
			blend_mode = "add",
			rotation = 360,
			color = Color.red,
		})

		rect:set_center(panel:w() * 0.5, panel:h() * 0.5)

		return
	end

	local s = math.min(texture_width, texture_height)
	local dw = texture_width / s
	local dh = texture_height / s

	local _dw = dw / math.max(dw, dh)
	local _dh = dh / math.max(dw, dh)

	item:set_size(math.round(_dw * panel_width), math.round(_dh * panel_height))
	item:set_rotation(360)
	item:set_center(panel:w() * 0.5, panel:h() * 0.5)
end

OffshoreCasinoComponent.states = {
	{
		"_update_loot_drops",
		0.5,
	},
	{
		"_update_rewards_list",
		0.5,
	},
}

function OffshoreCasinoComponent:is_generating_rewards()
	return self._loot_drops_coroutine ~= nil
end

function OffshoreCasinoComponent:reward_generation_progress()
	if self._generated_loot_drops then
		return self._generated_loot_drops.progress.current or 0, self._generated_loot_drops.progress.total or 1
	end

	return 1
end

function OffshoreCasinoComponent:has_finished_generating_rewards()
	if self._loot_drops_coroutine then
		local status = coroutine.status(self._loot_drops_coroutine)

		if status == "dead" then
			self._loot_drops = clone(self._generated_loot_drops.items)
			self._loot_amount = clone(self._generated_loot_drops.item_tbl)
			self._money_gained = self._generated_loot_drops.money_gained
			self._generated_loot_drops = nil
			self._loot_drops_coroutine = nil

			MenuCallbackHandler:save_progress()

			return true
		elseif status == "suspended" then
			coroutine.resume(self._loot_drops_coroutine)

			return false
		else
			return false
		end
	end

	return true
end

function OffshoreCasinoComponent:update(t, dt)
	if self:is_generating_rewards() then
		local current, total = self:reward_generation_progress()
		local complete = self:has_finished_generating_rewards()

		if alive(self._progress_text) then
			self._progress_text:set_text(string.format("%i/%i", complete and total or current, total))

			if alive(self._progress_bar) then
				self._progress_bar:set_w(self._progress_panel:w() * (complete and 1 or current / total))
			end
		end

		if complete then
			self:_setup_gui()
		end

		return
	end

	if self._wait_t then
		self._wait_t = self._wait_t - dt

		if self._wait_t < 0 then
			self._wait_t = nil
		end

		return
	end

	if not self._current_state then
		self:next_state()

		return
	end

	local cx, cy = managers.menu_component:get_right_controller_axis()

	if cy ~= 0 and self._list_scroll then
		self._list_scroll:perform_scroll(math.abs(cy * 500 * dt), math.sign(cy))
	end

	if not self.states[self._current_state] then
		return
	end

	local func = self.states[self._current_state][1]

	if self[func] then
		self[func](self, t, dt)
	end

	for idx, btn in ipairs(self._buttons) do
		btn:update(t, dt)
	end
end

function OffshoreCasinoComponent:next_state(wait_t)
	self._current_state = (self._current_state or 0) + 1
	local t = OffshoreCasinoComponent.states[self._current_state] and OffshoreCasinoComponent.states[self._current_state][2] or 0

	if t > 0 or wait_t then
		self:wait(wait_t or t)
	end
end

function OffshoreCasinoComponent:wait(t)
	self._wait_t = t
end

function OffshoreCasinoComponent:set_text(element, text, delay)
	if delay then
		wait(delay)
	end

	element:set_text(text)
end

function OffshoreCasinoComponent:flip_item_card(card, item_type, delay)
	local start_rot = card:rotation()
	local start_w = card:w()
	local cx, cy = card:center()
	local start_rotation = card:rotation()
	local end_rotation = start_rotation * -1
	local diff = end_rotation - start_rotation

	card:set_valign("scale")
	card:set_halign("scale")
	card:show()

	if delay then
		wait(delay)
	end

	managers.menu_component:post_event("loot_flip_card")
	over(0.25, function(p)
		card:set_rotation(start_rotation + math.sin(p * 45) * diff)

		if card:rotation() == 0 then
			card:set_rotation(360)
		end

		card:set_w(start_w * math.cos(p * 90))
		card:set_center(cx, cy)
	end)

	local texture, rect, coords = tweak_data.hud_icons:get_icon_data(item_type or "downcard_overkill_deck")

	card:set_image(texture)
	card:set_texture_rect(unpack(rect))
	over(0.25, function(p)
		card:set_rotation(start_rotation + math.sin(p * 45 + 45) * diff)

		if card:rotation() == 0 then
			card:set_rotation(360)
		end

		card:set_w(start_w * math.sin(p * 90))
		card:set_center(cx, cy)
	end)
end

function OffshoreCasinoComponent:fade_in(element, duration, delay)
	if delay then
		wait(delay)
	end

	element:show()
	over(duration, function(p)
		element:set_alpha(math.lerp(0, 1, p))
	end)
end

function OffshoreCasinoComponent:fade_out(element, duration, delay)
	if delay then
		wait(delay)
	end

	over(duration, function(p)
		element:set_alpha(math.lerp(1, 0, p))
	end)
	element:hide()
end

function OffshoreCasinoComponent:count_text(element, cash_string, start_val, end_val, duration, delay)
	if delay then
		wait(delay)
	end

	local v = start_val

	managers.menu_component:post_event("count_1")
	over(duration, function(p)
		v = math.lerp(start_val, end_val, p)

		element:set_text(managers.experience:cash_string(v, cash_string))
	end)
	managers.menu_component:post_event("count_1_finished")
end

function OffshoreCasinoComponent:fill_circle(element, start, target, duration, delay)
	if delay then
		wait(delay)
	end

	over(duration, function(p)
		local v = math.lerp(start, target, p)

		element:set_color(Color(v, 1, 1))
	end)
end

function OffshoreCasinoComponent:post_event(element, event, delay)
	if delay then
		wait(delay)
	end

	managers.menu:post_event(event)
end

function OffshoreCasinoComponent:loot_drops()
	return self._loot_drops or {}
end

function OffshoreCasinoComponent:_update_loot_drops()
	local loot_drops = self:loot_drops()
	local casino_data = self._node:parameters().menu_component_data or {}

	if #loot_drops < 1 then
		self:next_state(0)

		return
	end

	self._loot_panel = self._panel:panel({
		x = padding,
		y = padding,
		w = self._panel:w() - padding * 2,
		h = self._panel:h() - padding * 2,
	})
	local loot_params = {
		loot = managers.experience:experience_string(#loot_drops),
	}
	local drops_remaining = self._loot_panel:text({
		vertical = "bottom",
		name = "drops_remaining",
		align = "left",
		layer = 1,
		text = managers.localization:to_upper_text(casino_data.bet == "sell_items" and "menu_loot_drops_selling" or "menu_cs_loot_drops_remaining", loot_params),
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = tweak_data.screen_colors.text,
	})

	make_fine_text(drops_remaining)
	drops_remaining:set_left(self._loot_panel:left())
	drops_remaining:set_bottom(self._loot_panel:bottom() - padding)

	self._loot_scroll = ScrollablePanel:new(self._loot_panel, "loot_scroll", {
		padding = 0,
	})
	local num_items = #loot_drops
	local items_per_line = 6
	local max_lines = 3
	local max_items = items_per_line * max_lines
	local item_size = self._loot_scroll:canvas():w() / items_per_line
	local max_pages = 3
	local c = 0
	local intial_delay = 0
	local end_t = 0

	for i = 1, math.min(num_items, max_items * max_pages) do
		local lootdrop_data = loot_drops[i]
		local card_types = {
			weapon_mods = "upcard_weapon",
			xp = "upcard_xp",
			materials = "upcard_material",
			safes = "upcard_safe",
			cash = "upcard_cash",
			masks = "upcard_mask",
			colors = "upcard_color",
			mask_colors = "upcard_color",
			textures = "upcard_pattern",
			drills = "upcard_drill",
			weapon_bonus = "upcard_weapon_bonus",
		}
		local panel = self._loot_scroll:canvas():panel({
			x = item_size * (c % items_per_line),
			y = item_size * math.floor(c / items_per_line),
			w = item_size,
			h = item_size,
		})
		local card = self:create_card(panel, "downcard_overkill_deck", item_size * 0.8)

		card:set_center_x(panel:w() * 0.5)
		card:set_center_y(panel:h() * 0.5)
		card:set_alpha(0)

		local size = 0.75
		local item_panel = panel:panel({
			alpha = 0,
			visible = false,
			x = panel:w() * (1 - size) * 0.5,
			y = panel:h() * (1 - size) * 0.5,
			w = panel:w() * size,
			h = panel:h() * size,
			color = Color(math.random(), math.random(), math.random()),
		})

		self:_add_item_textures(lootdrop_data, item_panel)

		local loot_str = string.format("%s_%s_%s", lootdrop_data.global_value, lootdrop_data.type_items, lootdrop_data.item_entry)
		local count_text = self._loot_amount[loot_str] > 1 and tostring(self._loot_amount[loot_str]) or ""
		if count_text ~= "" then
			local count_bg = item_panel:bitmap({
				texture = "guis/textures/pd2/hud_progress_32px",
				h = 24,
				w = 24,
				layer = 1,
			})
			count_bg:set_rightbottom(item_panel:w(), item_panel:h())

			local amount_text = item_panel:text({
				text = count_text,
				vertical = "center",
				align = "center",
				h = 24,
				w = 24,
				font_size = tweak_data.menu.pd2_medium_font_size / (1 + (string.len(count_text - 1) * 0.25)),
				font = tweak_data.menu.pd2_medium_font,
				color = Color.black,
				layer = 2,
			})
			amount_text:set_center(count_bg:center())
		end

		local t = 0
		t = t + 1 + intial_delay

		if self._selling_items then
			item_panel:animate(callback(self, self, "fade_in"), 0.25, t)

			t = t + 0.5 + c * 0.2

			loot_params.loot = managers.experience:experience_string(num_items - i)
			local new_text = managers.localization:to_upper_text("menu_loot_drops_selling", loot_params)

			drops_remaining:animate(callback(self, self, "set_text"), new_text, t)

			t = t + 1

			card:animate(callback(self, self, "fade_in"), 0.25, t)
			item_panel:animate(callback(self, self, "fade_out"), 0.25, t)

			t = t + 2 + max_items * 0.5 * 0.2
			card:animate(callback(self, self, "flip_item_card"), "upcard_cash", t)
			card:animate(callback(self, self, "fade_out"), 0.25, t)
		else
			card:animate(callback(self, self, "fade_in"), 0.25, t)

			t = t + 0.5 + c * 0.2

			card:animate(callback(self, self, "flip_item_card"), card_types[lootdrop_data.type_items], t)

			loot_params.loot = managers.experience:experience_string(num_items - i)
			local new_text = managers.localization:to_upper_text("menu_cs_loot_drops_remaining", loot_params)

			drops_remaining:animate(callback(self, self, "set_text"), new_text, t)

			t = t + 1

			item_panel:animate(callback(self, self, "fade_in"), 0.25, t)
			card:animate(callback(self, self, "fade_out"), 0.25, t)

			t = t + 2 + max_items * 0.5 * 0.2

			item_panel:animate(callback(self, self, "fade_out"), 0.25, t)
		end

		c = c + 1

		if max_items <= c then
			c = 0
			intial_delay = t
		end

		end_t = t
	end

	if self._selling_items then
		end_t = end_t + 1
	end

	if num_items > max_items * max_pages then
		local more_text = self._loot_scroll:canvas():text({
			vertical = "center",
			align = "center",
			alpha = 0,
			text = managers.localization:text(casino_data.bet == "sell_items" and "menu_loot_sells_not_shown" or "menu_cs_loot_drops_not_shown", {
				remaining = managers.experience:experience_string(num_items - max_items * max_pages),
			}),
			font_size = tweak_data.menu.pd2_large_font_size,
			font = tweak_data.menu.pd2_large_font,
			color = tweak_data.screen_colors.text,
		})
		local t = end_t

		more_text:animate(callback(self, self, "fade_in"), 0.25, t)
		more_text:animate(callback(self, self, "fade_out"), 0.25, t + 2)

		end_t = end_t + 2.5
	end

	self._loot_scroll:update_canvas_size()

	self:next_state(end_t)
end

function OffshoreCasinoComponent:_update_rewards_list()
	if alive(self._loot_panel) then
		self._panel:remove(self._loot_panel)
	end

	self._list_panel = self._panel:panel({
		x = padding,
		y = padding,
		w = self._panel:w() - padding * 2,
		h = self._panel:h() - padding * 2 - tweak_data.menu.pd2_large_font_size,
	})
	self._list_scroll = ScrollablePanel:new(self._list_panel, "loot_scroll", {
		force_scroll_indicators = true,
		padding = 0,
	})
	local count = 0
	local fade_in_t = 0.25
	local fade_in_delay = fade_in_t / 4
	local size = tweak_data.menu.pd2_small_font_size

	local function add_reward_text(text, color, name)
		local reward_text = self._list_scroll:canvas():text({
			alpha = 0,
			vertical = "bottom",
			align = name == "cost" and "right" or "left",
			layer = 1,
			name = name,
			text = text,
			x = padding,
			y = padding + (size + 2) * (name == "cost" and count - 1 or count),
			h = size,
			font_size = size,
			font = tweak_data.menu.pd2_small_font,
			color = color or tweak_data.screen_colors.text,
		})

		if name == "cost" then
			reward_text:set_right(self._list_scroll:canvas():w() - (padding * 3))
		else
			count = count + 1
		end

		reward_text:animate(callback(self, self, "fade_in"), fade_in_t, count * fade_in_delay)
	end

	if not self._selling_items then
		add_reward_text(managers.localization:to_upper_text("menu_experience") .. " 0", nil, "experience")
	end

	add_reward_text(managers.localization:to_upper_text("menu_cash_spending") .. ": " .. managers.experience:cash_string(self._money_gained or 0) or "", nil, "spending")
	add_reward_text("")

	local loot_drops = self:loot_drops()

	for _, lootdrop_data in ipairs(loot_drops) do
		local td, text, color = nil
		local item_id = lootdrop_data.item_entry
		local category = lootdrop_data.type_items
		local gv = lootdrop_data.global_value
		local loot_str = string.format("%s_%s_%s", tostring(gv), tostring(category), tostring(item_id))

		if category == "weapon_mods" or category == "weapon_bonus" then
			category = "mods"
		end

		if category == "colors" then
			td = tweak_data.blackmarket.colors[item_id]
		elseif category == "textures" then
			td = tweak_data.blackmarket.textures[item_id]
		elseif category == "cash" then
			lootdrop_data.cost = tweak_data:get_value("money_manager", "loot_drop_cash", item_id)
			local amount = tweak_data:get_value("money_manager", "loot_drop_cash", item_id) * self._loot_amount[loot_str] or 0
			self._total_loot_drop_cash = (self._total_loot_drop_cash or 0) + amount
			self._list_scroll:canvas():child("spending"):set_text(managers.localization:to_upper_text("menu_cash_spending") .. " " .. managers.experience:cash_string(self._total_loot_drop_cash))
			text = managers.localization:text("bm_menu_" .. tostring(category)) .. ": " .. managers.experience:cash_string(lootdrop_data.cost)
			td = tweak_data.blackmarket.cash[item_id]
		elseif category == "xp" then
			lootdrop_data.cost = tweak_data:get_value("experience_manager", "loot_drop_value", item_id)
			local amount = tweak_data:get_value("experience_manager", "loot_drop_value", item_id) * self._loot_amount[loot_str] or 0
			self._total_loot_drop_exp = (self._total_loot_drop_exp or 0) + amount
			self._list_scroll:canvas():child("experience"):set_text(managers.localization:to_upper_text("menu_experience") .. " " .. managers.experience:experience_string(self._total_loot_drop_exp))

			text = managers.localization:text("bm_menu_" .. tostring(category)) .. ": " .. managers.experience:experience_string(lootdrop_data.cost)
			local _, rarity = string.gsub(item_id, "xp_pda9", "")
			color = rarity > 0 and tweak_data.screen_colors.infamous_color or tweak_data.screen_colors.text

			td = tweak_data.blackmarket.xp[item_id]
		elseif category == "safes" then
			td = tweak_data.economy[category] and tweak_data.economy[category][item_id]
		elseif category == "drills" then
			td = tweak_data.economy[category] and tweak_data.economy[category][item_id]
		else
			local tweak_data_category = category == "mods" and "weapon_mods" or category
			td = tweak_data.blackmarket[tweak_data_category][item_id]
		end

		if text == nil then
			if td.name_id then
				text = managers.localization:text("bm_menu_" .. tostring(category)) .. ": " .. managers.localization:text(td.name_id)
				color = tweak_data.lootdrop.global_values[gv] and tweak_data.lootdrop.global_values[gv].color or tweak_data.screen_colors.text
			else
				text = tostring(item_id) .. " - " .. tostring(category)
			end
		end

		if text then
			local amount = self._loot_amount[loot_str] > 1 and string.format(" (x%s)", self._loot_amount[loot_str]) or ""
			add_reward_text(text .. amount, color)

			if lootdrop_data.cost then
				if category == "xp" then
					add_reward_text(managers.experience:experience_string(lootdrop_data.cost * self._loot_amount[loot_str]), color, "cost")
				else
					add_reward_text(managers.experience:cash_string(lootdrop_data.cost * self._loot_amount[loot_str]), color, "cost")
				end
			end
		end
	end

	self._list_scroll:update_canvas_size()

	self._button_panel = self._panel:panel({
		alpha = 0,
		y = self._panel:h() - tweak_data.menu.pd2_large_font_size,
		h = tweak_data.menu.pd2_large_font_size - padding,
	})

	self._button_panel:animate(callback(self, self, "fade_in"), 0, 1)

	local btn = CrimeSpreeButton:new(self._button_panel)

	btn:set_text(managers.localization:to_upper_text("dialog_ok"))
	btn:set_callback(callback(self, self, "_close_rewards"))
	btn:set_selected(true)

	self._selected_item = btn

	table.insert(self._buttons, btn)

	self._total_loot_drop_cash = nil
	self._total_loot_drop_exp = nil

	self:next_state(0)
	self._node:parameters().block_back = false
end
