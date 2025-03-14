---@module Map Sizes
local M = {}

M.level_scale_map = {
	["framing_frame_3"] = "very_small",
	["mia_2"] = "very_small",
	["chew"] = "very_small",
	["chill_combat"] = "very_small",
	["hvh"] = "very_small",
	["nmh"] = "very_small",
	["fex"] = "very_small",
	["chca"] = "very_small",
	["four_stores"] = "small",
	["jewelry_store"] = "small",
	["mallcrasher"] = "small",
	["nightclub"] = "small",
	["ukrainian_job"] = "small",
	["arm_cro"] = "small",
	["arm_und"] = "small",
	["arm_hcm"] = "small",
	["arm_par"] = "small",
	["arm_fac"] = "small",
	["mus"] = "small",
	["man"] = "small",
	["flat"] = "small",
	["nail"] = "small",
	["help"] = "small",
	["moon"] = "small",
	["spa"] = "small",
	["wwh"] = "small",
	["rvd2"] = "small",
	["des"] = "small",
	["sah"] = "small",
	["vit"] = "small",
	["bph"] = "small",
	["pent"] = "small",
	["watchdogs_2"] = "large",
	["watchdogs_2_day"] = "large",
	["crojob2"] = "large",
	["crojob3"] = "large",
	["crojob3_night"] = "large",
	["kenaz"] = "large",
	["glace"] = "large",
	["run"] = "large",
	["mex"] = "large",
	["sand"] = "large",
	["ranc"] = "large",
	["shoutout_raid"] = "very_large",
	["peta"] = "very_large",
	["trai"] = "very_large",
	["corp"] = "very_large",
}

M.level_scales = {
	["very_small"] = 0.5,
	["small"] = 0.75,
	["medium"] = 1,
	["large"] = 1.25,
	["very_large"] = 1.5,
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
