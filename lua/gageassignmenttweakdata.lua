Hooks:PostHook(GageAssignmentTweakData, "init", "eclipse_init", function(self)
	-- Set Coin rewards based on the number of packages needed to complete the assignment
	local new_requirement = 5
	for _, v in pairs(self.assignments) do
		if v.aquire then
			v.aquire = new_requirement
			v.coin_reward = math.ceil(new_requirement / 5) * 2
		end
	end
end)
