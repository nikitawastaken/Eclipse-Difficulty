---@module White Xmas
local M = {}

local optsdisable_cop_lights = {
	unit_ids = {
		100213,
		100061,
		100290,
		104712,
		100214,
		100058,
	},
}

M.elements = {
	-- disable cop car lights
	Eclipse.mission_elements.gen_disable_unit(400001, "disable_cop_car_lights", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdisable_cop_lights),
}

return M
