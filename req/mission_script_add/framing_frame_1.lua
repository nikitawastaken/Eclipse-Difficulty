---@module Framing Frame Day 1
local M = {}
local optsVentBreaker = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104021, notify_unit_sequence = "release_vent", time = 0 },
	},
}
local optscloakerspawned = {
	on_executed = {
		{ id = 400001, delay = 0 },
	},
	elements = {
		104056,
	},
}

M.elements = {
	-- Vent fix
	Eclipse.mission_elements.object_editor(400001, "break_the_vent", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsVentBreaker),
	Eclipse.mission_elements.dummytrigger(400002, "cloaker_spawned", Vector3(-2400, -3677, 375), Rotation(0, 0, -0), optscloakerspawned),
}

return M
