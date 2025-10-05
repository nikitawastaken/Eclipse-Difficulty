---@module The Diamond
local M = {}

local optsDisable_first_sniper_dialogue = {
	toggle = "off",
	trigger_times = 1,
	enabled = true,
	elements = {
		400003,
	},
}
local optsEnable_more_snipers_dialogue = {
	trigger_times = 1,
	enabled = true,
	elements = {
		400004,
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
}
local Bain_sendmoresnipers = {
	dialogue = "play_pln_gen_snip_02",
}

M.elements = {
	-- sniper warning dialogue stuff
	Eclipse.mission_elements.gen_toggleelement(400001, "enable_more_snipers_dialogue", optsEnable_more_snipers_dialogue),
	Eclipse.mission_elements.gen_toggleelement(400002, "disable_first_snipers_dialogue", optsDisable_first_sniper_dialogue),
	Eclipse.mission_elements.gen_dialogue(400003, "they_sending_snipers", Bain_sendsnipers),
	Eclipse.mission_elements.gen_dialogue(400004, "they_sending_more_snipers", Bain_sendmoresnipers),
}

return M
