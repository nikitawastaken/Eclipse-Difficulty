local level_id = Eclipse.utils.level_id()

local expensive_ilija_heists = table.list_to_set({
	"trai",
})

Hooks:PostHook(PrePlanningTweakData, "init", "eclipse_init", function(self)
	-- less trivial big bank preplan
	self.types.vault_thermite.budget_cost = 6
	self.types.escape_c4_loud.budget_cost = 5
	self.types.escape_elevator_loud.budget_cost = 6
	self.types.escape_bus_loud.budget_cost = 10

	-- Bexico
	self.types.bex_car_pull.budget_cost = 8
	self.types.bex_zipline.budget_cost = 4

	if expensive_ilija_heists[level_id] then
		self.types.sniper.budget_cost = 6
	else
		self.types.sniper.budget_cost = 4
	end
end)
