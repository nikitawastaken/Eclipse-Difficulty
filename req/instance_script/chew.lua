---@module Interception
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local swat_1 = diff_i < 5 and scripted_enemy.swat_1 or scripted_enemy.heavy_swat_1
local sniper = scripted_enemy.sniper
local so_access = Eclipse.access_filter
local law = so_access.law
local swats = {
	[swat_1] = 3,
	[sniper] = 1,
}
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")
local dead_swats_amount = (normal and 4 or hard and 6 or 8) + (is_pro_job and 2 or 0)
local patches = {
	train_car_tanker = table.set(100598),
	train_car_boxcar = table.set(100599),
	train_car_gondola = table.set(100600),
	tall_train_intense = table.set(100088),
	tall_train_slow = table.set(100098),
	pursuit_car = {
		swats = table.set(100004, 100007),
		sniper_so = table.set(100102, 100103),
		dead_amount_counter = table.set(100090, 100112),
		dead_amount = table.set(100092),
		filters_disable = table.set(100074, 100075, 100033),
		filters_normal_above = table.set(100073),
	},
}

return {
	--[[
	["levels/instances/unique/chew/chew_train_car/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.train_car_tanker[element.id] then
				element.values.interval = 30
			elseif patches.train_car_boxcar[element.id] then
				element.values.interval = 30
			elseif patches.train_car_gondola[element.id] then
				element.values.interval = 30
			end
		end
	end,
	["levels/instances/unique/chew/chew_tall_train/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.tall_train_intense[element.id] then
				element.values.interval = 15
			elseif patches.tall_train_slow[element.id] then
				element.values.interval = 45
			end
		end
	end,
]]
	["levels/instances/unique/chew/chew_pursuit_car/world/world"] = function(result)
		local fbi_pickup = patches.pursuit_car

		for _, element in pairs(result.default.elements) do
			local id = element.id

			if fbi_pickup.swats[id] then
				element.values.enemy_table = swats
			elseif fbi_pickup.sniper_so[id] then
				element.values.SO_access = law
			elseif fbi_pickup.filters_normal_above[id] then
				table.map_append(element.values, filter_normal_above)
			elseif fbi_pickup.dead_amount[id] then
				element.values.amount = dead_swats_amount
			elseif fbi_pickup.dead_amount_counter[id] then
				element.values.counter_target = dead_swats_amount
			elseif fbi_pickup.filters_disable[id] then
				table.map_append(element.values, filter_disable)
			end
		end
	end,
}
