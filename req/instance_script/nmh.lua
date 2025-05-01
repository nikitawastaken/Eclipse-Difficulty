local patches = {
	interact_with_centrifuge = table.set(100015),
}

return {
	["levels/instances/unique/nmh/nmh_fuge/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.interact_with_centrifuge[element.id] then
				element.values.trigger_times = 0 -- why it has set trigger times to 9?
			end
		end
	end,
}
