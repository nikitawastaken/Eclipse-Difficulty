function PlayerCarryVR:_can_run()
	local can_run = true
	for _, name in pairs(self._tweak_data_name) do
		if tweak_data.carry.types[name] and not tweak_data.carry.types[name].can_run then
			can_run = false
			break
		end
	end

	return can_run or managers.player:has_category_upgrade("carry", "movement_penalty_nullifier")
end
