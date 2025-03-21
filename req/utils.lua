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

function M.diff_lerp(value_1, value_2)
	local f = math.max(0, diff_i - 2) / 4

	return math.lerp(value_1, value_2, math.min(f, 1))
end

function M.difficulty_index()
	return diff_i
end

function M.level_id()
	local level_id = Global.level_data and Global.level_data.level_id or Global.game_settings and Global.game_settings.level_id

	return level_id
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

return M
