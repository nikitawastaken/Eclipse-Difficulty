local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local crew_abilities = {
	--	"crew_interact",
	"crew_inspire",
	--	"crew_scavenge",
	"crew_ai_ap_ammo",
	--	"crew_ai_cable_ties",
	"crew_ai_flashbang",
	"crew_ai_counter_strike",
	"crew_ai_counter_tase",
	-- New abilities added by Eclipse
	"crew_ai_fix_drill",
	"crew_ai_dominator",
	"crew_ai_carry_stacker",
}

local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

function CrewManagementGui:previous_ability(henchman_index)
	local loadout = managers.blackmarket:henchman_loadout(henchman_index)
	local ability = loadout.ability
	local ability_index = ability and table.get_vector_index(crew_abilities, ability) or #crew_abilities + 1
	local map = self:_create_member_loadout_map("ability")
	local name = nil

	for index = ability_index - 1, 1, -1 do
		name = crew_abilities[index]

		if managers.blackmarket:is_crew_item_unlocked(name) and not map[name] then
			loadout.ability = name

			return self:reload()
		end
	end

	loadout.ability = nil

	return self:reload()
end

function CrewManagementGui:next_ability(henchman_index)
	local loadout = managers.blackmarket:henchman_loadout(henchman_index)
	local ability = loadout.ability
	local ability_index = ability and table.get_vector_index(crew_abilities, ability) or 0
	local map = self:_create_member_loadout_map("ability")
	local name = nil

	for index = ability_index + 1, #crew_abilities do
		name = crew_abilities[index]

		if managers.blackmarket:is_crew_item_unlocked(name) and not map[name] then
			loadout.ability = name

			return self:reload()
		end
	end

	loadout.ability = nil

	return self:reload()
end

function CrewManagementGui:populate_ability(henchman_index, data, gui)
	self:populate_custom("ability", henchman_index, tweak_data.upgrades.crew_ability_definitions, crew_abilities, data, gui)
end

