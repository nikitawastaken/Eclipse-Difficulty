local patches = {
	centrifuge = {
		interact_with_centrifuge = 100015,
		chance_fail = 100013,
		chance_success = 100017,
		chance_element = 100012,
	},
}

return {
	["levels/instances/unique/nmh/nmh_fuge/world/world"] = function(result)
		local centrifuge = patches.centrifuge
		for _, element in ipairs(result.default.elements) do
			if element.id == centrifuge.interact_with_centrifuge then
				element.values.trigger_times = 0 -- why it has set trigger times to 9?
			elseif element.id == centrifuge.chance_fail then
				element.values.callback = function()
					local chance_element = managers.mission:get_mission_element(centrifuge.chance_element)
					if chance_element and chance_element.chance_operation_add_chance then
						chance_element:chance_operation_add_chance(5)
					end
				end
			elseif element.id == centrifuge.chance_success then
				element.values.callback = function()
					local chance_element = managers.mission:get_mission_element(centrifuge.chance_element)
					if chance_element and chance_element.chance_operation_reset then
						chance_element:chance_operation_reset()
					end
				end
			elseif element.id == centrifuge.chance_element then
				element.values.chance = 25 -- Vanilla is 28
			end
		end
	end,
}
