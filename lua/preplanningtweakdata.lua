PrePlanningTweakData.expensive_ilija_heists = table.list_to_set({
	"trai",
})

local level_id = Eclipse.utils.clean_level_id()
local is_bex = level_id == "bex"

local silent_alarm_short = 20
local silent_alarm_medium = 30
local silent_alarm_long = 40

Hooks:PostHook(PrePlanningTweakData, "init", "eclipse_init", function(self)
	self.types.delay_police_10.delay_weapons_hot_t = silent_alarm_short
	self.types.delay_police_10_no_pos.delay_weapons_hot_t = silent_alarm_medium
	self.types.delay_police_20.delay_weapons_hot_t = silent_alarm_medium
	self.types.delayed_police.delay_weapons_hot_t = silent_alarm_medium -- Delayed police response on HLM D1
	self.types.delay_police_30.delay_weapons_hot_t = silent_alarm_long
	self.types.delay_police_30_no_pos.delay_weapons_hot_t = silent_alarm_long

	-- less trivial Big Bank preplanning
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
