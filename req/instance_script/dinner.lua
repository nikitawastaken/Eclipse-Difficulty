---@module Slaughterhouse
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()

local chance_fewest_pigs = normal and 0 or hard and 0.01 or 0.02
local fewest_pigs = math.random() < chance_fewest_pigs

M["levels/instances/unique/dinner/quad_meat/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if element.id == 100002 then -- choose_random_variation
			if fewest_pigs then
				element.values.on_executed = {
					{ id = 100000, delay = 0 }, -- 1
				}
			elseif normal then
				-- nothing
			elseif hard then
				element.values.on_executed = {
					{ id = 100004, delay = 0 }, -- 3
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100000, delay = 0 }, -- 1
				}
			else
				element.values.on_executed = {
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100000, delay = 0 }, -- 1
				}
			end
		end
	end
end

M["levels/instances/unique/dinner/triple_meat/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if element.id == 100002 then -- choose_random_variation
			if overkill or fewest_pigs then
				element.values.on_executed = {
					{ id = 100004, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
				}
			elseif hard then
				element.values.on_executed = {
					{ id = 100003, delay = 0 }, -- 3
					{ id = 100004, delay = 0 }, -- 2
					{ id = 100004, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
				}
			else
				-- nothing
			end
		end
	end
end

return M
