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

return {
	diff_lerp = function(value_1, value_2)
		local f = math.max(0, diff_i - 2) / 4
		
		return math.lerp(value_1, value_2, f)
	end,

	difficulty_index = function()	
		return diff_i
	end,

	level_id = function()
		local level_id = Global.level_data and Global.level_data.level_id
		
		return level_id
	end,

	is_eclipse = function()
		local is_eclipse = diff_i == 6
		
		return is_eclipse
	end,

	is_pro_job = function()
		local pro_job = Global.game_settings and Global.game_settings.one_down

		return pro_job
	end,

	diff_threshold = function()
		local hard_and_above = diff_i >= 3
		local overkill_and_above = diff_i >= 5

		return hard_and_above, overkill_and_above
	end,

	diff_groups = function()
		local normal = diff_i < 4 
		local hard = not normal and diff_i < 6
		local eclipse = not normal and not hard

		return normal, hard, eclipse
	end,
}