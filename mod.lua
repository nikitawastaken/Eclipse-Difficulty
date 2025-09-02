if not Eclipse then
	Eclipse = {
		mod_path = ModPath,
		mod_instance = ModInstance,
		save_path = SavePath .. "eclipse.json",
		logging = io.file_is_readable("mods/developer.txt"),
		required = {},
		settings = {
			ponr_assault_text = false,
			faction_assault_text = true,
			max_progression_infamy = 0,
			always_old_hitflash = false,
			player_styles = 1,
			flavor_text_tips = false,
			team_ai_weapons = 1,
		},
		loaded_elements = false,
	}

	function Eclipse:require(file)
		local path = self.mod_path .. "req/" .. file .. ".lua"
		return io.file_is_readable(path) and blt.vm.dofile(path)
	end

	function Eclipse:require_lua(file)
		local path = self.mod_path .. "lua/" .. file .. ".lua"
		return io.file_is_readable(path) and blt.vm.dofile(path)
	end

	function Eclipse:instance_script_patches()
		if self._instance_script_patches == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if level_id then
				self._instance_script_patches = self:require("instance_script/" .. level_id:gsub("_night$", ""):gsub("_day$", ""):gsub("_skip1$", ""):gsub("_skip2$", "")) or false
			end
		end

		return self._instance_script_patches
	end

	function Eclipse:mission_script_patches()
		if self._mission_script_patches == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if level_id then
				self._mission_script_patches = self:require("mission_script/" .. level_id:gsub("_night$", ""):gsub("_day$", ""):gsub("_skip1$", ""):gsub("_skip2$", "")) or false
			end
		end
		return self._mission_script_patches
	end

	function Eclipse:mission_script_add()
		Eclipse.loaded_elements = false
		if self._mission_script_add == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if level_id then
				self._mission_script_add = self:require("mission_script_add/" .. level_id:gsub("_night$", ""):gsub("_day$", ""):gsub("_skip1$", ""):gsub("_skip2$", "")) or false
			end
		end
		return self._mission_script_add
	end

	function Eclipse:log_console(...)
		if self.logging then
			log("[EclipseOverhaul] " .. table.concat({ ... }, " "))
		end
	end

	function Eclipse:warn_console(...)
		log("[EclipseOverhaul][Warning] " .. table.concat({ ... }, " "))
	end

	function Eclipse:error_console(...)
		log("[EclipseOverhaul][Error] " .. table.concat({ ... }, " "))
	end

	function Eclipse:log_chat(...)
		managers.chat:_receive_message(managers.chat.GAME, "Eclipse Debug", table.concat({ ... }, " "), Color.green)
	end

	function Eclipse:log_chat_interval(int, ...)
		if not self._last_chat_t or (self._last_chat_t + int) < Application:time() then
			managers.chat:_receive_message(managers.chat.GAME, "Eclipse Debug", table.concat({ ... }, " "), Color.green)
			self._last_chat_t = Application:time()
		end
	end

	function Eclipse:log_chat_unique(...)
		local vals = { ... }
		if Eclipse._old_chat_vals then
			if #Eclipse._old_chat_vals == #vals then
				for i, msg in ipairs(vals) do
					if Eclipse._old_chat_vals[i] ~= msg then
						Eclipse:log_chat(unpack(vals))
						Eclipse._old_chat_vals = vals
						break
					end
				end
			else
				Eclipse:log_chat(unpack(vals))
				Eclipse._old_chat_vals = vals
			end
		else
			Eclipse:log_chat(unpack(vals))
			Eclipse._old_chat_vals = vals
		end
	end

	Eclipse.utils = Eclipse:require("utils")
	Eclipse.scripted_enemy = Eclipse:require("scripted_enemies")
	Eclipse.access_filter = Eclipse:require("access_filter_presets")	
	Eclipse.preferred = Eclipse:require("preferred_groups")
	Eclipse.mission_elements = Eclipse:require("mission_elements")
	Eclipse.log = Eclipse:require("log")

	-- Setup networking
	Eclipse:require("networking")
	Eclipse:require("network_hooks")

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitEclipse", function(loc)
		local language_tbl = {
			[("english"):key()] = "en",
			[("schinese"):key()] = "schinese",
			[("russian"):key()] = "ru",
		}

		local language = language_tbl[SystemInfo:language():key()] or "en"
		local path = Eclipse.mod_path .. "loc/" .. language
		path = file.DirectoryExists(path) and path or Eclipse.mod_path .. "loc/en"
		local files = file.GetFiles(path .. "/")

		if files then
			for _, f in pairs(files) do
				loc:load_localization_file(path .. "/" .. f)
			end
		end
	end)

	-- Check for common mod conflicts
	Hooks:Add("MenuManagerOnOpenMenu", "MenuManagerOnOpenMenuEclipse", function()
		if Global.sh_mod_conflicts then
			return
		end

		Global.sh_mod_conflicts = {}
		local conflicting_mods = Eclipse:require("mod_conflicts") or {}
		for _, mod in pairs(BLT.Mods:Mods()) do
			if mod:IsEnabled() and conflicting_mods[mod:GetName()] then
				table.insert(Global.sh_mod_conflicts, mod:GetName())
			end
		end

		if #Global.sh_mod_conflicts > 0 then
			local message = "The following mod(s) are likely to cause unintended behavior or crashes in combination with Eclipse:\n\n"
			local buttons = {
				{
					text = "Disable conflicting mods",
					callback = function()
						for _, mod_name in pairs(Global.sh_mod_conflicts) do
							local mod = BLT.Mods:GetModByName(mod_name)
							if mod then
								mod:SetEnabled(false, true)
							end
						end
						MenuCallbackHandler:perform_blt_save()
					end,
				},
				{
					text = "Keep enabled (not recommended)",
				},
			}
			QuickMenu:new("Warning", message .. table.concat(Global.sh_mod_conflicts, "\n"), buttons, true)
		end
	end)

	-- Create settings menu
	Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusEclipse", function(_, nodes)
		local menu_id = "eclipse_menu"
		MenuHelper:NewMenu(menu_id)

		function MenuCallbackHandler:eclipse_ponr_assault_text_toggle(item)
			local enabled = (item:value() == "on")
			Eclipse.settings.ponr_assault_text = enabled
		end

		function MenuCallbackHandler:eclipse_faction_assault_text_toggle(item)
			local enabled = (item:value() == "on")
			Eclipse.settings.faction_assault_text = enabled
		end

		function MenuCallbackHandler:eclipse_max_progression_infamy_edit(item)
			local value = math.floor(item:value() + 0.5)

			Eclipse.settings.max_progression_infamy = value
		end

		function MenuCallbackHandler:eclipse_always_old_hitflash_toggle(item)
			local enabled = (item:value() == "on")
			Eclipse.settings.always_old_hitflash = enabled
		end

		function MenuCallbackHandler:eclipse_flavor_text_tips_toggle(item)
			local enabled = (item:value() == "on")
			Eclipse.settings.flavor_text_tips = enabled
		end

		function MenuCallbackHandler:eclipse_player_styles_setting(item)
			local value = item:value()

			Eclipse.settings.player_styles = value
		end

		function MenuCallbackHandler:eclipse_team_ai_weapons_setting(item)
			local value = item:value()

			Eclipse.settings.team_ai_weapons = value
		end

		function MenuCallbackHandler:eclipse_save()
			io.save_as_json(Eclipse.settings, Eclipse.save_path)
		end

		MenuHelper:AddToggle({
			id = "ponr_assault_text",
			title = "eclipse_menu_ponr_assault_text",
			desc = "eclipse_menu_ponr_assault_text_desc",
			callback = "eclipse_ponr_assault_text_toggle",
			value = Eclipse.settings.ponr_assault_text,
			menu_id = menu_id,
			priority = 100,
		})

		MenuHelper:AddToggle({
			id = "faction_assault_text",
			title = "eclipse_menu_faction_assault_text",
			desc = "eclipse_menu_faction_assault_text_desc",
			callback = "eclipse_faction_assault_text_toggle",
			value = Eclipse.settings.faction_assault_text,
			menu_id = menu_id,
			priority = 100,
		})

		MenuHelper:AddSlider({
			id = "max_progression_infamy",
			title = "eclipse_menu_max_progression_infamy",
			desc = "eclipse_menu_max_progression_infamy_desc",
			callback = "eclipse_max_progression_infamy_edit",
			value = Eclipse.settings.max_progression_infamy,
			menu_id = menu_id,
			is_percentage = false,
			show_value = true,
			min = 0,
			max = 500,
			step = 1,
			display_precision = 0,
			priority = 100,
		})

		MenuHelper:AddToggle({
			id = "always_old_hitflash",
			title = "eclipse_menu_always_old_hitflash",
			desc = "eclipse_menu_always_old_hitflash_desc",
			callback = "eclipse_always_old_hitflash_toggle",
			value = Eclipse.settings.always_old_hitflash,
			menu_id = menu_id,
			priority = 100,
		})

		MenuHelper:AddToggle({
			id = "flavor_text_tips",
			title = "eclipse_menu_flavor_text_tips",
			desc = "eclipse_menu_flavor_text_tips_desc",
			callback = "eclipse_flavor_text_tips_toggle",
			value = Eclipse.settings.flavor_text_tips,
			menu_id = menu_id,
			priority = 100,
		})

		MenuHelper:AddMultipleChoice({
			id = "player_styles",
			title = "eclipse_menu_player_styles",
			desc = "eclipse_menu_player_styles_desc",
			callback = "eclipse_player_styles_setting",
			items = {
				"eclipse_menu_player_styles_vanilla",
				"eclipse_menu_player_styles_expanded",
				"eclipse_menu_player_styles_none",
			},
			value = Eclipse.settings.player_styles,
			menu_id = menu_id,
			priority = 100,
		})

		MenuHelper:AddMultipleChoice({
			id = "team_ai_weapons",
			title = "eclipse_menu_team_ai_weapons",
			desc = "eclipse_menu_team_ai_weapons_desc",
			callback = "eclipse_team_ai_weapons_setting",
			items = {
				"eclipse_menu_team_ai_weapons_vanilla",
				"eclipse_menu_team_ai_weapons_lorefriendly",
				"eclipse_menu_team_ai_weapons_classic",
			},
			value = Eclipse.settings.team_ai_weapons,
			menu_id = menu_id,
			priority = 100,
		})

		nodes[menu_id] = MenuHelper:BuildMenu(menu_id, { back_callback = "eclipse_save" })
		MenuHelper:AddMenuItem(nodes["blt_options"], menu_id, "eclipse_menu_main")
	end)

	-- Load settings
	if io.file_is_readable(Eclipse.save_path) then
		local data = io.load_as_json(Eclipse.save_path)
		if data then
			local function merge(tbl1, tbl2)
				for k, v in pairs(tbl2) do
					if type(tbl1[k]) == type(v) then
						if type(v) == "table" then
							merge(tbl1[k], v)
						else
							tbl1[k] = v
						end
					end
				end
			end
			merge(Eclipse.settings, data)
		end
	end

	-- Notify about required game restart
	Hooks:Add("MenuManagerPostInitialize", "MenuManagerPostInitializeEclipse", function()
		Hooks:PostHook(BLTViewModGui, "clbk_toggle_enable_state", "sh_clbk_toggle_enable_state", function(self)
			if self._mod:GetName() == "Eclipse" then
				QuickMenu:new("Information", "A game restart is required to fully " .. (self._mod:IsEnabled() and "enable" or "disable") .. " all parts of Eclipse!", {}, true)
			end
		end)
	end)

	-- Disable some of "The Fixes"
	TheFixesPreventer = TheFixesPreventer or {}
	TheFixesPreventer.crash_upd_aim_coplogicattack = true
	TheFixesPreventer.fix_copmovement_aim_state_discarded = true
	TheFixesPreventer.tank_remove_recoil_anim = true
	TheFixesPreventer.fix_ai_set_attention = true
	TheFixesPreventer.tank_walk_near_players = true
	TheFixesPreventer.fix_hostages_not_moving = true
end

if RequiredScript and not Eclipse.required[RequiredScript] then
	local fname = Eclipse.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

	Eclipse.required[RequiredScript] = true
end
