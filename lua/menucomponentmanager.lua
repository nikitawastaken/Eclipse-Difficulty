-- Offshore casino rework stuff
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

-- Tips viewer stuff
Hooks:PostHook(MenuComponentManager, "mouse_moved", "EclipseTipsViewerMenuComponentManagerPostMouseMoved", function(self, o, x, y)
	if EclipseTipsViewer._panel then
		self._tips_highlights = self._tips_highlights or {}

		if EclipseTipsViewer._prev and EclipseTipsViewer._next then
			if EclipseTipsViewer._prev:inside(x, y) then
				if not self._tips_highlights["prev"] then
					self._tips_highlights["prev"] = true
					managers.menu_component:post_event("highlight")
					EclipseTipsViewer._prev:set_color(tweak_data.screen_colors.button_stage_2)
				end
			elseif EclipseTipsViewer._next:inside(x, y) then
				if not self._tips_highlights["next"] then
					self._tips_highlights["next"] = true
					managers.menu_component:post_event("highlight")
					EclipseTipsViewer._next:set_color(tweak_data.screen_colors.button_stage_2)
				end
			else
				self._tips_highlights["prev"] = nil
				self._tips_highlights["next"] = nil
				EclipseTipsViewer._prev:set_color(tweak_data.screen_colors.button_stage_3)
				EclipseTipsViewer._next:set_color(tweak_data.screen_colors.button_stage_3)
			end
		end

		if EclipseTipsViewer._cprev and EclipseTipsViewer._cnext then
			if EclipseTipsViewer._cprev:inside(x, y) then
				if not self._tips_highlights["cprev"] then
					self._tips_highlights["cprev"] = true
					managers.menu_component:post_event("highlight")
					EclipseTipsViewer._cprev:set_color(tweak_data.screen_colors.button_stage_2)
				end
			elseif EclipseTipsViewer._cnext:inside(x, y) then
				if not self._tips_highlights["cnext"] then
					self._tips_highlights["cnext"] = true
					managers.menu_component:post_event("highlight")
					EclipseTipsViewer._cnext:set_color(tweak_data.screen_colors.button_stage_2)
				end
			else
				self._tips_highlights["cprev"] = nil
				self._tips_highlights["cnext"] = nil
				EclipseTipsViewer._cprev:set_color(tweak_data.screen_colors.button_stage_3)
				EclipseTipsViewer._cnext:set_color(tweak_data.screen_colors.button_stage_3)
			end
		end
	end
end)

Hooks:PostHook(MenuComponentManager, "mouse_pressed", "EclipseTipsViewerMenuComponentManagerPostMousePressed", function(self, o, button, x, y)
	if EclipseTipsViewer._panel then
		if button == Idstring("0") then
			if EclipseTipsViewer._prev and EclipseTipsViewer._next then
				if EclipseTipsViewer._prev:inside(x, y) then
					managers.menu_component:post_event("selection_previous")
					EclipseTipsViewer:SetPageIndex(-1)
				elseif EclipseTipsViewer._next:inside(x, y) then
					managers.menu_component:post_event("selection_next")
					EclipseTipsViewer:SetPageIndex(1)
				end
			end
			if EclipseTipsViewer._cprev and EclipseTipsViewer._cnext then
				if EclipseTipsViewer._cprev:inside(x, y) then
					managers.menu_component:post_event("selection_previous")
					EclipseTipsViewer:SetCategoryIndex(-1)
				elseif EclipseTipsViewer._cnext:inside(x, y) then
					managers.menu_component:post_event("selection_next")
					EclipseTipsViewer:SetCategoryIndex(1)
				end
			end
		elseif button == Idstring("mouse wheel down") then
			if EclipseTipsViewer._bg then
				if EclipseTipsViewer._bg:inside(x, y) then
					EclipseTipsViewer:SetPageIndex(1)
				end
			end
		elseif button == Idstring("mouse wheel up") then
			if EclipseTipsViewer._bg then
				if EclipseTipsViewer._bg:inside(x, y) then
					EclipseTipsViewer:SetPageIndex(-1)
				end
			end
		end
	end
end)
