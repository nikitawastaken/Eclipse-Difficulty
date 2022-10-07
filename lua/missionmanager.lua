if Global.editor_mode then
	StreamHeist:log("Editor mode is active, mission script changes disabled")
	return
end


-- Add custom mission script changes and triggers for specific levels
-- Execution of mission scripts can trigger reinforce locations (trigger that has just a name disables previously enabled reinforcement with that id)
-- Mission script elements can be disabled or enabled
local mission_script_elements = StreamHeist:mission_script_patches()
if not mission_script_elements then
	return
end

Hooks:PreHook(MissionManager, "_activate_mission", "sh__activate_mission", function (self)
	for element_id, data in pairs(mission_script_elements) do
		local element = self:get_element_by_id(element_id)
		if not element then
			StreamHeist:error("Mission script element", element_id, "could not be found")
		else
			-- Check if this element is supposed to trigger reinforce points
			if data.reinforce then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_reinforce_" .. element_id, function ()
					StreamHeist:log(string.format("%s executed, toggled %u reinforce point(s)", element:editor_name(), #data.reinforce))
					for _, v in pairs(data.reinforce) do
						managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
					end
				end)
				StreamHeist:log(string.format("%s hooked as reinforce trigger for %u area(s)", element:editor_name(), #data.reinforce))
			end

			-- Check if this element is supposed to trigger a point of no return
			-- make point of no return scale with player count
			if data.ponr then
				local ponr_timer_balance_mul = managers.groupai:state():_get_balancing_multiplier(data.ponr_player_mul)
				local ponr_timer = data.ponr * ponr_timer_balance_mul
				Hooks:PostHook(element, "on_executed", "sh_on_executed_ponr_" .. element_id, function ()
					managers.groupai:state():set_point_of_no_return_timer(ponr_timer, 0)
				end)
				Hooks:PostHook(element, "client_on_executed", "sh_client_on_executed_ponr_" .. element_id, function ()
					managers.groupai:state():set_point_of_no_return_timer(ponr_timer, 0)
				end)
			end

			-- Check if this element is supposed to trigger a difficulty change
			if data.difficulty then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_difficulty_" .. element_id, function ()
					StreamHeist:log(string.format("%s executed, set difficulty to %.2f", element:editor_name(), data.difficulty))
					managers.groupai:state():set_difficulty(data.difficulty)
				end)
				StreamHeist:log(string.format("%s hooked as difficulty change trigger", element:editor_name()))
			end

			-- Check if this element has custom values set
			if data.values then
				for k, v in pairs(data.values) do
					element._values[k] = v
					StreamHeist:log(string.format("%s value \"%s\" has been set to \"%s\"", element:editor_name(), k, tostring(v)))
				end
			end

			if data.flashlight ~= nil then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element_id, function ()
					StreamHeist:log(string.format("%s executed, changing flashlight state to %s", element:editor_name(), data.flashlight and "true" or "false"))
					managers.game_play_central:set_flashlights_on(data.flashlight)
				end)
				StreamHeist:log(string.format("%s hooked as flashlight state trigger", element:editor_name()))
			end

			if data.func then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element_id, data.func)
				StreamHeist:log(string.format("%s hooked as function call trigger", element:editor_name()))
			end
		end
	end
end)