local patches = {
	train_car_tanker = table.set(100598),
	train_car_boxcar = table.set(100599),
	train_car_gondola = table.set(100600),
	tall_train_intense = table.set(100088),
	tall_train_slow = table.set(100098),
}

return {
	["levels/instances/unique/chew/chew_train_car/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.train_car_tanker[element.id] then
				element.values.interval = 30
			elseif patches.train_car_boxcar[element.id] then
				element.values.interval = 30
			elseif patches.train_car_gondola[element.id] then
				element.values.interval = 30
			end
		end
	end,
	["levels/instances/unique/chew/chew_tall_train/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.tall_train_intense[element.id] then
				element.values.interval = 15
			elseif patches.tall_train_slow[element.id] then
				element.values.interval = 45
			end
		end
	end,
}
