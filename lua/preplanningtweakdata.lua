Hooks:PostHook(PrePlanningTweakData, "init", "eclipse_init", function(self)
    -- less trivial big bank preplan
    self.types.vault_thermite.budget_cost = 6
    self.types.escape_c4_loud.budget_cost = 5
    self.types.escape_elevator_loud.budget_cost = 6
    self.types.escape_bus_loud.budget_cost = 10
end)