Hooks:PostHook(GageAssignmentTweakData, "init", "eclipse_init", function(self)
	-- Set Coin rewards based on the number of packages needed to complete the assignment
	for k, v in pairs(self.assignments) do
		if v.aquire then
			v.coin_reward = math.ceil(v.aquire / 5) * 2
		end
	end
	self.assignments.yellow_bull.aquire = 5
	self.assignments.red_spider.aquire = 5
	self.assignments.blue_eagle.aquire = 5
	self.assignments.purple_snake.aquire = 5
end)
