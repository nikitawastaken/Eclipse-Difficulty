-- When an escape or loot secure zone is activated, mark that area for reinforcement spawngroups
-- This is done by checking the list of elements an ElementAreaTrigger executes for ElementMissionEnd or ElementCarry,
-- If it contains any of these, it is considered the escape zone/loot secure trigger
local function check_executed_objects(area_trigger, current, recursion_depth)
	current = current or area_trigger
	recursion_depth = recursion_depth or 2

	if (area_trigger._values.enabled and true or false) == (area_trigger._reinforce_point_enabled and true or false) then
		return
	end

	for _, params in pairs(current._values.on_executed) do
		local element = current:get_mission_element(params.id)
		local element_class = getmetatable(element)
		if element_class == ElementMissionEnd or element_class == ElementCarry and element._values.operation == "secure" then
			area_trigger._reinforce_point_enabled = area_trigger._values.enabled
			if area_trigger._values.enabled then
				if area_trigger._values.use_shape_element_ids then
					for _, shape_element in pairs(area_trigger._shape_elements) do
						if shape_element._values.enabled then
							managers.groupai:state():set_area_min_police_force(shape_element._id, 3, shape_element._values.position)
						end
					end
				else
					managers.groupai:state():set_area_min_police_force(area_trigger._id, 3, area_trigger._values.position)
				end
				Eclipse:log(element_class == ElementMissionEnd and "Escape" or "Loot secure", "zone activated, enabling reinforce groups in its area")
			else
				if area_trigger._values.use_shape_element_ids then
					for _, shape_element in pairs(area_trigger._shape_elements) do
						managers.groupai:state():set_area_min_police_force(shape_element._id)
					end
				else
					managers.groupai:state():set_area_min_police_force(area_trigger._id)
				end
				Eclipse:log(element_class == ElementMissionEnd and "Escape" or "Loot secure", "zone deactivated, disabling reinforce groups in its area")
			end
			return true
		elseif recursion_depth > 0 and element_class == MissionScriptElement then
			if check_executed_objects(area_trigger, element, recursion_depth - 1) then
				return true
			end
		end
	end
end

Hooks:PostHook(ElementAreaTrigger, "on_set_enabled", "sh_on_set_enabled", check_executed_objects)

-- Point of no return escape zones only need the players who aren't downed to trigger the escape
local old_project_instigators = ElementAreaTrigger.project_instigators
function ElementAreaTrigger:project_instigators()
	local instigators = old_project_instigators(self)

	if Network:is_client() then
		if self._values.instigator == "criminals_not_downed" then
			table.insert(instigators, managers.player:player_unit())
			return instigators
		end
	end

	if self._values.instigator == "criminals_not_downed" then
		table.insert(instigators, managers.player:player_unit())
	end

	return instigators
end

function ElementAreaTrigger:project_amount_inside()
	local counter = #self._inside

	if self._values.instigator == "vehicle_with_players" then
		for _, instigator in pairs(self._inside) do
			local vehicle = instigator:vehicle_driving()

			if vehicle then
				counter = vehicle:num_players_inside()
			end
		end
	elseif self._values.instigator == "player_not_in_vehicle" then
		counter = 0
		local vehicles = managers.vehicle:get_all_vehicles()

		for _, instigator in pairs(self._inside) do
			local in_vehicle = false

			for _, vehicle in pairs(vehicles) do
				in_vehicle = in_vehicle or vehicle:vehicle_driving():find_seat_for_player(instigator)
			end

			if not in_vehicle then
				counter = counter + 1
			end
		end
	elseif self._values.instigator == "criminals_not_downed" then
		counter = 0

		for _, criminal in pairs(managers.groupai:state():all_player_criminals()) do
			for _, instigator in pairs(self._inside) do
				if criminal.unit == instigator and not criminal.unit:movement():downed() then
					counter = counter + 1
				end
			end
		end
	end

	return counter
end

function ElementAreaTrigger:project_amount_all()
	if self._values.instigator == "criminals" or self._values.instigator == "local_criminals" then
		local i = 0

		for _, data in pairs(managers.groupai:state():all_char_criminals()) do
			i = i + 1
		end

		return i
	elseif self._values.instigator == "ai_teammates" then
		local i = 0

		for _, data in pairs(managers.groupai:state():all_AI_criminals()) do
			i = i + 1
		end

		return i
	elseif self._values.instigator == "criminals_not_downed" then
		local i = 0

		for _, data in pairs(managers.groupai:state():all_player_criminals()) do
			if not data.unit:movement():downed() then
				i = i + 1
			end
		end

		return i
	end

	return managers.network:session() and managers.network:session():amount_of_alive_players() or 0
end
