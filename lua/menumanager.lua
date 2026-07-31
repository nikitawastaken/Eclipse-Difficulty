-- Auto Daily-Skin Dropper by Dr_Newbie (temporary workaround for the card drop issue caused by skin drops)
Hooks:Add("MenuManagerOnOpenMenu", "F_" .. Idstring("MenuManagerOnOpenMenu:Auto Daily-Skin Dropper"):key(), function(self, menu)
	if (menu == "menu_main" or menu == "lobby") and managers.network and managers.network.account then
		DelayedCalls:Add("F_" .. Idstring("DelayedCalls:Auto Daily-Skin Dropper"):key(), 1, function()
			_G.DailySkinDrops = _G.DailySkinDrops or {}
			function DailySkinDrops:Ask()
				if managers.network.account:inventory_reward(callback(DailySkinDrops, DailySkinDrops, "Result")) then
					--True
				else
					--False
				end
			end
			function DailySkinDrops:Result()
				--Why?
			end
			DailySkinDrops:Ask()
		end)
	end
end)

--# selene: allow(mixed_table)
function MenuCallbackHandler:is_contract_difficulty_allowed(item)
	if not managers.menu:active_menu() then
		return false
	end
	if not managers.menu:active_menu().logic then
		return false
	end
	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end
	if not managers.menu:active_menu().logic:selected_node():parameters().menu_component_data then
		return false
	end
	local job_data = managers.menu:active_menu().logic:selected_node():parameters().menu_component_data
	if not job_data.job_id then
		return false
	end
	if job_data.professional and item:value() < 3 then
		return false
	end
	local job_jc = tweak_data.narrative:job_data(job_data.job_id).jc
	local difficulty_jc = (item:value() - 2) * 10
	local plvl = managers.experience:current_level()
	local level_lock = tweak_data.difficulty_level_locks[item:value()] or 0
	local is_not_level_locked = plvl >= level_lock
	return is_not_level_locked
end

function MenuCrimeNetFiltersInitiator:update_node(node)
	if MenuCallbackHandler:is_win32() then
		local not_friends_only = not Global.game_settings.search_friends_only

		node:item("toggle_new_servers_only"):set_enabled(not_friends_only)
		node:item("toggle_server_state_lobby"):set_enabled(not_friends_only)
		node:item("toggle_job_appropriate_lobby"):set_enabled(not_friends_only)
		node:item("toggle_mutated_lobby"):set_enabled(not_friends_only)
		node:item("max_lobbies_filter"):set_enabled(not_friends_only)
		node:item("server_filter"):set_enabled(not_friends_only)
		node:item("kick_option_filter"):set_enabled(not_friends_only)
		node:item("job_id_filter"):set_enabled(not_friends_only)
		node:item("job_plan_filter"):set_enabled(not_friends_only)
		node:item("toggle_job_appropriate_lobby"):set_visible(self:is_standard())
		node:item("toggle_allow_safehouses"):set_visible(self:is_standard())
		node:item("toggle_mutated_lobby"):set_visible(self:is_standard())
		node:item("toggle_one_down_lobby"):set_visible(self:is_standard())
		node:item("difficulty_filter"):set_visible(false)
		node:item("difficulty"):set_visible(self:is_standard())
		node:item("job_id_filter"):set_visible(self:is_standard())
		node:item("max_spree_difference_filter"):set_visible(self:is_crime_spree())
		node:item("skirmish_wave_filter"):set_visible(self:is_skirmish())
		node:item("job_plan_filter"):set_visible(not self:is_skirmish())
	elseif MenuCallbackHandler:is_xb1() then
		if Global.game_settings.search_crimespree_lobbies then
			print("GN: CS lobby set to true")
			node:item("difficulty_filter"):set_enabled(false)
			node:item("max_spree_difference_filter"):set_enabled(true)
		else
			print("GN: CS lobby set to false")
			node:item("difficulty_filter"):set_enabled(true)
			node:item("max_spree_difference_filter"):set_enabled(false)
		end

		if Global.game_settings.search_crimespree_lobbies then
			node:item("toggle_mutated_lobby"):set_enabled(false)
		elseif Global.game_settings.search_mutated_lobbies then
			node:item("toggle_crimespree_lobby"):set_enabled(false)
		else
			node:item("toggle_mutated_lobby"):set_enabled(true)
			node:item("toggle_crimespree_lobby"):set_enabled(true)
		end
	end
end

