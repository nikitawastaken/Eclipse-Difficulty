if not Eclipse then

	Eclipse = {
		severely_decreased_scaling_heists = {},
		decreased_scaling_heists = {},
		increased_scaling_heists = {},
		severely_increased_scaling_heists = {},
	}

	local log_levels = {
		"Debug",
		"Warning",
		"Error"
	}

	function Eclipse:log(level, message)
		assert(0 < level and level < 4, "Eclipse log level must be between 1-3.")
		assert(message ~= nil, "Eclipse empty log message.")

		log(string.format("Eclipse %s: %s", log_levels[level], message))
	end

	function Eclipse:log_chat(message)
		managers.chat:_receive_message(managers.chat.GAME, "Eclipse", message, Color.green)
	end
end

if not StreamHeist then

	StreamHeist = {
		mod_path = ModPath,
		mod_instance = ModInstance,
		save_path = SavePath .. "eclipse.json",
		logging = io.file_is_readable("mods/developer.txt"),
		required = {},
		settings = {
			ponr_assault_text = false,
			max_progression_infamy = 0
		},
		loaded_elements = false
	}

	function StreamHeist:require(file)
		local path = self.mod_path .. "req/" .. file .. ".lua"
		return io.file_is_readable(path) and blt.vm.dofile(path)
	end

	function StreamHeist:mission_script_patches()
		if self._mission_script_patches == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if level_id then
				self._mission_script_patches = self:require("mission_script/" .. level_id:gsub("_night$", ""):gsub("_day$", "")) or false
			end
		end
		return self._mission_script_patches
	end

	function StreamHeist:mission_script_add()
		StreamHeist.loaded_elements = false
		if self._mission_script_add == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if level_id then
				self._mission_script_add = self:require("mission_script_add/" .. level_id:gsub("_night$", ""):gsub("_day$", "")) or false
			end
		end
		return self._mission_script_add
	end

	function StreamHeist:gen_dummy(id, name, pos, rot, opts)
		opts = opts or {}
		return {
			id = id,
			editor_name = name,
			class = "ElementSpawnEnemyDummy",
			values = {
				execute_on_startup = opts.execute_on_startup or false,
				participate_to_group_ai = opts.participate_to_group_ai or false,
				position = pos,
				force_pickup = opts.force_pickup or "none",
				voice = opts.voice or 0,
				enemy = opts.enemy or "units/payday2/characters/ene_swat_1/ene_swat_1",
				trigger_times = opts.trigger_times or 0,
				spawn_action = opts.spawn_action or "none",
				accessibility = opts.accessibility or "any",
				on_executed = opts.on_executed or {},
				rotation = rot,
				team = opts.team or "default",
				base_delay = opts.base_delay or 0,
				enabled = opts.enabled or false,
				amount = opts.amount or 0,
				interval = opts.interval or 5,
			},
		}
	end

	function StreamHeist:gen_spawngroup(id, name, elements, interval)
		return {
			id = id,
			editor_name = name,
			class = "ElementSpawnEnemyGroup",
			values = {
				on_executed = {},
				trigger_times = 0,
				base_delay = 0,
				ignore_disabled = false,
				amount = 0,
				spawn_type = "ordered",
				team = "default",
				execute_on_startup = false,
				enabled = true,
				preferred_spawn_groups = {
					"tac_shield_wall_charge",
					"FBI_spoocs",
					"tac_tazer_charge",
					"tac_tazer_flanking",
					"tac_shield_wall",
					"tac_swat_rifle_flank",
					"tac_shield_wall_ranged",
					"tac_bull_rush",
				},
				elements = elements,
				interval = interval or 0,
			},
		}
	end

	function StreamHeist:gen_so(id, name, pos, rot, opts)
		opts = opts or {}
		return {
			id = id,
			editor_name = name,
			class = "ElementSpecialObjective",
			values = {
				path_style = opts.path_style or "destination",
				align_position = opts.align_position or false,
				ai_group = "enemies",
				is_navigation_link = opts.is_navigation_link or false,
				position = pos,
				scan = opts.scan or false,
				needs_pos_rsrv = opts.needs_pos_rsrv or false,
				enabled = true,
				execute_on_startup = false,
				rotation = rot,
				base_delay = 0,
				action_duration_min = 0,
				search_position = pos,
				use_instigator = true,
				trigger_times = 0,
				trigger_on = "none",
				search_distance = 0,
				so_action = opts.so_action or "none",
				path_stance = opts.path_stance or "hos",
				path_haste = "run",
				repeatable = false,
				attitude = "engage",
				interval = 2,
				action_duration_max = 0,
				align_rotation = opts.align_rotation or false,
				pose = opts.pose or "none",
				forced = true,
				base_chance = 1,
				interaction_voice = "none",
				SO_access = opts.SO_access or "512", -- default to sniper
				chance_inc = 0,
				interrupt_dmg = 1,
				interrupt_objective = false,
				on_executed = {},
				interrupt_dis = opts.interrupt_dis or 1,
				patrol_path = "none",
			},
		}
	end

	function StreamHeist:gen_aiglobalevent(id, name, opts)
		opts = opts or {}
		return {
			id = id,
			editor_name = name,
			class = "ElementAiGlobalEvent",
			values = {
				on_executed = opts.on_executed or {},
				trigger_times = 1,
				base_delay = 0,
				execute_on_startup = false,
				enabled = true,
				wave_mode = opts.wave_mode or "none",
				AI_event = opts.AI_event or "none",
				blame = opts.blame or "empty"
			},
		}
	end

	function StreamHeist:gen_fakeassaultstate(id, name, state)
		return {
			id = id,
			editor_name = name,
			class = "ElementFakeAssaultState",
			values = {
				on_executed = {},
				trigger_times = 1,
				base_delay = 0,
				execute_on_startup = false,
				enabled = true,
				state = state or false
			},
		}
	end

	function StreamHeist:gen_areatrigger(id, name, pos, rot, opts)
		opts = opts or {}
		return {
			id = id,
			editor_name = name,
			class = "ElementAreaTrigger",
			module = "CoreElementArea",
			values = {
				execute_on_startup = false,
				trigger_times = opts.trigger_times or 1,
				on_executed = opts.on_executed or {},
				base_delay = opts.base_delay or 0,
				position = pos,
				rotation = rot,
				enabled = true,
				interval = 0.1,
				trigger_on = "on_enter",
				instigator = "player",
				shape_type = opts.shape_type or "box",
				width = opts.width or 500,
				depth = opts.depth or 500,
				height = opts.height or 500,
				radius = opts.radius or 250,
				spawn_unit_elements = {},
				amount = opts.amount or "1",
				instigator_name = "",
				use_disabled_shapes = false,
				substitute_object = "",
			},
		}
	end

	function StreamHeist:log(...)
		if self.logging then
			log("[StreamlinedHeistingAI] " .. table.concat({...}, " "))
		end
	end

	function StreamHeist:warn(...)
		log("[StreamlinedHeistingAI][Warning] " .. table.concat({...}, " "))
	end

	function StreamHeist:error(...)
		log("[StreamlinedHeistingAI][Error] " .. table.concat({...}, " "))
	end

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function(loc)
		local language_tbl = {
			[("english"):key()] = "en.txt",
			[("schinese"):key()] = "schinese.json",
			[("russian"):key()] = "ru.txt"
		}

		local language = language_tbl[SystemInfo:language():key()] or "en.txt"
		local path = StreamHeist.mod_path .. "loc/" .. language
		path = io.file_is_readable(path) and path or StreamHeist.mod_path .. "loc/en.txt"

		loc:load_localization_file(path)
	end)

	-- Check for common mod conflicts
	Hooks:Add("MenuManagerOnOpenMenu", "MenuManagerOnOpenMenuStreamlinedHeisting", function()
		if Global.sh_mod_conflicts then
			return
		end

		Global.sh_mod_conflicts = {}
		local conflicting_mods = StreamHeist:require("mod_conflicts") or {}
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
					callback = function ()
						for _, mod_name in pairs(Global.sh_mod_conflicts) do
							local mod = BLT.Mods:GetModByName(mod_name)
							if mod then
								mod:SetEnabled(false, true)
							end
						end
						MenuCallbackHandler:perform_blt_save()
					end
				},
				{
					text = "Keep enabled (not recommended)"
				},
			}
			QuickMenu:new("Warning", message .. table.concat(Global.sh_mod_conflicts, "\n"), buttons, true)
		end
	end)

	-- Create settings menu
	Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusStreamlinedHeisting", function(_, nodes)

		local menu_id = "eclipse_menu"
		MenuHelper:NewMenu(menu_id)

		function MenuCallbackHandler:eclipse_ponr_assault_text_toggle(item)
			local enabled = (item:value() == "on")
			StreamHeist.settings.ponr_assault_text = enabled
		end

		function MenuCallbackHandler:eclipse_max_progression_infamy_edit(item)
			local value = math.floor(item:value() + 0.5)

			StreamHeist.settings.max_progression_infamy = value
		end

		function MenuCallbackHandler:sh_save()
			io.save_as_json(StreamHeist.settings, StreamHeist.save_path)
		end

		MenuHelper:AddToggle({
			id = "ponr_assault_text",
			title = "eclipse_menu_ponr_assault_text",
			desc = "eclipse_menu_ponr_assault_text_desc",
			callback = "eclipse_ponr_assault_text_toggle",
			value = StreamHeist.settings.ponr_assault_text,
			menu_id = menu_id,
			priority = 100
		})

		MenuHelper:AddSlider({
			id = "max_progression_infamy",
			title = "eclipse_menu_max_progression_infamy",
			desc = "eclipse_menu_max_progression_infamy_desc",
			callback = "eclipse_max_progression_infamy_edit",
			value = StreamHeist.settings.max_progression_infamy,
			menu_id = menu_id,
			is_percentage = false,
			show_value = true,
			min = 0,
			max = 500,
			step = 1,
			display_precision = 0,
			priority = 100
		})

		nodes[menu_id] = MenuHelper:BuildMenu(menu_id, { back_callback = "sh_save" })
		MenuHelper:AddMenuItem(nodes["blt_options"], menu_id, "eclipse_menu_main")
	end)

	-- Load settings
	if io.file_is_readable(StreamHeist.save_path) then
		local data = io.load_as_json(StreamHeist.save_path)
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
			merge(StreamHeist.settings, data)
		end
	end

	-- Notify about required game restart
	Hooks:Add("MenuManagerPostInitialize", "MenuManagerPostInitializeStreamlinedHeisting", function ()
		Hooks:PostHook(BLTViewModGui, "clbk_toggle_enable_state", "sh_clbk_toggle_enable_state", function (self)
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
	TheFixesPreventer.tank_walk_near_players  = true
	TheFixesPreventer.fix_hostages_not_moving = true
end

if RequiredScript and not StreamHeist.required[RequiredScript] then

	local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

	StreamHeist.required[RequiredScript] = true

end
