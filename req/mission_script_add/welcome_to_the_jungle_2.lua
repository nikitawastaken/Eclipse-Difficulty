---@module Big Oil Day 2
local M = {}

local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts

local optsJumpdownNavlink01 = get_navlink_so_opts("e_nl_up_1m_dwn_4_5m", Vector3(-400, -1450, 0), 10, true, true, true)
local optsJumpdownNavlink02 = get_navlink_so_opts("e_nl_up_1m_dwn_4_5m", Vector3(-400, -1300, 0), 10, true, true, true)
local optsJumpdownNavlink03 = get_navlink_so_opts("e_nl_up_1m_dwn_4_5m", Vector3(-400, -700, 0), 10, true, true, true)
local optsJumpdownNavlink04 = get_navlink_so_opts("e_nl_up_1m_dwn_4_5m", Vector3(-400, -550, 0), 10, true, true, true)

M.elements = {
	Eclipse.mission_elements.gen_so(400001, "jumpdown_navlink01", Vector3(-700, -1450, 400), Rotation(-90, 0, 0), optsJumpdownNavlink01),
	Eclipse.mission_elements.gen_so(400002, "jumpdown_navlink02", Vector3(-700, -1300, 400), Rotation(-90, 0, 0), optsJumpdownNavlink02),
	Eclipse.mission_elements.gen_so(400003, "jumpdown_navlink03", Vector3(-700, -700, 400), Rotation(-90, 0, 0), optsJumpdownNavlink03),
	Eclipse.mission_elements.gen_so(400004, "jumpdown_navlink04", Vector3(-700, -550, 400), Rotation(-90, 0, 0), optsJumpdownNavlink04),
}

return M
