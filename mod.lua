if not Eclipse then
	Eclipse = {
		mod_path = ModPath,
		mod_instance = ModInstance,
		save_path = SavePath .. "eclipse.json",
		logging = io.file_is_readable("mods/developer.txt"),
		required = {},
		settings = {
			ponr_assault_text = false,
			max_progression_infamy = 0,
		},
		loaded_elements = false,
	}

	function Eclipse:require(file)
		local path = self.mod_path .. "req/" .. file .. ".lua"
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

	function Eclipse:log(...)
		if self.logging then
			log("[EclipseOverhaul] " .. table.concat({ ... }, " "))
		end
	end

	function Eclipse:warn(...)
		log("[EclipseOverhaul][Warning] " .. table.concat({ ... }, " "))
	end

	function Eclipse:error(...)
		log("[EclipseOverhaul][Error] " .. table.concat({ ... }, " "))
	end

	function Eclipse:log_chat(...)
		managers.chat:_receive_message(managers.chat.GAME, "Eclipse Debug", table.concat({ ... }, " "), Color.green)
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
	Eclipse.ffo_heists = Eclipse:require("ffo_heists")
	Eclipse.scripted_enemy = Eclipse:require("scripted_enemies")
	Eclipse.preferred = Eclipse:require("preferred_groups")
	Eclipse.mission_elements = Eclipse:require("mission_elements")
	Eclipse.map_sizes = Eclipse:require("map_sizes")

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitEclipse", function(loc)
		local language_tbl = {
			[("english"):key()] = "en.txt",
			[("schinese"):key()] = "schinese.json",
			[("russian"):key()] = "ru.txt",
		}

		local language = language_tbl[SystemInfo:language():key()] or "en.txt"
		local path = Eclipse.mod_path .. "loc/" .. language
		path = io.file_is_readable(path) and path or Eclipse.mod_path .. "loc/en.txt"

		loc:load_localization_file(path)
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

		function MenuCallbackHandler:eclipse_max_progression_infamy_edit(item)
			local value = math.floor(item:value() + 0.5)

			Eclipse.settings.max_progression_infamy = value
		end

		function MenuCallbackHandler:sh_save()
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

		nodes[menu_id] = MenuHelper:BuildMenu(menu_id, { back_callback = "sh_save" })
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
