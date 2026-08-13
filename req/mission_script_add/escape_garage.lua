---@module Escape: Garage
local M = {}

local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts

local optsGarageNavlinkVertical01 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(400, 850, -350), 15, true, true, true)
local optsGarageNavlinkVertical02 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(1000, 850, -350), 15, true, true, true)
local optsGarageNavlinkVertical03 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(400, 1370, -350), 15, true, true, true)
local optsGarageNavlinkVertical04 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(1000, 1370, -350), 15, true, true, true)

M.elements = {
	Eclipse.mission_elements.gen_so(400000, "garage_navlink_vertical01", Vector3(400, 590, 540), Rotation(0, 0, 0), optsGarageNavlinkVertical01),
	Eclipse.mission_elements.gen_so(400001, "garage_navlink_vertical02", Vector3(1000, 590, 540), Rotation(0, 0, 0), optsGarageNavlinkVertical02),
	Eclipse.mission_elements.gen_so(400002, "garage_navlink_vertical03", Vector3(400, 1620, 540), Rotation(-180, 0, 0), optsGarageNavlinkVertical03),
	Eclipse.mission_elements.gen_so(400003, "garage_navlink_vertical04", Vector3(1000, 1620, 540), Rotation(-180, 0, 0), optsGarageNavlinkVertical04),
}

return M
