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
		local chance_add_element = Eclipse.mission_elements.gen_chance_operator(140001, "chance_add", Vector3(0, 0, 0), Rotation(0, 0, 0), {
			enabled = true,
			chance = 5,
			operation = "add_chance",
			elements = { centrifuge.chance_element },
		})
		local chance_reset_element = Eclipse.mission_elements.gen_chance_operator(140002, "chance_reset", Vector3(0, 0, 0), Rotation(0, 0, 0), {
			enabled = true,
			operation = "reset_chance",
			elements = { centrifuge.chance_element },
		})
		for _, element in ipairs(result.default.elements) do
			if element.id == centrifuge.interact_with_centrifuge then
				element.values.trigger_times = 0 -- why it has set trigger times to 9?
			elseif element.id == centrifuge.chance_fail then
				table.insert(element.values.on_executed, { id = chance_add_element.id, delay = 0 })
			elseif element.id == centrifuge.chance_success then
				table.insert(element.values.on_executed, { id = chance_reset_element.id, delay = 0 })
			elseif element.id == centrifuge.chance_element then
				element.values.chance = 25 -- Vanilla is 28
			end
		end
		table.insert(result.default.elements, chance_add_element)
		table.insert(result.default.elements, chance_reset_element)
	end,
}
