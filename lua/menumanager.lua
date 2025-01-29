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
	return is_not_level_locked and managers.job:get_max_jc_for_player() >= math.clamp(job_jc + difficulty_jc, 0, 100)
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

	for index, filter in ipairs(kick_filters) do
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
Hooks:Add("MenuManagerBuildCustomMenus", "restoreBtnsMainMenu", function(menu_manager, nodes)
	local adv_options = nodes.adv_options
	if not adv_options then
		return
	end

	params = {
		name = "select_max_progress_btn",
		text_id = "menu_max_progress",
		help_id = "menu_max_progress_help",
		callback = "max_progress_msg",
	}

	new_item = adv_options:create_item(data, params)
	new_item.dirty_callback = callback(adv_options, adv_options, "item_dirty")
	if adv_options.callback_handler then
		new_item:set_callback_handler(adv_options.callback_handler)
	end

	position = 10
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
