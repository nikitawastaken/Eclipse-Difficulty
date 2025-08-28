---@module White Xmas
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local heavy_swat = scripted_enemy.heavy_swat_1
local taser = scripted_enemy.taser_1
local patches = {
	heavies = {
		spawn_ids = table.set(100015, 100016),
	},
}
local heavies_chopper_spawn = { [heavy_swat] = 2, [taser] = 1 }

M["levels/instances/unique/san_helicopter_4swat/world/world"] = function(result)
	local heavy_spawns = patches.heavies

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heavy_spawns.spawn_ids[id] then -- add Heavies with occasional Taser to White Xmas's helis
			element.values.enemy_table = heavies_chopper_spawn
		end
	end
end

return M
