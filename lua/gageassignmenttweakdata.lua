Hooks:PostHook(GageAssignmentTweakData, "init", "eclipse_init", function(self)
	local new_requirement = 5
	
	self.assignments.yellow_bull.aquire = new_requirement
	self.assignments.red_spider.aquire = new_requirement
	self.assignments.blue_eagle.aquire = new_requirement
	self.assignments.purple_snake.aquire = new_requirement
	
	-- Set Coin rewards based on the number of packages needed to complete the assignment
	for k, v in pairs(self.assignments) do
		if v.aquire then
			v.coin_reward = math.ceil(v.aquire / 5) * 2
		end
	end
end)
