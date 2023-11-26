if Global.editor_mode then
	StreamHeist:log("Editor mode is active, mission script changes disabled")
	return
end

-- Add custom mission script changes and triggers for specific levels
-- Execution of mission scripts can trigger reinforce locations (trigger that has just a name disables previously enabled reinforcement with that id)
-- Mission script elements can be disabled or enabled

Hooks:PreHook(MissionManager, "_activate_mission", "sh__activate_mission", function(self)
	local mission_script_elements = StreamHeist:mission_script_patches()
	if not mission_script_elements then
		return
	end

	for element_id, data in pairs(mission_script_elements) do
		local element = self:get_element_by_id(element_id)
		if not element then
			StreamHeist:error(string.format("Mission script element %u could not be found", element_id))
		else
			-- Check if this element is supposed to trigger reinforce points
			if data.reinforce then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_reinforce_" .. element_id, function()
					StreamHeist:log(string.format("%s executed, toggled %u reinforce point(s)", element:editor_name(), #data.reinforce))
					for _, v in pairs(data.reinforce) do
						managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
					end
				end)
				StreamHeist:log(string.format("%s hooked as reinforce trigger for %u area(s)", element:editor_name(), #data.reinforce))
			end

			-- Check if this element is supposed to trigger a point of no return
			-- thanks redflame
			local is_pro_job = Global.game_settings and Global.game_settings.one_down
			if is_pro_job then
				if data.ponr then
					local function set_ponr()
						local ponr_timer_balance_mul = data.ponr_player_mul and managers.groupai:state():_get_balancing_multiplier(data.ponr_player_mul) or 1
						managers.groupai:state():set_point_of_no_return_timer(data.ponr * ponr_timer_balance_mul, -1)
					end

					Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_" .. element_id, set_ponr)
					Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_ponr_" .. element_id, set_ponr)
				end

				if data.ponr_end then
					Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_end_" .. element_id, function()
						managers.groupai:state():remove_point_of_no_return_timer(0)
					end)
					Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_ponr_end_" .. element_id, function()
						managers.groupai:state():remove_point_of_no_return_timer(0)
					end)
				end

				-- instantly force into post ponr state
				if data.set_ponr_state then
					if Network:is_server() then
						Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_state_" .. element_id, function()
							managers.mission:set_ponr_state()
						end)
					end
				end
			end

			-- Check if this element is supposed to trigger a difficulty change
			if data.difficulty then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_difficulty_" .. element_id, function()
					StreamHeist:log(string.format("%s executed, set difficulty to %.2g", element:editor_name(), data.difficulty))
					managers.groupai:state():set_difficulty(data.difficulty)
				end)
				StreamHeist:log(string.format("%s hooked as difficulty change trigger", element:editor_name()))
			end

			-- Check if this element has custom values set
			if data.values then
				for k, v in pairs(data.values) do
					element._values[k] = v
					StreamHeist:log(string.format('%s value "%s" has been set to "%s"', element:editor_name(), k, tostring(v)))

					if k == "chance" then
						if element.chance_operation_set_chance then
							element:chance_operation_set_chance(v)
						end
					end
				end
			end

			if data.flashlight ~= nil then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element_id, function()
					StreamHeist:log(string.format("%s executed, changing flashlight state to %s", element:editor_name(), data.flashlight and "true" or "false"))
					managers.game_play_central:set_flashlights_on(data.flashlight)
				end)
				StreamHeist:log(string.format("%s hooked as flashlight state trigger", element:editor_name()))
			end

			if data.on_executed then
				for _, v in pairs(data.on_executed) do
					local new_element = self:get_element_by_id(v.id)
					if new_element then
						local val, i = table.find_value(element._values.on_executed, function(val)
							return val.id == v.id
						end)
						if v.remove then
							if val then
								table.remove(element._values.on_executed, i)
								StreamHeist:log(string.format("Removed element %s from on_executed of %s", new_element:editor_name(), element:editor_name()))
							end
						elseif val then
							val.delay = v.delay or 0
							val.delay_rand = v.delay_rand or 0
							StreamHeist:log(string.format("Modified element %s in on_executed of %s", new_element:editor_name(), element:editor_name()))
						else
							table.insert(element._values.on_executed, v)
							StreamHeist:log(string.format("Added element %s to on_executed of %s", new_element:editor_name(), element:editor_name()))
						end
					else
						StreamHeist:error(string.format("Mission script element %u could not be found", v.id))
					end
				end
			end

			if data.spawn_instigator_ids then
				for _, v in pairs(data.spawn_instigator_ids) do
					local new_element = self:get_element_by_id(v)
					if new_element then
						table.insert(element._values.spawn_instigator_ids, v)
						StreamHeist:log(string.format("Added element %s to spawn_instigator_ids of %s", new_element:editor_name(), element:editor_name()))
					else
						StreamHeist:error(string.format("Mission script element %u could not be found", v))
					end
				end
			end

			if data.func then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element_id, data.func)
				StreamHeist:log(string.format("%s hooked as function call trigger", element:editor_name()))
			end
		end
	end
end)

function MissionManager:set_ponr_state()
	self._instant_start_ponr = true
end
