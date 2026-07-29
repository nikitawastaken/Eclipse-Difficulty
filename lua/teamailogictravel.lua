-- Don't carry over "firing" variable, it has a chance to stopp bots from shooting
Hooks:PostHook(TeamAILogicTravel, "enter", "enter_ub", function(data)
	data.internal_data.firing = nil
end)

-- Make bots actually use inspire, not only if you are in their detected attention objects
local check_inspire_original = TeamAILogicTravel.check_inspire
local function path_length(path)
	local dis = 0
	for i = 1, #path - 1 do
		local p1 = path[i].x and path[i] or path[i].element:value("position")
		local p2 = path[i + 1].x and path[i + 1] or path[i + 1].element:value("position")
		dis = dis + mvector3.distance(p1, p2)
	end
	return dis
end
function TeamAILogicTravel.check_inspire(data, attention, ...)
	if data.objective and data.objective.action and data.objective.action.variant == "untie" then
		return
	end

	attention = attention or { unit = data.objective.follow_unit }

	local is_ai = managers.groupai:state():is_unit_team_AI(attention.unit)
	if is_ai and data.unit:character_damage():health_ratio() > 0.4 then
		local timer = 0
		if attention.unit:base().is_local_player then
			timer = attention.unit:character_damage()._downed_timer or timer
		elseif attention.unit:interaction().get_waypoint_time then
			timer = attention.unit:interaction():get_waypoint_time() or timer
		end

		local my_data = data.internal_data
		if my_data.advancing and my_data.coarse_path then
			if #my_data.coarse_path <= 2 and my_data.advancing._simplified_path then
				local path = my_data.advancing._simplified_path
				local dis = 0
				for i = 1, #path - 1 do
					local p1 = path[i].x and path[i] or path[i].element:value("position")
					local p2 = path[i + 1].x and path[i + 1] or path[i + 1].element:value("position")
					dis = dis + mvector3.distance(p1, p2)
				end
				local time_to_reach = dis / (data.char_tweak.move_speed.stand.run.cbt.fwd * 0.75)
				timer = timer - time_to_reach
			elseif my_data.coarse_path_index and my_data.coarse_path_index < #my_data.coarse_path then
				local path = my_data.coarse_path
				local dis = mvector3.distance(data.m_pos, path[my_data.coarse_path_index + 1][2] or data.m_pos)
				for i = my_data.coarse_path_index + 1, #path - 1 do
					if path[i][2] and path[i + 1][2] then
						dis = dis + mvector3.distance(path[i][2], path[i + 1][2])
					end
				end
				local time_to_reach = dis / (data.char_tweak.move_speed.stand.run.cbt.fwd * 0.75)
				timer = timer - time_to_reach
			end
		end

		if timer > (is_ai and 4 or 8) then
			return
		end
	end

	return check_inspire_original(data, attention, ...)
end

local update_original = TeamAILogicTravel.update
function TeamAILogicTravel.update(data, ...)
	if TeamAILogicBase._check_deliver_bag(data) then
		return
	end
	if data.objective then
		return update_original(data, ...)
	end
	return CopLogicTravel.upd_advance(data)
end

if Iter and Iter.settings and Iter.settings.streamline_path or restoration then
	return
end

-- Update pathing when walking action is finished
Hooks:PostHook(TeamAILogicTravel, "action_complete_clbk", "action_complete_clbk_ub", function(data, action)
	local my_data = data.internal_data
	if action:type() == "walk" and my_data.coarse_path and my_data.coarse_path_index < #my_data.coarse_path then
		TeamAILogicTravel.update(data)
	end
end)
