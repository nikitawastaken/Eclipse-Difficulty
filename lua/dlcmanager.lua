function GenericDLCManager:has_mrwi_deck()
	return false
end

function GenericDLCManager:has_mrwi_deck_equipped_mimicing()
	return false
end

-- Remove achievement locks from content, you still need dlc itself to use it
function GenericDLCManager:is_content_achievement_locked(category, entry)
	local achievement_dlc_id = self._achievement_locked_content and self._achievement_locked_content[category] and self._achievement_locked_content[category][entry]

	if achievement_dlc_id then
		local dlc_tweak = tweak_data.dlc[achievement_dlc_id]
		local has_dlc = dlc_tweak and dlc_tweak.loot_global_value
		local is_unlocked = not Global.dlc_manager.all_dlc_data[has_dlc] or Global.dlc_manager.all_dlc_data[has_dlc].verified

		if is_unlocked then
			return false
		else
			return true
		end
	end

	return false
end

-- Remove red text telling you about achievement requirement / progress from items, instead asks you to buy DLC
function GenericDLCManager:is_mask_achievement_locked(mask_id)
	return false
end

function GenericDLCManager:is_material_achievement_locked(material_id)
	return false
end

function GenericDLCManager:is_texture_achievement_locked(texture_id)
	return false
end

function GenericDLCManager:is_mask_achievement_milestone_locked(mask_id)
	return false
end

function GenericDLCManager:is_weapon_mod_achievement_milestone_locked(weapon_mod_id)
	return false
end

function GenericDLCManager:is_content_skirmish_locked(category, entry)
	return false
end

function GenericDLCManager:is_content_crimespree_locked(category, entry)
	return false
end

function GenericDLCManager:weapon_color_achievement_locked_content(weapon_color)
	return false
end

function GenericDLCManager:weapon_color_achievement_milestone_locked_content(weapon_color)
	return false
end

function GenericDLCManager:_create_skirmish_locked_content_table() end

function GenericDLCManager:_create_crimespree_locked_content_table() end

function GenericDLCManager:has_achievement(data)
	return false
end

function GenericDLCManager:has_achievement_milestone(data) end

function GenericDLCManager:has_freed_old_hoxton(data)
	return true
end