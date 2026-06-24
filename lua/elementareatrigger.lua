local level_id = Eclipse.utils.clean_level_id()

-- When an escape or loot secure zone is activated, mark that area for reinforcement spawngroups
-- This is done by checking the list of elements an ElementAreaTrigger executes for ElementMissionEnd or ElementCarry,
-- If it contains any of these, it is considered the escape zone/loot secure trigger
local function check_executed_objects(trigger, current, checked)
	if not current or checked[current] then
		return
	end

	checked[current] = true

	if (trigger._values.enabled and true or false) == (trigger._reinforce_point_enabled and true or false) then
		return
	end

	for _, params in pairs(current._values.on_executed) do
		local element = current:get_mission_element(params.id)
		local element_class = getmetatable(element)
		if element_class == ElementMissionEnd or element_class == ElementCarry and element._values.operation == "secure" then
			local force = trigger._values.enabled and 3 or nil
			trigger._reinforce_point_enabled = trigger._values.enabled
			if trigger._values.use_shape_element_ids then
				for _, shape_element in pairs(trigger._shape_elements) do
					if shape_element._values.enabled then
						managers.groupai:state():set_area_min_police_force(shape_element._id, force, shape_element._values.position)
					end
				end
			else
				managers.groupai:state():set_area_min_police_force(trigger._id, force, trigger._values.position)
			end
			local type = element_class == ElementMissionEnd and "Escape" or "Loot secure"
			if trigger._values.enabled then
				Eclipse:log_console("%s zone activated, enabling reinforce groups in its area", type)
			else
				Eclipse:log_console("%s zone deactivated, disabling reinforce groups in its area", type)
			end
			return true
		elseif check_executed_objects(trigger, element, checked) then
			return true
		end
	end
end

Hooks:PostHook(ElementAreaTrigger, "on_set_enabled", "sh_on_set_enabled", function(self)
	check_executed_objects(self, self, {})
end)

-- Hostile and intimidated enemies, but not converts
function ElementAreaTrigger.instigator_find_functions.enemies_no_converts(values, instigators)
	for _, data in pairs(managers.enemy:all_enemies()) do
		if not data.is_converted then
			table.insert(instigators, data.unit)
		end
	end
end

-- All enemies, whether hostile, converted, or intimidated
function ElementAreaTrigger.instigator_find_functions.enemies_all(values, instigators)
	for _, data in pairs(managers.enemy:all_enemies()) do
		table.insert(instigators, data.unit)
	end
end

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

		for _, _ in pairs(managers.groupai:state():all_char_criminals()) do
			i = i + 1
		end

		return i
	elseif self._values.instigator == "ai_teammates" then
		local i = 0

		for _, _ in pairs(managers.groupai:state():all_AI_criminals()) do
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

if not Network:is_server() then
	return
end

local needs_secure_match_level = {
	framing_frame_2 = true
}

local valid_carry_operations = {
	secure = true,
	secure_silent = true,
	remove = true
}

local valid_instigators = {
	loot = true,
	unique_loot = true
}

local function get_loot_secure_elements(current, recursion_depth, found_elements)
	recursion_depth = recursion_depth or 10
	found_elements = found_elements or {}
	for _, params in pairs(current._values.on_executed) do
		local element = current:get_mission_element(params.id)
		local element_class = getmetatable(element)
		if element_class == ElementCarry and valid_carry_operations[element._values.operation] then
			found_elements[element] = element
		end
		if element and recursion_depth > 0 then
			get_loot_secure_elements(element, recursion_depth - 1, found_elements)
		end
	end
	return found_elements
end

Hooks:PostHook(ElementAreaTrigger, "on_script_activated", "on_script_activated_ub", function (self)
	if valid_instigators[self._values.instigator] then
		self._loot_secure_elements = get_loot_secure_elements(self)
	end
end)

Hooks:PreHook(ElementAreaTrigger, "on_executed", "on_executed_ub", function (self, instigator)
	local throw_params = self:ub_can_secure_loot(instigator) and instigator:carry_data()._ub_throw_params
	if not throw_params or throw_params.expire_t < TimerManager:game():time() then
		return
	end

	local peer = managers.network:session():peer(instigator:carry_data():latest_peer_id())
	local peer_unit = peer and peer:unit()
	if not alive(peer_unit) then
		return
	end

	local u_key = peer_unit:key()
	local carry_id = instigator:carry_data():carry_id()
	local carry_type_tweak = tweak_data.carry[carry_id] and tweak_data.carry.types[tweak_data.carry[carry_id].type]
	local carry_throw_multiplier = carry_type_tweak and carry_type_tweak.throw_distance_multiplier or 1
	for _, v in pairs(managers.groupai:state():all_AI_criminals()) do
		local logic_data = v.unit:brain()._logic_data
		logic_data.secure_bag_data[u_key] = logic_data.secure_bag_data[u_key] or {}
		logic_data.secure_bag_data[u_key][self] = logic_data.secure_bag_data[u_key][self] or {}
		logic_data.secure_bag_data[u_key][self][carry_throw_multiplier] = throw_params
	end

	local has_value = tweak_data.carry[carry_id] and tweak_data.carry[carry_id].bag_value
	self._ub_match_carry_id = not has_value or needs_secure_match_level[level_id]
	self._ub_match_carry_id_secured = self._ub_match_carry_id_secured or {}
	self._ub_match_carry_id_secured[carry_id] = true
end)

function ElementAreaTrigger:ub_can_secure_loot(unit)
	if Monkeepers or not self._values.enabled or not self._loot_secure_elements or not self:is_instigator_valid(unit) then
		return
	end

	local carry_data = alive(unit) and unit:carry_data()
	if not carry_data then
		return
	end

	local carry_id = carry_data:carry_id()
	if self._ub_match_carry_id and not self._ub_match_carry_id_secured[carry_id] then
		return
	end

	for element in pairs(self._loot_secure_elements) do
		if element._values.enabled and (not element._values.type_filter or element._values.type_filter == "none" or carry_id == element._values.type_filter) then
			return true
		end
	end
end