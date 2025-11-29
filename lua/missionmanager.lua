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
			local ponr_timer_balance_mul = data.player_mul and managers.groupai:state():_get_balancing_multiplier(data.player_mul) or 1
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

function MissionManager.mission_script_patch_funcs.difficulty_min(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_difficulty_min_" .. element:id(), function()
		Eclipse:log_console("%s executed, set minimum difficulty to %.2g", element:editor_name(), data)
		managers.groupai:state():min_difficulty(data)
	end)
	Eclipse:log_console("%s hooked as minimum difficulty trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.difficulty_max(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_difficulty_max_" .. element:id(), function()
		Eclipse:log_console("%s executed, set maximum difficulty to %.2g", element:editor_name(), data)
		managers.groupai:state():max_difficulty(data)
	end)
	Eclipse:log_console("%s hooked as maximum difficulty trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.post_mga_event(self, element, data)
	Hooks:PostHook(element, "on_executed", "eclipse_on_executed_post_mga_event_" .. element:id(), function()
		--Eclipse:log_console("%s executed, playing %.2g", element:editor_name(), data)
		managers.groupai:state():_post_megaphone_event(data)
	end)
	Eclipse:log_console("%s hooked as megaphone cop event trigger", element:editor_name())
end

function MissionManager.mission_script_patch_funcs.flashlight(self, element, data)
	Hooks:PostHook(element, "on_executed", "sh_on_executed_flashlight_" .. element:id(), function()
	Hooks:PostHook(element, "client_on_executed", "sh_client_on_executed_flashlight_" .. element:id(), function()
		Eclipse:log_console("%s executed, changing flashlight state to %s", element:editor_name(), data and "true" or "false")
		managers.game_play_central:set_flashlights_on(data)
	end)
	Eclipse:log_console("%s hooked as flashlight state trigger", element:editor_name())
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
			Eclipse:log_console("warn", 'Invalid modify list value name "%s" on element "%s" (%s)!', k, element:editor_name(), element:id())
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
	if not data then -- dont point fingers at sh if i fuck up
		Eclipse:log_console("warn", 'Invalid SO access filter preset "%s" for element "%s" (%s)!', data, element:editor_name(), element:id())
	else
		element._values.SO_access_original = element._values.SO_access
		element._values.SO_access = managers.navigation:convert_access_filter_to_number(data)

		Eclipse:log_console("Replaced SO access filter of element %s", element:editor_name())
	end
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
