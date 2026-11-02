---@module Escape: Garage
local M = {}

local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts

local optsGarageNavlinkVertical01 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(400, 850, -350), 15, true, true, true)
local optsGarageNavlinkVertical02 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(1000, 850, -350), 15, true, true, true)
local optsGarageNavlinkVertical03 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(400, 1370, -350), 15, true, true, true)
local optsGarageNavlinkVertical04 = get_navlink_so_opts("e_nl_up_0_5m_dwn_9m", Vector3(1000, 1370, -350), 15, true, true, true)

local optsGarageNavlinkHorizontal01 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(-375, 300, 50), 15, true, true, true)
local optsGarageNavlinkHorizontal02 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(225, 300, 50), 15, true, true, true)
local optsGarageNavlinkHorizontal03 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(1200, 300, 50), 15, true, true, true)
local optsGarageNavlinkHorizontal04 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(1800, 300, 50), 15, true, true, true)

local optsGarageNavlinkHorizontal05 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(1000, 2000, 50), 15, true, true, true)
local optsGarageNavlinkHorizontal06 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(700, 2000, 50), 15, true, true, true)
local optsGarageNavlinkHorizontal07 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(-100, 2000, 50), 15, true, true, true)
local optsGarageNavlinkHorizontal08 = get_navlink_so_opts("e_nl_up_0_5_down_5m_swing", Vector3(-400, 2000, 50), 15, true, true, true)

M.elements = {
	Eclipse.mission_elements.gen_so(400001, "garage_navlink_vertical01", Vector3(400, 590, 525), Rotation(0, 0, 0), optsGarageNavlinkVertical01),
	Eclipse.mission_elements.gen_so(400002, "garage_navlink_vertical02", Vector3(1000, 590, 525), Rotation(0, 0, 0), optsGarageNavlinkVertical02),
	Eclipse.mission_elements.gen_so(400003, "garage_navlink_vertical03", Vector3(400, 1620, 525), Rotation(180, 0, 0), optsGarageNavlinkVertical03),
	Eclipse.mission_elements.gen_so(400004, "garage_navlink_vertical04", Vector3(1000, 1620, 525), Rotation(180, 0, 0), optsGarageNavlinkVertical04),

	Eclipse.mission_elements.gen_so(400005, "garage_navlink_horizontal01", Vector3(-375, 550, 550), Rotation(0, 0, 0), optsGarageNavlinkHorizontal01),
	Eclipse.mission_elements.gen_so(400006, "garage_navlink_horizontal02", Vector3(225, 550, 550), Rotation(0, 0, 0), optsGarageNavlinkHorizontal02),
	Eclipse.mission_elements.gen_so(400007, "garage_navlink_horizontal03", Vector3(1200, 550, 550), Rotation(0, 0, 0), optsGarageNavlinkHorizontal03),
	Eclipse.mission_elements.gen_so(400008, "garage_navlink_horizontal04", Vector3(1800, 550, 550), Rotation(0, 0, 0), optsGarageNavlinkHorizontal04),

	Eclipse.mission_elements.gen_so(400009, "garage_navlink_horizontal05", Vector3(1000, 1700, 550), Rotation(180, 0, 0), optsGarageNavlinkHorizontal05),
	Eclipse.mission_elements.gen_so(400010, "garage_navlink_horizontal06", Vector3(700, 1700, 550), Rotation(180, 0, 0), optsGarageNavlinkHorizontal06),
	Eclipse.mission_elements.gen_so(400011, "garage_navlink_horizontal07", Vector3(-100, 1700, 550), Rotation(180, 0, 0), optsGarageNavlinkHorizontal07),
	Eclipse.mission_elements.gen_so(400012, "garage_navlink_horizontal08", Vector3(-400, 1700, 550), Rotation(180, 0, 0), optsGarageNavlinkHorizontal08),
}

return M