function MenuCrimeNetFiltersInitiator:add_filters(node)
	if node:item("divider_end") then
		return
	end

	local params = {
		callback = "choice_difficulty_filter",
		name = "difficulty",
		text_id = "menu_diff_filter",
		help_id = "menu_diff_help",
		filter = true,
	}
	local data_node = {
		{
			value = -1,
			text_id = "menu_any",
			_meta = "option",
		},
		{
			value = 2,
			text_id = "menu_difficulty_normal",
			_meta = "option",
		},
		{
			value = 3,
			text_id = "menu_difficulty_hard",
			_meta = "option",
		},
		{
			value = 4,
			text_id = "menu_difficulty_very_hard",
			_meta = "option",
		},
		{
			value = 5,
			text_id = "menu_difficulty_overkill",
			_meta = "option",
		},
		{
			value = 6,
			text_id = "menu_difficulty_easy_wish",
			_meta = "option",
		},
		type = "MenuItemMultiChoice",
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_value(managers.network.matchmake:difficulty_filter())
	node:add_item(new_item)

	local item_params = {
		visible_callback = "is_multiplayer is_win32",
		name = "job_id_filter",
		callback = "choice_job_id_filter",
		text_id = "menu_job_id_filter",
		filter = true,
	}
	local data_node = {
		{
			value = -1,
			text_id = "menu_any",
			_meta = "option",
		},
		type = "MenuItemMultiChoice",
	}

	for index, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
		local job_tweak = tweak_data.narrative.jobs[job_id]
		local contact = job_tweak.contact
		local contact_tweak = tweak_data.narrative.contacts[contact]
		local is_hidden = (job_tweak.hidden or contact_tweak and contact_tweak.hidden) and not job_tweak.show_in_filters
		local allow = not job_tweak.wrapped_to_job and not is_hidden

		if allow then
			local text_id, color_data = tweak_data.narrative:create_job_name(job_id)
			local params = {
				localize = false,
				_meta = "option",
				text_id = text_id,
				value = index,
			}

			for count, color in ipairs(color_data) do
				params["color" .. count] = color.color
				params["color_start" .. count] = color.start
				params["color_stop" .. count] = color.stop
			end

			table.insert(data_node, params)
		end
	end

	local new_item = node:create_item(data_node, item_params)

	new_item:set_value(managers.network.matchmake:get_lobby_filter("job_id") or -1)
	node:add_item(new_item)

	local kick_params = {
		visible_callback = "is_multiplayer is_win32",
		name = "kick_option_filter",
		callback = "choice_kick_option",
		text_id = "menu_kicking_allowed_filter",
		filter = true,
	}
	local data_node = {
		{
			value = -1,
			text_id = "menu_any",
			_meta = "option",
		},
		type = "MenuItemMultiChoice",
	}
	local kick_filters = {
		{
			value = 1,
			text_id = "menu_kick_server",
		},
		{
			value = 2,
			text_id = "menu_kick_vote",
		},
		{
			value = 0,
			text_id = "menu_kick_disabled",
		},
	}

	for _, filter in ipairs(kick_filters) do
		table.insert(data_node, {
			_meta = "option",
			text_id = filter.text_id,
			value = filter.value,
		})
	end

	local new_item = node:create_item(data_node, kick_params)

	new_item:set_value(managers.network.matchmake:get_lobby_filter("kick_option") or -1)
	node:add_item(new_item)

	local divider_params = {
		size = 8,
		name = "divider_end",
		no_text = true,
	}
	local data_node = {
		type = "MenuItemDivider",
	}
	local new_item = node:create_item(data_node, divider_params)

	node:add_item(new_item)

	local reset_params = {
		callback = "_reset_filters",
		name = "reset_filters",
		align = "right",
		text_id = "dialog_reset_filters",
	}
	local data_node = {}
	local new_item = node:create_item(data_node, reset_params)

	node:add_item(new_item)
	self:modify_node(node, {})
end

-- Max progression and max mask customization, thanks gorg
Hooks:Add("MenuManagerBuildCustomMenus", "restoreBtnsMainMenu", function(_, nodes)
	local adv_options = nodes.adv_options
	if not adv_options then
		return
	end

	local params = {
		name = "select_max_progress_btn",
		text_id = "menu_max_progress",
		help_id = "menu_max_progress_help",
		callback = "max_progress_msg",
	}

	local new_item = adv_options:create_item(data, params)
	new_item.dirty_callback = callback(adv_options, adv_options, "item_dirty")
	if adv_options.callback_handler then
		new_item:set_callback_handler(adv_options.callback_handler)
	end

	local position = 10
	table.insert(adv_options._items, position, new_item)

	params = {
		name = "select_max_masks_btn",
		text_id = "menu_max_masks",
		help_id = "menu_max_masks_help",
		callback = "max_masks_msg",
	}

	new_item = adv_options:create_item(data, params)
	new_item.dirty_callback = callback(adv_options, adv_options, "item_dirty")
	if adv_options.callback_handler then
		new_item:set_callback_handler(adv_options.callback_handler)
	end

	position = 10
	table.insert(adv_options._items, position, new_item)
end)

function MenuCallbackHandler:max_progress_msg()
	local dialog_data = {
		title = managers.localization:text("dialog_warning_title"),
		text = managers.localization:text("menu_progress_msg", {}),
		focus_button = 1,
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "max_progress", index),
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = idk,
		cancel_button = true,
	}
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:max_masks_msg()
	local dialog_data = {
		title = managers.localization:text("dialog_warning_title"),
		text = managers.localization:text("menu_masks_msg", {}),
		focus_button = 1,
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "max_masks", index),
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = idk,
		cancel_button = true,
	}
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:max_progress()
	for i = managers.experience:current_level(), 99 do
		managers.experience:_level_up()
	end
	managers.experience:set_current_rank(Eclipse.settings.max_progression_infamy)
	managers.infamy:_set_points(managers.experience:current_rank())
	managers.money:_set_offshore(99999999999999 ^ 20)
	managers.money:_set_total(99999999999999 ^ 20)
	managers.custom_safehouse:add_coins(99999999999999 ^ 20)
	managers.skilltree:give_specialization_points(99999999999999 ^ 20)

	for name, item in pairs(tweak_data.blackmarket.weapon_mods) do
		if not item.dlc or managers.dlc:is_dlc_unlocked(item.dlc) then
			for i = 1, 100 do
				managers.blackmarket:add_to_inventory(item.dlc or "normal", "weapon_mods", name)
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.masks) do
		if name ~= "character_locked" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(item.dlc, "masks", name)
				end
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "masks", name)
				end
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.materials) do
		if name ~= "plastic" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				local global_value = item.infamous and "infamous" or item.global_value or item.dlc
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "materials", name)
				end
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "materials", name)
				end
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.textures) do
		if name ~= "no_color_no_material" and name ~= "no_color_full_material" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				local global_value = item.infamous and "infamous" or item.global_value or item.dlc
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "textures", name)
				end
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "textures", name)
				end
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.colors) do
		if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
			local global_value = item.infamous and "infamous" or item.global_value or item.dlc
			for i = 1, 10 do
				managers.blackmarket:add_to_inventory(global_value, "colors", name)
			end
		else
			local global_value = item.infamous and "infamous" or item.global_value or "normal"
			for i = 1, 10 do
				managers.blackmarket:add_to_inventory(global_value, "colors", name)
			end
		end
	end
