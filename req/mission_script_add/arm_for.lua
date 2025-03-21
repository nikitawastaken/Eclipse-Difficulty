---@module Armored Transport: Train Heist
local M = {}

local optsDisable_Vaultdozers = {
	toggle = "off",
	enabled = true,
	elements = {
		103227,
		103228,
		103229,
	},
}
local optsEnable_Vaultdozers = {
	enabled = true,
	elements = {
		103227,
		103228,
		103229,
	},
}

M.elements = {
	-- disable dozers in the vault so they don't spawn in stealth
	Eclipse.mission_elements.gen_toggleelement(400001, "enable_armydozer", optsEnable_Vaultdozers),
	Eclipse.mission_elements.gen_toggleelement(400002, "disable_armydozer", optsDisable_Vaultdozers),
}

return M
