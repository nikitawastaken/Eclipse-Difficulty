---@module Utilities
local M = {}

local difficulty = Global and Global.game_settings and Global.game_settings.difficulty or "normal"
local real_difficulty_index = ({
	normal = 2,
	hard = 3,
	overkill = 4,
	overkill_145 = 5,
	easy_wish = 6,
	overkill_290 = 7,
	sm_wish = 8,
})[difficulty] or 2
local diff_i = real_difficulty_index
local level_id = Global and Global.level_data and Global.level_data.level_id or Global.game_settings and Global.game_settings.level_id
local is_pro_job = Global and Global.game_settings and Global.game_settings.one_down
local is_overkill = diff_i == 5
local is_eclipse = diff_i == 6

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

function M.difficulty_index()
	return diff_i
end

function M.difficulty_name()
	local is_skirmish = tweak_data.levels[level_id] and tweak_data.levels[level_id].group_ai_state == "skirmish"

	return is_skirmish and "normal" or difficulty
end

function M.level_id()
	return level_id
end

function M.is_testmap()
	return level_id == "modders_devmap" or level_id == "Enemy_Spawner"
end

function M.is_pro_job()
	return is_pro_job
end

function M.is_overkill()
	return is_overkill
end

function M.is_eclipse()
	return is_eclipse
end

function M.is_eclipse_pro()
	return is_eclipse and is_pro_job
end

function M.is_solo()
	local solo = Global.game_settings and Global.game_settings.single_player

	return solo
end

function M.diff_threshold()
	local hard_and_above = diff_i >= 3
	local overkill_and_above = diff_i >= 5

	return hard_and_above, overkill_and_above
end

function M.diff_groups()
	local normal = diff_i < 4
	local hard = not normal and diff_i < 6
	local eclipse = not normal and not hard

	return normal, hard, eclipse
end

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

function M.diff_lerp(value_1, value_2)
	local f = math.max(0, diff_i - 2) / 4

	return math.lerp(value_1, value_2, math.min(f, 1))
end

function M.table_multiplier(target_table, mul)
	for i, v in pairs(target_table) do
		if type(mul) == "table" then
			target_table[i] = v * mul[math.clamp(i, 1, #mul)]
		elseif type(mul) == "number" then
			target_table[i] = v * mul
		end
	end
	return target_table
end

function M.weighted_selector(t)
	if type(t) ~= "table" then
		t = { t }
	end

	local selector = WeightedSelector:new()
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
