-- Duplicate of WeightedSelector
-- Always available, where WeightedSelector isn't available until post-tweakdata init
EclipseWeightedSelector = EclipseWeightedSelector or class()

function EclipseWeightedSelector:init()
	self:clear()
end

function EclipseWeightedSelector:add(value, weight)
	table.insert(self._values, {
		value = value,
		weight = weight
	})

	self._total_weight = self._total_weight + weight
end

function EclipseWeightedSelector:select()
	local rand = math.random() * self._total_weight

	for _, item in ipairs(self._values) do
		if rand < item.weight then
			return item.value
		end

		rand = rand - item.weight
	end

	return nil
end

function EclipseWeightedSelector:clear()
	self._values = {}
	self._total_weight = 0
end

