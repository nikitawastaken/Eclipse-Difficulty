-- Max progression taken from Classic Heisting, thanks gorg yet again
Hooks:Add("MenuManagerBuildCustomMenus", "restoreBtnsMainMenu", function(menu_manager, nodes)
    local adv_options = nodes.adv_options
    if not adv_options then
        return
    end

    params = {
        name = "select_max_progress_btn",
        text_id = "menu_max_progress",
        help_id = "menu_max_progress_help",
        callback = "max_progress_msg"
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
		text = managers.localization:text("menu_progress_msg", {
		}),
		focus_button = 1
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "max_progress", index)
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = idk,
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:max_progress()
	for i=managers.experience:current_level(), 99 do managers.experience:_level_up() end
	managers.experience:set_current_rank(25) -- change this value if you want a different infamy
	managers.infamy:_set_points(managers.experience:current_rank())
	managers.money:_set_offshore(99999999999999^20)
	managers.money:_set_total(99999999999999^20)
    managers.custom_safehouse:add_coins(99999999999999^20)
	managers.skilltree:give_specialization_points(99999999999999^20)
	
	for name, item in pairs(tweak_data.blackmarket.weapon_mods) do
		if not item.dlc or managers.dlc:is_dlc_unlocked(item.dlc) then
			for i = 1, 10 do
				managers.blackmarket:add_to_inventory(item.dlc or "normal", "weapon_mods", name)
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.masks) do
		if name ~= "character_locked" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				managers.blackmarket:add_to_inventory(item.dlc, "masks", name)
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				managers.blackmarket:add_to_inventory(global_value, "masks", name)
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.materials) do
		if name ~= "plastic" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				local global_value = item.infamous and "infamous" or item.global_value or item.dlc
				managers.blackmarket:add_to_inventory(global_value, "materials", name)
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				managers.blackmarket:add_to_inventory(global_value, "materials", name)
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.textures) do
		if name ~= "no_color_no_material" and name ~= "no_color_full_material" then
			if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
				local global_value = item.infamous and "infamous" or item.global_value or item.dlc
				managers.blackmarket:add_to_inventory(global_value, "textures", name)
			else
				local global_value = item.infamous and "infamous" or item.global_value or "normal"
				managers.blackmarket:add_to_inventory(global_value, "textures", name)
			end
		end
	end
	for name, item in pairs(tweak_data.blackmarket.colors) do
		if item.dlc and managers.dlc:is_dlc_unlocked(item.dlc) then
			local global_value = item.infamous and "infamous" or item.global_value or item.dlc
			managers.blackmarket:add_to_inventory(global_value, "colors", name)
		else
			local global_value = item.infamous and "infamous" or item.global_value or "normal"
			managers.blackmarket:add_to_inventory(global_value, "colors", name)
		end
	end
end