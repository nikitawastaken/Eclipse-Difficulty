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
local level_id = Global.level_data and Global.level_data.level_id or Global.game_settings and Global.game_settings.level_id

function M.diff_lerp(value_1, value_2)
	local f = math.max(0, diff_i - 2) / 4

	return math.lerp(value_1, value_2, math.min(f, 1))
end

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

function M.is_overkill()
	local is_overkill = diff_i == 5

	return is_overkill
end

function M.is_eclipse()
	local is_eclipse = diff_i == 6

	return is_eclipse
end

function M.is_pro_job()
	local pro_job = Global.game_settings and Global.game_settings.one_down

	return pro_job
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

return M