end

function MenuCallbackHandler:max_masks()
	for name, item in pairs(tweak_data.blackmarket.masks) do
		if name ~= "character_locked" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(item.dlc, "masks", name)
				end
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "masks", name)
				end
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.materials) do
		if name ~= "plastic" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				local global_value = item.infamous and "infamous" or item.global_value or item.dlc
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "materials", name)
				end
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "materials", name)
				end
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.textures) do
		if name ~= "no_color_no_material" and name ~= "no_color_full_material" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				local global_value = item.infamous and "infamous" or item.global_value or item.dlc
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "textures", name)
				end
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				for i = 1, 10 do
					managers.blackmarket:add_to_inventory(global_value, "textures", name)
				end
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.colors) do
		if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
			local global_value = item.infamous and "infamous" or item.global_value or item.dlc
			for i = 1, 10 do
				managers.blackmarket:add_to_inventory(global_value, "colors", name)
			end
		else
			local global_value = item.infamous and "infamous" or item.global_value or "normal"
			for i = 1, 10 do
				managers.blackmarket:add_to_inventory(global_value, "colors", name)
			end
		end
	end
end

-- remove the functionality of pro jobs disabling level restarts
function MenuCallbackHandler:_restart_level_visible()
	if not self:is_multiplayer() or managers.job:stage_success() then
		return false
	end

	-- if self:is_prof_job() then
	-- 	return false
	-- end

	local state = game_state_machine:current_state_name()

	return state ~= "ingame_waiting_for_players" and state ~= "ingame_lobby_menu" and state ~= "empty"
end

function MenuCallbackHandler:singleplayer_restart()
	return self:is_singleplayer()
		and self:has_full_game() --[[and self:is_normal_job()]]
		and not managers.job:stage_success()
end