-- remove the crew boosts since we don't use them anymore
function CrewManagementGui:init(ws, fullscreen_ws, node)
	managers.menu_component:close_contract_gui()
	managers.blackmarket:verfify_crew_loadout()
	MenuCallbackHandler:reset_crew_outfit()

	if alive(CrewManagementGui.panel_crash_protection) then
		CrewManagementGui.panel_crash_protection:parent():remove(CrewManagementGui.panel_crash_protection)
	end

	self._node = node
	node:parameters().data = node:parameters().data or {}
	self._panel = ws:panel():panel()
	CrewManagementGui.panel_crash_protection = self._panel
	self._item_w = 128
	self._item_h = 100
	self._image_max_h = 64
	self._item_h = 84
	self._buttons = {}
	self._buttons_no_nav = {}
	local title_text = self._panel:text({
		text = managers.localization:to_upper_text("menu_crew_management"),
		font = large_font,
		font_size = large_font_size,
	})

	make_fine_text(title_text)

	local loadout_text = self._panel:text({
		text = managers.localization:text("menu_crew_loadout_order"),
		font = medium_font,
		font_size = medium_font_size,
		y = medium_font_size,
	})

	make_fine_text(loadout_text)

	local info_panel = nil

	if managers.menu:is_pc_controller() then
		info_panel = self._panel:panel({
			w = 30,
			h = 24,
		})
		local info_icon = info_panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/inv_newdrop",
		})

		info_icon:set_texture_coordinates(Vector3(0, 16, 0), Vector3(16, 16, 0), Vector3(0, 0, 0), Vector3(16, 0, 0))
		info_icon:set_center(info_panel:center())

		local info_button = CrewManagementGuiButton:new(self, callback(self, self, "show_help_dialog"), true)
		info_button._panel = info_panel
		info_button._select_col = Color.white:with_alpha(0.25)
		info_button._normal_col = Color.white

		function info_button:_selected_changed(state)
			info_icon:set_color(state and self._select_col or self._normal_col)
		end
	end

	self._1_panel = self._panel:panel({
		h = 0,
		w = self._item_w,
		y = loadout_text:bottom(),
	})
	self._2_panel = self._panel:panel({
		h = 0,
		w = self._item_w,
		y = loadout_text:bottom(),
	})
	self._3_panel = self._panel:panel({
		h = 0,
		w = self._item_w,
		y = loadout_text:bottom(),
	})
	self._btn_panels = {
		self._1_panel,
		self._2_panel,
		self._3_panel,
	}

	self._3_panel:set_right(self._panel:right() - 10)
	self._2_panel:set_right(self._3_panel:left() - 10)
	self._1_panel:set_right(self._2_panel:left() - 10)

	for i, panel in pairs(self._btn_panels) do
		local slot_text = self._panel:text({
			text = managers.localization:text("menu_crew_slot_index", {
				index = i,
			}),
			font = small_font,
			font_size = small_font_size,
		})

		make_fine_text(slot_text)
		slot_text:set_lefttop(panel:lefttop())
		panel:set_top(slot_text:bottom())
	end

	loadout_text:set_left(self._1_panel:left())

	if info_panel then
		info_panel:set_center_y(loadout_text:center_y())
		info_panel:set_left(loadout_text:right())
	end

	self:create_mask_button(self._1_panel, 1)
	self:create_mask_button(self._2_panel, 2)
	self:create_mask_button(self._3_panel, 3)
	self:new_row()
	self:create_weapon_button(self._1_panel, 1)
	self:create_weapon_button(self._2_panel, 2)
	self:create_weapon_button(self._3_panel, 3)
	self:new_row()
	self:create_ability_button(self._1_panel, 1)
	self:create_ability_button(self._2_panel, 2)
	self:create_ability_button(self._3_panel, 3)
	-- self:new_row()
	-- self:create_skill_button(self._1_panel, 1)
	-- self:create_skill_button(self._2_panel, 2)
	-- self:create_skill_button(self._3_panel, 3)
	self:new_row()
	self:create_suit_button(self._1_panel, 1)
	self:create_suit_button(self._2_panel, 2)
	self:create_suit_button(self._3_panel, 3)
	self:new_row()

	local char_text = self._panel:text({
		text = managers.localization:text("menu_crew_character_order"),
		font = medium_font,
		font_size = medium_font_size,
	})

	make_fine_text(char_text)

	local cc_padding = 20
	cc_padding = 10

	char_text:set_top(self._1_panel:bottom() + cc_padding)
	char_text:set_left(self._1_panel:left())

	local cc_panel = self._panel:panel({
		w = self._3_panel:right() - self._1_panel:left(),
	})

	cc_panel:set_left(self._1_panel:left())
	cc_panel:set_top(char_text:bottom())

	local char_height = 70
	char_height = 64
	local char_panel = cc_panel:panel({
		w = 0,
		h = char_height,
	})
	local char_images = {}

	for i = 1, CriminalsManager.MAX_NR_TEAM_AI do
		local character = managers.blackmarket:preferred_henchmen(i)
		local texture = character and managers.blackmarket:get_character_icon(character) or "guis/textures/pd2/dice_icon"
		local _, img = self:_add_bitmap_panel_row(char_panel, {
			texture = texture,
		}, char_height, 64)

		table.insert(char_images, img)
	end

	char_panel:set_center_x(cc_panel:w() / 2)
	char_panel:set_top(15)
	cc_panel:set_h(char_panel:h() + 30)

	local char_btn = CrewManagementGuiButton:new(self, callback(self, self, "open_character_menu", 1))
	char_btn._panel = cc_panel
	char_btn._select_panel = BoxGuiObject:new(cc_panel, {
		sides = {
			2,
			2,
			2,
			2,
		},
	})
	local char_panel_size = {
		char_images[1]:size(),
	}

	function char_btn:_selected_changed(state, instant)
		CrewManagementGuiButton._selected_changed(self, state, instant)

		for _, img in pairs(char_images) do
			img:animate(state and select_anim or unselect_anim, char_panel_size, instant)
		end
	end

	char_btn:_selected_changed(false, true)

	local v = cc_panel

	BoxGuiObject:new(v, {
		sides = {
			1,
			1,
			1,
			1,
		},
	})
	v:bitmap({
		texture = "guis/textures/test_blur_df",
		layer = -1,
		halign = "scale",
		alpha = 1,
		render_template = "VertexColorTexturedBlur3D",
		valign = "scale",
		w = v:w(),
		h = v:h(),
	})
	v:rect({
		alpha = 0.4,
		layer = -1,
		color = Color.black,
	})

	for _, v in pairs(self._btn_panels) do
		BoxGuiObject:new(v, {
			sides = {
				1,
				1,
				2,
				1,
			},
		})
		v:bitmap({
			texture = "guis/textures/test_blur_df",
			layer = -1,
			halign = "scale",
			alpha = 1,
			render_template = "VertexColorTexturedBlur3D",
			valign = "scale",
			w = v:w(),
			h = v:h(),
		})
		v:rect({
			alpha = 0.4,
			layer = -1,
			color = Color.black,
		})
	end

	WalletGuiObject.set_wallet(self._panel)

	if managers.menu:is_pc_controller() then
		self._legends_panel = self._panel:panel({
			name = "legends_panel",
			w = self._panel:w() * 0.75,
			h = tweak_data.menu.pd2_medium_font_size,
		})

		self._legends_panel:set_right(self._panel:w())

		self._legends = {}

		local function new_legend(name, text_string, hud_icon)
			local panel = self._legends_panel:panel({
				visible = false,
				name = name,
			})
			local text = panel:text({
				blend_mode = "add",
				text = text_string,
				font = small_font,
				font_size = small_font_size,
				color = tweak_data.screen_colors.text,
			})

			make_fine_text(text)

			local text_x = 0
			local center_y = text:center_y()

			if hud_icon then
				local texture, texture_rect = tweak_data.hud_icons:get_icon_data(hud_icon)
				local icon = panel:bitmap({
					name = "icon",
					h = 23,
					blend_mode = "add",
					w = 17,
					texture = texture,
					texture_rect = texture_rect,
				})
				text_x = icon:right() + 2
				center_y = math.max(center_y, icon:center_y())

				icon:set_center_y(center_y)
			end

			text:set_left(text_x)
			text:set_center_y(center_y)
			panel:set_w(text:right())

			self._legends[name] = panel
		end

		new_legend("select", managers.localization:to_upper_text("menu_mouse_select"), "mouse_left_click")
		new_legend("switch", managers.localization:to_upper_text("menu_mouse_switch"), "mouse_scroll_wheel")
	end

	local index_x = node:parameters().data.crew_gui_index_x or 1
	local index_y = node:parameters().data.crew_gui_index_y or 1

	self:select_index(index_x, index_y)

	local back_button = self._panel:text({
		vertical = "bottom",
		name = "back_button",
		blend_mode = "add",
		align = "right",
		layer = 40,
		text = managers.localization:text("menu_back"),
		font_size = tweak_data.menu.pd2_large_font_size,
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.button_stage_3,
	})

	make_fine_text(back_button)
	back_button:set_right(self._panel:w())
	back_button:set_bottom(self._panel:h())
	back_button:set_visible(managers.menu:is_pc_controller())

	local back = CrewManagementGuiButton:new(self, function()
		managers.menu:back(true)
	end, true)
	back._panel = back_button
	back._select_col = tweak_data.screen_colors.button_stage_2
	back._normal_col = tweak_data.screen_colors.button_stage_3
	back._selected_changed = CrewManagementGuiTextButton._selected_changed
end
