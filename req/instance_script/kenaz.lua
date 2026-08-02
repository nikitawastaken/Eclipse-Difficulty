---@module Golden Grin Casino
local M = {}
local calc_team_ai_wgt = Eclipse.utils.calculate_team_ai_weight
local so_access = Eclipse.access_filter
local acrobatic = so_access.acrobatic
local preferred = Eclipse.preferred
local patches = {
	elevator = table.set(100013),
	so_access_tweak_drill = table.set(100302),
	so_access_tweak_powerbox = table.set(100015),
	the_drill_timer = table.set(100095),
}

return {
	["levels/instances/unique/kenaz/elevator_openable/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.elevator[element.id] then
				element.values.interval = 20
				element.values.interval_balance_mul = { 1.1, 1, 0.9, 0.8 }
			end
		end
	end,
	["levels/instances/unique/kenaz/the_drill/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak_drill[element.id] then
				element.values.SO_access = acrobatic -- only let SWATs, tasers and cloakers disable the drill
			elseif patches.the_drill_timer[element.id] then -- BFD drills faster with fewer players
				element.values.dt_balance_mul = { 1.4, 1.3, 1.2, 1.1 }
				element.values.team_ai_balance_mul_weight = calc_team_ai_wgt(2)
			end
		end
	end,
	["levels/instances/unique/kenaz/drill_powerbox/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak_powerbox[element.id] then
				element.values.SO_access = acrobatic -- only let SWATs, tasers and cloakers disable the power
			end
		end
	end,
}
