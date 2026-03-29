function SkirmishTweakData:_init_ransom_amounts()
	self.ransom_amounts = {
		250000,
		250000,
		250000,
		250000,
		250000,
		250000,
		250000,
		250000,
		1000000,
	}

	for i, ransom in ipairs(self.ransom_amounts) do
		self.ransom_amounts[i] = ransom + (self.ransom_amounts[i - 1] or 0)
	end
end
