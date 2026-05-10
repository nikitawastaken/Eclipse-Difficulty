-- if Global.editor_mode then
-- 	Eclipse:log("Editor mode is active, mission script changes disabled")
-- 	return
-- end

local mission_add = Eclipse:mission_script_add()
if mission_add then
	-- Load the elements from the file
	Hooks:PreHook(MissionScript, "init", "eclipse_missionmanager_init", function(self, data)
		if not Eclipse.loaded_elements and data.name == "default" then
			for _, element in ipairs(mission_add.elements) do
				table.insert(data.elements, element)
			end
			Eclipse.loaded_elements = true
		end
	end)
end

local is_pro_job = Eclipse.utils.is_pro_job()

-- Add custom mission script changes and triggers for specific levels
MissionManager.mission_script_patch_funcs = {}
function MissionManager.mission_script_patch_funcs.values(self, element, data)
	for k, v in pairs(data) do
		element._values[k] = v
		Eclipse:log_console('%s value "%s" has been set to "%s"', element:editor_name(), k, tostring(v))
	end

	if data.enemy and getmetatable(element) == ElementSpawnEnemyDummy then
		Eclipse:warn_console(string.format("Bad scripted spawn patch on %u, fixing", element:id()))
		self.mission_script_patch_funcs.enemy(self, element, data.enemy)
		element._values.enemy = nil
	end

	if data.timer and element.timer_operation_set_time then
		element:timer_operation_set_time(data.timer)
	end

	-- All of this just to be able to fix area triggers...
	if data.instigator and element._instigator_find_func then
		element._instigator_count_all_func = ElementAreaTrigger.instigator_project_all_functions[data.instigator]
		element._instigator_count_inside_func = ElementAreaTrigger.instigator_project_inside_functions[data.instigator]
		element._instigator_valid_func = ElementAreaTrigger.instigator_valid_functions[data.instigator]
		if Network:is_client() then
			element._instigator_find_func = ElementAreaTrigger.instigator_find_functions_client[data.instigator]
		else
			element._instigator_find_func = ElementAreaTrigger.instigator_find_functions[data.instigator]
			if element._values.trigger_on == "on_empty" then
				local temp_switch = ElementAreaTrigger.on_empty_find_func_switch[data.instigator]
				if temp_switch then
					element._on_empty_find_func_switch = element._instigator_find_func
					element._instigator_find_func = temp_switch
				else
					element._on_empty_find_func_switch = nil
				end
			end
		end
	end

	-- Handle new spawn group element functionality
	if data.interval and element._values.interval_reference then
		element._values.interval_reference = data.interval
		element._values.interval = nil
	end

	-- ASS edits
	if data.chance and element._chance then
		element._chance = data.chance
	end

	-- We love spawn group elements
	local group_data = element._group_data
	if group_data then
		group_data.amount = data.amount or group_data.amount
		group_data.spawn_type = data.spawn_type or group_data.spawn_type
		if data.ignore_disabled ~= nil then
			group_data.ignore_disabled = data.ignore_disabled
		end
		if data.elements then
			group_data.spawn_points, element._unused_randoms = {}, {}
			for i, id in ipairs(data.elements) do
				table.insert(element._unused_randoms, i)
				table.insert(group_data.spawn_points, element:get_mission_element(id))
			end
		end
	end
end

function MissionManager.mission_script_patch_funcs.on_executed(self, element, data)
	for _, v in pairs(data) do
		local new_element = self:get_element_by_id(v.id)
		if new_element then
			local val, i = table.find_value(element._values.on_executed, function(val)
				return val.id == v.id
			end)
			if v.remove then
				if val then
					table.remove(element._values.on_executed, i)
					Eclipse:log_console("Removed element %s from on_executed of %s", new_element:editor_name(), element:editor_name())
				end
			elseif val then
				val.delay = v.delay or 0
				val.delay_rand = v.delay_rand or 0

				if v.alternative then
					val.alternative = v.alternative
				end

				Eclipse:log_console("Modified element %s in on_executed of %s", new_element:editor_name(), element:editor_name())
			else
				table.insert(element._values.on_executed, v)
				Eclipse:log_console("Added element %s to on_executed of %s", new_element:editor_name(), element:editor_name())
			end
		else
			Eclipse:error_console("Mission script element %u could not be found", v.id)
		end

		if element._original_on_executed then
			element._original_on_executed = clone(element._values.on_executed)
		end
	end
