-- Fix weapon swaps not disabling the original weapon correctly if it has a different selection index
local _place_selection_original = PlayerInventory._place_selection
function PlayerInventory:_place_selection(selection_index, is_equip, ...)
	local next_update_funcs_index = #_next_update_funcs

	_place_selection_original(self, selection_index, is_equip, ...)

	if is_equip and #_next_update_funcs > next_update_funcs_index then
		local update_func = _next_update_funcs[next_update_funcs_index + 1]
		_next_update_funcs[next_update_funcs_index + 1] = function()
			if self._equipped_selection == selection_index then
				update_func()
			end
		end
	end
end