-- Remove vanilla DW and DS from Safehouse Raid
function MenuCrimeNetContactChillInitiator:modify_node(original_node, data)
	local node = original_node

	node:clean_items()

	local params = {
		callback = "_on_chill_change_difficulty",
		name = "difficulty",
		text_id = "menu_lobby_difficulty_title",
		help_id = "menu_diff_help",
		filter = true,
	}
	local data_node = {
		{
			value = "normal",
			text_id = "menu_difficulty_normal",
			_meta = "option",
		},
		{
			value = "hard",
			text_id = "menu_difficulty_hard",
			_meta = "option",
		},
		{
			value = "overkill",
			text_id = "menu_difficulty_very_hard",
			_meta = "option",
		},
		{
			value = "overkill_145",
			text_id = "menu_difficulty_overkill",
			_meta = "option",
		},
		{
			value = "easy_wish",
			text_id = "menu_difficulty_easy_wish",
			_meta = "option",
		},
		type = "MenuItemMultiChoice",
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		callback = "_on_chill_change_one_down",
		name = "toggle_one_down",
		text_id = "menu_toggle_one_down",
	}
	data_node = {
		{
			w = "24",
			y = "0",
			h = "24",
			s_y = "24",
			value = "on",
			s_w = "24",
			s_h = "24",
			s_x = "24",
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = "24",
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = "24",
			y = "0",
			h = "24",
			s_y = "24",
			value = "off",
			s_w = "24",
			s_h = "24",
			s_x = "0",
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = "0",
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	new_item = node:create_item(data_node, params)

	new_item:set_value("off")
	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		callback = "play_chill_combat",
		name = "CustomSafeHouseDefendBtn",
		align = "left",
		text_id = "menu_cn_chill_combat_defend",
	}
	data_node = {}
	new_item = node:create_item(data_node, params)

	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		callback = "ignore_chill_combat",
		name = "CustomSafeHouseIgnoreBtn",
		align = "left",
		text_id = "menu_cn_chill_combat_ignore_defend",
	}
	data_node = {}
	new_item = node:create_item(data_node, params)

	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		visible_callback = "is_pc_controller",
		name = "back",
		last_item = "true",
		text_id = "menu_back",
		align = "left",
		previous_node = "true",
	}
	data_node = {}
	new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name(self.DEFAULT_ITEM)
	node:select_item(self.DEFAULT_ITEM)

	return node
end

-- Offshore casino rework
function MenuCrimeNetCasinoInitiator:refresh_node(node)
	local options = {
		bet = node:item("bet_item"):value(),
		rolls = node:item("rolls_item"):value(),
		preferred = node:item("preferred_item"):value(),
		infamous = node:item("increase_infamous"):value(),
	}

	node:clean_items()
	self:_create_items(node, options)

	return node
end