end

function MissionManager.mission_script_patch_funcs.pre_func(self, element, data)
	Hooks:PreHook(element, "on_executed", "sh_on_executed_pre_func_" .. element:id(), data)
	Eclipse:log_console("%s hooked as pre function call trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.func(self, element, data)
	Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element:id(), data)
	Eclipse:log_console("%s hooked as function call trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.ponr(self, element, data)
	if is_pro_job then
		local function set_ponr()
			local ponr_timer_balance_mul = data.length_balance_mul
					and managers.groupai:state():_get_balancing_multiplier(data.length_balance_mul, tweak_data.group_ai.team_ai_balance_mul_weights.ponr_length)
				or 1
			managers.groupai:state():set_point_of_no_return_timer(data.length * ponr_timer_balance_mul, -1, "ffo")
		end

		Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_" .. element:id(), set_ponr)
		Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_ponr_" .. element:id(), set_ponr)
	end
end

function MissionManager.mission_script_patch_funcs.ponr_end(self, element, _)
	if is_pro_job then
		Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_end_" .. element:id(), function()
			managers.groupai:state():remove_point_of_no_return_timer(0)
		end)
		Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_ponr_end_" .. element:id(), function()
			managers.groupai:state():remove_point_of_no_return_timer(0)
		end)
	end
end

function MissionManager.mission_script_patch_funcs.set_ponr_state(self, element, _)
	if is_pro_job then
		if Network:is_server() then
			Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_state_" .. element:id(), function()
				managers.mission:set_ponr_state()
			end)
		end
	end
end

function MissionManager.mission_script_patch_funcs.spawn_instigator_ids(self, element, data)
	for _, v in pairs(data) do
		local new_element = self:get_element_by_id(v)
		if new_element then
			table.insert(element._values.spawn_instigator_ids, v)
			Eclipse:log_console(string.format("Added element %s to spawn_instigator_ids of %s", new_element:editor_name(), element:editor_name()))
		else
			Eclipse:error_console(string.format("Mission script element %u could not be found", v))
		end
	end
end

