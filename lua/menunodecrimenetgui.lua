-- Offshore casino rework
MenuNodeCrimenetCasinoGui.PRECISION = "%.1f"
function MenuNodeCrimenetCasinoGui:_setup_layout()
	local parent_layer = managers.menu:active_menu().renderer:selected_node():layer()
	self._panel = self.ws:panel():panel({
		layer = parent_layer + 1
	})
	local width, height, space_x, space_y, start_x = self:_get_sizes(self._panel:w(), self._panel:h())
	local large_font = tweak_data.menu.pd2_large_font
	local medium_font = tweak_data.menu.pd2_medium_font
	local small_font = tweak_data.menu.pd2_small_font
	local large_font_size = tweak_data.menu.pd2_large_font_size
	local medium_font_size = tweak_data.menu.pd2_medium_font_size
	local small_font_size = tweak_data.menu.pd2_small_font_size
	local option_size = self._panel:w() * (1 - self._align_line_proportions)
	local content_offset = 20
	local text_title = self._panel:text({
		blend_mode = "add",
		text = managers.localization:to_upper_text("menu_casino_title_main"),
		font_size = large_font_size,
		font = large_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, w, h = text_title:text_rect()
	self._main_panel = self._panel:panel({
		x = 0,
		y = h,
		w = self._panel:w(),
		h = self._panel:h() - h
	})
	local text_betting = self._main_panel:text({
		blend_mode = "add",
		text = managers.localization:to_upper_text("menu_casino_title_betting"),
		font_size = medium_font_size,
		font = medium_font,
		color = tweak_data.screen_colors.text
	})

	text_betting:set_position(start_x, 0)

	local _, _, _, h = text_betting:text_rect()

	text_betting:set_h(h)

	self._betting_panel = self._main_panel:panel({
		layer = 1,
		y = text_betting:bottom(),
		w = width,
		h = height
	})

	self._betting_panel:set_x(text_betting:x())
	BoxGuiObject:new(self._betting_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	local text_options = self._main_panel:panel({
		layer = 1,
		w = width - option_size,
		h = self.item_panel:h()
	})

	text_options:set_x(self._betting_panel:x())
	text_options:set_y(self.item_panel:y())

	local betting_titles = {
		{
			id = "bet",
			text = "menu_bet_item"
		},
		{
			id = "rolls",
			text = "menu_rolls_item"
		},
		{
			id = "prefer",
			text = "menu_casino_option_prefer_title"
		},
		{
			id = "infamous",
			text = "menu_casino_option_infamous_title"
		},
		{
			id = "safecards",
			text = "menu_casino_option_safecard_title"
		},
		{
			skip = true
		},
		{
			skip = true
		}
	}
	
	self._betting_titles = {}
	local i = 1
	local y = 0

	for _, item in ipairs(self.row_items) do
		if item.type ~= "divider" then
			if not betting_titles[i].skip then
				self._betting_titles[betting_titles[i].id] = text_options:text({
					align = "right",
					blend_mode = "add",
					text = managers.localization:to_upper_text(betting_titles[i].text),
					y = y,
					x = -10,
					font_size = small_font_size,
					font = small_font,
					color = tweak_data.screen_colors.text
				})
			end

			i = i + 1
		end

		y = y + item.gui_panel:h()
	end

	self._betting_carddeck = {
		textures = "upcard_pattern",
		colors = "upcard_color",
		materials = "upcard_material",
		weapon_mods = "upcard_weapon",
		cash = "upcard_cash",
		masks = "upcard_mask",
		xp = "upcard_xp",
		none = "downcard_overkill_deck"
	}
	self._betting_cards_panel = self._betting_panel:panel({
		layer = 1,
		x = content_offset,
		y = content_offset + 15,
		w = self._betting_panel:w() - content_offset * 2
	})

	self._betting_cards_panel:set_h((self.item_panel:y() - content_offset * 2) * 0.6)

	local texture, rect, coords = tweak_data.hud_icons:get_icon_data(self._betting_carddeck.none)
	self._betting_cards = {}

	for i = 1, 3 do
		self._betting_cards[i] = self._betting_cards_panel:bitmap({
			name = "upcard",
			halign = "scale",
			blend_mode = "add",
			valign = "scale",
			layer = 1,
			texture = texture,
			w = math.round(0.7111111111111111 * self._betting_cards_panel:h()),
			h = self._betting_cards_panel:h()
		})

		self._betting_cards[i]:set_rotation(math.random(14) - 7)
		self._betting_cards[i]:set_visible(MenuCallbackHandler:casino_betting_visible())
	end

	self:_set_cards(0)

	self._stats_panel = self._main_panel:panel({
		layer = 1,
		x = text_betting:x(),
		y = text_betting:bottom(),
		w = width,
		h = height / 2 - space_y / 2
	})

	self._stats_panel:set_x(self._betting_panel:right() + space_x)
	BoxGuiObject:new(self._stats_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	local text_stats = self._main_panel:text({
		blend_mode = "add",
		text = managers.localization:to_upper_text("menu_casino_title_stats"),
		font_size = medium_font_size,
		font = medium_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, _, h = text_stats:text_rect()

	text_stats:set_h(h)
	text_stats:set_x(self._stats_panel:x())
	text_stats:set_bottom(self._betting_panel:top())

	self._stats_cards = {
		"xp",
		"cash",
		"weapon_mods",
		"masks",
		"materials",
		"textures",
		"colors"
	}
	local stat_columns = {
		{
			name = "base",
			color = Color(0.5, 0.5, 0.5),
			color_inf = Color(1, 0.1, 1)
		},
		{
			name = "bets",
			color = tweak_data.screen_colors.risk
		},
		{
			name = "skill",
			color = tweak_data.screen_colors.resource
		},
		{
			name = "total",
			color = tweak_data.screen_colors.text,
			color_inf = Color(1, 0.1, 1)
		}
	}
	self._stat_values = {}
	local title_width = 150
	local column_width = 70
	local text_panel = nil
	local x = title_width + column_width * 0.55
	local y = content_offset

	for _, column in pairs(stat_columns) do
		self._stats_panel:text({
			blend_mode = "add",
			text = managers.localization:to_upper_text("menu_casino_stat_" .. column.name),
			x = x,
			y = y,
			font_size = small_font_size,
			font = small_font,
			color = column.color or tweak_data.screen_colors.text
		})

		x = x + column_width
	end

	y = content_offset + small_font_size + 10

	for _, stat in pairs(self._stats_cards) do
		self._stat_values[stat] = {}
		x = title_width

		for _, column in pairs(stat_columns) do
			text_panel = self._stats_panel:panel({
				layer = 1,
				x = x,
				y = y,
				w = column_width,
				h = small_font_size
			})
			self._stat_values[stat][column.name] = text_panel:text({
				blend_mode = "add",
				alpha = 1,
				align = "right",
				font_size = small_font_size,
				font = small_font,
				color = column.color or tweak_data.screen_colors.text
			})
			x = x + column_width
		end

		y = y + small_font_size
	end

	y = content_offset + small_font_size + 10

	for _, stat in pairs(self._stats_cards) do
		text_panel = self._stats_panel:panel({
			x = 0,
			layer = 1,
			y = y,
			w = title_width,
			h = small_font_size
		})
		self._stat_values[stat].title = text_panel:text({
			blend_mode = "add",
			align = "right",
			alpha = 1,
			text = managers.localization:to_upper_text("menu_casino_stat_" .. stat),
			font_size = small_font_size,
			font = small_font,
			color = tweak_data.screen_colors.text
		})
		y = y + small_font_size
	end

	self._infamous_values = {}
	y = y + small_font_size
	text_panel = self._stats_panel:panel({
		x = 0,
		layer = 1,
		y = y,
		w = title_width,
		h = small_font_size
	})

	text_panel:text({
		blend_mode = "add",
		align = "right",
		text = managers.localization:to_upper_text("bm_global_value_infamous"),
		font_size = small_font_size,
		font = small_font,
		color = Color(1, 0.1, 1)
	})

	x = title_width

	for _, column in pairs(stat_columns) do
		text_panel = self._stats_panel:panel({
			layer = 1,
			x = x,
			y = y,
			w = column_width,
			h = small_font_size
		})
		self._infamous_values[column.name] = text_panel:text({
			blend_mode = "add",
			align = "right",
			font_size = small_font_size,
			font = small_font,
			color = column.color_inf or column.color or tweak_data.screen_colors.text,
			alpha = column.alpha or 1
		})
		x = x + column_width
	end

	local stars = managers.experience:level_to_stars()
	local item_pc = tweak_data.lootdrop.STARS[stars].pcs[1]
	local skip_types = {
		xp = true,
		cash = true
	}
	local droppable_items = managers.lootdrop:droppable_items(item_pc, true, skip_types)
	local pc = stars * 10
	local weighted_type_chance = tweak_data.lootdrop.WEIGHTED_TYPE_CHANCE[pc]
	local sum = 0

	for type, items in pairs(droppable_items) do
		sum = sum + weighted_type_chance[type]
	end

	self._base_chances = {}

	for _, item in pairs(self._stats_cards) do
		self._base_chances[item] = 0
	end

	for type, items in pairs(droppable_items) do
		self._base_chances[type] = self:_round_value(weighted_type_chance[type] / sum * 100)
	end

	for _, stat in pairs(self._stats_cards) do
		
		local value = string.format(MenuNodeCrimenetCasinoGui.PRECISION, self._base_chances[stat])

		self._stat_values[stat].base:set_text(value .. "%")
		self._stat_values[stat].total:set_text(value .. "%")
	end

	local items_total = 0
	local items_infamous = 0

	for type, items in pairs(droppable_items) do
		items_total = items_total + #items

		for _, item in pairs(items) do
			if item.global_value == "infamous" then
				items_infamous = items_infamous + 1
			end
		end
	end

	local _, infamous_base_chance, infamous_mod = managers.lootdrop:infamous_chance({
		disable_difficulty = true
	})
	local infamous_chance = items_total > 0 and infamous_base_chance * items_infamous / items_total or 0
	self._infamous_chance = {
		base = infamous_chance,
		skill = infamous_mod
	}
	local value = self:_round_value(infamous_chance * 100)
	local skill = self:_round_value((infamous_chance * infamous_mod - infamous_chance) * 100)
	self._infamous_chance.value_base = value
	self._infamous_chance.value_skill = skill

	self._infamous_values.base:set_text(string.format(MenuNodeCrimenetCasinoGui.PRECISION, value) .. "%")
	self._infamous_values.skill:set_text(infamous_mod > 1 and "+" .. string.format(MenuNodeCrimenetCasinoGui.PRECISION, skill) .. "%" or "")
	self._infamous_values.total:set_text(string.format(MenuNodeCrimenetCasinoGui.PRECISION, value + skill) .. "%")

	self._breakdown_panel = self._main_panel:panel({
		layer = 1,
		w = width,
		h = self._betting_panel:h() - self._stats_panel:h() - space_y
	})

	self._breakdown_panel:set_x(self._stats_panel:x())
	self._breakdown_panel:set_top(self._stats_panel:bottom() + space_y)
	BoxGuiObject:new(self._breakdown_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	local text_breakdown = self._main_panel:text({
		blend_mode = "add",
		text = managers.localization:to_upper_text("menu_casino_title_breakdown"),
		font_size = medium_font_size,
		font = medium_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, _, h = text_breakdown:text_rect()

	text_breakdown:set_h(h)
	text_breakdown:set_x(self._breakdown_panel:x())
	text_breakdown:set_bottom(self._breakdown_panel:top())

	self._breakdown_titles = self._breakdown_panel:text({
		blend_mode = "add",
		x = content_offset,
		y = content_offset,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	self._breakdown_costs = self._breakdown_panel:text({
		blend_mode = "add",
		x = self._breakdown_panel:w() * 0.4,
		y = content_offset,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.risk
	})
	self._offshore_text = self._main_panel:text({
		blend_mode = "add",
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})

	self:set_offshore_text()

	local _, _, w, h = self._offshore_text:text_rect()

	self._offshore_text:set_h(h)
	self._offshore_text:set_x(self._betting_panel:x())
	self._offshore_text:set_y(self._betting_panel:bottom() + h + 16)

	local secured_cards = 0
	local increase_infamous = false
	local preferred_card = "none"
	local text_string = managers.localization:to_upper_text("menu_casino_total_bet", {
		casino_bet = managers.experience:cash_string(managers.money:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card))
	})
	self._total_bet = self._panel:text({
		blend_mode = "add",
		align = "right",
		text = text_string,
		font_size = large_font_size,
		font = large_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, _, h = self._total_bet:text_rect()

	self._total_bet:set_h(h)
	self._total_bet:set_right(self._breakdown_panel:right())
	self._total_bet:set_y(self._betting_panel:bottom() + h + 16)
	self:set_update_values(preferred_card, secured_cards, increase_infamous, false, false)
end

function MenuNodeCrimenetCasinoGui:set_update_values(preferred_card, secured_cards, increase_infamous, infamous_enabled, safecards_enabled)
	local node = managers.menu:active_menu() and managers.menu:active_menu().logic:selected_node()
	local currency = node and node:item("bet_item") and node:item("bet_item"):value() or "offshore"
	local sell_items = currency == "sell_items"
	
	local function set_cost(value)
		return currency == "coins" and managers.experience:experience_string(value / 100000) or managers.experience:cash_string(value)
	end
	
	local breakdown_titles = ""
	local breakdown_costs = ""
	
	local function breakdown_setup(title, cost)
		breakdown_titles = breakdown_titles .. "\n" .. managers.localization:to_upper_text(title) .. ":"
		breakdown_costs = breakdown_costs .. "\n" .. set_cost(cost)
	end
	
	if not sell_items then
		breakdown_setup("menu_casino_cost_fee", managers.money:get_cost_of_casino_entrance())
		
		if preferred_card ~= "none" then
			breakdown_setup("menu_casino_option_prefer_title", tweak_data:get_value("casino", "prefer_cost"))
		end

		if increase_infamous then
			breakdown_setup("menu_casino_option_infamous_title", tweak_data:get_value("casino", "infamous_cost"))
		end

		if secured_cards > 0 then
			breakdown_titles = breakdown_titles .. "\n" .. managers.localization:to_upper_text("menu_casino_option_safecard_title") .. ":"

			for i = 1, secured_cards do
				breakdown_costs = breakdown_costs .. "\n" .. set_cost(tweak_data:get_value("casino", "secure_card_cost", i))
			end
		end
	end

	self._breakdown_titles:set_text(breakdown_titles)
	self._breakdown_costs:set_text(breakdown_costs)

	local payout = nil
	if sell_items then
		_, _, payout = managers.lootdrop:get_stashed_items(node and node:item("preferred_item") and node:item("preferred_item"):value() or "none")
		payout = managers.experience:cash_string(payout)
	end

	local text_string = managers.localization:to_upper_text(sell_items and "menu_casino_total_sell" or "menu_casino_total_bet", {
		casino_bet = payout or set_cost(managers.money:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card, node and node:item("rolls_item") and node:item("rolls_item"):value() or 1))
	})

	self._total_bet:set_text(text_string)

	local nbr_types = 0

	for _, card in pairs(self._stats_cards) do
		for _, item in pairs(self._stat_values[card]) do
			item:set_alpha((secured_cards == 0 or preferred_card == "none") and 1 or 0.5)
		end

		nbr_types = nbr_types + ((self._base_chances[card] > 0 or card == preferred_card) and 1 or 0)
	end

	if sell_items or preferred_card == "none" then
		for _, card in pairs(self._stats_cards) do
			self._stat_values[card].bets:set_text("")
			self._stat_values[card].total:set_text(string.format(MenuNodeCrimenetCasinoGui.PRECISION, self._base_chances[card]) .. "%")
		end

		self:_set_cards(0)
	elseif nbr_types > 1 then
		local secured_value = 100 * secured_cards
		local preferred_chance = tweak_data:get_value("casino", "prefer_chance") * 100 * (3 - secured_cards)
		local preferred_left = preferred_chance / (nbr_types - 1)

		for _, card in pairs(self._stats_cards) do
			local non_secured_value = self._base_chances[card] * (3 - secured_cards)

			if preferred_card ~= "none" then
				non_secured_value = non_secured_value + (card == preferred_card and preferred_chance or -preferred_left)

				if non_secured_value < 0 then
					non_secured_value = 0
				end
			end

			local value = (non_secured_value + (card == preferred_card and secured_value or 0)) / 3 - self._base_chances[card]
			value = self:_round_value(value)

			self._stat_values[card].bets:set_text(value == 0 and "" or (value > 0 and "+" .. string.format(MenuNodeCrimenetCasinoGui.PRECISION, value) or string.format(MenuNodeCrimenetCasinoGui.PRECISION, value)) .. "%")
			self._stat_values[card].total:set_text(string.format(MenuNodeCrimenetCasinoGui.PRECISION, value + self._base_chances[card]) .. "%")

			if card == preferred_card then
				for _, item in pairs(self._stat_values[card]) do
					item:set_alpha(1)
				end
			end
		end

		self:_set_cards(secured_cards, secured_cards > 0 and self._betting_carddeck[preferred_card])
	end

	local base_value = self._infamous_chance.value_base + self._infamous_chance.value_skill
	local bets_value = increase_infamous and self:_round_value(base_value * tweak_data:get_value("casino", "infamous_chance") - base_value) or 0

	self._infamous_values.bets:set_text(increase_infamous and "+" .. string.format(MenuNodeCrimenetCasinoGui.PRECISION, bets_value) .. "%" or "")
	self._infamous_values.total:set_text(string.format(MenuNodeCrimenetCasinoGui.PRECISION, base_value + bets_value) .. "%")

	if self._betting_titles.safecards then
		self._betting_titles.safecards:set_alpha(safecards_enabled and 1 or 0.5)
	end

	if self._betting_titles.infamous then
		self._betting_titles.infamous:set_alpha(infamous_enabled and 1 or 0.5)
	end
	
	if self._betting_titles.bet then
		self._betting_titles.bet:set_text(managers.localization:to_upper_text(sell_items and "menu_disposal_item" or "menu_bet_item"))
	end
	
	if self._betting_titles.rolls then
		self._betting_titles.rolls:set_text(managers.localization:to_upper_text(sell_items and "menu_sell_payout_item" or "menu_rolls_item"))
	end
	
	if self._betting_titles.prefer then
		self._betting_titles.prefer:set_text(managers.localization:to_upper_text(sell_items and "menu_casino_sell_prefer_title" or "menu_casino_option_prefer_title"))
	end
	
	self:set_offshore_text()
end

function MenuNodeCrimenetCasinoGui:set_offshore_text()
	local node = managers.menu:active_menu() and managers.menu:active_menu().logic:selected_node()
	local currency = node and node:item("bet_item") and node:item("bet_item"):value() or "offshore"
	if currency == "cash" or currency == "sell_items" then
		self._offshore_text:set_text(managers.localization:to_upper_text("menu_cash", {money = managers.experience:cash_string(managers.money:total())}):gsub("##", ""))
	elseif currency == "coins" then
		self._offshore_text:set_text(managers.localization:to_upper_text("menu_es_coins_progress") .. ": " .. managers.experience:experience_string(managers.custom_safehouse:coins()))
	else
		self._offshore_text:set_text(managers.localization:to_upper_text("menu_offshore_account") .. ": " .. managers.experience:cash_string(managers.money:offshore()))
	end
end