function MenuCrimeNetCasinoInitiator:_create_items(node, options)
	local visible_callback = "casino_betting_visible"
	local bet_data = {
		{
			value = "offshore",
			text_id = "menu_bet_offshore",
			_meta = "option",
		},
		{
			value = "cash",
			text_id = "menu_bet_cash",
			_meta = "option",
		},
		type = "MenuItemMultiChoice",
	}

	if managers.custom_safehouse then
		table.insert(bet_data, {
			value = "coins",
			text_id = "menu_bet_coins",
			_meta = "option",
		})
	end

	table.insert(bet_data, {
		value = "sell_items",
		text_id = "menu_sell_items",
		_meta = "option",
	})

	local bet_params = {
		name = "bet_item",
		callback = "crimenet_casino_update",
		text_id = "",
		visible_callback = visible_callback,
	}
	local bet_item = node:create_item(bet_data, bet_params)
	bet_item:set_value(options and options.bet or "offshore")

	node:add_item(bet_item)

	self:create_divider(node, "casino_divider_bet", nil, 12)

	local sell_items = options and options.bet and options.bet == "sell_items"
	local card1 = options and options.card1 == "on" and 1 or 0
	local card2 = options and options.card2 == "on" and 1 or 0
	local card3 = options and options.card3 == "on" and 1 or 0
	local secure_cards = card1 + card2 + card3
	local _, max_bets = managers.money:can_afford_casino_fee(secure_cards, tostring(options and options.infamous) == "on", options and options.preferred or "none", bet_item:value())

	if sell_items then
		_, max_bets = managers.lootdrop:get_stashed_items(options and options.preferred or "none")
	end

	local rolls_data = {
		localize = false,
		show_value = true,
		step = 1,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 0,
		min = 1,
		max = max_bets,
	}

	local rolls_params = {
		name = "rolls_item",
		callback = "crimenet_casino_update_slider",
		text_id = " ",
		visible_callback = visible_callback,
	}
	local rolls_item = node:create_item(rolls_data, rolls_params)
	rolls_item:set_value(options and options.rolls or 1)

	node:add_item(rolls_item)

	local preferred_data = {
		{
			value = "none",
			text_id = sell_items and "menu_any" or "menu_casino_option_prefer_none",
			_meta = "option",
		},
		{
			value = "weapon_mods",
			text_id = "menu_casino_stat_weapon_mods",
			_meta = "option",
		},
		{
			value = "masks",
			text_id = "menu_casino_stat_masks",
			_meta = "option",
		},
		{
			value = "materials",
			text_id = "menu_casino_stat_materials",
			_meta = "option",
		},
		{
			value = "textures",
			text_id = "menu_casino_stat_textures",
			_meta = "option",
		},
		type = "MenuItemMultiChoice",
	}

	if not sell_items then
		table.insert(preferred_data, 2, {
			value = "cash",
			text_id = "menu_casino_stat_cash",
			_meta = "option",
		})

		table.insert(preferred_data, 2, {
			value = "xp",
			text_id = "menu_casino_stat_xp",
			_meta = "option",
		})
	end

	local preferred_params = {
		name = "preferred_item",
		callback = "crimenet_casino_update",
		text_id = "",
		visible_callback = visible_callback,
	}
	local preferred_item = node:create_item(preferred_data, preferred_params)

	if not sell_items and managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 1) then
		preferred_item:set_value("none")
		preferred_item:set_enabled(false)
	else
		preferred_item:set_value(options and options.preferred or "none")
	end

	node:add_item(preferred_item)

	local infamous_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local infamous_params = {
		name = "increase_infamous",
		callback = "crimenet_casino_update",
		text_id = "menu_casino_option_infamous_title",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback,
	}
	local infamous_items = {
		textures = true,
		colors = false,
		materials = true,
		weapon_mods = false,
		masks = true,
	}
	local preferred_value = preferred_item:value()
	local infamous_item = node:create_item(infamous_data, infamous_params)

	infamous_item:set_enabled(not sell_items and infamous_items[preferred_value])

	if not infamous_item:enabled() then
		infamous_item:set_value("off")
	else
		infamous_item:set_value(options and options.infamous or "off")
	end

	node:add_item(infamous_item)
	self:create_divider(node, "casino_divider_securecards")

	local card1_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local card1_params = {
		name = "secure_card_1",
		callback = "crimenet_casino_safe_card1",
		text_id = "menu_casino_option_safecard1",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback,
	}

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 1) then
		card1_params.disabled_color = Color(1, 0.6, 0.2, 0.2)
		card1_params.text_id = managers.localization:to_upper_text("menu_casino_option_safecard1")
			.. " - "
			.. managers.localization:to_upper_text("menu_casino_option_safecard_lock", {
				level = tweak_data:get_value("casino", "secure_card_level", 1),
			})
		card1_params.localize = "false"
	end

	local card1_item = node:create_item(card1_data, card1_params)

	card1_item:set_value(preferred_item:value() ~= "none" and options and options.card1 or "off")

	if sell_items or managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 1) then
		card1_item:set_enabled(false)
	else
		card1_item:set_enabled(preferred_item:value() ~= "none")
	end

	-- node:add_item(card1_item)

	local card2_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local card2_params = {
		name = "secure_card_2",
		callback = "crimenet_casino_safe_card2",
		text_id = "menu_casino_option_safecard2",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback,
	}

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 2) then
		card2_params.disabled_color = Color(1, 0.6, 0.2, 0.2)
		card2_params.text_id = managers.localization:to_upper_text("menu_casino_option_safecard2")
			.. " - "
			.. managers.localization:to_upper_text("menu_casino_option_safecard_lock", {
				level = tweak_data:get_value("casino", "secure_card_level", 2),
			})
		card2_params.localize = "false"
	end

	local card2_item = node:create_item(card2_data, card2_params)

	card2_item:set_value(preferred_item:value() ~= "none" and options and options.card2 or "off")

	if sell_items or managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 2) then
		card2_item:set_enabled(false)
	else
		card2_item:set_enabled(preferred_item:value() ~= "none")
	end

	-- node:add_item(card2_item)

	local card3_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local card3_params = {
		name = "secure_card_3",
		callback = "crimenet_casino_safe_card3",
		text_id = "menu_casino_option_safecard3",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback,
	}

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 3) then
		card3_params.disabled_color = Color(1, 0.6, 0.2, 0.2)
		card3_params.text_id = managers.localization:to_upper_text("menu_casino_option_safecard3")
			.. " - "
			.. managers.localization:to_upper_text("menu_casino_option_safecard_lock", {
				level = tweak_data:get_value("casino", "secure_card_level", 3),
			})
		card3_params.localize = "false"
	end

	local card3_item = node:create_item(card3_data, card3_params)

	card3_item:set_value(preferred_item:value() ~= "none" and options and options.card3 or "off")

	if sell_items or managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 3) then
		card3_item:set_enabled(false)
	else
		card3_item:set_enabled(preferred_item:value() ~= "none")
	end

	-- node:add_item(card3_item)
	self:create_divider(node, "casino_cost")

	local increase_infamous = infamous_item:value() == "on"
	local secured_cards = (card1_item:value() == "on" and 1 or 0) + (card2_item:value() == "on" and 1 or 0) + (card3_item:value() == "on" and 1 or 0)

	if options then
		managers.menu:active_menu().renderer:selected_node():set_update_values(preferred_item:value(), secured_cards, increase_infamous, infamous_item:enabled(), card1_item:enabled())
		managers.menu_component:can_afford()
	end
