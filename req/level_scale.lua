---@module Map Sizes
local M = {}

M.level_scale_map = {
	["framing_frame_3"] = "very_small",
	["mia_2"] = "very_small",
	["chew"] = "very_small",
	["nail"] = "very_small",
	["chill_combat"] = "very_small",
	["hvh"] = "very_small",
	["nmh"] = "very_small",
	["bph"] = "very_small",
	["fex"] = "very_small",
	["chca"] = "very_small",
	["four_stores"] = "small",
	["jewelry_store"] = "small",
	["mallcrasher"] = "small",
	["nightclub"] = "small",
	["ukrainian_job"] = "small",
	["hox_1"] = "small",
	["man"] = "small",
	["flat"] = "small",
	["help"] = "small",
	["moon"] = "small",
	["spa"] = "small",
	["wwh"] = "small",
	["rvd2"] = "small",
	["des"] = "small",
	["sah"] = "small",
	["vit"] = "small",
	["pent"] = "small",
	["watchdogs_2"] = "large",
	["watchdogs_2_day"] = "large",
	["crojob2"] = "large",
	["kenaz"] = "large",
	["peta"] = "large",
	["friend"] = "large",
	["bex"] = "large",
	["trai"] = "large",
	["corp"] = "large",
}

M.level_scales = {
	["very_small"] = 0.6,
	["small"] = 0.8,
	["medium"] = 1,
	["large"] = 1.2,
	["very_large"] = 1.4,
}

function M.scale_multiplier(level)
	local scale_preset = M.level_scale_map[level] or "medium"
	local scale_mul = 1

	if scale_preset then
		scale_mul = scale_mul * (M.level_scales[scale_preset] or 1)
	end

	return scale_mul
end

return M
