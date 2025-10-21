function JobManager:current_spawn_limit(special_type)
	if not special_type then
		return math.huge
	end

	local level_data = self:current_level_data()
	local is_skirmish = level_data and level_data.group_ai_state == "skirmish"
	local special_limit_balance_mul = managers.groupai:state():_get_balancing_multiplier(tweak_data.group_ai.special_unit_spawn_limits_balance_mul)

	if is_skirmish then
		local limits_table = tweak_data.skirmish.special_unit_spawn_limits
		local wave_number = managers.groupai:state():get_assault_number()
		local limit_index = math.clamp(wave_number, 1, #limits_table)

		return math.floor(limits_table[limit_index][special_type] * special_limit_balance_mul) or math.huge
	end

	return math.floor(tweak_data.group_ai.special_unit_spawn_limits[special_type] * special_limit_balance_mul) or math.huge
end

-- proper pro job reenable
function JobManager:is_current_job_professional()
	if not self._global.current_job then
		return
	end

	return Global.game_settings.one_down
end