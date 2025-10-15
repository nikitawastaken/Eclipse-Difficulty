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
	local level_tweak = M.access_table(tweak_data, "levels", M.level_id())
	return level_tweak and level_tweak.group_ai_state == "skirmish" or managers and managers.skirmish and managers.skirmish:is_skirmish()
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

-- Easily multiply the values in a list-style table such as { X, Y, Z }
-- Can supply a mul A (for all values) or { A, B, C } (for corresponding values)
function M.table_multiplier(target_table, mul)
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

-- The original one isn't good enough
function M.callback(o, base_class, base_func_name, ...)
	if base_class and base_func_name and base_class[base_func_name] then
		if #{ ... } > 0 then
			local args = { ... }
			if o then
				return function(...)
					return base_class[base_func_name](o, unpack(args), ...)
				end
			else
				return function(...)
					return base_class[base_func_name](unpack(args), ...)
				end
			end
		elseif o then
			return function(...)
				return base_class[base_func_name](o, ...)
			end
		else
			return function(...)
				return base_class[base_func_name](...)
			end
		end
	elseif base_class then
		local class_name = base_class and CoreDebug.class_name(getmetatable(base_class) or base_class)

		Eclipse:warn_console(string.format('Callback on class "%s" refers to a non-existing function "%s".', class_name, base_func_name))
	elseif base_func_name then
		Eclipse:warn_console(string.format('Callback to function "%s" is on a nil class.', base_func_name))
	else
		Eclipse:warn_console("Callback class and function was nil.")
	end
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

return M