end

function MenuCallbackHandler:crimenet_casino_update_slider(item)
	if item:enabled() then
		item._value = math.round(item._value)
		local node = managers.menu:active_menu().logic:selected_node()
		local card1 = node:item("secure_card_1") and node:item("secure_card_1"):value() == "on" and 1 or 0
		local card2 = node:item("secure_card_2") and node:item("secure_card_2"):value() == "on" and 1 or 0
		local card3 = node:item("secure_card_3") and node:item("secure_card_3"):value() == "on" and 1 or 0
		local secure_cards = card1 + card2 + card3
		local infamous_item = node:item("increase_infamous")
		local preferred_card = node:item("preferred_item") and node:item("preferred_item"):value() or "none"
		local preferred_card = node:item("preferred_item") and node:item("preferred_item"):value() or "none"
		managers.menu
			:active_menu().renderer
			:selected_node()
			:set_update_values(preferred_card, secure_cards, infamous_item:value() == "on", infamous_item:enabled(), node:item("secure_card_1") and node:item("secure_card_1"):enabled())
		managers.menu_component:can_afford()
	end
end

function MenuManager:show_confirm_pay_casino_fee(params)
	local dialog_data = {
		title = managers.localization:text("dialog_casino_pay_title"),
		text = managers.localization:text(params.dialog, {
			contract_fee = params.contract_fee,
			offshore = params.offshore,
		}),
		focus_button = 2,
	}
	local yes_button = {
		text = managers.localization:text("menu_cn_casino_pay_accept"),
		callback_func = params.yes_func,
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = params.no_func,
		cancel_button = true,
	}
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:casino_betting_visible()
	return true
end

function MenuCallbackHandler:play_safehouse(params)
	local function yes_func()
		if Global.game_settings.single_player then
			Global.mission_manager.has_played_tutorial = true
			MenuCallbackHandler:play_single_player()
			MenuCallbackHandler:start_single_player_job({
				difficulty = "normal",
				job_id = "safehouse",
			})
		else
			Global.mission_manager.has_played_tutorial = true
			MenuCallbackHandler:start_job({
				difficulty = "normal",
				job_id = "safehouse",
			})
		end
	end

	if params.skip_question then
		yes_func()

		return
	end

	managers.menu:show_play_safehouse_question({
		yes_func = yes_func,
	})
end

-- Tips viewer (port of Tips and Trivia viewer mod)
_G.EclipseTipsViewer = _G.EclipseTipsViewer or {}

Hooks:Add( "MenuManagerSetupCustomMenus" , "EclipseTipsViewerMenuManagerPostSetupCustomMenus" , function( self , nodes )
	MenuHelper:NewMenu( "EclipseEclipseTipsViewerMenu" )
end )

Hooks:Add( "MenuManagerInitialize" , "EclipseTipsViewerMenuManagerPostInit" , function( self )
	MenuCallbackHandler.EclipseTipsViewerFocus = function( self , focus )
		if focus then
			EclipseTipsViewer:ShowTips()
		else
			EclipseTipsViewer:DestroyTips()
		end
	end
end )

Hooks:Add( "MenuManagerBuildCustomMenus" , "EclipseTipsViewerMenuManagerPostBuildCustomMenus" , function( self , nodes )	
	nodes[ "EclipseEclipseTipsViewerMenu" ] = MenuHelper:BuildMenu( "EclipseEclipseTipsViewerMenu" , { focus_changed_callback = "EclipseTipsViewerFocus" } )
	MenuHelper:AddMenuItem( nodes["main"] , "EclipseEclipseTipsViewerMenu" , "menu_eclipse_tips_title" , "menu_eclipse_tips_desc", "inventory", "after" )
end )

