---@module Birth Of Sky
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local taser = scripted_enemy.taser_1
local shield = is_eclipse_pro and scripted_enemy.elite_shield or scripted_enemy.shield
local cloaker = scripted_enemy.cloaker
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local bulldozer = is_eclipse and random_elite_dozers or diff_i > 3 and random_dozers
local swats = { [swat_1] = 2, [swat_2] = 1 }
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_easy = Eclipse.utils.set_diff_groups("easy")
local filter_normal_above = Eclipse.utils.set_diff_groups("normal_above")
local patches = {
	pbr_sewer_ambush = {
		start_script = table.set(100019),
		random_script = table.set(100049),
		spawn_the_bulldozer = table.set(100020),
		spawn_two_shields_and_one_taser = table.set(100021),
		spawn_two_shields_and_one_cloaker = table.set(100022),
		dozer = table.set(100011),
		taser = table.set(100015),
		shields = table.set(100016, 100017),
		cloaker = table.set(100004),
		filters_disable = table.set(
			100025,
			100026,
			100027,
			100028,
			100029,
			100030,
			100031,
			100032,
			100033,
			100037,
			100038,
			100039,
			100040,
			100043,
			100044,
			100045,
			100046,
			100047,
			100048,
			100050,
			100051
		),
		filters_easy = table.set(100023),
		filters_normal_above = table.set(100024),
	},
	pbr_sewer_stationary_enemy = {
		enemies = table.set(100016, 100017, 100018, 100012),
	},
}

M["levels/instances/unique/pbr/pbr_stationary_enemy/world/world"] = function(result)
	local sewer_ambush_single_enemy = patches.pbr_sewer_stationary_enemy

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if sewer_ambush_single_enemy.enemies[id] then
			element.values.enemy_table = swats
		end
	end
end

M["levels/instances/unique/pbr/pbr_sewer_enemies/world/world"] = function(result)
	local sewer_ambush = patches.pbr_sewer_ambush

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if sewer_ambush.start_script[id] then
			element.values.on_executed = {
				{ id = 100023, delay = 0 },
				{ id = 100024, delay = 0 },
			}
		elseif sewer_ambush.random_script[id] then
			element.values.on_executed = {
				{ id = 100020, delay = 0 },
				{ id = 100021, delay = 0 },
				{ id = 100022, delay = 0 },
			}
		elseif sewer_ambush.spawn_the_bulldozer[id] then
			element.values.on_executed = {
				{ id = 100011, delay = 0 },
			}
		elseif sewer_ambush.spawn_two_shields_and_one_taser[id] then
			element.values.on_executed = {
				{ id = 100015, delay = 0 },
				{ id = 100016, delay = 0 },
				{ id = 100017, delay = 0 },
			}
		elseif sewer_ambush.spawn_two_shields_and_one_cloaker[id] then
			element.values.on_executed = {
				{ id = 100004, delay = 0 },
				{ id = 100016, delay = 0 },
				{ id = 100017, delay = 0 },
			}
		elseif sewer_ambush.dozer[id] then
			element.values.enemy_table = bulldozer
		elseif sewer_ambush.cloaker[id] then
			element.values.enemy = cloaker
		elseif sewer_ambush.taser[id] then
			element.values.enemy = taser
		elseif sewer_ambush.shields[id] then
			element.values.enemy = shield
		elseif sewer_ambush.filters_easy[id] then
			table.map_append(element.values, filter_easy)
			element.values.on_executed = {
				{ id = 100016, delay = 0 },
				{ id = 100015, delay = 0 },
				{ id = 100017, delay = 0 },
			}
		elseif sewer_ambush.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
			element.values.on_executed = {
				{ id = 100049, delay = 0 },
			}
		elseif sewer_ambush.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
