-- custody hostage trade outline
ContourExt._types.hostage_trade_uncustody = {
	priority = 2,
	material_swap_required = true,
	color = tweak_data.contour.character.more_dangerous_color,
}

-- resources hostage trade outline
ContourExt._types.hostage_trade_resources = {
	priority = 2,
	material_swap_required = true,
	color = tweak_data.contour.character.heal_color,
}

table.insert(ContourExt.indexed_types, hostage_trade_uncustody)
table.insert(ContourExt.indexed_types, hostage_trade_resources)

table.sort(ContourExt.indexed_types)

if #ContourExt.indexed_types > 128 then
	Application:error("[ContourExt] max # contour presets exceeded!")
end

--[[
local add_original = ContourExt.add
function ContourExt:add(...)
	local params = { ... }
	call_on_next_update(function()
		add_original(self, unpack(params))
	end)
end
]]
