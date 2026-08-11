---@module Utilities
local M = {}

-- This is how you make checking each subtable less verbose, e.g.
-- local and_chain = foo and foo.bar and foo.bar.baz and foo.bar.baz.stuff
-- local check_val = access_table(foo, "bar", "baz", "stuff")
function M.access_table(t, ...)
	local varargs = { ... }
	if #varargs > 0 then
		local idx = table.remove(varargs, 1)
		return t and M.access_table(t[idx], unpack(varargs))
	else
		return t
	end
end

function M.get_unit_from_id(unit_id)
	for _, data in pairs(managers.enemy:all_enemies()) do
		if data.unit:id() == unit_id then
			return data.unit
		end
	end
	for _, data in pairs(managers.enemy:all_civilians()) do
		if data.unit:id() == unit_id then
			return data.unit
		end
	end

	return false
end

-- Team AI helper functions ported from Useful Bots by Hoppip
function M.team_ai_get_assist_SO(unit)
	return {
		chance_inc = 0,
		base_chance = 1,
		usage_amount = 1,
		AI_group = "friendlies",
		search_pos = unit:position(),
		objective = M.team_ai_get_assist_objective(unit),
	}
end

function M.team_ai_get_assist_objective(unit, receiver)
	local pos = mvector3.copy(math.UP)
	mvector3.random_orthogonal(pos)
	mvector3.multiply(pos, 50)
	mvector3.add(pos, unit:position())
	local nav_tracker = managers.navigation:create_nav_tracker(pos)
	local nav_seg = nav_tracker:nav_segment()
	pos = nav_tracker:field_position()
	managers.navigation:destroy_nav_tracker(nav_tracker)
	return {
		type = "defend_area",
		scan = true,
		assist_unit = unit,
		haste = "run",
		pose = "stand",
		nav_seg = nav_seg,
		pos = pos,
	}
end

function M.team_ai_stop_assist_objective(unit)
	for _, c_data in pairs(managers.groupai:state():all_AI_criminals()) do
		local brain = c_data.unit:brain()
		local objective = brain:objective()
		if objective and objective.assist_unit == unit then
			brain:set_objective(managers.groupai:state():_determine_objective_for_criminal_AI(c_data.unit))
		end
	end
end

function M.team_ai_get_reviving_unit(unit)
	for _, c_data in pairs(managers.groupai:state():all_AI_criminals()) do
		local brain = c_data.unit:brain()
		local objective = brain:objective()
		if objective and objective.type == "revive" and objective.follow_unit == unit then
			return c_data.unit
		end
	end
end

function M.team_ai_force_attention(attention_unit)
	for _, c_data in pairs(managers.groupai:state():all_AI_criminals()) do
		local logic_data = c_data.unit:brain()._logic_data
		TeamAILogicBase.force_attention(logic_data, logic_data.internal_data, attention_unit)
	end
end

function M.team_ai_unregister_unit(unit)
	for _, c_data in pairs(managers.groupai:state():all_AI_criminals()) do
		local logic_data = c_data.unit:brain()._logic_data
		if logic_data._latest_follow_unit == unit then
			logic_data._latest_follow_unit = nil
		end
	end
end
-- Team AI helper functions end

-- Returns the difficulty index associated with the current difficulty
function M.difficulty_index()
	local difficulty_to_index = {
		easy = 1, -- Vanilla Easy, unused
		normal = 2, -- Easy
		hard = 3, -- Normal
		overkill = 4, -- Hard
		overkill_145 = 5, -- Overkill
		easy_wish = 6, -- Death Wish
		overkill_290 = 7, -- Vanilla Death Wish, unused
		sm_wish = 8, -- Vanilla Death Sentence, unused
	}
	return difficulty_to_index[M.difficulty_name()] or 2
end

-- Same as above, with vanilla Easy excluded (Eclipse Easy has a value of 0)
function M.difficulty_index_no_easy()
	return math.max(M.difficulty_index() - 2, 0)
end

-- Returns the current difficulty name
function M.difficulty_name()
	return M.access_table(Global, "game_settings", "difficulty") or "normal"
end

-- Returns the current level ID
function M.level_id()
	return M.access_table(Global, "level_data", "level_id") or M.access_table(Global, "game_settings", "level_id")
end

-- Returns the current level ID with suffixes like "_night" removed (for variants of the same level)
function M.clean_level_id(end_patterns)
	local level_id = M.level_id()
	if level_id then
		end_patterns = end_patterns or { "_night$", "_day$", "_skip1$", "_skip2$", "_new$" }
		for _, end_pattern in pairs(end_patterns) do
			level_id = string.gsub(level_id, end_pattern, "")
		end
	end
	return level_id
