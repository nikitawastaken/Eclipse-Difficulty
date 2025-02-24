function ElementInstigatorRule:_check_player_rules(rules, instigator)
	for rule, data in pairs(rules) do
		if rule == "carry_ids" then
			local current_carry_ids = managers.player:current_carry_id()

			if current_carry_ids[1] and data[current_carry_ids[1]] then
				return true
			end
			if current_carry_ids[2] and data[current_carry_ids[2]] then
				return true
			end

			return false
		end

		if rule == "states" then
			local current_state = managers.player:current_state()

			if not data[current_state] then
				return false
			end
		end

		if rule == "mission_equipment" then
			for value, _ in pairs(data) do
				if not managers.player:has_special_equipment(value) then
					return false
				end
			end
		end
	end

	return true
end