function MissionManager.mission_script_patch_funcs.reinforce(self, element, data)
	Hooks:PostHook(element, "on_executed", "sh_on_executed_reinforce_" .. element:id(), function()
		Eclipse:log_console("%s executed, toggled %u reinforce point(s)", element:editor_name(), #data)
		for _, v in pairs(data) do
			managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
		end
	end)
	Eclipse:log_console("%s hooked as reinforce trigger for %u area(s)", element:editor_name(), #data)
end

function MissionManager.mission_script_patch_funcs.difficulty(self, element, data)
	Hooks:PostHook(element, "on_executed", "sh_on_executed_difficulty_" .. element:id(), function()
		Eclipse:log_console("%s executed, set difficulty to %.2g", element:editor_name(), data)
		--managers.groupai:state():set_difficulty(data)
	end)
	Eclipse:log_console("%s hooked as difficulty change trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.difficulty_add(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_difficulty_add_" .. element:id(), function()
		Eclipse:log_console("%s executed, increased difficulty by %.2g", element:editor_name(), data)
		managers.groupai:state():add_difficulty(data)
	end)
	Eclipse:log_console("%s hooked as difficulty addition trigger", element:editor_name())
end

-- Addends, plural, so that you may add multiple at once if needed (eg, a small instant increase and a larger increase that takes a while)
function MissionManager.mission_script_patch_funcs.difficulty_addends(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_difficulty_addends" .. element:id(), function()
		if data[1] then
			Eclipse:log_console("%s executed, added %u difficulty addend(s)", element:editor_name(), #data)
			for _, addend in pairs(data) do
				managers.groupai:state():add_difficulty_addend(addend)
			end
		else
			Eclipse:log_console("%s executed, added difficulty addend", element:editor_name())
			managers.groupai:state():add_difficulty_addend(data)
		end
	end)
	Eclipse:log_console("%s hooked as difficulty addends trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.forced_difficulty(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_forced_difficulty" .. element:id(), function()
		managers.groupai:state():set_forced_difficulty(data)
	end)
end

function MissionManager.mission_script_patch_funcs.allowed_difficulty_addends(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_allowed_difficulty_addends" .. element:id(), function()
		for category, allowed in pairs(data) do
			managers.groupai:state():set_difficulty_addend_category_allowed(category, allowed)
		end
	end)
end

function MissionManager.mission_script_patch_funcs.paused_difficulty_addends(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_allowed_difficulty_addends" .. element:id(), function()
		for category, cache_limit in pairs(data) do
			managers.groupai:state():set_difficulty_addend_category_paused(category, cache_limit)
		end
	end)
end

function MissionManager.mission_script_patch_funcs.post_mga_event(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_post_mga_event_" .. element:id(), function()
		--Eclipse:log_console("%s executed, playing %.2g", element:editor_name(), data)
		managers.groupai:state():_post_megaphone_event(data)
	end)
	Eclipse:log_console("%s hooked as megaphone cop event trigger", element:editor_name())
end

-- Set flashlights on or off when this element is executed
function MissionManager.mission_script_patch_funcs.flashlight(self, element, data)
	local function set_flashlights()
		managers.game_play_central:set_flashlights_on(data)
	end
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_flashlight_" .. element:id(), set_flashlights)
	Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_flashlight_" .. element:id(), set_flashlights)
	Eclipse:log("%s hooked as flashlight state trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.groups(self, element, data)
	if not element._values.preferred_spawn_groups then
		-- log(element._id)
		return
	end
	local new_groups = table.list_to_set(element._values.preferred_spawn_groups)
	for group_name, enabled in pairs(data) do
		new_groups[group_name] = enabled or nil
	end
	element._values.preferred_spawn_groups = table.map_keys(new_groups)
	Eclipse:log_console("Changed %u preferred group(s) of %s", table.size(data), element:editor_name())
end

function MissionManager.mission_script_patch_funcs.ai_area(self, element, data)
	Hooks:PostHook(element, "on_executed", "sh_on_executed_ai_area_" .. element:id(), function()
		Eclipse:log_console("%s executed, creating %d AI area(s)", element:editor_name(), #data)
		for _, nav_segs in ipairs(data) do
			local area_pos = Vector3()
			for _, nav_seg_id in ipairs(nav_segs) do
				local nav_seg = managers.navigation._nav_segments[nav_seg_id]
				if not nav_seg then
					Eclipse:error_console("Nav segment %u could not be found", nav_seg_id)
					return
				end
				mvector3.add_scaled(area_pos, nav_seg.pos, 1 / #nav_segs)
			end
			self._ai_area_id = (self._ai_area_id or 10000) + 1
			managers.groupai:state():add_area(self._ai_area_id, nav_segs, area_pos)
		end
	end)
	Eclipse:log_console("%s hooked as AI area trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.spawn(self, element, data)
	Hooks:PostHook(element, "on_executed", "sh_on_executed_spawn_unit_" .. element:id(), function()
		Eclipse:log("%s executed, spawning %d unit(s)", element:editor_name(), #data)
		for _, u_data in ipairs(data) do
			local unit = World:spawn_unit(u_data.name, u_data.pos or Vector3(), u_data.rot or Rotation())
			if u_data.visible ~= nil then
				unit:set_visible(u_data.visible)
			end
		end
	end)
	Eclipse:log("%s hooked as unit spawn trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.flee_point(self, element, data)
	if Network:is_client() then
		return
	end

	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_flee_point_" .. element:id(), function()
		Eclipse:log("%s executed, toggled %u flee point(s)", element:editor_name(), #data)
		for _, v in pairs(data) do
			if v.position then
				managers.groupai:state():add_flee_point(v.name, v.position)
			else
				managers.groupai:state():remove_flee_point(v.name)
			end
		end
	end)
	Eclipse:log("%s hooked as flee point trigger for %u area(s)", element:editor_name(), #data)
end

function MissionManager.mission_script_patch_funcs.loot_drop(self, element, data)
	if Network:is_client() then
		return
	end

	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_loot_drop_" .. element:id(), function()
		Eclipse:log_console("%s executed, toggled %u loot drop point(s)", element:editor_name(), #data)
		for _, v in pairs(data) do
			if v.position then
				managers.groupai:state():add_enemy_loot_drop_point(v.name, v.position)
			else
				managers.groupai:state():remove_enemy_loot_drop_point(v.name)
			end
		end
	end)
	Eclipse:log_console("%s hooked as loot drop trigger for %u area(s)", element:editor_name(), #data)
end

-- TODO: integrate into values patch like modern ASS
function MissionManager.mission_script_patch_funcs.chance(self, element, data)
	element._values.chance = data
	element._chance = data
end

function MissionManager.mission_script_patch_funcs.spawn_action(self, element, data)
	local spawn_action = table.index_of(CopActionAct._act_redirects.enemy_spawn, data)
	element._values.spawn_action = spawn_action ~= -1 and spawn_action or nil
end

function MissionManager.mission_script_patch_funcs.modify_list_value(self, element, data)
	for k, v in pairs(data) do
		if type(element._values[k]) ~= "table" then
			Eclipse:warn_console("Invalid modify list value name %s on %s", k, element:editor_name())
		else
			for id, enabled in pairs(v) do
				if enabled then
					table.insert(element._values[k], id)
				else
					table.delete(element._values[k], id)
				end
			end
		end
	end
end

function MissionManager.mission_script_patch_funcs.enemy(self, element, data)
	element:replace_enemy_name(data)
	element:chk_used_mapped_names(true)

	Eclipse:log_console(string.format("Modified enemy spawn in element %s", element:editor_name()))
end

-- Thank you ASS :pray:
function MissionManager.mission_script_patch_funcs.so_access_filter(self, element, data)
	element._values.SO_access = managers.navigation:convert_access_filter_to_number(data)

	Eclipse:log_console("Replaced SO access filter of element %s", element:editor_name())
end

-- Referenced from ElementAiGlobalEvent, lib\managers\mission\elementaiglobalevent
function MissionManager.mission_script_patch_funcs.hunt(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_hunt_" .. element:id(), function()
		local hunt_mode = managers.groupai:state()._hunt_mode
		local flag = (data and not hunt_mode and "hunt") or (hunt_mode and not data and "besiege") or nil
		if flag then
			Eclipse:log_console("%s executed, setting wave mode to %s", element:editor_name(), flag)
			if managers.groupai:state():enemy_weapons_hot() then
				managers.groupai:state():set_wave_mode(flag)
			else
				local key = "eclipse_script_patch_hunt_" .. element:id()
				local events = { "enemy_weapons_hot", }
				local function clbk()
					managers.groupai:state():set_wave_mode(flag)
					managers.groupai:state():remove_listener(key)
				end
				managers.groupai:state():add_listener(key, events, clbk)
			end
		end
	end)
end

-- true -> regroup, false -> fade
function MissionManager.mission_script_patch_funcs.force_end_assault(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_force_end_assault_" .. element:id(), function()
		Eclipse:log_console("%s executed, forcibly %s assault", element:editor_name(), data and "regrouping" or "fading")
		managers.groupai:state():force_end_assault_phase(data)
	end)
end

--[[
	Format:
	[696969] = {
		add_drama = 0.5,
	},
	or
	[696969] = {
		add_drama = {
			amount = 0.5,
			balance_mul = { 1, 0.9, 0.8, 0.7 },
			team_ai_balance_mul_weight = 0.5,
		},
	},
]]
function MissionManager.mission_script_patch_funcs.add_drama(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_add_drama_" .. element:id(), function()
		local amount = 0
		if type(data) == "table" then
			amount = (data.amount or 0) * (managers.groupai:state():_get_balancing_multiplier(data.balance_mul, data.team_ai_balance_mul_weight) or 1)
		else
			amount = tonumber(data)
		end
		if amount and amount ~= 0 then
			Eclipse:log_console("%s executed, added %s drama", element:editor_name(), tostring(amount))
			managers.groupai:state():_add_drama(amount)
		end
	end)
end

Hooks:PreHook(MissionManager, "_activate_mission", "sh__activate_mission", function(self)
	local mission_script_elements = Eclipse:mission_script_patches()
	if not mission_script_elements then
		return
	end

	for element_id, data in pairs(mission_script_elements) do
		local element = self:get_element_by_id(element_id)
		if not element then
			Eclipse:error_console("Mission script element %u could not be found", element_id)
		else
			for patch_name, patch_data in pairs(data) do
				if self.mission_script_patch_funcs[patch_name] then
					self.mission_script_patch_funcs[patch_name](self, element, patch_data)
				else
					Eclipse:warn_console("MissionManager.mission_script_patch_funcs.%s does not exist", patch_name)
				end
			end
		end
	end
end)

function MissionManager:set_ponr_state()
	managers.groupai:set_state("ponr")
	managers.groupai:state():on_police_called("default")
	managers.groupai:state():set_difficulty(1)
end
