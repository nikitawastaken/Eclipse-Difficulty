PrePlanningTweakData.expensive_ilija_heists = table.list_to_set({
	"trai",
})

local level_id = Eclipse.utils.level_id()
local is_bex = level_id == "bex"

Hooks:PostHook(PrePlanningTweakData, "init", "eclipse_init", function(self)
	-- less trivial big bank preplan
	self.types.vault_thermite.budget_cost = 6
	self.types.escape_c4_loud.budget_cost = 5
	self.types.escape_elevator_loud.budget_cost = 6
	self.types.escape_bus_loud.budget_cost = 10

	-- Increase Ilija cost
	self.types.sniper.budget_cost = self.expensive_ilija_heists[level_id] and 6 or 4

	-- Tweak San Martin preplanning costs
	self.types.bex_car_pull.budget_cost = 8
	self.types.bag_zipline.budget_cost = is_bex and 4 or self.types.bag_zipline.budget_cost
end)