end

-- Calculates Team AI balance multipliers weights
function M.calculate_team_ai_weight(total_wgt)
	local max_nr_team_ai = M.access_table(CriminalsManager, "MAX_NR_TEAM_AI") or 3
	return (total_wgt - 1) / max_nr_team_ai
end

-- Returns the current job ID
function M.job_id()
	return M.access_table(Global, "job_manager", "current_job", "job_id")
end

-- Returns the current AI group type
function M.faction(levels_tweak)
	levels_tweak = levels_tweak or tweak_data and tweak_data.levels
	return levels_tweak and levels_tweak:get_ai_group_type() or "america"
end

-- Returns whether the current map is an enemy spawner map or not
function M.is_testmap()
	local level_id = M.level_id()
	return level_id == "modders_devmap" or level_id == "Enemy_Spawner"
end

-- Returns whether the Pro Job modifier is enabled or not
function M.is_pro_job()
	return M.access_table(Global, "game_settings", "one_down")
end

-- Returns whether the current difficulty is Overkill
function M.is_overkill()
	return M.difficulty_index() == 5
end

-- Returns whether the current difficulty is Death Wish (or vanilla DW/DS, if someone gets in there)
function M.is_eclipse()
	return M.difficulty_index() > 5
	-- return M.difficulty_index() == 6
end

-- Returns whether the current difficulty is Death Wish Pro Job
function M.is_eclipse_pro()
	return M.is_eclipse() and M.is_pro_job()
end

-- Returns whether the game is in offline mode
function M.is_solo()
	return M.access_table(Global, "game_settings", "single_player")
end

-- Returns whether the game is Holdout
function M.is_skirmish()
	local levels_tweak = M.access_table(tweak_data, "levels", M.level_id())
	return levels_tweak and levels_tweak.group_ai_state == "skirmish" or managers and managers.skirmish and managers.skirmish:is_skirmish()
end

-- Returns whether the difficulty is Normal or above, and Overkill or above
function M.diff_threshold()
	local difficulty_index = M.difficulty_index()
	local normal_and_above = difficulty_index >= 3
	local overkill_and_above = difficulty_index >= 5
	return normal_and_above, overkill_and_above
end

-- Returns whether the difficulty is within certain ranges
-- Easy/Normal, Hard/Overkill, and Death Wish are the three groups
function M.diff_groups()
	local difficulty_index = M.difficulty_index()
	local normal = difficulty_index < 4
	local hard = not normal and difficulty_index < 6
	local eclipse = not normal and not hard
	return normal, hard, eclipse
end

-- Used to easily generate difficulty modifications for filter elements
function M.set_diff_groups(group)
	group = string.lower(tostring(group))

	local easy, normal, hard, overkill, eclipse, enabled
	if group == "disable" then
		easy = false
		normal = false
		hard = false
		overkill = false
		eclipse = false
		enabled = false
	elseif group == "easy" then
		easy = true
		normal = false
		hard = false
		overkill = false
		eclipse = false
	elseif group == "easy_above" then
		easy = true
		normal = true
		hard = true
		overkill = true
		eclipse = true
	elseif group == "normal" then
		easy = false
		normal = true
		hard = false
		overkill = false
		eclipse = false
	elseif group == "normal_above" then
		easy = false
		normal = true
		hard = true
		overkill = true
		eclipse = true
	elseif group == "normal_below" then
		easy = true
		normal = true
		hard = false
		overkill = false
		eclipse = false
	elseif group == "hard" then
		easy = false
		normal = false
		hard = true
		overkill = false
		eclipse = false
	elseif group == "hard_above" then
		easy = false
		normal = false
		hard = true
		overkill = true
		eclipse = true
	elseif group == "hard_below" then
		easy = true
		normal = true
		hard = true
		overkill = false
		eclipse = false
	elseif group == "overkill" then
		easy = false
		normal = false
		hard = false
		overkill = true
		eclipse = false
	elseif group == "overkill_above" then
		easy = false
		normal = false
		hard = false
		overkill = true
		eclipse = true
	elseif group == "overkill_below" then
		easy = true
		normal = true
		hard = true
		overkill = true
		eclipse = false
	elseif group == "eclipse" then
		easy = false
		normal = false
		hard = false
		overkill = false
		eclipse = true
	else
		Eclipse:warn_console(string.format("Function set_diff_groups received invalid argument %s", group))

		return nil
	end

	return {
		enabled = enabled,
		difficulty_easy = easy,
		difficulty_normal = easy,
		difficulty_hard = normal,
		difficulty_overkill = hard,
		difficulty_overkill_145 = overkill,
		difficulty_easy_wish = eclipse,
		difficulty_overkill_290 = eclipse,
		difficulty_sm_wish = eclipse,
	}
