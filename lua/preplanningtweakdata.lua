local level_id = Eclipse.utils.level_id()

Hooks:PostHook(PrePlanningTweakData, "init", "eclipse_init", function(self)
	-- less trivial big bank preplan
	self.types.vault_thermite.budget_cost = 6
	self.types.escape_c4_loud.budget_cost = 5
	self.types.escape_elevator_loud.budget_cost = 6
	self.types.escape_bus_loud.budget_cost = 10
	
	local expensive_sniper_heists = {
		["trai"] = true,
	}
	
	if expensive_sniper_heists[level_id] then 
		self.types.sniper.budget_cost = 6
	else
		self.types.sniper.budget_cost = 2
	end
end)
