dofile(ModPath .. "lua/offshorecasinocomponent.lua")

MenuHelper:AddComponent("offshore_casino_claim_rewards", OffshoreCasinoComponent)

Hooks:Add("CoreMenuData.LoadDataMenu", "OffshoreCasinoComponent.CoreMenuData.LoadDataMenu", function(menu_id, menu)
	local new_node = {
		["_meta"] = "node",
		["modifier"] = "OffshoreCasinoInitiator",
		["name"] = "offshore_casino_claim_rewards",
		["menu_components"] = "offshore_casino_claim_rewards",
		["back_callback"] = "save_progress",
	}

	table.insert(menu, new_node)
end)

OffshoreCasinoInitiator = OffshoreCasinoInitiator or class()
function OffshoreCasinoInitiator:modify_node(original_node, data)
	local node = deep_clone(original_node)

	if data and data.back_callback then
		table.insert(node:parameters().back_callback, data.back_callback)
	end

	node:parameters().menu_component_data = data

	return node
end