end

-- Interpolates between two values based on current difficulty index
function M.diff_lerp(value_1, value_2)
	local f = M.difficulty_index_no_easy() / 4
	return math.lerp(value_1, value_2, math.min(f, 1))
end

-- Grab a value from a list based on difficulty index
-- Vanilla Easy uses the same value as Eclipse Easy
function M.get_difficulty_specific_value(t)
	local result = t[M.difficulty_index_no_easy() + 1]
	if result ~= nil then
		return result
	end
	return t[#t]
end

-- Grab a value from a list based on difficulty group
-- Easy/Normal, Hard/Overkill, and Death Wish are the three groups
function M.get_difficulty_group_specific_value(t)
	local difficulty_index = M.difficulty_index()
	local group_index = difficulty_index < 4 and 1 or difficulty_index < 6 and 2 or 3
	if t[group_index] ~= nil then
		return t[group_index]
	end
	return t[#t]
end

-- Generates a balance multiplier table that supports higher player counts of the BigLobby mod
-- Steps can be defined for any number of indices
-- Values for indices between those that are defined are interpolated
function M.generate_big_lobby_balance_muls(steps, round)
	if not steps then
		return {}
	end

	local balance_muls = {}
	local current_step = 1
	for i = 1, 22 do
		local current_step_tbl = steps[current_step]
		local prev_step_tbl = steps[math.max(current_step - 1, 1)]
		if not current_step_tbl or not prev_step_tbl then
			Eclipse:warn_console("Call to `generate_big_lobby_balance_muls` has incomplete steps, returning!")
			return balance_muls
		elseif current_step_tbl == prev_step_tbl then
			balance_muls[i] = current_step_tbl[1]
		else
			if round ~= nil and type(round) == "number" then
				balance_muls[i] = math.round(math.map_range_clamped(i, prev_step_tbl[2], current_step_tbl[2], prev_step_tbl[1], current_step_tbl[1]), round)
			else
				balance_muls[i] = math.map_range_clamped(i, prev_step_tbl[2], current_step_tbl[2], prev_step_tbl[1], current_step_tbl[1])
			end
		end
		if i >= current_step_tbl[2] then
			current_step = current_step + 1
		end
	end

	return balance_muls
end

-- Quickly create and populate a weighted selector from a table
function M.weighted_selector(t)
	if type(t) ~= "table" then
		t = { t }
	end

	local selector = EclipseWeightedSelector:new()
	for k, v in pairs(t) do
		if type(k) == "number" then
			selector:add(v, 1)
		else
			selector:add(k, v)
		end
	end
	return selector
end

-- Returns all Group AI state names
function M.get_group_ai_state_names()
	return { "besiege", "street", "safehouse", "ponr", "skirmish" }
end

function M.get_navlink_so_opts(so_action, search_position, interval, interrupt_dis, so_access)
	return {
		SO_access = so_access or "261600",
		scan = true,
		is_navigation_link = true,
		align_position = true,
		needs_pos_rsrv = true,
		align_rotation = true,
		interrupt_dmg = 0,
		so_action = so_action,
		search_position = search_position,
		interrupt_dis = interrupt_dis or 7,
		interval = interval or 2,
		path_haste = "none",
		path_stance = "none",
		attitude = "avoid",
	}
end

-- Based on Bank Heist's hiding Cloaker SO setup
-- search_position must be the same for all GroupAI hiding SOs
-- interrupt_dis is in meters
-- The SO group element must also be in AI navigation (or at least able to be found by GroupAI)
function M.get_hiding_cloaker_so_opts(so_action, search_position, interrupt_dis)
	return {
		SO_access = "1024",
		scan = true,
		align_position = true,
		needs_pos_rsrv = true,
		align_rotation = true,
		no_arrest = true,
		interrupt_dmg = 0,
		action_duration_min = 120,
		action_duration_max = 180,
		so_action = so_action,
		search_position = search_position,
		interrupt_dis = interrupt_dis or 7,
		interval = -1,
	}
end

-- Under GPL from
-- https://springrts.com/phpbb/viewtopic.php?t=45533
function M.log_traceback(maxdepth, maxwidth, maxtableelements, ...)
	local tracedebug = false
	local functionsource = true
	maxdepth = maxdepth or 16
	maxwidth = maxwidth or 10
	maxtableelements = maxtableelements or 32

	local function dbgt(t, m)
		local count = 0
		local res = ""
		for k, v in pairs(t) do
			count = count + 1
			if count < m then
				if tracedebug then
					Eclipse.log(count, k)
				end
				if type(k) == "number" and type(v) == "function" then -- try to get function lists?
					if tracedebug then
						Eclipse.log(k, v, debug.getinfo(v), debug.getinfo(v).name)
					end --debug.getinfo(v).short_src)?
					res = res .. tostring(k) .. ":" .. ((debug.getinfo(v) and debug.getinfo(v).name) or "<function>") .. ", "
				else
					res = res .. tostring(k) .. ":" .. tostring(v) .. ", "
				end
			end
		end
		res = "{" .. res .. "}[#" .. count .. "]"
		return res
	end

	local myargs = { ... }
	local infostr = ""
	for _, v in ipairs(myargs) do
		infostr = infostr .. tostring(v) .. "\t"
	end
	if infostr ~= "" then
		infostr = "Trace:[" .. infostr .. "]\n"
	end
	local functionstr = "" -- "Trace:["
	for i = 2, maxdepth do
		if debug.getinfo(i) then
			local funcName = (debug and debug.getinfo(i) and debug.getinfo(i).name)
			if funcName then
				functionstr = functionstr .. tostring(i - 1) .. ": " .. tostring(funcName) .. " "
				local arguments = ""
				funcName = (debug and debug.getinfo(i) and debug.getinfo(i).name) or "??"
				if funcName ~= "??" then
					if functionsource and debug.getinfo(i).source then
						local source = debug.getinfo(i).source
						if string.len(source) > 128 then
							source = "sourcetoolong"
						end
						functionstr = functionstr .. " @" .. source
					end
					if functionsource and debug.getinfo(i).linedefined then
						functionstr = functionstr .. ":" .. tostring(debug.getinfo(i).linedefined)
					end
					for j = 1, maxwidth do
						local name, value = debug.getlocal(i, j)
						if not name then
							break
						end
						if tracedebug then
							Eclipse.log(i, j, funcName, name)
						end
						local sep = ((arguments == "") and "") or ";\n\t\t"
						if tostring(name) == "self" then
							arguments = arguments .. sep .. ((name and tostring(name)) or "name?") .. "=" .. tostring("??")
						else
							local newvalue
							if maxtableelements > 0 and type({}) == type(value) then
								newvalue = dbgt(value, maxtableelements)
							else
								newvalue = value
							end
							arguments = arguments .. sep .. ((name and tostring(name)) or "name?") .. "=" .. tostring(newvalue)
						end
					end
				end
				functionstr = functionstr .. "\nLocals:\n\t{\n\t\t" .. arguments .. "\n\t}\n"
			else
				functionstr = functionstr .. tostring(i - 1) .. ": ??\n\n"
			end
		else
			break
		end
	end
	Eclipse.log(infostr .. functionstr)
end

---Load environment from tweak data and env name
function M.load_environment(level_tweak, environment_name)
	local environment_data = Eclipse:require("envsmod/" .. environment_name)

	if not environment_data then
		return
	end

	local new_color_grading = type(environment_data.color_grading) == "table" and table.random(environment_data.color_grading) or environment_data.color_grading

	if new_color_grading then
		Eclipse.color_grading = new_color_grading
		level_tweak.env_params.color_grading = new_color_grading
	end

	if environment_data.flashlights_on ~= nil then
		level_tweak.flashlights_on = environment_data.flashlights_on
	end

	if environment_data.environment_override then
		for k, v in pairs(environment_data.environment_override) do
			BeardLib:ReplaceScriptData(v, "custom_xml", k, "environment")
		end
	end

	if environment_data.sounds_override then
		for k, v in pairs(environment_data.sounds_override) do
			BeardLib:ReplaceScriptData(v, "custom_xml", k, "world_sounds")
		end
	end
end

---Load environment from tweak data and env name for clients
function M.client_load_environment(level_tweak, environment_name, color_grading)
	local environment_data = Eclipse:require("envsmod/" .. environment_name)

	if not environment_data then
		return
	end

	local new_color_grading = color_grading or type(environment_data.color_grading) == "table" and table.random(environment_data.color_grading) or environment_data.color_grading

	-- local viewport = managers.viewport:first_active_viewport()
	if new_color_grading then
		managers.environment_controller:set_default_color_grading(new_color_grading, true)
		-- if viewport then
		-- 	viewport:vp():set_post_processor_effect("World", Idstring("color_grading_post"), Idstring(new_color_grading))
		-- else
		-- 	Eclipse.log("no viewport found somehow?")
		-- end
	end

	if environment_data.flashlights_on ~= nil then
		managers.game_play_central:set_flashlights_on(environment_data.flashlights_on)
	end

	if environment_data.effect_spawner ~= nil then
		for effect_name, effect_data in pairs(environment_data.effect_spawner) do
			for _, v in pairs(effect_data) do
				World:effect_manager():spawn({
					effect = Idstring(effect_name),
					position = v.position,
					rotation = v.rotation,
				})
			end
		end
	end

	if environment_data.environment_override then
		for k, v in pairs(environment_data.environment_override) do
			BeardLib:ReplaceScriptData(v, "custom_xml", k, "environment")
			local em = managers.viewport:_get_environment_manager()
			em._env_data_map[k] = em:_load(k)
			managers.viewport:set_default_environment(k, nil, nil)
		end
	end

	if environment_data.sounds_override then
		for k, v in pairs(environment_data.sounds_override) do
			BeardLib:ReplaceScriptData(v, "custom_xml", k, "world_sounds")
		end
	end
end

-- Easily replaces the values in a list-style table such as { X, Y, Z }
-- Can supply a replacement A (for all values) or { A, B, C } (for corresponding values)
function M.table_replace(target_table, replace)
	local replace_type = type(replace)
	for i, v in pairs(target_table) do
		if replace_type == "table" then
			target_table[i] = replace[math.clamp(i, 1, #replace)]
		elseif replace_type == "number" then
			target_table[i] = replace
		end
	end
	return target_table
end

-- Easily multiply the values in a list-style table such as { X, Y, Z }
-- Can supply a multiplier A (for all values) or { A, B, C } (for corresponding values)
function M.table_multiply(target_table, mul)
	local mul_type = type(mul)
	for i, v in pairs(target_table) do
		if mul_type == "table" then
			target_table[i] = v * mul[math.clamp(i, 1, #mul)]
		elseif mul_type == "number" then
			target_table[i] = v * mul
		end
	end
	return target_table
end

-- Easily adds to the values in a list-style table such as { X, Y, Z }
-- Can supply an addend A (for all values) or { A, B, C } (for corresponding values)
function M.table_add(target_table, add)
	local add_type = type(add)
	for i, v in pairs(target_table) do
		if add_type == "table" then
			target_table[i] = v + add[math.clamp(i, 1, #add)]
		elseif add_type == "number" then
			target_table[i] = v + add
		end
	end
	return target_table
end

-- Easily subtracts from the values in a list-style table such as { X, Y, Z }
-- Can supply an subtrahend A (for all values) or { A, B, C } (for corresponding values)
function M.table_subtract(target_table, sub)
	local sub_type = type(sub)
	for i, v in pairs(target_table) do
		if sub_type == "table" then
			target_table[i] = v - sub[math.clamp(i, 1, #sub)]
		elseif sub_type == "number" then
			target_table[i] = v - sub
		end
	end
	return target_table
end

-- Get the distance between vec1 and vec2 on one axis ("x", "y", or "z")
function M.mvec3_distance_on_axis(axis, vec1, vec2)
	return math.abs(mvector3[axis](vec1) - mvector3[axis](vec2))
end

-- Get the distance between vec1 and vec2 on each axis
function M.mvec3_distances_by_axis(vec1, vec2)
	local x_dis = math.abs(mvector3.x(vec1) - mvector3.x(vec2))
	local y_dis = math.abs(mvector3.y(vec1) - mvector3.y(vec2))
	local z_dis = math.abs(mvector3.z(vec1) - mvector3.z(vec2))
	return x_dis, y_dis, z_dis
end

-- Returns value rounded down if it is a number, or an integer between value[1] rounded down and value[2] rounded down if it is a table
-- Adapted from `CoreMissionScriptElement.MissionScriptElement.get_random_table_value`
function M.get_random_table_value(value)
	if tonumber(value) then
		return math.floor(value)
	end
	return math.floor(value[1]) + math.random(math.floor(value[2] + 1)) - 1
end

-- Returns value if it is a number, or a float between value[1] and value[2] if it is a table
-- Adapted from `CoreMissionScriptElement.MissionScriptElement.get_random_table_value_float`
function M.get_random_table_value_float(value)
	return tonumber(value) or value[1] + math.rand(value[2])
end

return M