Hooks:Add( "MenuManagerPopulateCustomMenus" , "EclipseTipsViewerMenuManagerPostPopulateCustomMenus" , function( self , nodes )

	if tweak_data and tweak_data.tips then
		local data = {}
		EclipseTipsViewer.Categories = {}
		EclipseTipsViewer.TipData = {}

		for k , v in pairs( tweak_data.tips.tips ) do
			if not data[ "loading_" .. v.category .. "_title" ] then
				data[ "loading_" .. v.category .. "_title" ] = true
				table.insert( EclipseTipsViewer.Categories , v.category )
			end

			EclipseTipsViewer.TipData[ v.category ] = EclipseTipsViewer.TipData[ v.category ] or {}
			EclipseTipsViewer.TipData[ v.category ][ v.cat_index ] = v.image
		end
	end

	MenuCallbackHandler[ "EclipseTipsViewerButtonCallback" ] = function( self ) end

	MenuHelper:AddButton({
		id 			= "EclipseTipsViewerButton",
		title 		= "",
		desc 		= "",
		callback 	= "EclipseTipsViewerButtonCallback",
		menu_id 	= "EclipseEclipseTipsViewerMenu",
		localized 	= false
	})

end )

local function aligntext( object , above )
	local _ , _ , _ , h = object:text_rect()

	object:set_h( h )
	object:set_right( EclipseTipsViewer._panel:right() - 8 )

	if above then object:set_top( above ) end
end

local function alignpage()
	local _ , _ , w , h = EclipseTipsViewer._page:text_rect()

	EclipseTipsViewer._page:set_size( w , h )
	EclipseTipsViewer._page:set_center_x( EclipseTipsViewer._category:center_x() )
	EclipseTipsViewer._page:set_top( EclipseTipsViewer._text:bottom() + 4 )

	EclipseTipsViewer._prev:set_righttop( EclipseTipsViewer._page:left() , EclipseTipsViewer._page:top() )
	EclipseTipsViewer._next:set_lefttop( EclipseTipsViewer._page:right() , EclipseTipsViewer._page:top() )
end

local function alignbg()
	EclipseTipsViewer._bg:set_righttop( EclipseTipsViewer._panel:right() , EclipseTipsViewer._category:top() - 1 )
	EclipseTipsViewer._bg_blur:set_righttop( EclipseTipsViewer._panel:right() , EclipseTipsViewer._category:top() - 1 )
	EclipseTipsViewer._bg:set_h( EclipseTipsViewer._page:bottom() - EclipseTipsViewer._category:top() )
	EclipseTipsViewer._bg_blur:set_h( EclipseTipsViewer._page:bottom() - EclipseTipsViewer._category:top() )
end

function EclipseTipsViewer:ShowTips()

	EclipseTipsViewer.CategoryIndex = EclipseTipsViewer.CategoryIndex or 1
	EclipseTipsViewer.PageIndex = EclipseTipsViewer.PageIndex or 1

	if not managers.menu_component then
		return
	end

	self._panel = managers.menu_component._ws:panel():panel()

	self._bg = self._panel:rect({
		w 		= self._panel:w() * 0.35,
		h 		= 0,
		color 	= tweak_data.screen_colors.button_stage_3,
		alpha 	= 0.25,
		layer 	= 500
	})

	self._bg_blur = self._panel:bitmap({
		texture 		= "guis/textures/test_blur_df",
		w 				= self._panel:w() * 0.35,
		h 				= 0,
		layer 			= 500,
		render_template = "VertexColorTexturedBlur3D"
	})

	self._category = self._panel:text({
		name 		= "category",
		text 		= managers.localization:to_upper_text( "loading_" .. EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] .. "_title" ),
		blend_mode 	= "normal",
		w 			= ( self._panel:w() * 0.35 ) - 16,
		h 			= self._panel:h(),
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 28,
		color 		= tweak_data.screen_colors.button_stage_2,
		vertical 	= "center",
		align 		= "center",
		wrap 		= true,
		word_wrap 	= true,
		layer 		= 501
	})

	self._text = self._panel:text({
		name 		= "text",
		text 		= managers.localization:text( "loading_" .. EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] .. "_" .. EclipseTipsViewer.PageIndex ),
		blend_mode 	= "normal",
		w 			= ( self._panel:w() * 0.35 ) - 16,
		h 			= self._panel:h(),
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 24,
		color 		= tweak_data.screen_colors.button_stage_2,
		vertical 	= "center",
		align 		= "center",
		wrap 		= true,
		word_wrap 	= true,
		layer 		= 501
	})

	self._page = self._panel:text({
		name 		= "page",
		text 		= string.format( "%d / %d" , EclipseTipsViewer.PageIndex , tweak_data.tips.category_totals[ EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] ] ),
		blend_mode 	= "normal",
		w 			= self._panel:w() * 0.35,
		h 			= self._panel:h(),
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 24,
		color 		= tweak_data.screen_colors.button_stage_3,
		vertical 	= "center",
		align 		= "center",
		layer 		= 501
	})

	self._cprev = self._panel:bitmap({
		texture 		= "guis/textures/menu_arrows",
		texture_rect 	= {
							0,
							0,
							24,
							24
						},
		color 			= tweak_data.screen_colors.button_stage_3,
		w 				= 24,
		h 				= 24,
		x 				= 0,
		y 				= 0,
		layer 			= 501,
		blend_mode 		= "normal"
	})

	self._cnext = self._panel:bitmap({
		texture 		= "guis/textures/menu_arrows",
		texture_rect 	= {
							24,
							0,
							-24,
							24
						},
		color 			= tweak_data.screen_colors.button_stage_3,
		w 				= 24,
		h 				= 24,
		x 				= 0,
		y 				= 0,
		layer 			= 501,
		blend_mode 		= "normal"
	})

	self._prev = self._panel:bitmap({
		texture 		= "guis/textures/menu_arrows",
		texture_rect 	= {
							0,
							0,
							24,
							24
						},
		color 			= tweak_data.screen_colors.button_stage_3,
		w 				= 24,
		h 				= 24,
		x 				= 0,
		y 				= 0,
		layer 			= 501,
		blend_mode 		= "normal"
	})

	self._next = self._panel:bitmap({
		texture 		= "guis/textures/menu_arrows",
		texture_rect 	= {
							24,
							0,
							-24,
							24
						},
		color 			= tweak_data.screen_colors.button_stage_3,
		w 				= 24,
		h 				= 24,
		x 				= 0,
		y 				= 0,
		layer 			= 501,
		blend_mode 		= "normal"
	})

	self._image = self._panel:bitmap({
		texture = "guis/textures/loading/hints/" .. EclipseTipsViewer.TipData[ EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] ][ EclipseTipsViewer.PageIndex ],
		w 		= 192,
		h 		= 192,
		layer 	= 501
	})

	aligntext( self._category , self._panel:h() * .10 )

	self._image:set_top( self._category:bottom() )
	self._image:set_center_x( self._category:center_x() )

	aligntext( self._text , self._image:bottom() )

	self._cprev:set_lefttop( self._category:left() , self._category:top() )
	self._cnext:set_righttop( self._category:right() , self._category:top() )

	alignpage()

	alignbg()

