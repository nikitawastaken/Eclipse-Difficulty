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

-- Add animation weights to enable switching of animations for specific weapon parts.
local weapon_anim_weights = {}
local equip_selection_original = PlayerInventory.equip_selection
function PlayerInventory:equip_selection(...)
	local result = equip_selection_original(self, ...)
	if result then
		local is_player = managers.player:player_unit() == self._unit
		if is_player then
			-- Remove previous weapon weights
			for _, weights in pairs(weapon_anim_weights) do
				self._unit:camera()._camera_unit:anim_state_machine():set_global(weights, 0)
			end

			if self:equipped_unit():base()._blueprint then
				weapon_anim_weights = managers.weapon_factory:get_animation_weights_from_weapon(self:equipped_unit():base()._factory_id, self:equipped_unit():base()._blueprint)
				-- And apply the current weapon weights
				for _, weights in pairs(weapon_anim_weights) do
					self._unit:camera()._camera_unit:anim_state_machine():set_global(weights, 1)
				end
			end
		end
	end

	return result
end

local unequip_selection_original = PlayerInventory.unequip_selection_original
function PlayerInventory:unequip_selection_original(...)
	local result = unequip_selection_original(self, ...)

	if result and managers.player:player_unit() == self._unit and self:equipped_unit():base()._blueprint then
		weapon_anim_weights = managers.weapon_factory:get_animation_weights_from_weapon(self:equipped_unit():base()._factory_id, self:equipped_unit():base()._blueprint)
	end

	return result
end