end

function EclipseTipsViewer:DestroyTips()

	if alive( self._panel ) then

		self._panel:remove( self._category )
		self._panel:remove( self._text )
		self._panel:remove( self._page )
		self._panel:remove( self._bg )
		self._panel:remove( self._bg_blur )
		self._panel:remove( self._prev )
		self._panel:remove( self._next )
		self._panel:remove( self._cprev )
		self._panel:remove( self._cnext )
		self._panel:remove( self._image )
		self._panel:remove( self._panel )

		self._category = nil
		self._text = nil
		self._page = nil
		self._bg = nil
		self._bg_blur = nil
		self._prev = nil
		self._next = nil
		self._cprev = nil
		self._cnext = nil
		self._image = nil
		self._panel = nil

	end

end

function EclipseTipsViewer:SetCategoryIndex( index )

	if self.CategoryIndex + index < 1 then
		self.CategoryIndex = #EclipseTipsViewer.Categories
	elseif self.CategoryIndex + index > #EclipseTipsViewer.Categories then
		self.CategoryIndex = 1
	else
		self.CategoryIndex = self.CategoryIndex + index
	end

	self:SetPageIndex( 0 )

end

function EclipseTipsViewer:SetPageIndex( index )

	if self.PageIndex + index < 1 then
		self.PageIndex = tweak_data.tips.category_totals[ EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] ]
	elseif self.PageIndex + index > tweak_data.tips.category_totals[ EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] ] then
		self.PageIndex = 1
	else
		self.PageIndex = self.PageIndex + index
	end

	self:UpdateTips()

end

function EclipseTipsViewer:UpdateTips()

	if self._panel and alive( self._panel ) then
		self._category:set_text( managers.localization:to_upper_text( "loading_" .. EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] .. "_title" ) )
		self._text:set_text( managers.localization:text( "loading_" .. EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] .. "_" .. EclipseTipsViewer.PageIndex ) )
		self._page:set_text( string.format( "%d / %d" , EclipseTipsViewer.PageIndex , tweak_data.tips.category_totals[ EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] ] ) )

		self._image:set_image( "guis/textures/loading/hints/" .. EclipseTipsViewer.TipData[ EclipseTipsViewer.Categories[ EclipseTipsViewer.CategoryIndex ] ][ EclipseTipsViewer.PageIndex ] )

		aligntext( self._text , self._image:bottom() )
		alignpage()
		alignbg()
	end

end